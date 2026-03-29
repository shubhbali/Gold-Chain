pragma solidity 0.6.6;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IStateSender} from "./IStateSender.sol";

contract StateSender is IStateSender, Ownable {
    uint256 public counter;
    mapping(address => address) public registrations;

    event NewRegistration(address indexed user, address indexed sender, address indexed receiver);
    event StateSynced(uint256 indexed id, address indexed contractAddress, bytes data);

    function register(address sender, address receiver) external onlyOwner {
        require(sender != address(0), "StateSender: INVALID_SENDER");
        require(receiver != address(0), "StateSender: INVALID_RECEIVER");
        registrations[sender] = receiver;
        emit NewRegistration(_msgSender(), sender, receiver);
    }

    function syncState(address receiver, bytes calldata data) external override {
        require(registrations[_msgSender()] == receiver, "StateSender: NOT_REGISTERED");
        counter += 1;
        emit StateSynced(counter, receiver, data);
    }
}
