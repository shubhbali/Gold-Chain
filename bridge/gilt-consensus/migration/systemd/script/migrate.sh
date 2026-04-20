#!/bin/bash

umask 0022

# -------------------- Env variables, to be adjusted before rolling out --------------------
V1_VERSION="1.6.0"
V1_GENESIS_CHECKSUM="e5f70d0a115144d24d60f2a12fbd6fc393b23d65669327c6d422eedafb84a7a19f56adb0d8290aa9a919e0d30da167924e44daaa7244c1d213382695c313d92c"
V2_GENESIS_CHECKSUM="38003386814a1cf6194f7e29e9b27d6e8711760cef357c500b94dda3e366899b6577a912e97a0527c96bc17174b186d269697cae3e8525022074bc83e36b4ed3"
V2_VERSION="0.2.9"
V1_CHAIN_ID="giltconsensus-137"
V2_CHAIN_ID="giltconsensusv2-137"
V2_GENESIS_TIME="2025-07-10T15:20:00Z"
V1_HALT_HEIGHT=24404500
VERIFY_EXPORTED_DATA=false
TRUSTED_GENESIS_URL="https://storage.googleapis.com/mainnet-giltconsensusv2-genesis/dump-genesis.json"

# -------------------- const env variables --------------------
V2_INITIAL_HEIGHT=$(( V1_HALT_HEIGHT + 1 ))
DUMP_V1_GENESIS_FILE_NAME="dump-genesis.json"
DRY_RUN=false
V2_GILTCONSENSUS_HOME="/var/lib/gilt-consensus"

# -------------------- Script start --------------------
START_TIME=$(date +%s)
SCRIPT_PATH=$(realpath "$0")

LOG_FILE="migrate.log"
exec > >(tee -a "$LOG_FILE") 2>&1

if ! tail -n 10 "$SCRIPT_PATH" | grep -q "# End of script"; then
  echo "[ERROR] Script appears to be incomplete or partially downloaded, try to download it again."
  exit 1
fi

if [[ "$(id -u)" -ne 0 ]]; then
  echo "[ERROR] This script must be run as root. Use sudo and rerun it."
  exit 1
fi

# CLI-provided values
GILTCONSENSUS_HOME=""
GILTCONSENSUS_CLI_PATH=""
GILTCONSENSUSD_PATH=""
NETWORK=""
NODETYPE=""
GILTCONSENSUS_SERVICE_USER=""
GENERATE_GENESIS=""
BACKUP=""

show_help() {
  echo "Usage: sudo bash migrate.sh \\
            --giltconsensus-v1-home=<PATH_TO_GILTCONSENSUS_HOME> \\
            --giltconsensuscli-path=<PATH_TO_GILTCONSENSUSCLI_BINARY> \\
            --giltconsd-path=<PATH_TO_GILTCONSENSUSD_BINARY> \\
            --network=mainnet|gilttestnet \\
            --node-type=sentry|validator \\
            --service-user=<GILTCONSENSUS_SERVICE_USER> \\
            --generate-genesis=true|false \\
            --backup=true|false"
  echo "Required arguments:"
  echo "  --giltconsensus-v1-home=PATH          Absolute path to GiltConsensus home directory (must contain 'config' and 'data')"
  echo "  --giltconsensuscli-path=PATH               Path to the giltconsensuscli binary (must be >= v1.0.10)"
  echo "  --giltconsd-path=PATH                 Path to the giltconsd binary (must be apocalypse tag: 1.2.0-41-*)"
  echo "  --network=mainnet|gilttestnet       Network this node is part of (use 'mainnet' or 'gilttestnet')"
  echo "  --node-type=sentry|validator  Whether this node is a sentry or validator"
  echo "  --service-user=USER          System user that runs the GiltConsensus service"
  echo "                                (typically 'giltconsensus'; check systemd with 'sudo systemctl status giltconsd')"
  echo "  --generate-genesis=true|false Whether to export genesis from giltconsd (recommended: true)"
  echo "  --backup=true|false Whether to create the v1 backup under <PATH_TO_GILTCONSENSUS_HOME>.backup (recommended: true)"
  exit 0
}

# Parse args
for arg in "$@"; do
  case $arg in
    --giltconsensus-v1-home=*) GILTCONSENSUS_HOME="${arg#*=}" ;;
    --giltconsensuscli-path=*) GILTCONSENSUS_CLI_PATH="${arg#*=}" ;;
    --giltconsd-path=*) GILTCONSENSUSD_PATH="${arg#*=}" ;;
    --network=*) NETWORK="${arg#*=}" ;;
    --node-type=*) NODETYPE="${arg#*=}" ;;
    --service-user=*) GILTCONSENSUS_SERVICE_USER="${arg#*=}" ;;
    --generate-genesis=*) GENERATE_GENESIS="${arg#*=}" ;;
    --backup=*) BACKUP="${arg#*=}" ;;
    --help|-h) show_help ;;
    *) echo "[ERROR] Unknown argument: $arg"; exit 1 ;;
  esac
  shift || true
  done

