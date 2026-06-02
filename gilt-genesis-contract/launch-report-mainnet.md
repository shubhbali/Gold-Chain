# Gold Chain Launch Report: mainnet

- Chain ID: 56
- Source chain ID: Gold-Chain-Mainnet
- Config: launch-config/mainnet.json
- Config hash: c6d987333be843c08fa2b87a48f4fabc757f34d3ea489a8fb17d90e49877ade5
- Genesis: genesis.json
- Genesis hash: d0976a1879d4544cdf4d202fbc98291ac39561909897d36a0496d43ec0583104
- Validator set bytes hash: b965a9ece6e04b2aee630af60e2827f81f4017b38cde0e13aab481d4282809b3
- Validator bootstrap hash: 67d6740c05efc15c511341b34947419f54844e27a1ede1057ff51add55d88d45
- Extra data hash: fa2de8acff7f78bd08f431f2c996746f0ba4ebaaa50fcd97b67900f0c104195a

## Required Launch Features

- Total allocated GILT wei: 3000000000000000000000000000
- GILT inflation: ON from block_1
- GILT reward source: GILT_INFLATION_AND_FEES
- GILT inflation base supply wei: 3000000000000000000000000000
- GILT inflation initial rate: 1000 bps
- GILT inflation minimum rate: 150 bps
- GILT inflation yearly decay: 1500 bps
- GILT staking: ON
- GOLD staking: ON from day one
- GOLD staking rewards: GILT_PLUS_FEES
- GOLD reward split: 2000 bps
- Staking unbond period: 7 days
- Slash reserve vault: 0x08E68Ec70FA3b629784fDB28887e206ce8561E08
- Max elected validators: 45
- GOLD contract address: 0x0000000000000000000000000000000000003003
- GOLD admin: 0x08E68Ec70FA3b629784fDB28887e206ce8561E08
- GOLD bridge depositor: 0x08E68Ec70FA3b629784fDB28887e206ce8561E08
- GOLD type: ERC1155
- GOLD emits GOLD rewards: false
- PAXG-backed GOLD token ID: 1
- XAUT-backed GOLD token ID: 2
- GOLD route lock: LOCKED (PAXG/XAUT precision finalized)
- GOLD route precision finalized at launch: true
- GOLD bridge deposits closed at launch: false
- GOLD migration minting enabled at launch: false
- Migration at launch: OFF
- Ratio enforcement at launch: OFF
- PAXG route: rootDecimals=18, goldDecimals=18, scale=1/1, rootUnit=1
- XAUT route: rootDecimals=6, goldDecimals=18, scale=1000000000000/1, rootUnit=1

## GILT Allocations

- Total allocated GILT wei: 3000000000000000000000000000
- 0xD1445cB51A14E781EB8032539e2aF254a67f1f03: 500000000000000000000000000
- 0x9020565B91E731B63aC8c3297101A9Fe83806CEb: 500000000000000000000000000
- 0x9E0d48A0c7459e2D13A2c693fdCFFdaC1E25dDc5: 500000000000000000000000000
- 0x5122281d3A2AdD52e05B2813694D02f662a6bBD0: 500000000000000000000000000
- 0x218D9e56fde6665646C6e0fc0EbA7dC609016655: 500000000000000000000000000
- 0xE6f904b6f319A1824E5A167A9Be1592F87A5E6C8: 500000000000000000000000000

## Validators

- 0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0: votingPower=0x0000000000000064, fee=0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0, giltFee=0x225D6AF01985dd4f627abbe1ee0062Fce8C3f5D0, bls=0x81c0ae1ad54aeaea61d454dbfc58e5268e659b46ccd5099b31c5167698af671f709484b753b84c99ed0b8f2a83a8c1a9

## Governance

- StakeHub protector: 0x08E68Ec70FA3b629784fDB28887e206ce8561E08
- Governor protector: 0x08E68Ec70FA3b629784fDB28887e206ce8561E08

## System Predeploys

