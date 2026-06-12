// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "bridge/ethereum/contracts/GoldRootCustody.sol";
import "bridge/ethereum/contracts/MockRootGoldToken.sol";
import "bridge/shared/contracts/BridgeThresholdVerifier.sol";

contract DeploySepoliaRootBridge is Script {
    uint256 internal constant PAXG_ROUTE_ID = 1;
    uint256 internal constant XAUT_ROUTE_ID = 2;

    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);
        address governance = vm.envOr("ROOT_GOVERNANCE", deployer);
        address bridgeSigner = vm.envOr("BRIDGE_SIGNER", deployer);
        address childBridge = vm.envAddress("CHILD_BRIDGE_ADDRESS");
        uint256 goldChainChainId = vm.envUint("GOLD_CHAIN_CHAIN_ID");
        uint256 signerSetDelay = vm.envOr("SIGNER_SET_DELAY", uint256(1 days));

        address[] memory signers = new address[](1);
        signers[0] = bridgeSigner;

        vm.startBroadcast(deployerKey);
        MockRootGoldToken paxg = new MockRootGoldToken("Mock PAX Gold", "mPAXG", 18, deployer);
        MockRootGoldToken xaut = new MockRootGoldToken("Mock Tether Gold", "mXAUT", 18, deployer);
        BridgeThresholdVerifier verifier = new BridgeThresholdVerifier(governance, signers, 1, signerSetDelay);
        GoldRootCustody custody = new GoldRootCustody(governance, verifier, goldChainChainId, childBridge);
        custody.setRoute(PAXG_ROUTE_ID, address(paxg), true, true, true);
        custody.setRoute(XAUT_ROUTE_ID, address(xaut), true, true, true);
        paxg.mint(deployer, 1_000_000 ether);
        xaut.mint(deployer, 1_000_000 ether);
        vm.stopBroadcast();

        console2.log("MOCK_PAXG", address(paxg));
        console2.log("MOCK_XAUT", address(xaut));
        console2.log("ROOT_VERIFIER", address(verifier));
        console2.log("ROOT_CUSTODY", address(custody));
        console2.log("ROOT_GOVERNANCE", governance);
        console2.log("BRIDGE_SIGNER", bridgeSigner);
    }
}