# Check required
missing_args=()
[[ -z "$GILTCONSENSUS_HOME" ]] && missing_args+=("--giltconsensus-v1-home")
[[ -z "$GILTCONSENSUS_CLI_PATH" ]] && missing_args+=("--giltconsensuscli-path")
[[ -z "$GILTCONSENSUSD_PATH" ]] && missing_args+=("--giltconsd-path")
[[ -z "$NETWORK" ]] && missing_args+=("--network")
[[ -z "$NODETYPE" ]] && missing_args+=("--node-type")
[[ -z "$GILTCONSENSUS_SERVICE_USER" ]] && missing_args+=("--service-user")
[[ -z "$GENERATE_GENESIS" ]] && missing_args+=("--generate-genesis")
[[ -z "$BACKUP" ]] && missing_args+=("--backup")
if (( ${#missing_args[@]} > 0 )); then
  echo "[ERROR] Missing required arguments: ${missing_args[*]}"
  show_help
fi

# Track temp files to clean up on exit
TEMP_FILES=()

# Function to print step information
print_step() {
    echo ""
    local step_number=$1
    local message=$2
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "\n[$timestamp] [STEP $step_number] $message"
}

# Function to handle errors
handle_error() {
    local step_number=$1
    local message=$2
    echo -e "\n[ERROR] Step $step_number failed: $message"
    exit 1
}

# Function to clean up temp files on script exit
cleanup_temp_files() {
    for f in "${TEMP_FILES[@]}"; do
        [[ -f "$f" ]] && rm -f "$f"
    done
}
trap cleanup_temp_files EXIT

# Function to validate absolute paths for user input
validate_absolute_path() {
    local path=$1
    local name=$2
    if [[ ! "$path" =~ ^/ ]]; then
        handle_error $STEP "$name must be an absolute path."
    fi
}

# Function to compare versions
version_ge() {
    [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" == "$2" ]]
}

# Normalize versions: strip leading 'v' if present
normalize_version() {
  local raw="$1"
  echo "${raw#v}"  # removes leading 'v' if it exists
}

# Helper to set or insert a key=value pair in a TOML file (top-level only)
set_toml_key() {
  local file="$1"
  local key="$2"
  local value="$3"
  local escaped_value

  # Escape double quotes in value
  escaped_value=$(printf '%s' "$value" | sed 's/"/\\"/g')

  if grep -qE "^$key\s*=" "$file"; then
    sed -i "s|^$key\s*=.*|$key = \"$escaped_value\"|" "$file"
  else
    echo "$key = \"$escaped_value\"" >> "$file"
  fi
}


# ------------------ Welcome Message ------------------
echo ""
echo -e "----------------------------------------------------------"
echo -e "🔄  Gilt GiltConsensus v1 → v2 Migration Script  🔄"
echo -e "----------------------------------------------------------"
echo ""
sleep 5


# Step 1: Check script dependencies
STEP=1
print_step $STEP "CHECK DEPENDENCIES"
# Define base and new dependencies
DEPENDENCIES=("curl" "tar" "jq" "sha512sum" "file" "awk" "sed" "systemctl" "grep" "id")
MISSING_DEPS=()
# Check if commands are available
for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done
# Fail if missing
if (( ${#MISSING_DEPS[@]} > 0 )); then
    handle_error $STEP "Missing dependencies: ${MISSING_DEPS[*]@Q}. Please install them and rerun the script."
fi
echo "[INFO] All required dependencies are installed."


# Step 2: Validate provided arguments
STEP=2
print_step $STEP "ARGUMENTS VALIDATION"
# GILTCONSENSUS_HOME
validate_absolute_path "$GILTCONSENSUS_HOME" "GILTCONSENSUS_HOME"
if [[ ! -d "$GILTCONSENSUS_HOME/data" || ! -d "$GILTCONSENSUS_HOME/config" ]]; then
    handle_error $STEP "Required directories (data, config) are missing in GILTCONSENSUS_HOME: $GILTCONSENSUS_HOME"
fi
# GILTCONSENSUS_CLI_PATH
validate_absolute_path "$GILTCONSENSUS_CLI_PATH" "GILTCONSENSUS_CLI_PATH"
GILTCONSENSUSCLI_VERSION=$("$GILTCONSENSUS_CLI_PATH" version 2>/dev/null)
if [[ -z "$GILTCONSENSUSCLI_VERSION" ]]; then
    handle_error $STEP "GILTCONSENSUSCLI_PATH is invalid or giltconsensuscli is not executable."
fi
# Compare giltconsensuscli version
if [[ "$DRY_RUN" != "true" ]]; then
  NORMALIZED_GILTCONSENSUSCLI_VERSION=$(normalize_version "$GILTCONSENSUSCLI_VERSION")
  NORMALIZED_EXPECTED_VERSION=$(normalize_version "$V1_VERSION")

  if [[ "$NORMALIZED_GILTCONSENSUSCLI_VERSION" != "$NORMALIZED_EXPECTED_VERSION" ]]; then
    handle_error $STEP "giltconsensuscli version mismatch! Expected: $V1_VERSION, Found: $GILTCONSENSUSCLI_VERSION"
  fi
fi
# Validate giltconsd path and version
validate_absolute_path "$GILTCONSENSUSD_PATH" "GILTCONSENSUSD_PATH"
GILTCONSENSUSD_VERSION=$("$GILTCONSENSUSD_PATH" version 2>/dev/null)
if [[ -z "$GILTCONSENSUSD_VERSION" ]]; then
    handle_error $STEP "GILTCONSENSUSD_PATH is invalid or giltconsd is not executable."
fi

if [[ "$DRY_RUN" != "true" ]]; then
  NORMALIZED_GILTCONSENSUSD_VERSION=$(normalize_version "$GILTCONSENSUSD_VERSION")
  if [[ "$NORMALIZED_GILTCONSENSUSD_VERSION" != "$NORMALIZED_EXPECTED_VERSION" ]]; then
    handle_error $STEP "giltconsd version mismatch! Expected: $V1_VERSION, Found: $GILTCONSENSUSD_VERSION"
  fi
fi
# NETWORK
if [[ "$NETWORK" != "gilttestnet" && "$NETWORK" != "mainnet" ]]; then
    handle_error $STEP "Invalid network! Must be 'gilttestnet' or 'mainnet'."
fi
# V1_CHAIN_ID validation (only determine EXPECTED_V1_CHAIN_ID if V1_CHAIN_ID is not "devnet")
if [[ "$V1_CHAIN_ID" != "devnet" ]]; then
    case "$NETWORK" in
        mainnet)
            EXPECTED_V1_CHAIN_ID="giltconsensus-137"
            ;;
        gilttestnet)
            EXPECTED_V1_CHAIN_ID="giltconsensus-80002"
            ;;
        *)
            # For any other network, fallback to devnet
            EXPECTED_V1_CHAIN_ID="devnet"
            ;;
    esac
fi
if [[ -n "$EXPECTED_V1_CHAIN_ID" ]]; then
    if [[ "$V1_CHAIN_ID" != "$EXPECTED_V1_CHAIN_ID" ]]; then
        handle_error $STEP "Chain ID mismatch: expected $EXPECTED_V1_CHAIN_ID, got $V1_CHAIN_ID"
    fi
fi
# NODETYPE
if [[ "$NODETYPE" != "sentry" && "$NODETYPE" != "validator" ]]; then
    handle_error $STEP "Invalid node type! Must be 'sentry' or 'validator'."
fi
# GILTCONSENSUS_SERVICE_USER
if [[ -z "$GILTCONSENSUS_SERVICE_USER" ]]; then
    handle_error $STEP "GILTCONSENSUS_SERVICE_USER cannot be empty."
fi
if ! id "$GILTCONSENSUS_SERVICE_USER" &>/dev/null; then
    handle_error $STEP "User '$GILTCONSENSUS_SERVICE_USER' does not exist on this system."
fi
# GENERATE_GENESIS
if [[ "$GENERATE_GENESIS" != "true" && "$GENERATE_GENESIS" != "false" ]]; then
    handle_error $STEP "Invalid value for --generate-genesis. Must be 'true' or 'false'."
fi
# BACKUP
if [[ "$BACKUP" != "true" && "$BACKUP" != "false" ]]; then
    handle_error $STEP "Invalid value for --backup. Must be 'true' or 'false'."
fi
echo "[INFO] All provided arguments are valid."

# Step 3: stop giltconsensus-v1. The apocalypse tag embeds the halt_height so giltconsd should be down already, running it for consistency/completeness
STEP=3
print_step $STEP "BACK UP SERVICE FILE AND STOP V1"
if systemctl list-units --type=service | grep -q giltconsd.service; then
    if systemctl is-active --quiet giltconsd; then
        systemctl stop giltconsd
    else
        echo "[INFO] giltconsd service is already stopped."
    fi
else
    if service giltconsd status &> /dev/null; then
        service giltconsd stop
    else
        echo "[INFO] giltconsd service is already stopped or not found."
    fi
fi
GILTCONSENSUSD_UNIT_FILE="/lib/systemd/system/giltconsd.service"
GILTCONSENSUSD_UNIT_BACKUP="/lib/systemd/system/giltconsd.service.backup"
if [ -f "$GILTCONSENSUSD_UNIT_FILE" ]; then
    if [ -f "$GILTCONSENSUSD_UNIT_BACKUP" ]; then
        echo "[INFO] Backup already exists at $GILTCONSENSUSD_UNIT_BACKUP"
    else
        cp "$GILTCONSENSUSD_UNIT_FILE" "$GILTCONSENSUSD_UNIT_BACKUP"
        echo "[INFO] Backed up $GILTCONSENSUSD_UNIT_FILE to $GILTCONSENSUSD_UNIT_BACKUP"
    fi
else
    echo "[WARNING] $GILTCONSENSUSD_UNIT_FILE not found. Nothing to back up."
fi

# Step 4: Ensure node has committed up to latest height
STEP=4
print_step $STEP "LATEST HEIGHT CHECK IN V1"

if [[ "$GENERATE_GENESIS" == "false" ]]; then
    echo "[INFO] Skipping committed height check since GENERATE_GENESIS=false was passed."
else
    # Get the last committed height from disk
    if ! COMMITTED_HEIGHT=$($GILTCONSENSUS_CLI_PATH get-last-committed-height --home "$GILTCONSENSUS_HOME" --quiet 2>/dev/null | tail -1); then
        handle_error $STEP "Unable to fetch committed height from disk with giltconsensuscli"
    fi

    if ! [[ "$COMMITTED_HEIGHT" =~ ^[0-9]+$ ]]; then
        handle_error $STEP "Invalid height value returned: $COMMITTED_HEIGHT"
    fi

    echo "[INFO] Latest committed height: $COMMITTED_HEIGHT"
    if [[ "$COMMITTED_HEIGHT" -lt "$V1_HALT_HEIGHT" ]]; then
        echo "[WARN] Node has not yet committed the apocalypse height."
        echo "       Expected: $V1_HALT_HEIGHT"
        echo "       Found:    $COMMITTED_HEIGHT"
        echo "       This node will NOT generate its own genesis file."
        GENERATE_GENESIS=false
    else
        echo "[INFO] Node has committed the apocalypse height."
        echo "       Expected: $V1_HALT_HEIGHT"
        echo "       Found:    $COMMITTED_HEIGHT"
        echo "       This node will generate its own genesis file."
        GENERATE_GENESIS=true
    fi
fi

# Step 5: Generate or download GiltConsensus v1 genesis JSON
STEP=5
print_step $STEP "OBTAIN V1 GENESIS FILE"
GENESIS_FILE="$GILTCONSENSUS_HOME/$DUMP_V1_GENESIS_FILE_NAME"
if $GENERATE_GENESIS; then
    echo "[INFO] Generating genesis file using giltconsd export..."
    if ! $GILTCONSENSUS_CLI_PATH export-giltconsensus --home "$GILTCONSENSUS_HOME" --chain-id "$V1_CHAIN_ID"; then
        handle_error $STEP "Failed to generate GiltConsensus v1 genesis file $GENESIS_FILE"
    fi
    echo "[INFO] This may take some time as the genesis on mainnet is supposed to be around 5GB..."
    echo "[INFO] Genesis file generated to $GENESIS_FILE"
else
    echo "[INFO] Downloading genesis file from default source: $TRUSTED_GENESIS_URL"
    echo "[INFO] This may take some time as the genesis on mainnet is supposed to be around 5GB..."
    if ! curl -fsSL "$TRUSTED_GENESIS_URL" -o "$GENESIS_FILE"; then
        handle_error $STEP "Failed to download genesis file from $TRUSTED_GENESIS_URL"
    fi
    echo "[INFO] Genesis file downloaded to $GENESIS_FILE"
fi


# Step 6: Generate checksum of the genesis export
STEP=6
print_step $STEP "V1 GENESIS CHECKSUM GENERATION"
V1_GENESIS_CHECKSUM_FILE="$GILTCONSENSUS_HOME/$DUMP_V1_GENESIS_FILE_NAME.sha512"
# Ensure the genesis file exists before computing checksum
if [[ ! -f "$GENESIS_FILE" ]]; then
    handle_error $STEP "Genesis file $GENESIS_FILE not found. Cannot generate checksum."
fi
# execute command
sha512sum "$GENESIS_FILE" | awk '{print $1}' > "$V1_GENESIS_CHECKSUM_FILE"
# Verify checksum file exists and is not empty
if [[ ! -s "$V1_GENESIS_CHECKSUM_FILE" ]]; then
    handle_error $STEP "Checksum file was not created or is empty."
fi
GENERATED_V1_GENESIS_CHECKSUM=$(awk '{print $1}' "$V1_GENESIS_CHECKSUM_FILE")
# Print checksum
echo "[INFO] Generated checksum: $GENERATED_V1_GENESIS_CHECKSUM"


# Step 7: verify checksum
STEP=7
print_step $STEP "V1 GENESIS CHECKSUM VERIFICATION"
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY-RUN] Skipping checksum verification"
else
    V1_GENESIS_CHECKSUM_FILE="$GILTCONSENSUS_HOME/$DUMP_V1_GENESIS_FILE_NAME.sha512"
    # Ensure checksum file exists before reading it
    if [[ ! -f "$V1_GENESIS_CHECKSUM_FILE" ]]; then
        handle_error $STEP "Checksum file $V1_GENESIS_CHECKSUM_FILE not found! Cannot verify checksum."
    fi
    # Read expected checksum from the file
    V1_GENESIS_CHECKSUM=$(awk '{print $1}' "$V1_GENESIS_CHECKSUM_FILE")
    # Verify checksum matches the generated one
    if [[ "$GENERATED_V1_GENESIS_CHECKSUM" != "$V1_GENESIS_CHECKSUM" ]]; then
        handle_error $STEP "Checksum mismatch! Expected: $V1_GENESIS_CHECKSUM, Found: $GENERATED_V1_GENESIS_CHECKSUM"
    fi
    echo "[INFO] Checksum verification passed."
fi

# Step 8: move giltconsensus-v1 to backup location (if BACKUP is true) or create minimal backup (if BACKUP is false)
STEP=8
BACKUP_DIR="${GILTCONSENSUS_HOME}.backup"
print_step $STEP "BACKING UP V1"
# Ensure parent directory exists in both cases
sudo mkdir -p "$(dirname "$BACKUP_DIR")" || handle_error $STEP "Failed to create parent directory for $BACKUP_DIR"
if [[ "$BACKUP" == "false" ]]; then
  echo "[INFO] Skipping full backup. Proceeding with minimal config + state + bridge backup"
  # Create minimal backup structure
  sudo mkdir -p "$BACKUP_DIR/config" || handle_error $STEP "Failed to create backup config dir"
  sudo mkdir -p "$BACKUP_DIR/data" || handle_error $STEP "Failed to create backup data dir"
  # Copy essential config files
  for file in app.toml config.toml giltconsensus-config.toml node_key.json priv_validator_key.json; do
    src="$GILTCONSENSUS_HOME/config/$file"
    dst="$BACKUP_DIR/config/$file"
    if [[ -f "$src" ]]; then
      sudo cp -a "$src" "$dst" || handle_error $STEP "Failed to copy $src to $dst"
    else
      handle_error $STEP "$src not found during minimal backup"
    fi
  done
  # Copy priv_validator_state.json separately
  state_file="$GILTCONSENSUS_HOME/data/priv_validator_state.json"
  if [[ -f "$state_file" ]]; then
    sudo cp -a "$state_file" "$BACKUP_DIR/data/" || handle_error $STEP "Failed to copy $state_file"
  else
    handle_error $STEP "$state_file not found during minimal backup"
  fi
  # Move genesis
  if [[ -f "$GENESIS_FILE" ]]; then
    sudo mv "$GENESIS_FILE" "$BACKUP_DIR" || handle_error $STEP "Failed to move $GENESIS_FILE"
  else
    handle_error $STEP "$GENESIS_FILE not found during minimal backup"
  fi
  # Move genesis checksum
  if [[ -f "$V1_GENESIS_CHECKSUM_FILE" ]]; then
    sudo mv "$V1_GENESIS_CHECKSUM_FILE" "$BACKUP_DIR" || handle_error $STEP "Failed to copy $V1_GENESIS_CHECKSUM_FILE"
  else
    handle_error $STEP "$V1_GENESIS_CHECKSUM_FILE not found during minimal backup"
  fi
  # Copy bridge folder if it exists
  if [[ -d "$GILTCONSENSUS_HOME/bridge" ]]; then
    sudo cp -a "$GILTCONSENSUS_HOME/bridge" "$BACKUP_DIR/" || handle_error $STEP "Failed to copy bridge directory"
  else
    echo "[INFO] bridge directory not found, skipping"
  fi
  echo "[INFO] Minimal backup completed (config + state + bridge)"
  # Remove v1 home
  sudo rm -rf "$GILTCONSENSUS_HOME" || echo "[INFO] $GILTCONSENSUS_HOME does not exist, skipping removal"
  # Assign proper ownership and permissions
  echo "[INFO] Assigning correct ownership and permissions under $BACKUP_DIR as user: $GILTCONSENSUS_SERVICE_USER"
  # Sanity check: avoid chowning critical paths
  CRITICAL_PATHS=("/" "/usr" "/usr/bin" "/bin" "/lib" "/lib64" "/etc" "/boot")
  for path in "${CRITICAL_PATHS[@]}"; do
      if [[ "$BACKUP_DIR" == "$path" ]]; then
          handle_error $STEP "Refusing to chown critical system path: $path"
      fi
  done
  echo "[INFO] Recursively setting ownership of all contents in $BACKUP_DIR to $GILTCONSENSUS_SERVICE_USER"
  sudo chown -R "$GILTCONSENSUS_SERVICE_USER" "$BACKUP_DIR" || handle_error $STEP "Failed to chown $BACKUP_DIR"
  # Set 640 permissions for all files
  echo "[INFO] Setting 640 permissions for all files under $BACKUP_DIR"
  find "$BACKUP_DIR" -type f ! -name '.*' -exec chmod 644 {} \; || handle_error $STEP "Failed to chmod files"
  # Set 750 permissions for all directories
  echo "[INFO] Setting 755 permissions for all directories under $BACKUP_DIR"
  find "$BACKUP_DIR" -type d ! -name '.*' -exec chmod 755 {} \; || handle_error $STEP "Failed to chmod directories"
  echo "[INFO] Ownership and permissions successfully enforced under $BACKUP_DIR"
  # Override sensitive files with stricter permissions
  SENSITIVE_FILES=(
    "$BACKUP_DIR/config/priv_validator_key.json"
    "$BACKUP_DIR/config/node_key.json"
    "$BACKUP_DIR/data/priv_validator_state.json"
  )
  echo "[INFO] Enforcing stricter 600 permissions on sensitive files"
  for f in "${SENSITIVE_FILES[@]}"; do
    if [[ -f "$f" ]]; then
      chmod 600 "$f" || echo "[WARN] Failed to chmod 600 $f"
    fi
  done
  echo "[INFO] Ownership and permissions successfully enforced under $BACKUP_DIR"
else
  echo "[INFO] Backup will be executed from $GILTCONSENSUS_HOME to $BACKUP_DIR"
  # Move GiltConsensus home to backup location
  sudo mv "$GILTCONSENSUS_HOME" "$BACKUP_DIR" || handle_error $STEP "Failed to move $GILTCONSENSUS_HOME to $BACKUP_DIR"
  echo "[INFO] Backup (move) completed successfully."
fi

# Step 9 : select the proper gilt-consensus binary package
STEP=9
print_step $STEP "PACKAGE TARGETING FOR V2"
tmpDir="/tmp/tmp-gilt-consensus"
sudo mkdir -p $tmpDir || handle_error $STEP "Cannot create $tmpDir directory for downloading files"
profileInfo=${NETWORK}-${NODETYPE}-config_v${V2_VERSION}
profileInforpm=${NETWORK}-${NODETYPE}-config-v${V2_VERSION}
baseUrl="https://github.com/giltchain/gilt-consensus/releases/download/v${V2_VERSION}"
case "$(uname -s).$(uname -m)" in
    Linux.x86_64)
        if command -v dpkg &> /dev/null; then
            type="deb"
            binary="giltconsensus-v${V2_VERSION}-amd64.deb"
            profile="giltconsensus-${profileInfo}-all.deb"
        elif command -v rpm &> /dev/null; then
            type="rpm"
            binary="giltconsensus-v${V2_VERSION}.x86_64.rpm"
            profile="giltconsensus-${profileInforpm}.noarch.rpm"
        elif command -v apk &> /dev/null; then
            handle_error $STEP "No binary distribution for your platform"
        else
            handle_error $STEP "No binary distribution for your platform"
        fi
        ;;
    Linux.aarch64)
        if command -v dpkg &> /dev/null; then
            type="deb"
            binary="giltconsensus-v${V2_VERSION}-arm64.deb"
            profile="giltconsensus-${profileInfo}-all.deb"
        elif command -v rpm &> /dev/null; then
            type="rpm"
            binary="giltconsensus-v${V2_VERSION}.aarch64.rpm"
            profile="giltconsensus-${profileInforpm}.noarch.rpm"
        elif command -v apk &> /dev/null; then
            handle_error $STEP "No binary distribution for your platform"
        else
            handle_error $STEP "No binary distribution for your platform"
        fi
        ;;
    Darwin.x86_64)
        handle_error $STEP "No binary distribution for your platform"
        ;;
    Darwin.arm64|Darwin.aarch64)
        handle_error $STEP "No binary distribution for your platform"
        ;;
    *) handle_error $STEP "No binary distribution for your platform";;
