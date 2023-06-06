// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vesting {
    enum StakeholderType {Founder, Investor, Employer}

    struct Stakeholder {
        address account;
        StakeholderType stakeholderType;
    }

    IERC20 public token;
    address public receiver;
    uint256 public amount;
    uint256 public expiry;
    bool public locked = false;
    bool public claimed = false;
    address public owner;

    mapping(address => StakeholderType) public stakeholderTypes;
    mapping(StakeholderType => uint256) public lockingDurations;
    mapping(StakeholderType => uint256) public defaultTokenAmounts;
    mapping(StakeholderType => address[]) public stakeholders;

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender; // Set the contract deployer as the owner
        stakeholderTypes[msg.sender] = StakeholderType.Founder; // Set the deployer's stakeholder type as "Founder"
        stakeholders[StakeholderType.Founder].push(msg.sender); // Add the deployer's address to the list of Founder stakeholders
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

   function lock (
    StakeholderType _stakeholderType
    ) public onlyOwner {
            require(!locked, "Tokens have already been locked");
            require(lockingDurations[_stakeholderType] > 0, "Locking duration not set for this stakeholder type");
            uint256 lockingDuration = lockingDurations[_stakeholderType];
            uint256 _amount = defaultTokenAmounts[_stakeholderType];
            require(_amount > 0, "Default token amount not set for this stakeholder type");
            uint256 ownerBalance = token.balanceOf(owner);
            require(ownerBalance >= _amount * stakeholders[_stakeholderType].length, "Insufficient tokens in owner's account");

        for (uint256 i = 0; i < stakeholders[_stakeholderType].length; i++) {
            address currentReceiver = stakeholders[_stakeholderType][i];
            token.transferFrom(owner, currentReceiver, _amount);
    }
            receiver = address(0); // Set receiver to address(0) to indicate multiple receivers
            amount = _amount * stakeholders[_stakeholderType].length;
            // Calculate the expiry timestamp
            expiry = block.timestamp + lockingDuration  ;
            locked = true;
    }

   function setStakeholderType(address _address, StakeholderType _stakeholderType) public onlyOwner {
        if (stakeholderTypes[_address] != StakeholderType(0)) {
            revert("Stakeholder type already set for this address");
    }
        stakeholderTypes[_address] = _stakeholderType;
        stakeholders[_stakeholderType].push(_address);
    }

    function setLockingDuration(StakeholderType _stakeholderType, uint256 _lockingDuration) public onlyOwner {
        lockingDurations[_stakeholderType] = _lockingDuration;    
    }

    function setDefaultTokenAmount(StakeholderType _stakeholderType, uint256 _amount) public onlyOwner {
        require(defaultTokenAmounts[_stakeholderType] == 0, "Default token amount already set for this stakeholder type");
        defaultTokenAmounts[_stakeholderType] = _amount;
    }

    function withdraw() external {
        require(block.timestamp > expiry, "Tokens are locked");
        require(!claimed, "Tokens have already been claimed");
        claimed = true;
        token.transfer(receiver, amount);
    }

    function getTime() external view returns (uint256) {
        return block.timestamp;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vesting {
    enum StakeholderType {Founder, Investor, Employer}

    struct Stakeholder {
        address account;
        StakeholderType stakeholderType;
    }

    IERC20 public token;
    address public receiver;
    uint256 public amount;
    uint256 public expiry;
    bool public locked = false;
    bool public claimed = false;
    address public owner;

    mapping(address => StakeholderType) public stakeholderTypes;
    mapping(StakeholderType => uint256) public lockingDurations;
    mapping(StakeholderType => uint256) public defaultTokenAmounts;
    mapping(StakeholderType => address[]) public stakeholders;

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender; // Set the contract deployer as the owner
        stakeholderTypes[msg.sender] = StakeholderType.Founder; // Set the deployer's stakeholder type as "Founder"
        stakeholders[StakeholderType.Founder].push(msg.sender); // Add the deployer's address to the list of Founder stakeholders
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

   function lock (
    StakeholderType _stakeholderType
    ) public onlyOwner {
            require(!locked, "Tokens have already been locked");
            require(lockingDurations[_stakeholderType] > 0, "Locking duration not set for this stakeholder type");
            uint256 lockingDuration = lockingDurations[_stakeholderType];
            uint256 _amount = defaultTokenAmounts[_stakeholderType];
            require(_amount > 0, "Default token amount not set for this stakeholder type");
            uint256 ownerBalance = token.balanceOf(owner);
            require(ownerBalance >= _amount * stakeholders[_stakeholderType].length, "Insufficient tokens in owner's account");

        for (uint256 i = 0; i < stakeholders[_stakeholderType].length; i++) {
            address currentReceiver = stakeholders[_stakeholderType][i];
            token.transferFrom(owner, currentReceiver, _amount);
    }
            receiver = address(0); // Set receiver to address(0) to indicate multiple receivers
            amount = _amount * stakeholders[_stakeholderType].length;
            // Calculate the expiry timestamp
            expiry = block.timestamp + lockingDuration  ;
            locked = true;
    }

   function setStakeholderType(address _address, StakeholderType _stakeholderType) public onlyOwner {
        if (stakeholderTypes[_address] != StakeholderType(0)) {
            revert("Stakeholder type already set for this address");
    }
        stakeholderTypes[_address] = _stakeholderType;
        stakeholders[_stakeholderType].push(_address);
    }

    function setLockingDuration(StakeholderType _stakeholderType, uint256 _lockingDuration) public onlyOwner {
        lockingDurations[_stakeholderType] = _lockingDuration;    
    }

    function setDefaultTokenAmount(StakeholderType _stakeholderType, uint256 _amount) public onlyOwner {
        require(defaultTokenAmounts[_stakeholderType] == 0, "Default token amount already set for this stakeholder type");
        defaultTokenAmounts[_stakeholderType] = _amount;
    }

    function withdraw() external {
        require(block.timestamp > expiry, "Tokens are locked");
        require(!claimed, "Tokens have already been claimed");
        claimed = true;
        token.transfer(receiver, amount);
    }

    function getTime() external view returns (uint256) {
        return block.timestamp;
    }
}
