// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "../contracts/gold/GoldRouteToken.sol";
import "../contracts/gold/GoldPhaseRegistry.sol";
import "../contracts/gold/GoldBridgeMinter.sol";
import "bridge/gold-chain/contracts/GoldChildBridge.sol";
import "bridge/shared/contracts/BridgeThresholdVerifier.sol";

contract DeployGoldChildBridge is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);
        address governance = vm.envOr("CHILD_GOVERNANCE", deployer);
        address depositFinalizer = vm.envOr("DEPOSIT_FINALIZER", deployer);
        address bridgeSigner = vm.envOr("BRIDGE_SIGNER", deployer);
        uint256 ethereumChainId = vm.envUint("ETHEREUM_CHAIN_ID");
        address rootCustody = vm.envAddress("ROOT_CUSTODY_ADDRESS");
        address paxgRootToken = vm.envAddress("PAXG_ROOT_TOKEN");
        address xautRootToken = vm.envAddress("XAUT_ROOT_TOKEN");
        uint256 signerSetDelay = vm.envOr("SIGNER_SET_DELAY", uint256(1 days));

        address[] memory signers = new address[](1);
        signers[0] = bridgeSigner;

        vm.startBroadcast(deployerKey);
        GoldRouteToken gold = new GoldRouteToken("", governance);
        GoldPhaseRegistry phases = new GoldPhaseRegistry(governance);
        GoldBridgeMinter minter = new GoldBridgeMinter(gold, phases, governance);
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(governance, signers, 1, signerSetDelay);
        GoldChildBridge childBridge = new GoldChildBridge(
            IGoldBridgeMinter(address(minter)),
            governance,
            depositFinalizer,
            verifier,
            ethereumChainId,
            rootCustody,
            paxgRootToken,
            xautRootToken
        );
        gold.grantRole(gold.BRIDGE_MINTER_ROLE(), address(minter));
        minter.grantRole(minter.CHILD_BRIDGE_ROLE(), address(childBridge));
        vm.stopBroadcast();

        console2.log("GOLD_ROUTE_TOKEN", address(gold));
        console2.log("GOLD_PHASE_REGISTRY", address(phases));
        console2.log("GOLD_BRIDGE_MINTER", address(minter));
        console2.log("CHILD_VERIFIER", address(verifier));
        console2.log("CHILD_BRIDGE", address(childBridge));
        console2.log("CHILD_GOVERNANCE", governance);
        console2.log("DEPOSIT_FINALIZER", depositFinalizer);
        console2.log("BRIDGE_SIGNER", bridgeSigner);
    }
}
