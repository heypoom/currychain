pragma solidity ^0.4.24;

import "./Base.sol";
import "./Jobs.sol";
import "./Token.sol";

contract CurryBookings is CurryBase {
    CurryJobs jobs = CurryJobs(msg.sender);
    CurryToken token = CurryToken(msg.sender);

    // A curry was requested by a customer
    event CurryRequested(uint curryId, address customer);

    // Book a job for the curry
    /// @dev Can a curry be owned by many customers at the same time?
    function bookCurry(uint curryId, uint price) public payable {
        uint balance = token.balanceOf(msg.sender);

        // Customer must not already bought the curry.
        require(msg.sender != ownerOf(curryId));

        // Customer must have enough money to afford the curry's price.
        require(balance >= price);

        // Assign the curry to the owner.
        curryToOwner[curryId] = msg.sender;
        ownerCurryCount[msg.sender]++;

        // Book a job!
        jobs.createJob(curryId, price);

        emit CurryRequested(curryId, msg.sender);
    }
}
