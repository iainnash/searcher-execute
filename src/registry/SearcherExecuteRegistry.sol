// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISearcherExecute} from "../interfaces/ISearcherExecute.sol";
import {IERC165} from "../interfaces/IERC165.sol";
import {ISearcherExecuteRegistry} from "../interfaces/ISearcherExecuteRegistry.sol";


contract SearcherExecuteRegistry is ISearcherExecuteRegistry {
    function contractName() external pure returns (string memory) {
        return "Searcher Execute Registry";
    }
    function register(uint256 recheckAfter, uint256 rewardBps) external {
        if (!IERC165(msg.sender).supportsInterface(type(ISearcherExecute).interfaceId)) {
            revert InterfaceNotSupported();
        }
        emit SearcherExecuteRegistered(msg.sender, recheckAfter, rewardBps);
    }
}