| Contract | Address | Classification | Runtime bytes | Code hash | Artifact |
| --- | --- | --- | ---: | --- | --- |
| GiltValidatorSet | 0x0000000000000000000000000000000000001000 | ACTIVE_CORE | 27591 | e8a818496b05574b04753b40a25c547b42feb8314b8ea3dd0dcea3357ef280b0 | out/GiltValidatorSet.sol/GiltValidatorSet.json |
| SlashIndicator | 0x0000000000000000000000000000000000001001 | ACTIVE_CORE | 13039 | adb09f231125feff90896fde9b4a267e5503be8c59a8d4d6a4860fd8d20ced25 | out/SlashIndicator.sol/SlashIndicator.json |
| SystemReward | 0x0000000000000000000000000000000000001002 | ACTIVE_CORE | 2925 | 4a7cf6c0bbb6c0f181a8a173b2f15e5520321a8878780106e47b6f618e8398e5 | out/SystemReward.sol/SystemReward.json |
| TendermintLightClient | 0x0000000000000000000000000000000000001003 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| TokenHub | 0x0000000000000000000000000000000000001004 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| RelayerIncentivize | 0x0000000000000000000000000000000000001005 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| RelayerHub | 0x0000000000000000000000000000000000001006 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| GovHub | 0x0000000000000000000000000000000000001007 | ACTIVE_CORE | 2642 | 2b8828258ede39cb257645c3d432574bd909f0b3f3cedf741ce2b70ece6eb568 | out/GovHub.sol/GovHub.json |
| TokenManager | 0x0000000000000000000000000000000000001008 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| CrossChain | 0x0000000000000000000000000000000000002000 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| Staking | 0x0000000000000000000000000000000000002001 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| StakeHub | 0x0000000000000000000000000000000000002002 | ACTIVE_CORE | 8883 | 71c25c8e17d39d5718b0f83c8dbff6b385ede0d13dd30202dd149e362fb6e82f | out/StakeHub.sol/StakeHub.json |
| StakeHubValidators | 0x0000000000000000000000000000000000002010 | ACTIVE_CORE | 21002 | d56b2714a96efd60efc362ca239b21a04fd7b15f12109336d8de56de7c268fbb | out/StakeHubValidators.sol/StakeHubValidators.json |
| StakeHubGiltStaking | 0x0000000000000000000000000000000000002011 | ACTIVE_CORE | 13950 | 886c38029ce0d74ba4480f09ae7917cbc9af08c055f543151e03b210ce6f0917 | out/StakeHubGiltStaking.sol/StakeHubGiltStaking.json |
| StakeHubGoldStaking | 0x0000000000000000000000000000000000002012 | ACTIVE_CORE | 13119 | d55f037e103aec7af92d3a96d0759c4c14a8ee98e969cae12377d4994bf7da5d | out/StakeHubGoldStaking.sol/StakeHubGoldStaking.json |
| StakeHubRewards | 0x0000000000000000000000000000000000002013 | ACTIVE_CORE | 8819 | e7fc21343af01feb5fb1d37598f6ea07e39a48f5d24014792065f4f9f7c4f009 | out/StakeHubRewards.sol/StakeHubRewards.json |
| StakeHubInflation | 0x0000000000000000000000000000000000002014 | ACTIVE_CORE | 9395 | 583c2c9ca8956d1fd14ad7d8c48b5fdbd30de1312dfcf801c1f7075e1969344b | out/StakeHubInflation.sol/StakeHubInflation.json |
| StakeHubSlashing | 0x0000000000000000000000000000000000002015 | ACTIVE_CORE | 11369 | f4606eb9232dadf18a857062edfc7aae011d554d2f5abc52dedafd192b7607b5 | out/StakeHubSlashing.sol/StakeHubSlashing.json |
| StakeHubMigration | 0x0000000000000000000000000000000000002016 | ACTIVE_CORE | 8756 | af3316266e23cee1c0c4124150d7853af3ff3c069a8352273e8dc7281896dc45 | out/StakeHubMigration.sol/StakeHubMigration.json |
| StakeHubParams | 0x0000000000000000000000000000000000002017 | ACTIVE_CORE | 13864 | 2d736b314e96da400b7e96fe316b6829a1996d99e68b77e52d47f9b44afeca2c | out/StakeHubParams.sol/StakeHubParams.json |
| StakeHubValidatorViews | 0x0000000000000000000000000000000000002018 | ACTIVE_CORE | 15383 | 7dd9b53d8f612868bad21f2722aaffb283450008f112072d76589c2653c13ed7 | out/StakeHubValidatorViews.sol/StakeHubValidatorViews.json |
| StakeCredit | 0x0000000000000000000000000000000000002003 | ACTIVE_CORE | 8855 | c9765155e2b9741950d1b992402fa35c34869e88a8bf3397d2f16e2b04a323b5 | out/StakeCredit.sol/StakeCredit.json |
| GiltGovernor | 0x0000000000000000000000000000000000002004 | ACTIVE_CORE | 28504 | e1e8ca6275bf462c83da24b14fc39515e38aed89c11b12fbd8cd8075ef0bf778 | out/GiltGovernor.sol/GiltGovernor.json |
| GovToken | 0x0000000000000000000000000000000000002005 | ACTIVE_CORE | 9828 | b3b70db8363f9a8a0701ee018437d4d9a293ef3a68ff20ed31a88cd3d8c55fb8 | out/GovToken.sol/GovToken.json |
| GiltTimelock | 0x0000000000000000000000000000000000002006 | ACTIVE_CORE | 9630 | ea6222f01fe7a5b000b8dfd7ba51cf0e94b1d3061d5ee1bbb4221a742be4ea25 | out/GiltTimelock.sol/GiltTimelock.json |
| TokenRecoverPortal | 0x0000000000000000000000000000000000003000 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| StateReceiver | 0x0000000000000000000000000000000000003001 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| NativeGiltBridge | 0x0000000000000000000000000000000000003002 | RESERVED_INERT | 71 | 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a | out/ReservedPredeploy.sol/ReservedPredeploy.json |
| PhysicalGold1155 | 0x0000000000000000000000000000000000003003 | ACTIVE_CORE | 14073 | 55d90275fb6402bcbce7008442fa220c114d58a3b27cbd8392d3fe017974b3f5 | out/PhysicalGold1155.sol/PhysicalGold1155.json launch immutables patched |

