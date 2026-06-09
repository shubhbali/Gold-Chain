# Gold Chain Production Overhaul Plan

> **For Hermes:** Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Turn the current mixed Gold Chain repo into one clean production-grade BSC/Parlia-style L1 where GILT is the native gas/staking/inflation token, GOLD is the route-aware gold-backed asset, the Ethereum bridge is lock/mint/burn/release, and future reserve-backed migration is built in without preserving fake fallback paths.

**Architecture:** One canonical execution client (`gilt-chain`) plus one canonical genesis/system-contract builder. Delete or quarantine duplicate execution/Polygon/Bor/Heimdall paths instead of pretending they are fallback options. Bridge and migration code must depend on the canonical chain, not carry another chain implementation.

**Non-negotiables:**
- No BSC chain ID `56` for Gold Chain.
- No compressed fork-test schedule for persistent testnet/mainnet.
- No validator signer mismatch.
- No duplicate execution client as a hidden fallback.
- No mocks or shortcut bridge flows in production path.
- No single omnipotent GOLD minter.
- Old PAXG-backed claims redeem PAXG; old XAUT-backed claims redeem XAUT.

---

## Phase 0 — Freeze, branch, and make the repo safe to refactor

### Task 0.1: Create overhaul branch

**Objective:** Isolate the refactor from current code.

**Commands:**
```bash
cd /root/workspaces/gold/gold-chain
git status --short
git checkout -b overhaul/production-gold-chain
```

**Verification:**
```bash
git branch --show-current
# expected: overhaul/production-gold-chain
```

---

### Task 0.2: Capture current inventory before deleting anything

**Objective:** Produce a deletion/refactor ledger so nothing is removed blindly.

**Create:** `docs/overhaul/current-inventory.md`

**Content must list:**
- canonical candidate: `gilt-chain/`
- genesis/system contracts: `gilt-genesis-contract/`
- duplicate/suspect execution path: `bridge/gilt-exec/`
- Polygon/Heimdall/Bor-style paths: `bridge/gilt-consensus/`, `bridge/pos-contracts/`, `bridge/pos-portal/`
- runtime datadirs: `.gold-testnet*`
- launch scripts and generated genesis files

**Verification:**
```bash
git diff -- docs/overhaul/current-inventory.md
```

---

## Phase 1 — Choose one canonical chain and remove false fallbacks

### Task 1.1: Declare canonical components

**Objective:** Create a single architecture decision record.

**Create:** `docs/architecture/ADR-0001-canonical-chain.md`

**Decision:**
- `gilt-chain/` is the only execution/consensus client.
- `gilt-genesis-contract/` is either kept as the genesis/system-contract source or replaced by `chain/genesis/`, but not duplicated.
- `bridge/gilt-exec/` is not a fallback execution client.
- Polygon/Bor/Heimdall components are not part of Gold Chain unless a later ADR explicitly adopts them.

**Verification:** ADR clearly says what is canonical and what is deleted/quarantined.

---

### Task 1.2: Delete or quarantine duplicate execution code

**Objective:** Remove the second execution-client path from the production tree.

**Primary action:** delete if not imported by canonical build:
- `bridge/gilt-exec/`

**If immediate deletion breaks bridge package imports:**
- move it to `attic/removed-gilt-exec/`
- add `attic/README.md` saying it is not buildable production code and must not be launched
- then remove all references from production scripts/configs

**Search commands:**
```bash
cd /root/workspaces/gold/gold-chain
git grep -n "gilt-exec\|bridge/gilt-exec"
```

**Verification:**
```bash
git grep -n "gilt-exec\|bridge/gilt-exec" -- ':!attic/**'
# expected: no production references
```

---

### Task 1.3: Remove Polygon/Bor/Heimdall bridge path from production path

**Objective:** Stop treating Polygon architecture as part of Gold Chain.

**Delete/quarantine:**
- `bridge/gilt-consensus/`
- `bridge/pos-contracts/`
- `bridge/pos-portal/`

**Allowed exception:** keep only if a file is directly reused by the new Ethereum custody bridge and has no Bor/Heimdall assumptions. If reused, move the minimal code into new paths under `bridge/ethereum/` or `bridge/gold-chain/`.

**Verification:**
```bash
git grep -n "heimdall\|bor\|polygon\|matic\|pos-portal\|pos-contracts" -- ':!attic/**'
# expected: no production-path dependency unless explicitly documented in ADR
```

---

## Phase 2 — Fix chain identity and genesis generation

### Task 2.1: Create one canonical chain spec

**Objective:** Stop scattering chain ID, validators, forks, and system addresses across files.

**Create:** `chain/spec/gold-mainnet.yaml`
**Create:** `chain/spec/gold-testnet.yaml`

