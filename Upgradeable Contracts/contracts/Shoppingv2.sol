//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Shoppingv2 {
    bool initialized;

    function initialize() public {
        require(!initialized, "already initialized");

        initialized = true;
    }
    
    struct Cart {
        string[] goods;
        uint256 amount;
    }

    mapping(address => Cart) carts;

    function addToCart(string[] memory goods, uint256[] memory prices) public returns(uint256) {
        require(goods.length == prices.length, "Inputs do not match");
        require(goods.length <= 20, "Can't add more than 20 things to cart at a time");

        uint256 total;
        for (uint i=0; i<goods.length; i++) {
            //check whether price is 0
            require(prices[i] != 0, "Price cannot be 0");
            total += prices[i];
            if((carts[msg.sender].goods).length == 0) {
                continue;
            }
            (carts[msg.sender].goods).push(goods[i]);
        }

        if((carts[msg.sender].goods).length == 0) {
                carts[msg.sender].goods = goods;
        }
        carts[msg.sender].amount = total;

        return total;
    }

    function checkout(string[] memory goods, uint256[] memory prices) public payable {
        if (goods.length > 0) {
            addToCart(goods, prices);
        }

        require(carts[msg.sender].amount == msg.value, "Insufficient funds");

        carts[msg.sender] = Cart (
            new string[](0),
            0
        );
    }

    function getTotal(address shopper) public view returns(uint256) {
        return carts[shopper].amount;
    }
}