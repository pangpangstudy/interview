// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

/// @title Multicall3
/// @notice 聚合多个函数调用的结果
/// @dev 向后兼容 Multicall 和 Multicall2
/// @dev 聚合方法被标记为 `payable` 以便每次调用节省 24 gas
contract Multicall3 {
    // 调用的数据结构
    struct Call {
        // 目标合约地址
        address target;
        // callData
        bytes callData;
    }

    struct Call3 {
        address target;
        // 是否允许失败
        bool allowFailure;
        bytes callData;
    }
    // // 包含以太币传递和额外参数的调用结构
    struct Call3Value {
        address target;
        bool allowFailure;
        // // 调用时传递的以太币数量
        uint256 value;
        bytes callData;
    }
    // 调用结果的结构
    struct Result {
        bool success;
        bytes returnData;
    }

    /// @notice 与 Multicall 向后兼容的调用聚合
    /// @param calls Call 结构体数组
    /// @return blockNumber 执行调用的区块号
    /// @return returnData 包含响应的字节数组
    function aggregate(
        Call[] calldata calls
    ) public payable returns (uint256 blockNumber, bytes[] memory returnData) {
        blockNumber = block.number;
        uint256 length = calls.length;
        returnData = new bytes[](length);
        Call calldata call;
        for (uint256 i = 0; i < length; ) {
            bool success;
            call = calls[i];
            (success, returnData[i]) = call.target.call(call.callData);
            // 如果调用失败，则抛出异常
            require(success, "Multicall3: call failed");
            unchecked {
                ++i;
            }
        }
    }

    /// @notice 与 Multicall2 向后兼容
    /// @notice 聚合调用而不要求成功
    /// @param requireSuccess 如果为 true，要求所有调用成功
    /// @param calls Call 结构体数组
    /// @return returnData Result 结构体数组
    function tryAggregate(
        bool requireSuccess,
        Call[] calldata calls
    ) public payable returns (Result[] memory returnData) {
        uint256 length = calls.length;
        returnData = new Result[](length);
        // 直接在这定义一个临时变量，减少索引查询
        Call calldata call;
        for (uint256 i = 0; i < length; ) {
            // 初始化变量 存储执行结果 与返回值
            Result memory result = returnData[i];
            // 赋值临时变量
            call = calls[i];
            // 如果没有临时变量的话，这里calls[i].targetcall(calls[i].callData) 这里会消耗更多的gas因为3次索引查询
            (result.success, result.returnData) = call.target.call(
                call.callData
            );
            // call是不会自动回滚交易的
            if (requireSuccess)
                require(result.success, "Multicall3: call failed");
            // unchecked 块告诉编译器在这个块内不要进行溢出检查。
            unchecked {
                ++i;
            }
        }
    }

    /// @notice 与 Multicall2 向后兼容
    /// @notice 使用 tryAggregate 聚合调用并允许失败
    /// @param calls Call 结构体数组
    /// @return blockNumber 执行调用的区块号
    /// @return blockHash 执行调用的区块哈希
    /// @return returnData Result 结构体数组
    // 返回数据多了blockNumber blockHash
    function tryBlockAndAggregate(
        bool requireSuccess,
        Call[] calldata calls
    )
        public
        payable
        returns (
            uint256 blockNumber,
            bytes32 blockHash,
            Result[] memory returnData
        )
    {
        blockNumber = block.number;
        blockHash = blockhash(block.number);
        returnData = tryAggregate(requireSuccess, calls);
    }

    /// @notice 与 Multicall2 向后兼容
    /// @notice 使用 tryAggregate 聚合调用并允许失败
    /// @param calls Call 结构体数组
    /// @return blockNumber 执行调用的区块号
    /// @return blockHash 执行调用的区块哈希
    /// @return returnData Result 结构体数组
    // 这里是函数重写为requireSuccess = true
    function blockAndAggregate(
        Call[] calldata calls
    )
        public
        payable
        returns (
            uint256 blockNumber,
            bytes32 blockHash,
            Result[] memory returnData
        )
    {
        (blockNumber, blockHash, returnData) = tryBlockAndAggregate(
            true,
            calls
        );
    }

    /// @notice 聚合调用，如果需要则确保每个调用都返回成功
    /// @param calls Call3 结构体数组
    /// @return returnData Result 结构体数组
    // 这里的是否允许失败 是再接在Call3这个struct中的
    function aggregate3(
        Call3[] calldata calls
    ) public payable returns (Result[] memory returnData) {
        uint256 length = calls.length;
        returnData = new Result[](length);
        Call3 calldata calli;
        for (uint256 i = 0; i < length; ) {
            Result memory result = returnData[i];
            calli = calls[i];
            (result.success, result.returnData) = calli.target.call(
                calli.callData
            );
            assembly {
                // 如果调用失败且不允许失败则回滚
                // `allowFailure := calldataload(add(calli, 0x20))` 和 `success := mload(result)`
                if iszero(or(calldataload(add(calli, 0x20)), mload(result))) {
                    // 设置 "Error(string)" 签名: bytes32(bytes4(keccak256("Error(string)")))
                    mstore(
                        0x00,
                        0x08c379a000000000000000000000000000000000000000000000000000000000
                    )
                    // 设置数据偏移量
                    mstore(
                        0x04,
                        0x0000000000000000000000000000000000000000000000000000000000000020
                    )
                    // 设置回滚字符串长度
                    mstore(
                        0x24,
                        0x0000000000000000000000000000000000000000000000000000000000000017
                    )
                    // 设置回滚字符串: bytes32(abi.encodePacked("Multicall3: call failed"))
                    mstore(
                        0x44,
                        0x4d756c746963616c6c333a2063616c6c206661696c6564000000000000000000
                    )
                    revert(0x00, 0x64)
                }
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @notice 带有 msg value 的聚合调用
    /// @notice 如果 msg.value 小于调用值之和则回滚
    /// @param calls Call3Value 结构体数组
    /// @return returnData Result 结构体数组
    function aggregate3Value(
        Call3Value[] calldata calls
    ) public payable returns (Result[] memory returnData) {
        //用于记录结构中记录的value总值
        uint256 valAccumulator;
        uint256 length = calls.length;
        returnData = new Result[](length);
        Call3Value calldata calli;
        for (uint256 i = 0; i < length; ) {
            Result memory result = returnData[i];
            calli = calls[i];
            uint256 val = calli.value;
            // 在这个溢出发生之前，人类将成为第五类卡尔达舍夫文明 - andreas
            // ~ 10^25 Wei 存在 << ~ 10^76 大小的 uint 适合 uint256
            unchecked {
                valAccumulator += val;
            }
            (result.success, result.returnData) = calli.target.call{value: val}(
                calli.callData
            );
            assembly {
                // 如果调用失败且不允许失败则回滚
                // `allowFailure := calldataload(add(calli, 0x20))` 和 `success := mload(result)`
                if iszero(or(calldataload(add(calli, 0x20)), mload(result))) {
                    // 设置 "Error(string)" 签名: bytes32(bytes4(keccak256("Error(string)")))
                    mstore(
                        0x00,
                        0x08c379a000000000000000000000000000000000000000000000000000000000
                    )
                    // 设置数据偏移量
                    mstore(
                        0x04,
                        0x0000000000000000000000000000000000000000000000000000000000000020
                    )
                    // 设置回滚字符串长度
                    mstore(
                        0x24,
                        0x0000000000000000000000000000000000000000000000000000000000000017
                    )
                    // 设置回滚字符串: bytes32(abi.encodePacked("Multicall3: call failed"))
                    mstore(
                        0x44,
                        0x4d756c746963616c6c333a2063616c6c206661696c6564000000000000000000
                    )
                    revert(0x00, 0x84)
                }
            }
            unchecked {
                ++i;
            }
        }
        // 最后，确保 msg.value = SUM(call[0...i].value)
        // 判断  valAccumulator总值 和 请求函数携带的值
        require(msg.value == valAccumulator, "Multicall3: value mismatch");
    }

    /// @notice 返回给定区块号的区块哈希
    /// @param blockNumber 区块号
    function getBlockHash(
        uint256 blockNumber
    ) public view returns (bytes32 blockHash) {
        blockHash = blockhash(blockNumber);
    }

    /// @notice 返回区块号
    function getBlockNumber() public view returns (uint256 blockNumber) {
        blockNumber = block.number;
    }

    /// @notice 返回区块 coinbase
    function getCurrentBlockCoinbase() public view returns (address coinbase) {
        coinbase = block.coinbase;
    }

    /// @notice 返回区块难度
    function getCurrentBlockDifficulty()
        public
        view
        returns (uint256 difficulty)
    {
        difficulty = block.difficulty;
    }

    /// @notice 返回区块 gas 限制
    function getCurrentBlockGasLimit() public view returns (uint256 gaslimit) {
        gaslimit = block.gaslimit;
    }

    /// @notice 返回区块时间戳
    function getCurrentBlockTimestamp()
        public
        view
        returns (uint256 timestamp)
    {
        timestamp = block.timestamp;
    }

    /// @notice 返回给定地址的 (ETH) 余额
    function getEthBalance(address addr) public view returns (uint256 balance) {
        balance = addr.balance;
    }

    /// @notice 返回最后一个区块的区块哈希
    function getLastBlockHash() public view returns (bytes32 blockHash) {
        unchecked {
            blockHash = blockhash(block.number - 1);
        }
    }

    /// @notice 获取给定区块的基础费用
    /// @notice 如果给定链未实现 BASEFEE 操作码，可能会回滚
    function getBasefee() public view returns (uint256 basefee) {
        basefee = block.basefee;
    }

    /// @notice 返回链 ID
    function getChainId() public view returns (uint256 chainid) {
        chainid = block.chainid;
    }
}
