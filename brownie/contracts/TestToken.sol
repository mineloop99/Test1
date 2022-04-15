// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./Utils/Ownable.sol";
import "./Tokens/ERC20.sol";

contract TestToken is Ownable, ERC20 {
    uint256 private constant _maxTotalSupply = 10_000_000e18; // 10,000,000 max Tokens

    constructor() ERC20("Test1 Token", "TEST") {}

    // Returns maximum total supply of the token
    function getMaxTotalSupply() external pure returns (uint256) {
        return _maxTotalSupply;
    }

    // No more tokens minted when max supply reached, mint action will not be reverted
    function mint(address _to, uint256 _amount) public onlyOwner {
        uint256 remain = _maxTotalSupply - totalSupply();
        if (remain > _amount) {
            _mint(_to, _amount);
        } else {
            _mint(_to, remain);
        }
    }
}
