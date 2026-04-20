# Manual Migration

This guide is for performing a manual migration from GiltConsensus v1 to v2 using `systemd`.

---

## 1. Confirm Prerequisites

Ensure all required steps in the [Migration Checklist](../systemd/1-MIGRATION-CHECKLIST.md) are completed.

---

## 2. Stop GiltConsensus v1

Once instructed by the Gilt team, to start the migration, stop the GiltConsensus v1 service.  
```bash
sudo systemctl stop giltconsd
````

If using a custom service name, replace `giltconsd` accordingly.

---

## 3. Backup GiltConsensus v1 Data

Move the existing `GILTCONSENSUS_HOME` (typically `/var/lib/gilt-consensus`)
to a backup directory (e.g., `/var/lib/gilt-consensus.backup`), or any other location (or external storage).  

```bash
sudo mv /var/lib/gilt-consensus /var/lib/gilt-consensus.backup
```

This preserves `config` and `data` folders, And `bridge` folder as well, if used.

You can start with the backup as soon as the halt height `24404500` has been reached.   

---

## 4. Backup the Systemd Service File

```bash
sudo mv /lib/systemd/system/giltconsd.service /lib/systemd/system/giltconsd.service.backup
```

---

## 5. Install GiltConsensus v2

For a script-driven migration flow, use the automated guide:

[2a-MIGRATION-AUTOMATED.md](./2a-MIGRATION-AUTOMATED.md)

For manual installation, build from source:
```bash
git clone https://github.com/chatzoneai-spec/Gold-Chain.git
cd Gold-Chain/bridge/gilt-consensus
git checkout master
make build
sudo cp build/giltconsd /usr/bin/giltconsd
```

---

## 6. Verify Installation

```bash
giltconsd version
```

Output should print the installed `giltconsd` version.

---

## 7. Manually Migrate Configuration

After initialization, customize the following files under `GILTCONSENSUS_HOME/config`:
The templates for mainnet are available in the [GiltConsensus v2 GitHub repository](https://github.com/chatzoneai-spec/Gold-Chain/tree/master/bridge/gilt-consensus/packaging/templates/config/mainnet).

* `app.toml`
* `config.toml`
* `client.toml`

Please migrate your old v1 configurations by applying only the safe subset of configurations needed for v2
(remaining settings can be tuned later).

### `config.toml` (v1 → v2):

Port the following from v1:

```toml
moniker = "..." 
proxy_app = "..."
[p2p]
external_address = "..."
seeds = "..."
persistent_peers = "..."
max_num_inbound_peers = "..."
max_num_outbound_peers = "..."
pex = "..."
```

Also set in v2

```toml
log_level = "info"
log_format = "plain"
```

### `giltconsensus-config.toml` (v1) → `app.toml` (v2):

Port the following:

```toml
[custom]
eth_rpc_url = "..." 
gilt_rpc_url = "..."
gilt_grpc_url = "..."
amqp_url = "..."
```

Also set:

```toml
[custom]
gilt_grpc_flag = false
gilt_rpc_timeout = "1s"
```

And make sure 
```toml
[custom]
chain = "mainnet"
```

### `client.toml` (v2 only):

Set directly:

```toml
chain-id = "giltconsensusv2-137"
```

---

## 8. Restore the `bridge` Folder (If Used)

Move it from your backup into the new `GILTCONSENSUS_HOME`.

---

## 9. Download Genesis File

```bash
wget -O <GILTCONSENSUS_HOME>/config/genesis.json https://storage.googleapis.com/mainnet-giltconsensusv2-genesis/migrated_dump-genesis.json
```

---

## 10. Download Checksum

```bash
wget -O <GILTCONSENSUS_HOME>/config/genesis.json.sha512 https://storage.googleapis.com/mainnet-giltconsensusv2-genesis/migrated_dump-genesis.json.sha512
```

---

## 11. Verify genesis checksum

Move into the folder where you have downloaded the genesis file.
Generate the checksum of the `genesis.json` file by running

```
sha512sum genesis.json
```

The output will be something like
```bash
<CHECKSUM> genesis.json
```

Verify that the `CHECKSUM` string matches the one present in `genesis.json.sha512`

**Do not proceed if the checksum verification fails (string mismatch).**

---

## 12. Migrate `priv_validator_key.json`

Extract from the v1 file (under v1's `GILTCONSENSUS_HOME/config`, previously backed-up) the following fields,    
and inject into the corresponding fields of v2’s `priv_validator_key.json`  
*Do not change key types, as in v1 they have a tendermint namespace and in v they have a comet namespace.*  

Values to extract from v1's `priv_validator_key.json`:
* `address`
* `pub_key.value`
* `priv_key.value`

Example of v1's `priv_validator_key.json`:

```json
{
  "address": "...",
  "pub_key": {
    "type": "tendermint/PubKeySecp256k1",
    "value": "..."
  },
  "priv_key": {
    "type": "tendermint/PrivKeySecp256k1",
    "value": "..."
  }
}
```

Example of v2's `priv_validator_key.json`:

```json
{
  "address": "...",
  "pub_key": {
    "type": "cometbft/PubKeySecp256k1eth",
    "value": "..."
  },
  "priv_key": {
    "type": "cometbft/PrivKeySecp256k1eth",
    "value": "..."
  }
}
```

---

## 13. Migrate `node_key.json`

Extract `priv_key.value` from v1 and overwrite the same field in v2.  
This preserves the node’s identity (`node_id`).

Example of v1's `node_key.json`:

```json
{
  "priv_key":{
    "type":"tendermint/PrivKeyEd25519",
    "value":"..."
  }
}
```

Example of v2's `node_key.json`:

```json
{
  "priv_key":{
    "type":"tendermint/PrivKeyEd25519",
    "value":"..."
  }
}
```

---

## 14. Normalize `priv_validator_state.json`

In the v2 `GILTCONSENSUS_HOME/data/priv_validator_state.json`, ensure that the `round` field is an integer (not a string).  
Also, set the `height` field to `24404501`, and make sure the only fields present are `height`, `round`, and `step`:


✅ This is valid:  
```json
{
  "height": "24404501",
  "round": 0,
  "step": 0
}
```

❌ This is invalid:  
```json
{
  "height": "24404501",
  "round": "0",
  "step": 0
}
```
---

## 15. Set File Ownership and Permissions

Ensure `giltconsensus` can access all necessary files:

```bash
sudo chown -R GILTCONSENSUS_SERVICE_USER GILTCONSENSUS_HOME
find GILTCONSENSUS_HOME -type f -exec chmod 640 {} \;
find GILTCONSENSUS_HOME -type d -exec chmod 755 {} \;

