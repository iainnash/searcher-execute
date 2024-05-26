// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


interface ISearcherExecuteRegistry {
    event SearcherExecuteRegistered(address sender, uint256 recheckAfter, uint256 rewardBps);
    error InterfaceNotSupported();
    function register(uint256 recheckAfter, uint256 rewardBps) external;
}