**Required fields:**
```yaml
chain:
  name: Gold Chain
  chainId: <NEW_UNIQUE_ID>
  networkId: <SAME_OR_EXPLICIT_ID>
  nativeSymbol: GILT
  blockTimeSeconds: 3

forks:
  activateFromGenesis:
    berlin: true
    london: true
    shanghai: true
    cancun: false
  compressedTestSchedule: false

consensus:
  engine: parlia
  epochLength: 200

validators:
  - name: validator-0
    consensusAddress: 0x...
    feeAddress: 0x...
    giltFeeAddress: 0x...
    blsPublicKey: 0x...
    votingPower: 100

systemContracts:
  validatorSet: 0x0000000000000000000000000000000000001000
  slash: 0x0000000000000000000000000000000000001001
  systemReward: 0x0000000000000000000000000000000000001002
  stakeHub: 0x0000000000000000000000000000000000002002
  govHub: 0x0000000000000000000000000000000000001007
  governor: 0x0000000000000000000000000000000000002004
  timelock: 0x0000000000000000000000000000000000002005
  goldBridge: 0x0000000000000000000000000000000000003000
  goldAsset: 0x0000000000000000000000000000000000003001
```

**Decision needed before implementation:** pick final unique chain IDs for mainnet/testnet. Do not use `56`.

---

### Task 2.2: Replace compressed fork-test genesis with production genesis builder

**Objective:** Generate genesis from `chain/spec/*.yaml`, not hand-edit `genesis-template.json`.

**Create:** `chain/genesis/build-genesis.js` or `chain/genesis/build-genesis.go`

**Inputs:**
- `chain/spec/gold-mainnet.yaml`
- `chain/spec/gold-testnet.yaml`
- compiled system contract bytecode/artifacts

**Outputs:**
- `chain/genesis/out/mainnet/genesis.json`
- `chain/genesis/out/testnet/genesis.json`
- `chain/genesis/out/*/validators.conf`
- `chain/genesis/out/*/address-book.json`

**Hard validations:**
- reject chain ID `56`
- reject compressed fork schedule for non-devnet
- reject empty validator set
- reject duplicate validator addresses
- reject validator address mismatch between extraData and validator set storage
- reject missing system contract bytecode

**Verification:**
```bash
node chain/genesis/build-genesis.js --network testnet
node chain/genesis/build-genesis.js --network mainnet
jq .config.chainId chain/genesis/out/testnet/genesis.json
```

---

### Task 2.3: Update `gilt-chain/params/config.go`

**Objective:** Make client chain configs match generated genesis.

**Modify:** `gilt-chain/params/config.go`

**Required changes:**
- replace BSC chain ID `56` in Gold config
- add `GoldMainnetChainConfig`
- add `GoldTestnetChainConfig`
- remove or clearly label `RialtoChainConfig` as dev-only fork-test, not used by persistent testnet
- set forks active from genesis or match `chain/spec/*.yaml`

**Verification:**
```bash
cd gilt-chain
go test ./params ./core ./consensus/parlia
```

---

## Phase 3 — Validator/signing correctness

### Task 3.1: Build validator key manifest

**Objective:** Make validator keys explicit and auditable.

**Create:** `chain/validators/validators.testnet.yaml`
**Create:** `chain/validators/validators.mainnet.template.yaml`

**Fields:**
```yaml
validators:
  - name: validator-0
    consensusAddress: 0x...
    signerKeystorePath: /secure/path/not/in/repo
    nodeKeyPath: /secure/path/not/in/repo
    feeAddress: 0x...
    blsPublicKey: 0x...
```

**Rule:** private keys never committed.

---

### Task 3.2: Add preflight validator check

**Objective:** Chain must refuse launch if signer keys do not match genesis validators.

**Create:** `chain/scripts/preflight-validators.js`

**Checks:**
- read generated genesis `extraData`
- read validator set storage if encoded in genesis alloc
- read `validators.conf`
- read local keystore addresses for node datadirs
- fail if signer account is not authorized in genesis

**Verification command:**
```bash
node chain/scripts/preflight-validators.js \
  --genesis chain/genesis/out/testnet/genesis.json \
  --validators chain/genesis/out/testnet/validators.conf \
  --datadir .gold-testnet-v2
```

**Expected current result before fix:** FAIL because `.gold-testnet-v2` keys do not match `0x225D...`.

**Expected result after fix:** PASS.

---

### Task 3.3: Replace localnet/testnet launch scripts

**Objective:** Launch only from generated genesis and validated keys.

**Create/replace:** `chain/scripts/start-testnet.sh`

**Required behavior:**
1. run genesis builder
2. run validator preflight
3. initialize datadirs only if explicitly asked
4. start validators with matching signer accounts
5. expose RPC/WS/metrics
6. write process IDs/log paths

**No destructive reset unless flag is passed:**
```bash
--reset-datadir-confirmed
```

