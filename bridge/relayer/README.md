# Gold Chain bridge relayer

Relays only finalized bridge events for the canonical lock/mint/burn/release model:

- Ethereum `PAXG`/`XAUT` is locked in `GoldRootCustody`.
- Gold Chain credits/mints route-backed `GOLD` through `GoldChildBridge`.
- Redemption burns/debits `GOLD` on Gold Chain.
- Ethereum `PAXG`/`XAUT` is released from custody.

The relayer core refuses to start without an explicit finality policy. Local tests use in-memory chain mocks, but production configuration must provide real RPC endpoints, contract addresses, enabled routes, and finality thresholds.

## Test

```bash
npm test
```

## Minimal production config shape

```json
{
  "environment": "production",
  "ethereum": {
    "rpcUrl": "https://...",
    "rootCustodyAddress": "0x...",
    "startBlock": 0,
    "finality": { "minConfirmations": 64 }
  },
  "goldChain": {
    "rpcUrl": "https://...",
    "childBridgeAddress": "0x...",
    "startBlock": 0,
    "finality": { "minConfirmations": 20 }
  },
  "routes": {
    "1": { "symbol": "PAXG", "rootToken": "0x...", "enabled": true },
    "2": { "symbol": "XAUT", "rootToken": "0x...", "enabled": true }
  },
  "relayer": { "keyPath": "/secure/path/relayer.json" },
  "statePath": "./relayer-state.json"
}
```