esac
url="${baseUrl}/${binary}"
package="$tmpDir/$binary"
echo "[INFO] Right package for your platform has been targeted"

# Step 10: download gilt-consensus binary package
STEP=10
print_step $STEP "DOWNLOAD V2 PACKAGE"
echo "[INFO] Package will be downloaded from $baseUrl to $tmpDir"
curl -L "$url" -o "$package" || handle_error $STEP "Failed to download binary from \"$url\""
if [ -n "$profile"  ]; then
    profileUrl="${baseUrl}/${profile}"
    profilePackage=$tmpDir/$profile
    curl -L "$profileUrl" -o "$profilePackage" || handle_error $STEP "Failed to download profile from \"$profileUrl\""
fi

# Step 11: install gilt-consensus binary
STEP=11
print_step $STEP "INSTALL V2 BINARY"
sudo dpkg --purge giltconsd-profile || echo "[WARN] Nothing to purge"
if [ "$type" = "deb" ]; then
    echo "[INFO] Uninstalling any existing giltconsd..."
    sudo dpkg -r giltconsd giltconsensus || echo "[WARN] Nothing to uninstall"
    echo "[INFO] Installing $package..."
    sudo dpkg -i "$package" || handle_error $STEP "Failed to install $package"
    if [ -n "$profilePackage" ] && [ ! -d "$V2_GILTCONSENSUS_HOME"/config ]; then
        echo "[INFO] Installing profile package..."
        sudo dpkg -i "$profilePackage" || handle_error $STEP "Failed to install profile package"
    fi
