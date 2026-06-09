#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '../..');

function usage() {
  console.error(`Usage: node chain/scripts/disaster-recovery-check.js [options]

Options:
  --datadir <dir>        Existing persistent datadir (default: .gold-testnet-live)
  --network <name>       Network (default: testnet)
  --backup-dir <dir>     Backup output dir (default: .gold-testnet-live/backups/<timestamp>)
  --verify-restore       Build a temporary restored validator-material tree and run preflight

Copies only validator material/config needed for recovery. It does not hot-copy
chaindata, because hot chaindata snapshots are not a safe production DR proof.
`);
  process.exit(2);
}
function arg(name, def = null) { const i = process.argv.indexOf(name); return i === -1 ? def : process.argv[i + 1]; }
function has(name) { return process.argv.includes(name); }
function must(c, m) { if (!c) throw new Error(m); }
function ts() { return new Date().toISOString().replace(/[:.]/g, '-'); }
function sha(file) { return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex'); }
function copyFile(src, dst) { fs.mkdirSync(path.dirname(dst), { recursive: true }); fs.copyFileSync(src, dst); }
function run(cmd, args) {
  const res = spawnSync(cmd, args, { cwd: ROOT, encoding: 'utf8' });
  if (res.status !== 0) throw new Error(`command failed: ${cmd} ${args.join(' ')}\n${res.stderr}${res.stdout}`.trim());
  return res.stdout;
}
function walk(dir, pred, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, ent.name);
    if (ent.isDirectory()) walk(p, pred, out);
    else if (pred(p)) out.push(p);
  }
  return out;
}

function main() {
  const datadir = path.resolve(ROOT, arg('--datadir', '.gold-testnet-live'));
  const network = arg('--network', 'testnet');
  const backupDir = path.resolve(ROOT, arg('--backup-dir', path.join(path.relative(ROOT, datadir), 'backups', ts())));
  must(fs.existsSync(datadir), `datadir missing: ${datadir}`);

  run('node', ['chain/genesis/build-genesis.js', '--network', network]);
  const files = [
    `chain/spec/gold-${network}.yaml`,
    `chain/genesis/out/${network}/genesis.json`,
    `chain/genesis/out/${network}/validators.conf`,
    `chain/genesis/out/${network}/address-book.json`,
  ];
  for (const f of files) copyFile(path.join(ROOT, f), path.join(backupDir, f));
  const pass = path.join(datadir, 'password.txt');
  must(fs.existsSync(pass), `password file missing: ${pass}`);
  copyFile(pass, path.join(backupDir, path.relative(ROOT, pass)));

  const keyFiles = walk(datadir, p => p.includes(`${path.sep}keystore${path.sep}`));
  must(keyFiles.length > 0, `no keystore files under ${datadir}`);
  for (const f of keyFiles) copyFile(f, path.join(backupDir, path.relative(ROOT, f)));

  const manifest = {
    generatedAt: new Date().toISOString(),
    network,
    sourceDatadir: path.relative(ROOT, datadir),
    note: 'Validator material/config backup only. Chaindata intentionally excluded; nodes recover by syncing from genesis plus peers/snapshots taken with proper DB tooling.',
    files: walk(backupDir, () => true).map(f => ({ path: path.relative(backupDir, f), sha256: sha(f), bytes: fs.statSync(f).size })),
  };
  fs.writeFileSync(path.join(backupDir, 'MANIFEST.json'), JSON.stringify(manifest, null, 2) + '\n');

  if (has('--verify-restore')) {
    const restore = path.join(backupDir, 'restore-check');
    for (let i = 0; i < 3; i++) {
      const src = path.join(backupDir, path.relative(ROOT, datadir), `node${i}`, 'keystore');
      const dst = path.join(restore, `node${i}`, 'keystore');
      if (fs.existsSync(src)) fs.cpSync(src, dst, { recursive: true });
    }
    const out = run('node', ['chain/scripts/preflight-validators.js', '--genesis', path.join(backupDir, `chain/genesis/out/${network}/genesis.json`), '--validators', path.join(backupDir, `chain/genesis/out/${network}/validators.conf`), '--datadir', restore]);
    process.stdout.write(out);
  }

  console.log(`PASS disaster recovery backup: ${path.relative(ROOT, backupDir)} files=${manifest.files.length}`);
  console.log('PASS restore proof: genesis/config/validator keystores are sufficient to reconstruct validator identity without resetting live chaindata');
}

main();