chmod 600 GILTCONSENSUS_HOME/config/priv_validator_key.json
chmod 600 GILTCONSENSUS_HOME/config/node_key.json
chmod 600 GILTCONSENSUS_HOME/data/priv_validator_state.json
```

---

## 16. Update Systemd Service User/Group

Check with:

```bash
systemctl status giltconsd
```

Verify the `User=` and `Group=` match the v1 configuration.  
If needed, edit `/lib/systemd/system/giltconsd.service` accordingly.  
Use your previously backed-up service file as reference.

---

## 17. Reload and Start GiltConsensus v2

```bash
sudo systemctl daemon-reload
sudo systemctl start giltconsd
```

---

## 18. Upgrade And Restart Telemetry (If Needed)

If you're using telemetry, you need to upgrade the service to be compatible with v2.  
Follow your telemetry service's GiltConsensus v2 upgrade guide before restarting telemetry.


```bash
sudo systemctl restart telemetry
```

---

## 19. Configure WebSocket for Gilt ↔ GiltConsensus Communication

Edit Gilt's `config.toml` to include:

```toml
[giltconsensus]
ws-address = "ws://localhost:26657/websocket"
```

---

## 20. Restart Gilt (If Step 19 Was Applied)

```bash
sudo systemctl restart gilt
```

---

## 21. Check GiltConsensus Logs

```bash
journalctl -fu giltconsd
```

If the genesis time is in the future, you will see:  

```
Genesis time is in the future. Sleeping until then...
```

Otherwise, the node will begin syncing immediately.  

### Keyring Info
*Not required for the migration*  
The encoding for v2 keys is different from v1, because it uses `base64` and no longer `hex`.  
If you plan to use the `giltconsd` to submit txs, you will need to import your keys into the keyring again.  
Instructions on how to do that are available in the [README](../../README.md) file.
