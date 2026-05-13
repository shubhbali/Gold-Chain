pragma solidity 0.6.6;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";

contract FeeOnTransferERC20 is ERC20 {
    using SafeMath for uint256;

    uint256 public feeBps;
    address public feeCollector;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 feeBps_,
        address feeCollector_
    ) public ERC20(name_, symbol_) {
        require(feeBps_ < 10000, "FeeOnTransferERC20: BAD_FEE");
        require(feeCollector_ != address(0), "FeeOnTransferERC20: BAD_COLLECTOR");
        feeBps = feeBps_;
        feeCollector = feeCollector_;
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 feeAmount = amount.mul(feeBps).div(10000);
        uint256 transferAmount = amount.sub(feeAmount);

        super._transfer(sender, recipient, transferAmount);
        if (feeAmount != 0) {
            super._transfer(sender, feeCollector, feeAmount);
        }
    }
}
