No, you’re right. Testnet config is **not** a production-readiness gap if you are currently testing testnet. I should not have counted roughnet/testnet values, chain ID, [localhost](http://localhost) defaults, mainnet addresses, or missing local tools as “gaps.”

Filtered properly, the actual gaps I saw are:

**1. Bridge live scripts can bypass the intended finality discipline**

The protocol-side bridge listener has confirmation logic, but the live helper scripts can build checkpoint/exit data from a freshly mined child receipt path. If those scripts are used for testing or operations, they can exercise an unsafe flow that does not match the final bridge safety model.

That is a real implementation gap because testnet should behave like mainnet: bridge events should move only after the required confirmation/finality rule.  

**The native GILT bridge has a flaw that lets anyone make blocks unminable.** When a user wants to bridge GILT out of Gold Chain, the system relies on a two-step process: an on-chain event is fired, then the chain core reads that event afterward to actually subtract their balance. In between those two steps, the user can move their balance out using a normal transfer. The end result is that the after-step fails because the balance is no longer there, which makes the whole transaction error out — and that error invalidates the block. A malicious user can craft transactions on purpose that look fine but break the block whoever tries to include them. Block producers can be griefed indefinitely.  

**. Wrapped GOLD lets anyone walk away with whichever underlying gold they want.** Wrapped GOLD is supposed to be a 1:1 wrapper over real underlying gold (PAXG-backed or XAUT-backed). But the wrapper doesn't track who wrapped which one. It just counts total wrapped GOLD. So if Alice wraps PAXG-gold and Bob wraps XAUT-gold, Bob can unwrap and ask for PAXG-gold instead — and get it, because the wrapper has it. Bob steals Alice's backing.

**4. The bridge mints GOLD based on the requested amount, not the amount actually received.** PAXG charges a fee on every transfer. When a user deposits PAXG into the bridge, the bridge contract receives slightly less than the deposit amount but credits the user as if it received the full amount. So every PAXG deposit creates more GOLD on Gold Chain than there is PAXG locked on Ethereum. The deficit accumulates with every deposit and the bridge becomes structurally undercollateralized.

**5. When a validator is slashed, their GOLD is destroyed on Gold Chain but the matching PAXG/XAUT on Ethereum is locked forever.** GOLD is supposed to be redeemable for real gold-backed assets on Ethereum. When a misbehaving validator gets punished, their staked GOLD is sent to a burn address. But nothing tells the Ethereum-side bridge to release the underlying PAXG/XAUT. So real gold-backed assets sit permanently stuck in the bridge contract with no GOLD remaining to redeem against them. The punishment destroys real value rather than redirecting it to a treasury or stakers.

**9. The validator contract can tell the staking contract any "inflation amount" it wants and the staking contract believes it.** The inflation accounting on Gold Chain has two contracts that should agree. The validator contract mints new GILT and tells the staking contract "we minted X." The staking contract has no way to verify that X matches the actual amount minted. If the validator contract is upgraded or has a bug, the recorded inflation can drift away from real supply, breaking the long-term emission schedule.

**10. Inflation that goes to jailed validators sits stuck for a while and is double-counted in stats.** When a jailed validator is up for an inflation payout, the chain still mints the GILT and credits the inflation counter, but the GILT itself just sits in the validator contract until the next epoch flushes it to the system reward pool. During that gap, the chain reports the inflation as "distributed" while the funds aren't actually with anyone, and the per-validator earnings stats lose that amount.

**11. Slashing the last surviving validator destroys their stake but keeps them producing blocks.** There is a safety check that says "if jailing this validator would leave the chain with no producers, don't jail them." But by the time that check runs, the slashing has already burned their stake. So the chain ends up with a single producer whose stake has been reduced to almost nothing — and they can be slashed again and again, each time losing more stake while still being the active producer. The chain keeps running on a producer with no skin in the game.

**12. When a reward forward fails, the funds get stuck in the staking contract with no recovery.** For jailed or uninitialized validators, the staking contract forwards their reward to the system reward pool. If that forward fails for any reason (pool paused, receive function reverts), the contract silently ignores the failure, emits a "failed" log, and the GILT just stays in the staking contract. There's no automated retry and no admin function to sweep it out later. Every such failure leaks GILT into limbo.

**24. The legacy-to-new GOLD migration contract has no way to be funded.** The migration contract is supposed to take old GOLD from users and hand them back new GOLD. To do that it needs a supply of new GOLD sitting in it. The contract has a way for the owner to pull GOLD out, but no clean way to put GOLD in. Until somebody manually pushes new GOLD into it through a generic ERC1155 transfer, every migration attempt fails — and that funding step isn't part of any documented deploy procedure. 



**3. ABI/artifact consistency is not clean**

The core ABI files for `StakeHub` / `GiltValidatorSet` are modified and appear out of sync with current contract sources. If the ABI set does not exactly match deployed/generated contracts, chain calls and scripts can break or call wrong shapes.

That is an implementation/release gap, not a parameter decision.




## **Scanner can't decode Gold Chain**

**22. The block explorer treats Gold Chain as a generic Ethereum-like chain with no awareness of what's special about it.** The explorer is a fork of a generic chain explorer. The list of "chains we know how to read" doesn't include Gold Chain. So every staking action, validator rotation, BLS vote, GOLD mint (PAXG-backed vs XAUT-backed), governance action, and bridge event displays as raw bytes that no normal user can interpret. The chain looks like a black box to anyone using the explorer.

**23. The bridge indexer needs a specific chain type that isn't activated.** The explorer ships with database tables for indexing Polygon-style bridges, but those tables only get created if the explorer is told it's running on a specific chain type. Gold Chain doesn't match any of those types, so the tables aren't created, and the bridge events are never indexed. Users have no way to look up deposits or exits in the explorer.





**25. The owner of the GOLD contract can change the bridge math while bridge transactions are mid-flight.** The GOLD contract on Gold Chain and the predicate contract on Ethereum both have to agree on the same conversion ratio for deposits and withdrawals. The Ethereum side is fixed once deployed. The Gold Chain side can be changed at any time by the owner. If the owner ever updates the ratio, deposits already done in flight will produce mismatched amounts, and withdrawals that were valid yesterday will revert today. There's no migration path; it's a footgun handed to whoever holds the owner key.


**2. Bridge status/tooling does not distinguish event states strongly enough**

The tooling should not let an operator confuse “event seen” with “event safe.” It should explicitly separate pending, confirmed, finalized/actionable, and completed.

That is not a config issue. It is a bridge safety tooling gap. 

**6. Bridge messages sent to the wrong type of recipient silently vanish.** When the bridge tries to deliver a cross-chain message, it first checks if the recipient is a smart contract. If somebody (operator error, misconfiguration) points a message at a regular wallet address instead, the bridge moves on and marks the message as processed without delivering it and without saving it for retry. The asset on the Ethereum side is locked, but on Gold Chain the corresponding mint never happens. The user's funds are lost in transit with no recovery path.

**7. The bridge's "rescue failed deliveries" mechanism cannot be turned on.** There is a backup system to replay bridge messages that failed historically. To activate it, somebody has to initialize a piece of cryptographic proof data. Only one specific address is allowed to do that initialization, and that address is a deprecated cross-chain hub contract that no longer has the right function to make the call. So the rescue button is wired to a button that no longer exists. If anything goes wrong, there is no way to bulk-recover stuck messages.

**8. Anyone can replay individual failed bridge messages, not just the operator.** The single-message replay function has no access control. Any random person can pick a stuck message and re-trigger it. For the bridge itself this isn't catastrophic, but it lets attackers spam-replay messages at receivers that aren't expecting them, potentially confusing downstream contracts that assumed only the operator would re-deliver.

**13. A single bridge component is shared between two assets with very different decimal scales.** PAXG uses 18 decimals (like ETH), XAUT uses 6 decimals (like USDC). The bridge uses one contract with one fixed conversion ratio for both. The ratio is reasonable for PAXG but completely wrong for XAUT — XAUT deposits get scaled down to dust-sized amounts of GOLD on Gold Chain. As wired today, XAUT bridging is effectively unusable.

**14. A test/mock contract is sitting in the production bridge folder.** There is a fake child-token contract clearly labeled "Mock" that doesn't actually hold real balances — it just keeps a memo of who is "owed" tokens. It's deployable from the same scripts as the real contracts. If anyone misconfigures the deploy and points the bridge at this contract instead of the real one, the bridge will appear to mint GILT on Gold Chain while no actual GILT exists.

**15. The chain-id check for incoming bridge messages compares text strings to a config field.** Inbound bridge messages carry a chain identifier that's compared as text against the chain's own ID setting. If the Ethereum-side configuration sends the wrong identifier (typo, default value, mismatched environment), every message gets dropped silently with no alert. The chain just stops receiving anything and there's no logged error a monitoring system can pick up.

**16. The bridge has no minimum waiting period before treating Ethereum events as real.** The configuration for "how long to wait before trusting an Ethereum-side event" defaults to zero. Without manually setting it, the chain treats fresh events as final immediately — which means if Ethereum reorgs (re-orders recent blocks), the bridge could have already minted GOLD against a deposit that no longer exists. This directly violates the safety principle that only finalized events should drive bridge state.

**17. The bridge is shipped switched off.** The chain core looks for a bridge configuration URL. If the URL is empty, it just doesn't run the bridge. There's no default URL baked in anywhere. So a fresh node started with default settings produces blocks but never bridges anything in or out. An operator has to manually pass the right flag, and there is no startup warning or log that says "the bridge is disabled."


**3. A single private key can mint unlimited GOLD on Gold Chain and drain the real PAXG/XAUT held in the Ethereum-side bridge.** The GOLD token contract has a "mint" function restricted to its owner. The deploy script makes the owner a single normal wallet (an EOA), not a multisig or governance contract. That single key can mint as much GOLD as it wants out of thin air. The attacker can then run that fake GOLD through the bridge and the bridge will release real PAXG/XAUT on Ethereum to back it. One stolen key empties the entire collateral.



Left:





## **DEX is wired wrong**

**18. The DEX router has a precomputed shortcut for finding trading pairs that will probably point at the wrong addresses.** To save gas, the DEX has a hardcoded "fingerprint" of its trading-pair contract baked into its router. That fingerprint was copied from PancakeSwap on BSC. If the trading-pair contract on Gold Chain is compiled with even slightly different settings (different compiler version, different optimizer), the actual fingerprint changes. Then every swap the router does will calculate a wrong pair address and either revert or route into thin air. Nobody has verified the two match.

**19. The DEX router needs a wrapped native-token contract at launch, and there isn't one.** Every Uniswap-style DEX requires a "wrapped" version of the native coin (like WETH for Ethereum). The Gold Chain version (WGILT) is in the repo but no script deploys it, and the genesis doesn't pre-deploy it either. Without WGILT at a known address, the router can't even be constructed, which means no native-coin trading at all.

**20. The wrapped GILT contract is old-style code that has known compatibility problems and a balance leak.** The contract is written against a very old Solidity version. It uses an obsolete pattern for receiving native coin that some modern wallets and DEX integrations don't handle correctly — depositing the first time costs more gas than a basic transfer provides, so it can fail unpredictably depending on the sender's history. On top of that, the contract allows users to "send" their wrapped balance to the zero address as if burning it, but that doesn't actually reduce supply — it just adds to the zero address's balance. Supply drifts away from reality.

**21. None of the advanced DEX features have been wired to Gold Chain.** Concentrated liquidity (V3), farming, voting-escrow, lottery, prediction — all the modules that PancakeSwap has — exist as source code in the repo, but nothing deploys them on Gold Chain and the frontend doesn't know they exist there. They're effectively decoration until somebody writes deployment scripts and frontend config for each.  

**4. DEX subgraph logic still contains inherited BSC pricing assumptions**

I am not talking about network config. I mean the indexing/pricing logic itself has BSC/WBNB-style assumptions. If the DEX testnet is supposed to behave like final Gold Chain, the indexer pricing logic needs to model `GOLDGILT` correctly.

That is a code behavior gap if DEX analytics are part of what you need working.

That’s the cleaned list. The rest I mentioned before was noise for your current ask.


**26. Nothing in the repo actually ties the DEX to Gold Chain.** There are scripts that deploy the bridge and the GOLD contract. There are no scripts that deploy the DEX factory, the DEX router, and the wrapped native token together as one set on Gold Chain. They exist as separate pieces with no connecting glue. Standing up the DEX from this repo on a fresh chain would require writing new deployment glue from scratch.  

---

---

## **Wiring inconsistencies that break the runtime path**


