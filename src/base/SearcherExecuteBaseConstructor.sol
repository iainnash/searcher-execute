// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SearcherExecuteBase} from "./SearcherExecuteBase.sol";

abstract contract SearcherExecuteBaseConstructor is SearcherExecuteBase {
    constructor(uint256 recheckAfter) {
        // 100% reward (double gas)
        initialize(recheckAfter, 100 * PERCENT_TO_BPS);
    }
}