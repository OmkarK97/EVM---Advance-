// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Factory contract
contract TokenFactory {
    // Mapping to keep track of created tokens
    mapping(address => bool) public isTokenCreated;

    // Event emitted when a new token is created
    event TokenCreated(address tokenAddress);

    // Function to create a new token
    function createToken(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) public returns (address) {
        // Deploy a new ERC20 token contract
        address tokenAddress = address(new CustomToken(name, symbol, initialSupply));

        // Mark the token as created
        isTokenCreated[tokenAddress] = true;

        emit TokenCreated(tokenAddress);

        return tokenAddress;
    }
}

// Custom ERC20 token contract
contract CustomToken is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }

    // Mint additional tokens
    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }
}
