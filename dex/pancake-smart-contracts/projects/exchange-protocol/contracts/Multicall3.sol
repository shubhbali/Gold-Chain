// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Multicall3 {
    struct Call {
        address target;
        bytes callData;
    }

    struct Call3 {
        address target;
        bool allowFailure;
        bytes callData;
    }

    struct Call3Value {
        address target;
        bool allowFailure;
        uint256 value;
        bytes callData;
    }

    struct Result {
        bool success;
        bytes returnData;
    }

    function aggregate(Call[] calldata calls) external payable returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        uint256 length = calls.length;
        returnData = new bytes[](length);

        for (uint256 i = 0; i < length; ++i) {
            (bool success, bytes memory data) = calls[i].target.call(calls[i].callData);
            require(success, "Multicall3: call failed");
            returnData[i] = data;
        }
    }

    function tryAggregate(bool requireSuccess, Call[] calldata calls) external payable returns (Result[] memory results) {
        uint256 length = calls.length;
        results = new Result[](length);

        for (uint256 i = 0; i < length; ++i) {
            (bool success, bytes memory data) = calls[i].target.call(calls[i].callData);
            if (requireSuccess) {
                require(success, "Multicall3: call failed");
            }
            results[i] = Result(success, data);
        }
    }

    function aggregate3(Call3[] calldata calls) external payable returns (Result[] memory results) {
        uint256 length = calls.length;
        results = new Result[](length);

        for (uint256 i = 0; i < length; ++i) {
            (bool success, bytes memory data) = calls[i].target.call(calls[i].callData);
            if (!calls[i].allowFailure) {
                require(success, "Multicall3: call failed");
            }
            results[i] = Result(success, data);
        }
    }

    function aggregate3Value(Call3Value[] calldata calls) external payable returns (Result[] memory results) {
        uint256 length = calls.length;
        results = new Result[](length);
        uint256 totalValue;

        for (uint256 i = 0; i < length; ++i) {
            totalValue += calls[i].value;
            (bool success, bytes memory data) = calls[i].target.call{value: calls[i].value}(calls[i].callData);
            if (!calls[i].allowFailure) {
                require(success, "Multicall3: call failed");
            }
            results[i] = Result(success, data);
        }

        require(msg.value == totalValue, "Multicall3: value mismatch");
    }

    function getBlockHash(uint256 blockNumber) external view returns (bytes32) {
        return blockhash(blockNumber);
    }

    function getBlockNumber() external view returns (uint256) {
        return block.number;
    }

    function getCurrentBlockCoinbase() external view returns (address) {
        return block.coinbase;
    }

    function getCurrentBlockDifficulty() external view returns (uint256) {
        return block.difficulty;
    }

    function getCurrentBlockGasLimit() external view returns (uint256) {
        return block.gaslimit;
    }

    function getCurrentBlockTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

    function getEthBalance(address addr) external view returns (uint256) {
        return addr.balance;
    }

    function getLastBlockHash() external view returns (bytes32) {
        return blockhash(block.number - 1);
    }

    function getBasefee() external view returns (uint256) {
        return 0;
    }

    function getChainId() external view returns (uint256) {
        return block.chainid;
    }
}
