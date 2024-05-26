// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SearcherExecuteBaseConstructor} from "../base/SearcherExecuteBaseConstructor.sol";

interface IERC721Burn {
    function burn(uint256 tokenId) external;
}

contract NFTBurnTime is SearcherExecuteBaseConstructor {
    address targetNFT;
    uint256 targetNFTId;

    constructor(uint256 burnAtTimestamp, address _targetNFT, uint256 _targetNFTId) SearcherExecuteBaseConstructor(burnAtTimestamp) {
        targetNFT = _targetNFT;
        targetNFTId = _targetNFTId;
    }

    function _execute() internal override {
        IERC721Burn(targetNFT).burn(targetNFTId);
        // Since we have no need to re-run this, we can safely 
    }
}