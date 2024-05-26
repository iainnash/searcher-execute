// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISearcherExecute} from "../interfaces/ISearcherExecute.sol";
import {ISearcherExecuteRegistry} from "../interfaces/ISearcherExecuteRegistry.sol";
import {IERC165} from "../interfaces/IERC165.sol";

interface ISearcherExecuteBase {
    error OnlyManager();
    error CannotWithdrawSoMuch();
    error TransferFailed(bytes why);
    error RefundError();
}

abstract contract SearcherExecuteBase is ISearcherExecute, ISearcherExecuteBase, IERC165 {
    /// @custom:storage-location erc7201:searcherexecute.data
    struct SearcherExecuteStoredData {
        uint256 recheckAfter;
        uint256 executeBalance;
        uint256 rewardBps;
        address manager;
    }

    // keccak256(abi.encode(uint256(keccak256("searcherexecute.data")) - 1)) & ~bytes32(uint256(0xff));
    bytes32 private constant SEARCHER_EXECUTE_STORED_DATA_LOCATION =
        0x3d75b27e9bc49ea9edbbb7187daa99a5929809247726cf801ba18aecad011a00;
    
    uint256 constant PERCENT_TO_BPS = 100;
    uint256 constant GAS_BUFFER = 30_000;
    uint256 constant TRANSFER_AMOUNT = 100_000;
    address constant REGISTRY_LOCATION = address(0x0);
    
    modifier onlyAfterExecuteDelay() {
        if (block.timestamp < getRecheckAfter()) {
            revert NotReadyToExecute();
        }

        _;
    }

    function _execute() internal virtual {
        // to override
    }

    function execute() external {
        SearcherExecuteStoredData storage storedData = _getSearcherExecuteStoredData();
        uint256 startGas = gasleft();
        uint256 recheckAfter = storedData.recheckAfter;
        if (block.timestamp < recheckAfter) {
            revert NotReadyToExecute();
        }
        _execute();
        uint256 gasUsed = (gasleft() - startGas) + GAS_BUFFER + TRANSFER_AMOUNT;

        // Ignore success, if this fails the execute happens we do not mind.
        address(msg.sender).call{value: gasUsed * tx.gasprice * (10_000 + storedData.rewardBps) / 10_000}('');
    }

    function isManager(address manager) internal virtual view returns (bool) {
        return manager == _getSearcherExecuteStoredData().manager;
    }

    function _requireManager(address manager) internal view {
        if (!isManager(manager))  {
            revert OnlyManager();
        }
    }

    function fund() payable external {
        _getSearcherExecuteStoredData().executeBalance += msg.value;
    }

    function managerWithdraw(uint256 amount) external {
        SearcherExecuteStoredData storage storedData = _getSearcherExecuteStoredData();
        if (amount > storedData.executeBalance) {
            revert CannotWithdrawSoMuch();
        }
        if (amount == 0) {
            amount = storedData.executeBalance;
        }
        // Transfer to manager
        (bool success, bytes memory why) = address(storedData.manager).call{value: amount}('');
        if (!success) {
            revert TransferFailed(why);
        }
    }

    function _getSearcherExecuteStoredData() private pure returns (SearcherExecuteStoredData storage $) {
        assembly {
            $.slot := SEARCHER_EXECUTE_STORED_DATA_LOCATION
        }
    } 

    function getRecheckAfter() internal view returns (uint256) {
        return _getSearcherExecuteStoredData().recheckAfter;
    }

    function updateNewExecutionWithDelay(uint256 newTimestamp) internal {
        SearcherExecuteStoredData storage storedData = _getSearcherExecuteStoredData();
        emit EventRewardNotice(newTimestamp, storedData.rewardBps);
        storedData.recheckAfter = newTimestamp;
    }

    function updateNewExecution(uint256 newTimestamp, uint256 rewardBps) internal {
        SearcherExecuteStoredData storage storedData = _getSearcherExecuteStoredData();
        emit EventRewardNotice(newTimestamp, rewardBps);
        storedData.recheckAfter = newTimestamp;
        storedData.rewardBps = rewardBps;
    }

    function initialize(uint256 recheckAfter, uint256 rewardBps) internal {
        updateNewExecution(recheckAfter, rewardBps);
        if (address(REGISTRY_LOCATION).code.length > 0) {
            ISearcherExecuteRegistry(REGISTRY_LOCATION).register(recheckAfter, rewardBps);
        }
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == bytes4(0x01ffc9a7) || interfaceId == type(ISearcherExecute).interfaceId;
    }
}