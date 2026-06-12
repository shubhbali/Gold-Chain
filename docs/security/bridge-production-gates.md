# Gold Bridge Production Gates

A bridge build is not production-ready unless every gate below passes with real commands and recorded output.

## Contract Gates

- Root custody only accepts supported route IDs:
  - `1 = PAXG`
  - `2 = XAUT`
- Root custody rejects unsupported route IDs.
- Root custody rejects fee-on-transfer short receipts instead of over-accounting.
- Route-finalized custody configuration cannot change token address.
- Deposits and withdrawals can be paused independently by route.
- Withdrawal release cannot exceed `lockedByRoute`.
- Root-chain withdrawal release is permissionless after a valid threshold proof; relayer/finalizer liveness is not required for authorization.
- Deposit and withdrawal IDs are replay-protected on-chain.
- Typed bridge message hash binds:
  - source chain ID
  - destination chain ID
  - source bridge
  - destination bridge
  - route ID
  - token
  - sender
  - recipient
  - amount
  - nonce
  - source block
  - tx hash
  - log index
  - direction
- Threshold verifier rejects insufficient, duplicate, unsorted, malformed, or non-signer signatures.
- Production gate fails if `GoldRootCustody.finalizeWithdrawal()` reintroduces `onlyFinalizer`.

## Relayer Gates

- Relayer config rejects unsafe production finality.
- Relayer requires safe/finalized tags or explicit conservative production finality.
- Relayer validates exact event source chain ID.
- Relayer validates exact emitter bridge address.
- Relayer validates block hash, tx hash, and log index.
- Relayer validates route symbol and recipient address.
- Relayer uses overlap rescans to avoid cursor skips.
- Relayer treats already-processed on-chain messages as successful after restart.
- Relayer state writes are atomic temp-file + fsync + rename.

## E2E Gates

- PAXG lock -> route 1 GOLD mint.
- XAUT lock -> route 2 GOLD mint.
- PAXG route GOLD burn -> PAXG release.
- XAUT route GOLD burn -> XAUT release.
- Valid finalized burn proof can be submitted by user, keeper, sponsor, or relayer.
- Replay rejection.
- Wrong emitter rejection.
- Wrong chain rejection.
- Malformed recipient rejection.
- Pause behavior.
- Relayer restart after tx success before durable save.

## Commands

```bash
export PATH="$HOME/.foundry/bin:$PATH"
cd /root/workspaces/gold/gold-chain/gilt-genesis-contract
forge test -vvv --match-contract 'BridgeCustodyHardening|BridgeThresholdVerifier'

cd /root/workspaces/gold/gold-chain/bridge/relayer
npm run check
npm test

cd /root/workspaces/gold/gold-chain
export GOLD_TESTNET_DATADIR=.gold-testnet-mainnet-grade
bash scripts/build-all.sh
```

## Acceptance

- No skipped bridge security tests.
- No test-only mocks in production route config.
- No low-confirmation production finality.
- No single finalizer accepted as final production security model without documented signer/proof upgrade and explicit risk acceptance.