elif [ "$type" = "rpm" ]; then
    echo "[INFO] Uninstalling any existing giltconsd..."
    sudo rpm -e giltconsensus || echo "[WARN] Nothing to uninstall"
    echo "[INFO] Installing $package..."
    sudo rpm -i --force "$package" || handle_error $STEP "Failed to install $package"
    if [ -n "$profilePackage" ] && [ ! -d "$V2_GILTCONSENSUS_HOME"/config ]; then
        echo "[INFO] Installing profile package..."
        sudo rpm -i --force "$profilePackage" || handle_error $STEP "Failed to install profile package"
    fi
elif [ "$type" = "apk" ]; then
    echo "[INFO] Installing $package..."
    sudo apk add --allow-untrusted "$package" || handle_error $STEP "Failed to install $package"
elif [ "$type" = "tar.gz" ]; then
    unpack="$tmpDir/unpack"
    mkdir -p "$unpack"
    tar -xzf "$package" -C "$unpack" || handle_error $STEP "Failed to unpack"
    echo "[INFO] Copying binary to /usr/local/bin/giltconsd"
    sudo cp "$unpack/giltconsd" /usr/local/bin/giltconsd || handle_error $STEP "Failed to copy binary to /usr/local/bin/giltconsd"
    sudo chmod +x /usr/local/bin/giltconsd
    echo "[INFO] Copying binary to /usr/bin/giltconsd"
    sudo cp "$unpack/giltconsd" /usr/bin/giltconsd || handle_error $STEP "Failed to copy binary to /usr/bin/giltconsd"
    sudo chmod +x /usr/bin/giltconsd
