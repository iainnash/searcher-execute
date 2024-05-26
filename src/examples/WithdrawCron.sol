// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SearcherExecuteBaseConstructor} from "../base/SearcherExecuteBaseConstructor.sol";

contract SearcherExecuteBase is SearcherExecuteBaseConstructor {
    address targetNFT;
    uint256 targetNFTId;
    event DayClock();

    constructor() SearcherExecuteBaseConstructor(block.timestamp + 1 days) {
    }

    function _execute() internal override onlyAfterExecuteDelay {
        updateNewExecutionWithDelay(block.timestamp + 1 days);
        emit DayClock();
    }
}