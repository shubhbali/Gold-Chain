# Rollback Procedure

If you executed the migration and gilt-consensus fails to start or throws some errors,  
you can debug and fix the issues without rolling back to v1.

However, if the migration itself fails due to an error,
and you wish to roll back to the previous stable state to retry the migration, follow the steps below carefully.

---

## 1. Stop the GiltConsensus v2 Service

```bash
sudo systemctl stop giltconsd
````

> ℹ️ If the service does not exist, the command will fail harmlessly. You can safely ignore any related error.

---

## 2. Restore the v1 `GILTCONSENSUS_HOME` Directory

⚠️ **Important:** Make sure the backup directory exists before deleting anything.

```bash
sudo rm -rf /var/lib/gilt-consensus # or any other v1 home you used as flag in the script (`--giltconsensus-v1-home`)
sudo mv <HOME_BACKUP_LOCATION> /var/lib/gilt-consensus
```

> ❌ **Do not delete `/var/lib/gilt-consensus` unless you have confirmed the backup exists!**
> Otherwise, you risk losing critical data.
> If the backup folder doesn't exist, skip this step and do not remove the current v1 home

---

## 3. Delete Genesis Dump Files

```bash
sudo rm -f /var/lib/gilt-consensus/dump_genesis.json
sudo rm -f /var/lib/gilt-consensus/dump_genesis.json.sha512
sudo rm -f /var/lib/gilt-consensus/migrated_dump_genesis.json
sudo rm -f /var/lib/gilt-consensus/migrated_dump_genesis.json.sha512
```

> Optional but recommended to ensure a clean state before retrying migration.
> If these files do not exist, it's not a problem.
---

## 4. Restore the v1 Systemd Service File

First, verify that the backup exists:

```bash
ls -l /lib/systemd/system/giltconsd.service.backup
```

If the file exists, you can restore it with:

```bash
sudo mv -f /lib/systemd/system/giltconsd.service.backup /lib/systemd/system/giltconsd.service
```

> ℹ️ If the backup does **not** exist, skip this step.
> You likely didn’t modify or back up the service file during migration.

## 5. Install GiltConsensus v1

If you don’t have the v1 binary already backed up, reinstall GiltConsensus `v1.6.0` from your internal release artifact or package source, and place the binary at:

```bash
/usr/bin/giltconsd
```

---

## 6. Check the Installed Version

```bash
/usr/bin/giltconsd version
```

Expected output:

```
1.6.0
```

If the output shows a v2 version, replace the binary manually with the correct v1 build.

---

## 7. Reload the Daemon and Start GiltConsensus

```bash
sudo systemctl daemon-reload && sudo systemctl start giltconsd
```

---

## 8. Restart Telemetry (If Needed)

```bash
sudo systemctl restart telemetry
```

> Optional, only needed if your telemetry service was configured separately.

---

## 9. Check the Logs

```bash
journalctl -fu giltconsd
```

Use this to monitor the node and confirm it is running correctly on v1.

---

## 10. Retry Migration When Ready

Once the underlying issues are resolved, you can rerun the migration script or proceed with a manual migration workflow.
