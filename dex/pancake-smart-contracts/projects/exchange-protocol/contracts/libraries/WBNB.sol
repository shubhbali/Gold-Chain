// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

/**
 * @title Wrapped GILT (WGILT compatibility contract)
 * @notice This contract intentionally keeps the historical `WBNB` name and file path
 * for backwards compatibility with existing deployment and test tooling.
 * Production behavior is WGILT: explicit supply accounting, zero-address guards,
 * and modern native transfer handling.
 */
contract WBNB {
    string public name = "Wrapped GILT";
    string public symbol = "WGILT";
    uint8 public decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    receive() external payable {
        _deposit(msg.sender, msg.value);
    }

    fallback() external payable {
        _deposit(msg.sender, msg.value);
    }

    function deposit() external payable {
        _deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) external {
        require(balanceOf[msg.sender] >= wad, "WGILT: insufficient balance");

        balanceOf[msg.sender] -= wad;
        totalSupply -= wad;

        (bool success, ) = payable(msg.sender).call{value: wad}("");
        require(success, "WGILT: native transfer failed");

        emit Transfer(msg.sender, address(0), wad);
        emit Withdrawal(msg.sender, wad);
    }

    function approve(address guy, uint256 wad) external returns (bool) {
        require(guy != address(0), "WGILT: zero spender");
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint256 wad) external returns (bool) {
        _transfer(msg.sender, dst, wad);
        return true;
    }

    function transferFrom(address src, address dst, uint256 wad) external returns (bool) {
        if (src != msg.sender) {
            uint256 allowed = allowance[src][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= wad, "WGILT: insufficient allowance");
                allowance[src][msg.sender] = allowed - wad;
                emit Approval(src, msg.sender, allowance[src][msg.sender]);
            }
        }

        _transfer(src, dst, wad);
        return true;
    }

    function _deposit(address account, uint256 amount) private {
        require(account != address(0), "WGILT: zero receiver");

        balanceOf[account] += amount;
        totalSupply += amount;

        emit Transfer(address(0), account, amount);
        emit Deposit(account, amount);
    }

    function _transfer(address src, address dst, uint256 wad) private {
        require(dst != address(0), "WGILT: zero destination");
        require(balanceOf[src] >= wad, "WGILT: insufficient balance");

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);
    }
}
