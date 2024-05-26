// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SearcherExecuteBaseConstructor} from "../base/SearcherExecuteBaseConstructor.sol";

contract WithdrawCron is SearcherExecuteBaseConstructor {
    address targetNFT;
    uint256 targetNFTId;
    event FiveMinClock();

    constructor() SearcherExecuteBaseConstructor(block.timestamp + 60 * 5) {
    }

    function _execute() internal override onlyAfterExecuteDelay {
        updateNewExecutionWithDelay(block.timestamp + 60 * 6);
        emit FiveMinClock();
    }
}