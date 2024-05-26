// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ImmutableCreate2FactoryUtils} from "./ImmutableCreate2FactoryUtils.sol";

import {SearcherExecuteRegistry} from "../src/registry/SearcherExecuteRegistry.sol";

contract DeployRegistry is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        ImmutableCreate2FactoryUtils.safeCreate2OrGetExisting(bytes32(0), type(SearcherExecuteRegistry).creationCode);
    }
}
