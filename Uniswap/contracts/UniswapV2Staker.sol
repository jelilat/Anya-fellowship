// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract UniswapV2Staker is ERC1155 {
    IUniswapV2Factory factoryAddress;

    //
    struct StakeDetails {
        bool initialized; // whether the stake has been initialized
        uint256 stakeId;
        mapping(address => uint256) stakers; //stakers and their stakes.
    }

    // UniswapV2Pairs and Stake Information
    mapping(address => StakeDetails) stakes;

    // number of UniswapV2Pairs with valid stakes.
    uint256 totalV2PairStakes;

    constructor() ERC1155("https://stake.example/api/item/{id}.json") {
        factoryAddress = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    }

    //checks whether the pairAddress is a valid uniswapv2 LP token address
    modifier confirmPair(address pairAddress) {
        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        address token0 = pair.token0();
        address token1 = pair.token1();

        address pairAddressFromFactory = factoryAddress.getPair(token0, token1);
        require(pairAddressFromFactory != address(0), "Not a valid UniswapV2 LP Token");
        _;
    }

    function stake(address pairAddress, uint256 amount) confirmPair(pairAddress) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        bool success = pair.transferFrom(msg.sender, address(this), amount);
        require(success == true, "Approve contract to spend token");

        uint256 stakeId;

        if (stakes[pairAddress].initialized == false) {
            stakes[pairAddress].initialized == true;
            stakes[pairAddress].stakeId = totalV2PairStakes;
            totalV2PairStakes++;
            stakeId = totalV2PairStakes;
        } else {
            stakeId = stakes[pairAddress].stakeId;
        }

        (stakes[pairAddress].stakers)[msg.sender] += amount;
        _mint(msg.sender, stakeId, amount, "");
    }

    function unstake(address pairAddress, uint256 amount) public {
        require(stakes[pairAddress].initialized == true, "Stake has not been initialized");
        require((stakes[pairAddress].stakers)[msg.sender] >= amount, "You don't have enough tokens");
        ERC1155 rewardToken = ERC1155(address(this));
        rewardToken.safeTransferFrom(msg.sender, address(this), stakes[pairAddress].stakeId, amount, "0x0");

        (stakes[pairAddress].stakers)[msg.sender] -= amount;

        IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
        pair.transferFrom(address(this), msg.sender, amount);
    }
}