## System Contract Bytecode Hashes

- validatorContract: e8a818496b05574b04753b40a25c547b42feb8314b8ea3dd0dcea3357ef280b0 (out/GiltValidatorSet.sol/GiltValidatorSet.json, ACTIVE_CORE, 27591 bytes)
- slashContract: adb09f231125feff90896fde9b4a267e5503be8c59a8d4d6a4860fd8d20ced25 (out/SlashIndicator.sol/SlashIndicator.json, ACTIVE_CORE, 13039 bytes)
- systemRewardContract: 4a7cf6c0bbb6c0f181a8a173b2f15e5520321a8878780106e47b6f618e8398e5 (out/SystemReward.sol/SystemReward.json, ACTIVE_CORE, 2925 bytes)
- tendermintLightClient: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- tokenHub: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- relayerIncentivize: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- relayerHub: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- govHub: 2b8828258ede39cb257645c3d432574bd909f0b3f3cedf741ce2b70ece6eb568 (out/GovHub.sol/GovHub.json, ACTIVE_CORE, 2642 bytes)
- tokenManager: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- crossChain: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- staking: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- stakeHub: 71c25c8e17d39d5718b0f83c8dbff6b385ede0d13dd30202dd149e362fb6e82f (out/StakeHub.sol/StakeHub.json, ACTIVE_CORE, 8883 bytes)
- stakeHubValidatorsModule: d56b2714a96efd60efc362ca239b21a04fd7b15f12109336d8de56de7c268fbb (out/StakeHubValidators.sol/StakeHubValidators.json, ACTIVE_CORE, 21002 bytes)
- stakeHubGiltStakingModule: 886c38029ce0d74ba4480f09ae7917cbc9af08c055f543151e03b210ce6f0917 (out/StakeHubGiltStaking.sol/StakeHubGiltStaking.json, ACTIVE_CORE, 13950 bytes)
- stakeHubGoldStakingModule: d55f037e103aec7af92d3a96d0759c4c14a8ee98e969cae12377d4994bf7da5d (out/StakeHubGoldStaking.sol/StakeHubGoldStaking.json, ACTIVE_CORE, 13119 bytes)
- stakeHubRewardsModule: e7fc21343af01feb5fb1d37598f6ea07e39a48f5d24014792065f4f9f7c4f009 (out/StakeHubRewards.sol/StakeHubRewards.json, ACTIVE_CORE, 8819 bytes)
- stakeHubInflationModule: 583c2c9ca8956d1fd14ad7d8c48b5fdbd30de1312dfcf801c1f7075e1969344b (out/StakeHubInflation.sol/StakeHubInflation.json, ACTIVE_CORE, 9395 bytes)
- stakeHubSlashingModule: f4606eb9232dadf18a857062edfc7aae011d554d2f5abc52dedafd192b7607b5 (out/StakeHubSlashing.sol/StakeHubSlashing.json, ACTIVE_CORE, 11369 bytes)
- stakeHubMigrationModule: af3316266e23cee1c0c4124150d7853af3ff3c069a8352273e8dc7281896dc45 (out/StakeHubMigration.sol/StakeHubMigration.json, ACTIVE_CORE, 8756 bytes)
- stakeHubParamsModule: 2d736b314e96da400b7e96fe316b6829a1996d99e68b77e52d47f9b44afeca2c (out/StakeHubParams.sol/StakeHubParams.json, ACTIVE_CORE, 13864 bytes)
- stakeHubValidatorViewsModule: 7dd9b53d8f612868bad21f2722aaffb283450008f112072d76589c2653c13ed7 (out/StakeHubValidatorViews.sol/StakeHubValidatorViews.json, ACTIVE_CORE, 15383 bytes)
- stakeCredit: c9765155e2b9741950d1b992402fa35c34869e88a8bf3397d2f16e2b04a323b5 (out/StakeCredit.sol/StakeCredit.json, ACTIVE_CORE, 8855 bytes)
- governor: e1e8ca6275bf462c83da24b14fc39515e38aed89c11b12fbd8cd8075ef0bf778 (out/GiltGovernor.sol/GiltGovernor.json, ACTIVE_CORE, 28504 bytes)
- govToken: b3b70db8363f9a8a0701ee018437d4d9a293ef3a68ff20ed31a88cd3d8c55fb8 (out/GovToken.sol/GovToken.json, ACTIVE_CORE, 9828 bytes)
- timelock: ea6222f01fe7a5b000b8dfd7ba51cf0e94b1d3061d5ee1bbb4221a742be4ea25 (out/GiltTimelock.sol/GiltTimelock.json, ACTIVE_CORE, 9630 bytes)
- tokenRecoverPortal: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- stateReceiver: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- nativeGiltBridge: 70d07b5c4f2b8bdd1ab07443c5b227ccbf7c0b866d8fbf2e681580f91950b56a (out/ReservedPredeploy.sol/ReservedPredeploy.json, RESERVED_INERT, 71 bytes)
- physicalGold1155: 55d90275fb6402bcbce7008442fa220c114d58a3b27cbd8392d3fe017974b3f5 (out/PhysicalGold1155.sol/PhysicalGold1155.json, ACTIVE_CORE, 14073 bytes, launch immutables patched)

## Storage Layout Hashes

- GiltValidatorSet: 13307d51906eca83117e4d30c90a95dd0940a28848202dca2ede5300e64d672d (11 launch fields, ACTIVE_CORE)
- StakeHub: ff29cc0d01142189ff2ae249ebf578799f73fb3f1d980a38e8b094485a80d8f1 (28 launch fields, ACTIVE_CORE)
- PhysicalGold1155: f5d79a6c0b68e246063a770445c76aaedc538b1881c262814194e0a5ac440ff8 (11 launch fields, ACTIVE_CORE)