else
    handle_error $STEP "Unknown package type: $type"
fi
echo "[INFO] GiltConsensus-v2 binary installation completed"

# Step 12: copy binary to user-specified path
STEP=12
print_step $STEP "COPY V1 BINARY"
echo "[INFO] The binary will be copied to $GILTCONSENSUSD_PATH"
# Determine source binary path - prefer /usr/bin/giltconsd
if [ -x "/usr/bin/giltconsd" ]; then
    SOURCE_BINARY="/usr/bin/giltconsd"
elif [ -x "/usr/local/bin/giltconsd" ]; then
    SOURCE_BINARY="/usr/local/bin/giltconsd"
else
    # Fallback to command resolution
    SOURCE_BINARY=$(command -v giltconsd)
    if [[ -z "$SOURCE_BINARY" ]] || [[ ! -x "$SOURCE_BINARY" ]]; then
        handle_error $STEP "Could not find giltconsd binary after installation"
    fi
fi
echo "[INFO] Using source binary at: $SOURCE_BINARY"
# Verify binary is valid
file_type=$(file "$SOURCE_BINARY")
echo "[DEBUG] Source binary type: $file_type"
if [[ "$file_type" != *"ELF 64-bit"* ]]; then
    handle_error $STEP "Source giltconsd binary is not valid: $file_type"
fi
# Check target directory exists
dir_path=$(dirname "$GILTCONSENSUSD_PATH")
if [ ! -d "$dir_path" ]; then
    handle_error $STEP "Target directory $dir_path does not exist"
fi
# Skip copy if source and destination are the same
if [[ "$SOURCE_BINARY" = "$GILTCONSENSUSD_PATH" ]]; then
    echo "[INFO] Binary is already at target location: $GILTCONSENSUSD_PATH"
else
    if [ -f "$GILTCONSENSUSD_PATH" ]; then
        echo "[INFO] Backing up existing giltconsd binary"
        sudo mv "$GILTCONSENSUSD_PATH" "${GILTCONSENSUSD_PATH}.bak" || handle_error $STEP "Backup failed"
    fi
    echo "[INFO] Copying $SOURCE_BINARY → $GILTCONSENSUSD_PATH"
    sudo cp "$SOURCE_BINARY" "$GILTCONSENSUSD_PATH" || handle_error $STEP "Failed to copy binary"
    sudo chmod +x "$GILTCONSENSUSD_PATH" || handle_error $STEP "Failed to chmod binary"
fi
echo "[INFO] giltconsd binary installed at $GILTCONSENSUSD_PATH"


# Step 13: verify gilt-consensus version
STEP=13
print_step $STEP "VERIFY V2 VERSION"
# Check if giltconsd is installed and executable
if [[ ! -x "$GILTCONSENSUSD_PATH" ]]; then
    handle_error $STEP "GiltConsensusd binary is missing or not executable: $GILTCONSENSUSD_PATH"
fi
# Check giltconsd version
echo "[INFO] Checking giltconsd version..."
GILTCONSENSUSD_V2_VERSION_RAW=$("$GILTCONSENSUSD_PATH" version 2>/dev/null | awk 'NF' | tail -n 1)
if [[ -z "$GILTCONSENSUSD_V2_VERSION_RAW" ]]; then
    echo "[ERROR] Failed to retrieve GiltConsensus v2 version"
    echo "[DEBUG] Testing binary execution:"
    "$GILTCONSENSUSD_PATH" version 2>&1 || echo "Binary execution failed"
    handle_error $STEP "Failed to retrieve GiltConsensus v2 version. Installation may have failed."
fi
# Normalize actual and expected versions
NORMALIZED_GILTCONSENSUSD_V2_VERSION=$(normalize_version "$GILTCONSENSUSD_V2_VERSION_RAW")
NORMALIZED_EXPECTED_V2_VERSION=$(normalize_version "$V2_VERSION")
echo "[DEBUG] Expected version (normalized): $NORMALIZED_EXPECTED_V2_VERSION"
echo "[DEBUG] Found version (normalized): $NORMALIZED_GILTCONSENSUSD_V2_VERSION"
if [[ "$NORMALIZED_GILTCONSENSUSD_V2_VERSION" != "$NORMALIZED_EXPECTED_V2_VERSION" ]]; then
    handle_error $STEP "GiltConsensus v2 version mismatch! Expected: $V2_VERSION, Found: $GILTCONSENSUSD_V2_VERSION_RAW"
fi
# Ensure GILTCONSENSUS_HOME exists
if [[ ! -d "$V2_GILTCONSENSUS_HOME" ]]; then
    handle_error $STEP "$V2_GILTCONSENSUS_HOME does not exist after installation."
fi
echo "[INFO] gilt-consensus is using the correct version $V2_VERSION"

# Step 14: migrate genesis file
STEP=14
print_step $STEP "MIGRATE V1 GENESIS FILE TO V2"
echo "[INFO] v1 genesis file $GENESIS_FILE is being migrated to v2 format and stored in $BACKUP_DIR/migrated_$DUMP_V1_GENESIS_FILE_NAME"
# Define the target output file
MIGRATED_GENESIS_FILE="$BACKUP_DIR/migrated_$DUMP_V1_GENESIS_FILE_NAME"
# Ensure the v1 genesis file exists before proceeding
if [[ ! -f "$BACKUP_DIR/$DUMP_V1_GENESIS_FILE_NAME" ]]; then
    handle_error $STEP "Genesis file $BACKUP_DIR/$DUMP_V1_GENESIS_FILE_NAME not found! Cannot proceed with migration."
fi
# Sanity check: warn if V2_GENESIS_TIME is in the future
GENESIS_TIMESTAMP=$(date -d "$V2_GENESIS_TIME" +%s)
NOW_TIMESTAMP=$(date +%s)
if (( GENESIS_TIMESTAMP > NOW_TIMESTAMP )); then
    echo "[WARNING] V2_GENESIS_TIME is in the future: $V2_GENESIS_TIME"
    echo "          This may cause GiltConsensus to sleep until that time on startup."
fi
# Run the migration command
if ! giltconsd migrate "$BACKUP_DIR/$DUMP_V1_GENESIS_FILE_NAME" --chain-id="$V2_CHAIN_ID" --genesis-time="$V2_GENESIS_TIME" --initial-height="$V2_INITIAL_HEIGHT" --verify-data="$VERIFY_EXPORTED_DATA"; then
    handle_error $STEP "Migration command failed."
fi
echo "[INFO] Genesis file migrated successfully from v1 to v2"
# ensure migrated genesis file exists
if [[ ! -f "$MIGRATED_GENESIS_FILE" ]]; then
    handle_error $STEP "Expected migrated genesis file not found at $MIGRATED_GENESIS_FILE"
fi
# Confirm initial_height in migrated genesis matches configured V2_INITIAL_HEIGHT
echo "[INFO] Verifying initial_height in migrated genesis file..."
ACTUAL_V2_INITIAL_HEIGHT=$(jq -r '.initial_height' "$MIGRATED_GENESIS_FILE")
[[ "$ACTUAL_V2_INITIAL_HEIGHT" =~ ^[0-9]+$ ]] || handle_error $STEP "Failed to parse initial_height from migrated genesis."
if [[ "$ACTUAL_V2_INITIAL_HEIGHT" != "$V2_INITIAL_HEIGHT" ]]; then
    echo "[WARNING] Mismatch detected!"
    echo "          Configured V2_INITIAL_HEIGHT: $V2_INITIAL_HEIGHT"
    echo "          Genesis file contains:     $ACTUAL_V2_INITIAL_HEIGHT"
    handle_error $STEP "V2_INITIAL_HEIGHT mismatch detected"
