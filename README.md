## ERC20

This is an implementation of ERC20 from scratch in Solidity.
It follows the OpenZepplin ERC20 contract standard. 

OpenZepplin's `ERC20` implements interfaces `IERC20`, `IERC20Metadata` and `IERC20Errors`.
These interfaces are as it is similar to the standard, however my implementation of the contract 
is very different from how it is implemented there.

### Contract
This contract has
1) `name() -> (string memory)`
2) `decimals() -> (string memory)`
3) `symbol() -> (string memory)`
4) `totalSupply() -> (uint256)`
5) `balanceOf(address account) -> (uint256)`
6) `transfer(address to, uint256 value) -> bool`
7) `allowance(address owner, address spender) -> uint256`
8) `approve(address spender, uint256 value) -> bool`
9) `transferFrom(address from, address to ,uint256 value) -> bool`
10) `_addAllowance(address from, address approver, uint256 value)`
11) `_deductAllowance(address from, address approver, uint256 value)`
12) `_deductToken(address from, uint256 amount)`
13) `_addToken(address to, uint256 amount)`
14) `_mint(address to, uint256 amount)`
15) `_burn(address from, uint256 amount)`