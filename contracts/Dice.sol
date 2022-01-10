// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@chainlink/contracts/src/v0.8/VRFConsumerBase.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Dice is VRFConsumerBase, Ownable, ReentrancyGuard {
    bytes32 internal keyHash;
    ERC20 public token;
    uint8 public feePercent;
    uint256 minBet;
    uint256 maxBet;
    address public devAddress;
    address zeroAddress = 0x0000000000000000000000000000000000000000;
    mapping (address => uint256) public balances;
    event RequestRandomness(bytes32 indexed requestId, bytes32 keyHash, uint256 seed);
    event RequestRandomnessFulfilled(bytes32 indexed requestId, uint256 randomness);
    event eventSetTokenAddress(address tokenAddress);
    event eventSetDevAddress(address devAddress);

    constructor(address _vrfCoordinator) VRFConsumerBase(_vrfCoordinator, _tokenAddress) public {
        vrfCoordinator = _vrfCoordinator;
        keyHash = 0xced103054e349b8dfb51352f0f8fa9b5d20dde3d06f9f43cb2b85bc64b238205; // hard-coded for Ropsten

        //TODO: delete this after tests are over:
        devAddress = 0x650E5c6071f31065d7d5Bf6CaD5173819cA72c41;
        token = ERC20(0xF42a4429F107bD120C5E42E069FDad0AC625F615); // XUSD
        minBet = 1000000000000000000; // 1 XUSD
        maxBet = 100000000000000000000; // 100 XUSD
        feePercent = 3;
    }

    function rollDice(uint256 _bet, uint8 _guessNumber, uint256 _userProvidedSeed) public nonReentrant returns (bytes32 _requestId) {
        require(_bet >= minBet, 'rollDice: Your bet has not reached the allowed minimum');
        require(_bet <= maxBet, 'rollDice: Your bet has exceeded the allowed maximum');
        require(token.balanceOf(address(this)) >= _bet * 6, 'rollDice: Not enough ballance in Dice contract');
        uint256 seed = uint256(keccak256(abi.encode(_userProvidedSeed, blockhash(block.number)))); // Hash user seed and blockhash
        bytes32 _requestId = requestRandomness(keyHash, _bet, seed);
        emit RequestRandomness(_requestId, keyHash, seed);
        fee = _bet * feePercent / 100;
        require(token.transfer(devAddress, fee)); // sends fee (3%) from bet to devWallet
        if (diceResult == guessNumber) balances[msg.sender] += (_bet - fee) * 6;
        else balances[msg.sender] -= _bet;
        return _requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) external override returns (uint256 result) {
        uint256 diceResult = randomness % 6 + 1;
        emit RequestRandomnessFulfilled(requestId, randomness);
        return diceResult;
    }

    function deposit(uint256 _amount) public {
        require(_amount <= token.balanceOf(msg.sender), 'deposit: You cannot deposit more than your wallet balance');
        require(token.transferFrom(msg.sender, address(this), _amount));
        balances[msg.sender] -= amount;
    }

    function withdraw(uint256 _amount) public {
        require(_amount <= balances[msg.sender], 'withdraw: You cannot withdraw more than your balance');
        require(token.transfer(msg.sender, _amount));
        balances[msg.sender] -= amount;
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        require(address(token) == zeroAddress, 'setTokenAddress: token can be set only once');
        token = ERC20(_tokenAddress);
        emit eventSetTokenAddress(_tokenAddress);
    }

    function setDevAddress(address _devAddress) public onlyOwner {
        devAddress = _devAddress;
        emit eventSetDevAddress(_devAddress);
    }

    function setMinBet(uint256 _minBet) public onlyOwner {
        minBet = _minBet;
        emit eventSetMinBet(_minBet);
    }

    function setMinBet(uint256 _maxBet) public onlyOwner {
        maxBet = _maxBet;
        emit eventSetMaxBet(_maxBet);
    }
}