else
    echo "[INFO] initial_height in genesis matches expected value: $V2_INITIAL_HEIGHT"
fi


# Step 15: Generate checksum of the migrated genesis
STEP=15
print_step $STEP "V2 GENESIS CHECKSUM GENERATION"
echo "[INFO] The checksum for the v2 genesis file will be saved in $MIGRATED_GENESIS_FILE.sha512"
V2_GENESIS_CHECKSUM_FILE="$MIGRATED_GENESIS_FILE.sha512"
# Ensure the genesis file exists before computing checksum
if [[ ! -f "$MIGRATED_GENESIS_FILE" ]]; then
    handle_error $STEP "Migrated genesis file $MIGRATED_GENESIS_FILE not found. Cannot generate checksum."
fi
# execute command
sha512sum "$MIGRATED_GENESIS_FILE" | awk '{print $1}' > "$V2_GENESIS_CHECKSUM_FILE"
# Verify checksum file exists and is not empty
if [[ ! -s "$V2_GENESIS_CHECKSUM_FILE" ]]; then
    handle_error $STEP "Checksum file was not created or is empty."
fi
GENERATED_V2_GENESIS_CHECKSUM=$(awk '{print $1}' "$V2_GENESIS_CHECKSUM_FILE")
# Print checksum
echo "[INFO] Generated checksum: $GENERATED_V2_GENESIS_CHECKSUM"


# Step 16: verify checksum of the migrated genesis
STEP=16
print_step $STEP "V2 GENESIS CHECKSUM VERIFICATION"
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY-RUN] Skipping checksum verification"
else
    V2_GENESIS_CHECKSUM_FILE="$MIGRATED_GENESIS_FILE.sha512"
    # Ensure checksum file exists before reading it
    if [[ ! -f "$V2_GENESIS_CHECKSUM_FILE" ]]; then
        handle_error $STEP "Checksum file $V2_GENESIS_CHECKSUM_FILE not found! Cannot verify checksum."
    fi
    # Read expected checksum from the file
    V2_GENESIS_CHECKSUM=$(awk '{print $1}' "$V2_GENESIS_CHECKSUM_FILE")
    # Verify checksum matches the generated one
    if [[ "$GENERATED_V2_GENESIS_CHECKSUM" != "$V2_GENESIS_CHECKSUM" ]]; then
        handle_error $STEP "Checksum mismatch! Expected: $V2_GENESIS_CHECKSUM, Found: $GENERATED_V2_GENESIS_CHECKSUM"
    fi
    echo "[INFO] Checksum verification passed."
fi


# Step 17: create temp gilt-consensus home dir
STEP=17
print_step $STEP "V2 FOLDERS PERMISSIONS"
sudo mkdir -p "$V2_GILTCONSENSUS_HOME" || handle_error $STEP "Failed to create $V2_GILTCONSENSUS_HOME directory"
# apply proper permissions for the current user
sudo chmod -R 755 "$V2_GILTCONSENSUS_HOME" || handle_error $STEP "Failed to set permissions"
sudo chown -R "$GILTCONSENSUS_SERVICE_USER" "$V2_GILTCONSENSUS_HOME" || handle_error $STEP "Failed to change ownership"
echo "[INFO] $V2_GILTCONSENSUS_HOME created successfully"
if [ -f "$V2_GILTCONSENSUS_HOME/config/genesis.json" ]; then
    sudo rm "$V2_GILTCONSENSUS_HOME/config/genesis.json" || handle_error $STEP "Failed to remove existing json in $V2_GILTCONSENSUS_HOME/config"
fi

# Step 18: init gilt-consensus
STEP=18
print_step $STEP "V2 INIT"
# Ensure GiltConsensus home exists before proceeding
if [[ ! -d "$V2_GILTCONSENSUS_HOME" ]]; then
    handle_error $STEP "$V2_GILTCONSENSUS_HOME does not exist. Cannot proceed with initialization."
fi
# Init GiltConsensus v2
if ! giltconsd init "temp_moniker" --chain-id="$V2_CHAIN_ID" --home="$V2_GILTCONSENSUS_HOME"; then
    handle_error $STEP "Failed to initialize giltconsd."
fi
echo "[INFO] giltconsd initialized successfully."


# Step 19: verify required directories exist
STEP=19
print_step $STEP "V2 DIRS AND FILES CHECK"
echo "[INFO] Verifying required directories and configuration files in $V2_GILTCONSENSUS_HOME"
# Check if required directories exist
REQUIRED_DIRS=("data" "config")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ ! -d "$V2_GILTCONSENSUS_HOME/$dir" ]]; then
        handle_error $STEP "Required directory is missing: $V2_GILTCONSENSUS_HOME/$dir"
    fi
done
# Ensure config directory contains the necessary files
REQUIRED_CONFIG_FILES=("app.toml" "client.toml" "config.toml" "genesis.json" "node_key.json" "priv_validator_key.json")
for file in "${REQUIRED_CONFIG_FILES[@]}"; do
    if [[ ! -f "$V2_GILTCONSENSUS_HOME/config/$file" ]]; then
        handle_error $STEP "Missing required configuration file: $file"
    fi
done
# Ensure data directory contains the necessary files
REQUIRED_DATA_FILES=("priv_validator_state.json")
for file in "${REQUIRED_DATA_FILES[@]}"; do
    if [[ ! -f "$V2_GILTCONSENSUS_HOME/data/$file" ]]; then
        handle_error $STEP "Missing required data file: $file"
    fi
done
echo "[INFO] All required directories are present in $V2_GILTCONSENSUS_HOME"


# Step 20: Restore bridge directory from backup
STEP=20
print_step $STEP "RESTORE BRIDGE"
BRIDGE_SRC="$BACKUP_DIR/bridge"
BRIDGE_DEST="$V2_GILTCONSENSUS_HOME/bridge"

if [[ -d "$BRIDGE_SRC" ]]; then
    echo "[INFO] Detected bridge directory in backup: $BRIDGE_SRC"
    echo "[INFO] Restoring it to: $BRIDGE_DEST"
    cp -a "$BRIDGE_SRC" "$BRIDGE_DEST" || handle_error $STEP "Failed to restore bridge directory"
    echo "[INFO] Bridge directory restored successfully."
else
    echo "[INFO] No bridge directory found in backup. Skipping restore."
fi


# Step 21: move genesis file to new giltconsensus home
STEP=21
print_step $STEP "V2 GENESIS MOVE"
echo "[INFO] Moving genesis file to $V2_GILTCONSENSUS_HOME/config"
TARGET_GENESIS_FILE="$V2_GILTCONSENSUS_HOME/config/genesis.json"
# Backup existing genesis file before replacing it
if [ -f "$TARGET_GENESIS_FILE" ]; then
    echo "[INFO] Backing up existing genesis file..."
    mv "$TARGET_GENESIS_FILE" "${TARGET_GENESIS_FILE}.bak"
    echo "[INFO] Backup saved at: $TARGET_GENESIS_FILE.bak"
fi
# Replace with the migrated genesis
cp -p "$MIGRATED_GENESIS_FILE" "$TARGET_GENESIS_FILE" || handle_error $STEP "Failed to replace genesis file with migrated version."


# Step 22: edit priv_validator_key.json file according to v2 setup
STEP=22
print_step $STEP "UPDATE priv_validator_key.json"
PRIV_VALIDATOR_FILE="$V2_GILTCONSENSUS_HOME/config/priv_validator_key.json"
TEMP_PRIV_FILE="temp_priv_validator_key.json"
TEMP_FILES+=("$TEMP_PRIV_FILE")

