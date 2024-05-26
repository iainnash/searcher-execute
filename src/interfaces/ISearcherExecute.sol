// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ISearcherExecute {
    error NotReadyToExecute();
    event EventRewardNotice(uint256 recheckAfter, uint256 rewardBps);
    function execute() external;
}
