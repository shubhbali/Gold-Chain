// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "bridge/ethereum/contracts/GoldRootCustody.sol";
import "bridge/gold-chain/contracts/GoldChildBridge.sol";

contract NonReturningERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external {
        allowance[msg.sender][spender] = amount;
    }

    function transfer(address to, uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }

    function transferFrom(address from, address to, uint256 amount) external {
        require(balanceOf[from] >= amount, "balance");
        require(allowance[from][msg.sender] >= amount, "allowance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }
}

contract BoolERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function mint(address to, uint256 amount) external {
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "balance");
        require(allowance[from][msg.sender] >= amount, "allowance");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract BridgeMinterMock is IGoldBridgeMinter {
    mapping(uint256 => mapping(address => uint256)) public balanceOf;
    mapping(bytes32 => bool) public finalizedDeposits;
    bytes32 public lastDepositId;
    uint256 public lastRouteId;
    address public lastRecipient;
    uint256 public lastAmount;

    function mint(address to, uint256 routeId, uint256 amount) external {
        balanceOf[routeId][to] += amount;
    }

    function finalizeDeposit(bytes32 depositId, uint256 routeId, uint256 amount, address recipient) external {
        require(!finalizedDeposits[depositId], "deposit replay");
        finalizedDeposits[depositId] = true;
        balanceOf[routeId][recipient] += amount;
        lastDepositId = depositId;
        lastRouteId = routeId;
        lastRecipient = recipient;
        lastAmount = amount;
    }

    function burnForWithdrawal(address account, uint256 routeId, uint256 amount) external {
        require(balanceOf[routeId][account] >= amount, "insufficient");
        balanceOf[routeId][account] -= amount;
    }
}

contract BridgeCustodyHardeningTest is Test {
    address governance = address(0xA11CE);
    address finalizer = address(0xB0B);
    address user = address(0xCAFE);
    address recipient = address(0xD00D);
    uint256 constant PAXG = 1;

    function testRootCustodyAcceptsNonReturningErc20AndFinalizesWithdrawals() public {
        NonReturningERC20 token = new NonReturningERC20();
        GoldRootCustody custody = new GoldRootCustody(governance, finalizer);

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        token.mint(user, 100 ether);
        vm.prank(user);
        token.approve(address(custody), 100 ether);

        vm.prank(user);
        bytes32 depositId = custody.deposit(PAXG, 25 ether, recipient);
        assertTrue(depositId != bytes32(0));
        assertEq(custody.lockedByRoute(PAXG), 25 ether);
        assertEq(token.balanceOf(address(custody)), 25 ether);

        vm.prank(finalizer);
        custody.finalizeWithdrawal(keccak256("w1"), PAXG, user, 5 ether);
        assertEq(custody.lockedByRoute(PAXG), 20 ether);
        assertEq(token.balanceOf(user), 80 ether);
    }

    function testRootCustodyFinalizedRouteCannotChangeTokenButCanCloseDeposits() public {
        BoolERC20 token = new BoolERC20();
        BoolERC20 replacement = new BoolERC20();
        GoldRootCustody custody = new GoldRootCustody(governance, finalizer);

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, true);

        vm.prank(governance);
        vm.expectRevert(GoldRootCustody.RouteFinalized.selector);
        custody.setRoute(PAXG, address(replacement), true, true, true);

        vm.prank(governance);
        custody.setDepositsEnabled(PAXG, false);

        token.mint(user, 10 ether);
        vm.startPrank(user);
        token.approve(address(custody), 10 ether);
        vm.expectRevert(GoldRootCustody.DepositsDisabled.selector);
        custody.deposit(PAXG, 1 ether, recipient);
        vm.stopPrank();
    }

    function testRootCustodyPauseAndTwoStepGovernance() public {
        BoolERC20 token = new BoolERC20();
        GoldRootCustody custody = new GoldRootCustody(governance, finalizer);
        address newGovernance = address(0x1234);

        vm.prank(governance);
        custody.setRoute(PAXG, address(token), true, true, false);
        vm.prank(governance);
        custody.pause();

        token.mint(user, 10 ether);
        vm.startPrank(user);
        token.approve(address(custody), 10 ether);
        vm.expectRevert(GoldRootCustody.PausedError.selector);
        custody.deposit(PAXG, 1 ether, recipient);
        vm.stopPrank();

        vm.prank(governance);
        custody.beginGovernanceTransfer(newGovernance);
        vm.prank(user);
        vm.expectRevert(GoldRootCustody.NotPendingGovernance.selector);
        custody.acceptGovernance();
        vm.prank(newGovernance);
        custody.acceptGovernance();
        assertEq(custody.governance(), newGovernance);
    }

    function testChildBridgePauseReplayAndTwoStepGovernance() public {
        BridgeMinterMock minter = new BridgeMinterMock();
        GoldChildBridge bridge = new GoldChildBridge(IGoldBridgeMinter(address(minter)), governance, finalizer);
        bytes32 depositId = keccak256("deposit-1");
        address newGovernance = address(0x4567);

        vm.prank(finalizer);
        bridge.finalizeDeposit(depositId, PAXG, 10 ether, user);
        assertEq(minter.balanceOf(PAXG, user), 10 ether);

        vm.prank(finalizer);
        vm.expectRevert(GoldChildBridge.AlreadyFinalized.selector);
        bridge.finalizeDeposit(depositId, PAXG, 10 ether, user);

        vm.prank(governance);
        bridge.pause();
        vm.prank(user);
        vm.expectRevert(GoldChildBridge.PausedError.selector);
        bridge.withdraw(PAXG, 1 ether, recipient);

        vm.prank(governance);
        bridge.beginGovernanceTransfer(newGovernance);
        vm.prank(newGovernance);
        bridge.acceptGovernance();
        assertEq(bridge.governance(), newGovernance);
    }
}