if [ -f "$PRIV_VALIDATOR_FILE" ]; then
    echo "[INFO] Creating backup of priv_validator_key.json..."
    sudo cp "$PRIV_VALIDATOR_FILE" "$PRIV_VALIDATOR_FILE.bak" || handle_error $STEP "Failed to backup priv_validator_key.json"
    echo "[INFO] Backup saved at: $PRIV_VALIDATOR_FILE.bak"
else
    handle_error $STEP "priv_validator_key.json not found in GiltConsensus config directory!"
fi
ADDRESS=$(jq -r '.address' "$BACKUP_DIR/config/priv_validator_key.json")
PUB_KEY_VALUE=$(jq -r '.pub_key.value' "$BACKUP_DIR/config/priv_validator_key.json")
PRIV_KEY_VALUE=$(jq -r '.priv_key.value' "$BACKUP_DIR/config/priv_validator_key.json")
if jq --arg addr "$ADDRESS" \
      --arg pub "$PUB_KEY_VALUE" \
      --arg priv "$PRIV_KEY_VALUE" \
      '.address = $addr | .pub_key.value = $pub | .priv_key.value = $priv' \
      "$PRIV_VALIDATOR_FILE" > "$TEMP_PRIV_FILE"; then
    if [[ ! -s "$TEMP_PRIV_FILE" ]]; then
        handle_error $STEP "Updated priv_validator_key.json is empty or invalid!"
    fi
    mv "$TEMP_PRIV_FILE" "$PRIV_VALIDATOR_FILE" || handle_error $STEP "Failed to move updated priv_validator_key.json into place"
else
    handle_error $STEP "Failed to update priv_validator_key.json"
fi
echo "[INFO] Updated priv_validator_key.json file saved as $PRIV_VALIDATOR_FILE"


# Step 23: edit node_key.json file according to v2 setup
STEP=23
print_step $STEP "UPDATE node_key.json"
NODE_KEY_FILE="$V2_GILTCONSENSUS_HOME/config/node_key.json"
TEMP_NODE_KEY_FILE="temp_node_key.json"
TEMP_FILES+=("$TEMP_NODE_KEY_FILE")
if [ -f "$NODE_KEY_FILE" ]; then
    echo "[INFO] Creating backup of node_key.json..."
    cp "$NODE_KEY_FILE" "$NODE_KEY_FILE.bak" || handle_error $STEP "Failed to backup node_key.json"
    echo "[INFO] Backup saved at: $NODE_KEY_FILE.bak"
else
    handle_error $STEP "node_key.json not found in GiltConsensus config directory!"
fi
NODE_KEY=$(jq -r '.priv_key.value' "$BACKUP_DIR/config/node_key.json") || handle_error $STEP "Failed to extract priv_key.value from backup node_key.json"
if jq --arg nodekey "$NODE_KEY" \
      '.priv_key.value = $nodekey' \
      "$NODE_KEY_FILE" > "$TEMP_NODE_KEY_FILE"; then
    if [[ ! -s "$TEMP_NODE_KEY_FILE" ]]; then
        handle_error $STEP "Updated node_key.json is empty or invalid!"
    fi
    mv "$TEMP_NODE_KEY_FILE" "$NODE_KEY_FILE" || handle_error $STEP "Failed to move updated node_key.json into place"
else
    handle_error $STEP "Failed to update node_key.json"
fi
echo "[INFO] Updated node_key.json file saved as $NODE_KEY_FILE"


# Step 24: Fix JSON formatting in priv_validator_state.json and set initial height
STEP=24
print_step $STEP "UPDATE priv_validator_state.json"
PRIV_VALIDATOR_STATE="$V2_GILTCONSENSUS_HOME/data/priv_validator_state.json"
TEMP_STATE_FILE="temp_priv_validator_state.json"
TEMP_FILES+=("$TEMP_STATE_FILE")
if [ ! -f "$PRIV_VALIDATOR_STATE" ]; then
    handle_error $STEP "priv_validator_state.json not found in $V2_GILTCONSENSUS_HOME/data/"
fi
echo "[INFO] Creating backup of priv_validator_state.json..."
cp "$PRIV_VALIDATOR_STATE" "$PRIV_VALIDATOR_STATE.bak" || handle_error $STEP "Failed to backup priv_validator_state.json"
echo "[INFO] Backup saved at: $PRIV_VALIDATOR_STATE.bak"
# Validate the file has proper JSON
jq empty "$PRIV_VALIDATOR_STATE" || handle_error $STEP "Invalid JSON detected in priv_validator_state.json"
# Apply transformations:
#   1. Convert "round" from string to int
#   2. Set "height" to string value of $V2_INITIAL_HEIGHT
if jq --arg height "$V2_INITIAL_HEIGHT" '.round |= tonumber | .height = $height' "$PRIV_VALIDATOR_STATE" > "$TEMP_STATE_FILE"; then
    if [[ ! -s "$TEMP_STATE_FILE" ]]; then
        handle_error $STEP "Updated priv_validator_state.json is empty or invalid!"
    fi
    mv "$TEMP_STATE_FILE" "$PRIV_VALIDATOR_STATE" || handle_error $STEP "Failed to move updated priv_validator_state.json into place"
else
    handle_error $STEP "Failed to update priv_validator_state.json"
fi
echo "[INFO] Successfully updated priv_validator_state.json"

# Step 25: Configuration changes
STEP=25
print_step $STEP "V1 -> V2 CONFIG PORTING"
# 1. Set chain-id in client.toml
CLIENT_TOML="$V2_GILTCONSENSUS_HOME/config/client.toml"
echo "[INFO] Setting chain-id in client.toml..."
set_toml_key "$CLIENT_TOML" "chain-id" "$V2_CHAIN_ID"
actual_chain_id=$(grep -E '^chain-id\s*=' "$CLIENT_TOML" | cut -d'=' -f2 | tr -d ' "')
if [[ "$actual_chain_id" != "$V2_CHAIN_ID" ]]; then
    echo "[WARN] Validation failed: expected chain-id = $V2_CHAIN_ID, found $actual_chain_id"
fi
echo "[OK]   client.toml: chain-id = $V2_CHAIN_ID"
# 2. Migrate config.toml keys
OLD_CONFIG_TOML="$BACKUP_DIR/config/config.toml"
NEW_CONFIG_TOML="$V2_GILTCONSENSUS_HOME/config/config.toml"
CONFIG_KEYS=(
    "moniker"
    "external_address"
    "seeds"
    "persistent_peers"
    "max_num_inbound_peers"
    "max_num_outbound_peers"
    "proxy_app"
    "addr_book_strict"
)
echo "[INFO] Copying selected values from v1 config.toml to v2..."
for key in "${CONFIG_KEYS[@]}"; do
    value=$(grep -E "^$key\s*=" "$OLD_CONFIG_TOML" | cut -d'=' -f2- | sed 's/^ *//;s/^"//;s/"$//' || true)
    if [[ -n "$value" ]]; then
        set_toml_key "$NEW_CONFIG_TOML" "$key" "$value"
        echo "[OK]   config.toml: $key = $value"
    else
        echo "[WARN] config.toml: key '$key' not found or empty in v1, skipping"
    fi
done
for key in "${CONFIG_KEYS[@]}"; do
    expected=$(grep -E "^$key\s*=" "$OLD_CONFIG_TOML" | cut -d'=' -f2- | tr -d ' "' || true)
    actual=$(grep -E "^$key\s*=" "$NEW_CONFIG_TOML" | cut -d'=' -f2- | tr -d ' "' || true)
    if [[ "$expected" != "$actual" ]]; then
        echo "[WARN] Validation failed for '$key' in config.toml: expected '$expected', got '$actual'"
    fi
