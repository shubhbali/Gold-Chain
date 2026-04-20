pragma solidity ^0.5.2;

import {RootChainStorage} from "./RootChainStorage.sol";
import {Proxy} from "../common/misc/Proxy.sol";
import {Registry} from "../common/Registry.sol";

contract RootChainProxy is Proxy, RootChainStorage {
    constructor(address _proxyTo, address _registry, string memory _giltconsensusId) public Proxy(_proxyTo) {
        registry = Registry(_registry);
        giltconsensusId = keccak256(abi.encodePacked(_giltconsensusId));
    }
}
