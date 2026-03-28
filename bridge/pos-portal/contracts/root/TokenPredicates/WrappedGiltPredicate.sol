pragma solidity 0.6.6;

import {AccessControlMixin} from "../../common/AccessControlMixin.sol";
import {RLPReader} from "../../lib/RLPReader.sol";
import {ITokenPredicate} from "./ITokenPredicate.sol";
import {Initializable} from "../../common/Initializable.sol";
import {IWrappedGilt} from "../RootToken/IWrappedGilt.sol";

contract WrappedGiltPredicate is ITokenPredicate, AccessControlMixin, Initializable {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant TOKEN_TYPE = keccak256("WrappedGilt");
    bytes32 public constant TRANSFER_EVENT_SIG = keccak256(
        "Transfer(address,address,uint256)"
    );

    event LockedWrappedGilt(
        address indexed depositor,
        address indexed depositReceiver,
        address indexed rootToken,
        uint256 amount
    );

    event ExitedWrappedGilt(
        address indexed exitor,
        address indexed rootToken,
        uint256 amount
    );

    constructor() public {
        _disableInitializer();
    }

    function initialize(address _owner) external initializer {
        _setupContractId("WrappedGiltPredicate");
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(MANAGER_ROLE, _owner);
    }

    function lockTokens(
        address depositor,
        address depositReceiver,
        address rootToken,
        bytes calldata depositData
    ) external override only(MANAGER_ROLE) {
        uint256 amount = abi.decode(depositData, (uint256));
        emit LockedWrappedGilt(depositor, depositReceiver, rootToken, amount);
        IWrappedGilt(rootToken).burnFrom(depositor, amount);
    }

    function exitTokens(
        address,
        address rootToken,
        bytes calldata log
    ) external override only(MANAGER_ROLE) {
        RLPReader.RLPItem[] memory logRLPList = log.toRlpItem().toList();
        RLPReader.RLPItem[] memory logTopicRLPList = logRLPList[1].toList();

        require(
            bytes32(logTopicRLPList[0].toUint()) == TRANSFER_EVENT_SIG,
            "WrappedGiltPredicate: INVALID_SIGNATURE"
        );

        address withdrawer = address(logTopicRLPList[1].toUint());
        require(
            address(logTopicRLPList[2].toUint()) == address(0),
            "WrappedGiltPredicate: INVALID_RECEIVER"
        );

        uint256 amount = logRLPList[2].toUint();
        IWrappedGilt(rootToken).mint(withdrawer, amount);

        emit ExitedWrappedGilt(withdrawer, rootToken, amount);
    }

    function migrateTokens(address, bytes calldata)
        external
        override
        only(MANAGER_ROLE)
    {
        revert("WrappedGiltPredicate: MIGRATION_DISABLED");
    }
}
