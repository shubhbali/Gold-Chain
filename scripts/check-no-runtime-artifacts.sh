#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

# Runtime data must never be tracked. Keep this intentionally narrow enough to
# avoid source/test fixtures, but broad enough to catch the common production
# leak classes for GoldScan/Postgres, Erlang DETS, prod logs, and node chaindata.
mapfile -t offenders < <(
  git ls-files | awk '
    /(^|\/)goldscan-db-data[^\/]*(\/|$)/ {print; next}
    /(^|\/)(postgres-data|postgres_data|pgdata|pg_data)(\/|$)/ {print; next}
    /(^|\/)PG_VERSION$/ {print; next}
    /(^|\/)pg_(wal|xact|multixact|subtrans|tblspc|twophase|replslot|serial|snapshots|stat|stat_tmp|notify|logical)(\/|$)/ {print; next}
    /(^|\/)logs\/prod\// {print; next}
    /(^|\/)prod\/.*\.log$/ {print; next}
    /\.dets$/ {print; next}
    /(^|\/)chaindata(\/|$)/ {print; next}
  '
)

if ((${#offenders[@]} > 0)); then
  echo "ERROR: tracked runtime artifacts are present:" >&2
  printf '  %s\n' "${offenders[@]}" >&2
  echo "Remove these from git and keep runtime state outside the repository." >&2
  exit 1
fi

echo "OK: no tracked Postgres/DETS/prod-log/chaindata runtime artifacts found."