done
echo "[INFO] config.toml values migrated successfully."
# 3. Set static log parameters in config.toml
echo "[INFO] Setting static logging parameters in config.toml..."
set_toml_key "$NEW_CONFIG_TOML" "log_level" "info"
set_toml_key "$NEW_CONFIG_TOML" "log_format" "plain"
echo "[OK]   config.toml: log_level = info"
echo "[OK]   config.toml: log_format = plain"
# 4. Migrate giltconsensus-config.toml → app.toml
OLD_GILTCONSENSUS_CONFIG_TOML="$BACKUP_DIR/config/giltconsensus-config.toml"
NEW_APP_TOML="$V2_GILTCONSENSUS_HOME/config/app.toml"
APP_KEYS=(
    "eth_rpc_url"
    "gilt_rpc_url"
    "gilt_grpc_flag"
    "gilt_grpc_url"
    "amqp_url"
)
echo "[INFO] Copying selected values from v1 giltconsensus-config.toml to app.toml..."
for key in "${APP_KEYS[@]}"; do
    value=$(grep -E "^$key\s*=" "$OLD_GILTCONSENSUS_CONFIG_TOML" | cut -d'=' -f2- | sed 's/^ *//;s/^"//;s/"$//' || true)
    if [[ -n "$value" ]]; then
        set_toml_key "$NEW_APP_TOML" "$key" "$value"
        echo "[OK]   app.toml: $key = $value"
    else
        echo "[WARN] app.toml: key '$key' not found or empty in v1, skipping"
    fi
done
# 5. Validate
for key in "${APP_KEYS[@]}"; do
    expected=$(grep -E "^$key\s*=" "$OLD_GILTCONSENSUS_CONFIG_TOML" | cut -d'=' -f2- | tr -d ' "' || true)
    actual=$(grep -E "^$key\s*=" "$NEW_APP_TOML" | cut -d'=' -f2- | tr -d ' "' || true)
    if [[ "$expected" != "$actual" ]]; then
        echo "[WARN] Validation failed for '$key' in app.toml: expected '$expected', got '$actual'"
    fi
done
# 6. Set static gilt_grpc_flag=false in app.toml (recommended for the migration)
echo "[INFO] Setting gilt_grpc_flag param to false in app.toml..."
set_toml_key "app.toml" "gilt_grpc_flag" "false"
echo "[OK]   app.toml: gilt_grpc_flag = false"
echo "[INFO] app.toml values migrated and updated successfully."
# 6. Set static gilt_rpc_timeout=1s in app.toml (recommended for the migration)
echo "[INFO] Setting gilt_rpc_timeout param to 1s in config.toml..."
set_toml_key "app.toml" "gilt_rpc_timeout" "1s"
echo "[OK]   app.toml: gilt_rpc_timeout = 1s"
echo "[INFO] app.toml values migrated and updated successfully."


# Step 26: Assign correct ownership to GiltConsensus directories
STEP=26
print_step $STEP "V2 OWNERSHIP AND PERMISSIONS"
echo "[INFO] Assigning correct ownership and permissions under $V2_GILTCONSENSUS_HOME as user: $GILTCONSENSUS_SERVICE_USER"
# Sanity check: avoid chowning critical paths
CRITICAL_PATHS=("/" "/usr" "/usr/bin" "/bin" "/lib" "/lib64" "/etc" "/boot")
for path in "${CRITICAL_PATHS[@]}"; do
    if [[ "$V2_GILTCONSENSUS_HOME" == "$path" ]]; then
        handle_error $STEP "Refusing to chown critical system path: $path"
    fi
done
echo "[INFO] Recursively setting ownership of all contents in $V2_GILTCONSENSUS_HOME to $GILTCONSENSUS_SERVICE_USER"
sudo chown -R "$GILTCONSENSUS_SERVICE_USER" "$V2_GILTCONSENSUS_HOME" || handle_error $STEP "Failed to chown $V2_GILTCONSENSUS_HOME"
# Set 640 permissions for all files
echo "[INFO] Setting 640 permissions for all files under $V2_GILTCONSENSUS_HOME"
find "$V2_GILTCONSENSUS_HOME" -type f ! -name '.*' -exec chmod 644 {} \; || handle_error $STEP "Failed to chmod files"
# Set 750 permissions for all directories
echo "[INFO] Setting 755 permissions for all directories under $V2_GILTCONSENSUS_HOME"
find "$V2_GILTCONSENSUS_HOME" -type d ! -name '.*' -exec chmod 755 {} \; || handle_error $STEP "Failed to chmod directories"
echo "[INFO] Ownership and permissions successfully enforced under $V2_GILTCONSENSUS_HOME"
# Override sensitive files with stricter permissions
SENSITIVE_FILES=(
  "$V2_GILTCONSENSUS_HOME/config/priv_validator_key.json"
  "$V2_GILTCONSENSUS_HOME/config/node_key.json"
  "$V2_GILTCONSENSUS_HOME/data/priv_validator_state.json"
)
echo "[INFO] Enforcing stricter 600 permissions on sensitive files"
for f in "${SENSITIVE_FILES[@]}"; do
  if [[ -f "$f" ]]; then
    chmod 600 "$f" || echo "[WARN] Failed to chmod 600 $f"
  fi
done
echo "[INFO] Ownership and permissions successfully enforced under $V2_GILTCONSENSUS_HOME"

# Step 27: Automatically update the systemd unit file to set the correct user
STEP=27
print_step $STEP "EDIT SYSTEMD FILE"
echo "[INFO] Patching systemd service file to enforce user: $GILTCONSENSUS_SERVICE_USER"
SERVICE_FILE=$(systemctl status giltconsd | grep 'Loaded:' | awk '{print $3}' | tr -d '();')
if [[ -z "$SERVICE_FILE" || ! -f "$SERVICE_FILE" ]]; then
    echo "[WARNING] Could not detect systemd unit file for giltconsd. Please update it manually to set the correct 'User=' value."
    handle_error $STEP "system unit not detected"
else
    echo "[INFO] Detected service file: $SERVICE_FILE"
    BACKUP_SERVICE_FILE="${SERVICE_FILE}.bak"
    echo "[INFO] Creating backup at: $BACKUP_SERVICE_FILE"
    sudo cp "$SERVICE_FILE" "$BACKUP_SERVICE_FILE" || handle_error $STEP "Failed to backup service file"

    echo "[INFO] Updating User= in [Service] block only if present"
    sudo sed -i "/^\[Service\]/,/^\[/{s/^\(\s*User=\).*/\1$GILTCONSENSUS_SERVICE_USER/}" "$SERVICE_FILE"

    echo "[INFO] Reloading systemd daemon"
    sudo systemctl daemon-reload
    echo "[INFO] Systemd unit patched."
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

# Step 28: Clean up .bak files in V2_GILTCONSENSUS_HOME parent directory
STEP=28
print_step $STEP "CLEAN UP"
echo "[INFO] Cleaning up all the .bak files in the parent directory of $V2_GILTCONSENSUS_HOME"
# Determine the parent directory of V2_GILTCONSENSUS_HOME
GILTCONSENSUS_PARENT_DIR=$(dirname "$V2_GILTCONSENSUS_HOME")
# Find and delete all .bak files or directories
BAK_FILES=$(find "$GILTCONSENSUS_PARENT_DIR" -name "*.bak")
if [[ -n "$BAK_FILES" ]]; then
    echo "[INFO] Removing the following backup files or directories:"
    echo "$BAK_FILES"
    find "$GILTCONSENSUS_PARENT_DIR" -name "*.bak" -exec rm -rf {} \;
    echo "[INFO] Cleanup complete."
else
    echo "[INFO] No .bak files or directories found in $GILTCONSENSUS_PARENT_DIR"
fi

echo -e "\n✅ GILTCONSENSUS MIGRATION EXECUTED SUCCESSFULLY! ✅"
echo -e "🕓 Migration completed in ${MINUTES}m ${SECONDS}s."

# Don't remove next line!
# End of script
