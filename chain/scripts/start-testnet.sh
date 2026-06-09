#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

DATADIR="${GOLD_TESTNET_DATADIR:-.gold-testnet-mainnet-grade}"
NETWORK="${GOLD_TESTNET_NETWORK:-testnet}"
PASSWORD_FILE="${GOLD_TESTNET_PASSWORD_FILE:-$DATADIR/password.txt}"
GETH="${GETH:-$ROOT/gilt-chain/build/bin/geth}"
LOG_DIR="$DATADIR/logs"
PID_DIR="$DATADIR/pids"
RPC_API="eth,net,web3,admin,miner,personal,txpool"

need() { command -v "$1" >/dev/null 2>&1 || { echo "FAIL missing command: $1" >&2; exit 1; }; }
rpc() {
  local port="$1" method="$2" params="${3:-[]}"
  node -e '
    const http=require("http");
    const port=process.argv[1], method=process.argv[2], params=JSON.parse(process.argv[3]);
    const body=JSON.stringify({jsonrpc:"2.0",id:1,method,params});
    const req=http.request({host:"127.0.0.1",port,path:"/",method:"POST",headers:{"content-type":"application/json","content-length":Buffer.byteLength(body)},timeout:2500}, r=>{
      let d=""; r.on("data",c=>d+=c); r.on("end",()=>{try{const j=JSON.parse(d); if(j.error) process.exit(2); console.log(JSON.stringify(j.result));}catch(e){process.exit(3)}})
    });
    req.on("error",()=>process.exit(4)); req.on("timeout",()=>req.destroy()); req.end(body);
  ' "$port" "$method" "$params" 2>/dev/null
}
port_up() { rpc "$1" eth_chainId >/dev/null 2>&1; }
wait_rpc() {
  local port="$1" deadline=$((SECONDS + 60))
  until port_up "$port"; do
    if (( SECONDS >= deadline )); then echo "FAIL RPC $port did not become ready" >&2; exit 1; fi
    sleep 1
  done
}
validator_addr() {
  node -e 'const j=require(process.argv[1]); console.log(j.validators[Number(process.argv[2])].consensusAddress.toLowerCase())' "$ROOT/chain/genesis/out/$NETWORK/address-book.json" "$1"
}
node_enode() {
  rpc 8545 admin_nodeInfo | node -e 'const j=JSON.parse(require("fs").readFileSync(0,"utf8")); const e=j.enode.replace(/@[0-9.]+:/,"@127.0.0.1:"); console.log(e)'
}
pid_running() { [[ -f "$1" ]] && kill -0 "$(cat "$1")" >/dev/null 2>&1; }
start_node() {
  local idx="$1" rpc_port="$2" p2p_port="$3" bootnode_arg="$4"
  local node_dir="$DATADIR/node$idx" pid_file="$PID_DIR/node$idx.pid" log_file="$LOG_DIR/node$idx.log"
  local addr; addr="$(validator_addr "$idx")"
  if port_up "$rpc_port"; then
    echo "PASS node$idx already serving RPC on $rpc_port"
    return
  fi
  if pid_running "$pid_file"; then
    echo "FAIL node$idx pid $(cat "$pid_file") is running but RPC $rpc_port is not healthy" >&2
    exit 1
  fi
  [[ -d "$node_dir/geth/chaindata" ]] || "$GETH" --datadir "$node_dir" init "chain/genesis/out/$NETWORK/genesis.json"
  echo "+ start node$idx rpc=$rpc_port p2p=$p2p_port addr=$addr"
  nohup "$GETH" \
    --datadir "$node_dir" \
    --networkid "$(node -e 'console.log(require(process.argv[1]).chain.chainId)' "$ROOT/chain/genesis/out/$NETWORK/address-book.json")" \
    --port "$p2p_port" \
    $bootnode_arg \
    --http --http.addr 127.0.0.1 --http.port "$rpc_port" --http.api "$RPC_API" --http.vhosts '*' \
    --allow-insecure-unlock --unlock "$addr" --password "$PASSWORD_FILE" \
    --mine --miner.etherbase "$addr" --syncmode full --verbosity 3 \
    >"$log_file" 2>&1 &
  echo $! > "$pid_file"
  wait_rpc "$rpc_port"
  echo "PASS node$idx started pid=$(cat "$pid_file") rpc=$rpc_port"
}

need node
[[ -x "$GETH" ]] || { echo "FAIL geth binary not executable: $GETH" >&2; exit 1; }
[[ -f "$PASSWORD_FILE" ]] || { echo "FAIL password file missing: $PASSWORD_FILE" >&2; exit 1; }
mkdir -p "$LOG_DIR" "$PID_DIR"

node chain/genesis/build-genesis.js --network "$NETWORK"
node chain/scripts/preflight-validators.js \
  --genesis "chain/genesis/out/$NETWORK/genesis.json" \
  --validators "chain/genesis/out/$NETWORK/validators.conf" \
  --datadir "$DATADIR"

start_node 0 8545 30303 ""
BOOTNODE="$(node_enode)"
start_node 1 8546 30304 "--bootnodes $BOOTNODE"
start_node 2 8547 30305 "--bootnodes $BOOTNODE"

node chain/scripts/healthcheck-testnet.js --rpc http://127.0.0.1:8545,http://127.0.0.1:8546,http://127.0.0.1:8547 --min-peers 1 --max-lag 2

echo "PASS Gold Chain $NETWORK running from $DATADIR"
