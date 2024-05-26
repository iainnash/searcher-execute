## Searcher Execute

Searcher execute allows _any_ searcher to execute desired tasks onchain.

While users need to initialize transactions, this library and standard is for a decentralized searcher type execution of desired actions with a small expectation of compensation beyond the price of gas configurable by the user.


## Example runner address:
https://sepolia.etherscan.io/address/0x2382a8829c1C7E66F8F5B2A594983e0438A7Ece6

### Overall Design

```sol
interface ISearcherExecute {
    event EventRewardNotice(uint256 recheckAfter);
    function execute() external;
}
```

### The searcher execute

### Optional Searcher Execute Registry

```sol
interface ISearcherExecuteRegistry {
    event SearcherExecuteRegistered(address sender, uint256 recheckAfter, uint256 rewardBps);
    error InterfaceNotSupported();
    function register(uint256 recheckAfter, uint256 rewardBps) external;
}
```

The idea is that we can meter the gas required and return double the gas used to fund a searcher to execute a type of action we want.

Searchers can either utilize the requested timestamps for actions or if the timestamp is shown as zero, simulate all functions shown in the registry in an expectation of profit.

Users of the protocol do not need to pick one provider but can just change parameters or scripts if operating conditions change and just need to fund the contract to pay the searchers for their execution.

The idea is this standard is searcher and agent agnostic and released as a hyperstructure solidity SDK.