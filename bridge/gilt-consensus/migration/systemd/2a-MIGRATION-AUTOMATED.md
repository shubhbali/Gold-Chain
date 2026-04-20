# Automated Migration with provided [script](./script/migrate.sh)

---

## 1. Preparation

Confirm you have verified the requirements in the [Migration Checklist](../systemd/1-MIGRATION-CHECKLIST.md).

---

## 2. Download and Verify the Script

```bash
curl -O https://raw.githubusercontent.com/chatzoneai-spec/Gold-Chain/master/bridge/gilt-consensus/migration/systemd/script/migrate.sh
curl -O https://raw.githubusercontent.com/chatzoneai-spec/Gold-Chain/master/bridge/gilt-consensus/migration/systemd/script/migrate.sh.sha512
sha512sum -c migrate.sh.sha512
```

Expected output:

```
migrate.sh: OK
```

**Do not proceed if the checksum verification fails.**

---

## 3. Execute the Script

Prepare the command with the appropriate parameters:

```bash
sudo bash migrate.sh \
  --giltconsensus-v1-home=/var/lib/gilt-consensus \
  --giltconsensuscli-path=/usr/bin/giltconsensuscli \
  --giltconsd-path=/usr/bin/giltconsd \
  --network=mainnet \
  --node-type=validator \
  --service-user=giltconsensus \
  --generate-genesis=false \
  --backup=true
```

This will initialize GiltConsensus v2 in `/var/lib/gilt-consensus`.

---

## 4. Start GiltConsensus v2

```bash
sudo systemctl daemon-reload
sudo systemctl start giltconsd
```

## 5. Upgrade And Restart telemetry (if applicable):

If you're using telemetry, you need to upgrade the service to be compatible with v2.  
Follow your telemetry service's GiltConsensus v2 upgrade guide before restarting telemetry.

Then you can restart the telemetry service:  
```bash
sudo systemctl restart telemetry
```

## 6. Check GiltConsensus Logs
Check logs:

```bash
journalctl -fu giltconsd
```

---

## 7. Sync from Genesis Time

If the genesis time is in the future, you will see:

```
Genesis time is in the future. Sleeping until then...
```

The node will begin syncing once the specified time is reached.

## 8. Configure WebSocket for Gilt ↔ GiltConsensus Communication

Edit Gilt's `config.toml` to include:

```toml
[giltconsensus]
ws-address = "ws://localhost:26657/websocket"
```

---

## 9. Restart Gilt (If Step 8 Was Applied)

```bash
sudo systemctl restart gilt
```

### Keyring Info
*Not required for the migration*  
The encoding for v2 keys is different from v1, because it uses `base64` and no longer `hex`.  
If you plan to use the `giltconsd` to submit txs, you will need to import your keys into the keyring again.  
Instructions on how to do that are available in the [README](../../README.md) file.
