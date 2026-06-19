#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

python3 - <<'PY'
import json
import re
import subprocess
import sys
from pathlib import Path

root = Path.cwd()
errors = []


def git_ls(pattern: str):
    out = subprocess.check_output(["git", "ls-files", pattern], text=True)
    return [p for p in out.splitlines() if p]


def is_production_relayer_config(path: Path, data: dict) -> bool:
    name = path.name.lower()
    env = str(data.get("environment", "")).lower()
    return env == "production" or any(token in name for token in ("prod", "production", "mainnet"))


for rel in git_ls("bridge/relayer/config*.json*"):
    path = root / rel
    try:
        data = json.loads(path.read_text())
    except Exception as exc:
        errors.append(f"{rel}: invalid JSON: {exc}")
        continue

    if not is_production_relayer_config(path, data):
        continue

    for chain in ("ethereum", "goldChain"):
        min_confirmations = (((data.get(chain) or {}).get("finality") or {}).get("minConfirmations"))
        if min_confirmations == 1:
            errors.append(f"{rel}: production {chain}.finality.minConfirmations is 1")

    for route_id, route in (data.get("routes") or {}).items():
        if isinstance(route, dict) and route.get("mockOnly") is True:
            errors.append(f"{rel}: production route {route_id} has mockOnly=true")

runtime_path = root / "scan/goldscan/config/runtime.exs"
runtime = runtime_path.read_text()
scanner_key = "INDEXER_GOLDCHAIN_ROUTE_ASSET_BY_ROOT_TOKEN_JSON"

# GoldScan production must not silently boot with an empty mainnet route map.
# The runtime config should provide a non-empty mainnet default for the route
# asset map, while still allowing operators to override it via the env var.
match = re.search(
    r'root_route_asset_by_token:\s*ConfigHelper\.parse_json_env_var\(\s*"'
    + re.escape(scanner_key)
    + r'"\s*,\s*~s\((\{.*?\})\)\s*\)',
    runtime,
    flags=re.S,
)

if not match:
    errors.append(
        f"scan/goldscan/config/runtime.exs: {scanner_key} must have a non-empty mainnet JSON default"
    )
else:
    try:
        route_map = json.loads(match.group(1))
    except Exception as exc:
        errors.append(f"scan/goldscan/config/runtime.exs: invalid {scanner_key} default JSON: {exc}")
    else:
        if not isinstance(route_map, dict) or len(route_map) == 0:
            errors.append(f"scan/goldscan/config/runtime.exs: {scanner_key} default route map is empty")

# Also catch explicit empty route maps in tracked production/mainnet scanner files.
for rel in git_ls("scan/goldscan/**"):
    lower = rel.lower()
    if not any(token in lower for token in ("prod", "production", "mainnet")):
        continue
    path = root / rel
    if not path.is_file():
        continue
    try:
        text = path.read_text(errors="ignore")
    except Exception:
        continue
    if scanner_key in text and re.search(rf'{scanner_key}\s*[:=]\s*["\']?\{{\}}["\']?', text):
        errors.append(f"{rel}: production/mainnet scanner route map is explicitly empty")

if errors:
    print("ERROR: production config drift detected:", file=sys.stderr)
    for err in errors:
        print(f"  {err}", file=sys.stderr)
    sys.exit(1)

print("OK: production relayer configs and scanner mainnet route map passed drift checks.")
PY
