pragma solidity ^0.4.24;

import "./CurryToken.sol";

contract VIPCustomer {
    uint vipPrice = 1000;
    address developer = 0x55498657B8Fab82f79b95Ed238fb7E615D6667c3;

    mapping (address => bool) vipCustomers;

    CurryToken token = CurryToken(msg.sender);

    function buyVIP() public payable {
        uint balance = token.balanceOf(msg.sender);

        require(balance >= vipPrice);

        token.transfer(developer, vipPrice);

        vipCustomers[msg.sender] = true;
    }
}