**Verification:**
```bash
bash chain/scripts/start-testnet.sh --network testnet
curl -s localhost:8545 -H 'content-type: application/json' \
  -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

---

## Phase 4 — GILT native token and inflation

### Task 4.1: Define GILT economics spec

**Objective:** Make GILT supply/inflation deterministic.

**Create:** `docs/economics/gilt-tokenomics.md`

**Must define:**
- initial supply
- genesis allocations
- inflation rate/schedule
- per-block or per-epoch mint formula
- validator/delegator reward split
- treasury/community allocation if any
- max annual inflation
- governance-adjustable parameters and limits

---

### Task 4.2: Implement one reward mint authority

**Objective:** Only protocol/system reward path mints inflationary GILT.

**Modify likely paths:**
- `gilt-chain/consensus/parlia/*`
- `gilt-chain/core/*`
- `gilt-genesis-contract/contracts/*SystemReward*`
- `gilt-genesis-contract/contracts/*Stake*`

**Rules:**
- no arbitrary EOA can mint GILT
- bridge cannot mint GILT
- GOLD contracts cannot mint GILT
- GILT reward minting follows the exact schedule

**Tests:**
- unit test reward amount per epoch
- integration test validator gets reward
- test inflation cap cannot be exceeded

**Verification:**
```bash
cd gilt-chain
go test ./consensus/parlia ./core -run 'Reward|Inflation|GILT'
cd ../gilt-genesis-contract
forge test -vvv --match-contract '*Reward*'
```

---

## Phase 5 — GOLD asset model

### Task 5.1: Define GOLD route model

**Objective:** Lock the asset semantics before coding.

**Create:** `docs/assets/gold-route-accounting.md`

**Decision:** Phase 1 uses route-aware claims:
- route `PAXG` claim redeems PAXG
- route `XAUT` claim redeems XAUT

**Recommended implementation:** ERC1155 route claims.

**Token IDs:**
```text
1 = PAXG-backed GOLD claim
2 = XAUT-backed GOLD claim
```

**Invariant:**
```text
routeSupply[PAXG] <= lockedPAXG * PAXG_TO_GOLD_RATIO
routeSupply[XAUT] <= lockedXAUT * XAUT_TO_GOLD_RATIO
```

---

### Task 5.2: Replace/clean GOLD contract authority model

**Objective:** Split mint authorities by purpose.

**Create/modify contracts under:** `contracts/gold/` or `gilt-genesis-contract/contracts/gold/`

**Contracts:**
- `GoldRouteToken.sol` — route-aware GOLD claims
- `GoldBridgeMinter.sol` — can mint/burn only Phase 1 route claims
- `ReserveGoldController.sol` — future Phase 2 reserve-backed issuance
- `GoldMigrationController.sol` — converts old route claims to reserve-backed claims when phase opens
- `GoldPhaseRegistry.sol` — phase state machine

**Delete/avoid:**
- any single contract that can mint all GOLD for bridge, reserve, migration, treasury, and admin

**Tests:**
```bash
forge test -vvv --match-contract 'GoldRoute|GoldBridge|ReserveGold|GoldMigration|GoldPhase'
```

---

### Task 5.3: Add GOLD phase state machine

**Objective:** Migration must be explicit and irreversible where required.

**States:**
```solidity
enum GoldPhase {
    BridgeBacked,          // Phase 1 deposits + withdrawals enabled
    MigrationAnnounced,    // migration announced, deposits may still be enabled depending policy
    BridgeDepositsStopped, // no new bridge minting, old withdrawals active
    MigrationOpen,         // old claims can convert to reserve-backed GOLD
    LegacyRedemptionOnly,  // old claims redeem only, new reserve system live
    LegacySunset           // only if legally/governance approved
}
```

**Rules:**
- only governance + timelock changes phase
- cannot skip unsafe states
- stopping deposits must not stop withdrawals
- migrated claim cannot be redeemed twice

---

## Phase 6 — Ethereum bridge rebuilt cleanly

### Task 6.1: Root custody contracts

**Objective:** Ethereum side locks/releases PAXG and XAUT only.

**Create:** `bridge/ethereum/contracts/GoldRootCustody.sol`
**Create:** `bridge/ethereum/contracts/RouteRegistry.sol`

**Functions:**
- `deposit(routeId, amount, recipientOnGoldChain)`
- `finalizeWithdrawal(routeId, amount, recipient, proof)`
- `pauseRoute(routeId)`
- `setRoute(...)` via governance/timelock only

**Security:**
- reentrancy guard
- replay protection
- per-route accounting
- finality/proof verification hook
- emergency pause

---

### Task 6.2: Child bridge contracts

**Objective:** Gold Chain side mints/burns route claims.

**Create:** `bridge/gold-chain/contracts/GoldChildBridge.sol`

**Functions:**
- `finalizeDeposit(rootDepositId, routeId, amount, recipient, proof)`
- `withdraw(routeId, amount, ethereumRecipient)`

**Rules:**
- deposit proof cannot replay
- wrong route rejected
- bridge mints only via `GoldBridgeMinter`
- withdraw burns route claim before emitting exit event

---

### Task 6.3: Relayer/checkpoint service

**Objective:** One bridge service watches Ethereum and Gold Chain and relays finalized events.

**Create:** `bridge/relayer/`

**Required config:**
- Ethereum RPC
- Gold Chain RPC
- root custody address
- child bridge address
- confirmation/finality policy
- route registry
- relayer key path

**Verification:**
- simulated local Ethereum root + Gold Chain deposit/withdraw test
- then Sepolia test with real token mocks or approved real test tokens
- never claim production-ready until lock/mint/burn/release passes end-to-end

---

## Phase 7 — Migration design implemented before mainnet

### Task 7.1: Build migration controller tests first

**Objective:** Future migration cannot break old claims.

**Tests:**
- user holds PAXG route claim
- deposits stopped
- user can still withdraw PAXG
- user can choose to migrate to reserve-backed GOLD
- migrated claim cannot withdraw PAXG after conversion
- unmigrated claim remains redeemable
- XAUT route remains separate

**Verification:**
```bash
forge test -vvv --match-contract 'GoldMigration'
```

---

### Task 7.2: Add reserve-backed GOLD controller

**Objective:** Phase 2 issuance is separate from Phase 1 bridge.

**Rules:**
- reserve issuer role separate from bridge minter
- mint caps
- pause
- audit metadata/reserve report hash
- governance + timelock for parameter changes

---

## Phase 8 — Build, tests, and production gates

### Task 8.1: Add canonical build script

**Create:** `scripts/build-all.sh`

**Runs:**
```bash
cd gilt-chain && go test ./...
cd ../gilt-genesis-contract && forge build && forge test
cd ../bridge/ethereum && forge build && forge test
cd ../bridge/gold-chain && forge build && forge test
cd ../bridge/relayer && npm test
```

---

### Task 8.2: Add production gate script

**Create:** `scripts/production-gate.sh`

**Must fail if:**
- chain ID is `56`
- compressed fork schedule exists in mainnet/testnet spec
- duplicate execution clients are referenced
- genesis validator mismatch exists
- bridge has mock-only route in production config
- GOLD mint authority is not split
- old bridged redemption tests fail
- no fresh transaction inclusion test exists

---

### Task 8.3: Persistent testnet acceptance test

**Objective:** Testnet must behave like mainnet rehearsal.

**Acceptance:**
- 3+ validators
- all validators same genesis hash
- chain produces blocks past 10,000
- restart validators without state loss
- send fresh transaction and get receipt
- deploy GOLD/bridge system contracts
- run PAXG route deposit/withdraw test
- run XAUT route deposit/withdraw test
- pause bridge deposit and verify withdrawal still works
- migration dry-run works without breaking old claims

---

## Phase 9 — What gets deleted

Delete or quarantine unless proven necessary by a fresh ADR:

```text
bridge/gilt-exec/
bridge/gilt-consensus/
bridge/pos-contracts/
bridge/pos-portal/
.gold-testnet-v2/ generated broken state
old genesis files using chainId 56 for Gold Chain
old compressed fork persistent testnet configs
scripts that generate validators not inserted into genesis
scripts that launch nodes without validator preflight
any bridge deployment using incomplete child-only address books
any mock bridge code referenced by production configs
```

Keep only if rewritten into canonical production paths:

```text
gilt-chain/
gilt-genesis-contract/ or replacement chain/genesis + system-contracts
GOLD route contracts
GILT staking/reward/system contracts
new bridge/ethereum/
new bridge/gold-chain/
new bridge/relayer/
new migration/
```

---

## Phase 10 — Implementation order

Do not start with bridge UI/scanner/DEX. Order is:

1. canonical chain decision
2. delete/quarantine duplicate execution paths
3. unique chain ID and clean chain spec
4. genesis builder
5. validator preflight
6. clean multi-validator testnet
7. GILT inflation/reward correctness
8. GOLD route contracts
9. Ethereum bridge custody + child bridge
10. relayer/checkpoint
11. migration controller
12. explorer/scanner/DEX after chain+bridge is stable

---

## Done definition

This overhaul is done only when:

- `scripts/production-gate.sh` passes
- `scripts/build-all.sh` passes
- persistent testnet launches from generated genesis
- validator keys match genesis
- blocks continue past fork boundaries
- GILT rewards/inflation match spec
- PAXG-backed GOLD deposits and withdraws as PAXG
- XAUT-backed GOLD deposits and withdraws as XAUT
- Phase 2 migration tests prove old claims remain redeemable
- no production code references deleted duplicate execution/Polygon paths

