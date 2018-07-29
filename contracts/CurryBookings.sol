pragma solidity ^0.4.24;

import "./CurryBase.sol";
import "./CurryJobs.sol";
import "./CurryToken.sol";

contract CurryBookings is CurryBase {
    CurryJobs jobs = CurryJobs(msg.sender);
    CurryToken token = CurryToken(msg.sender);

    /// @title A curry was requested by a customer
    event CurryRequested(uint curryId, address customer);

    /// @title Book a job for the curry
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
        jobs.jobsMapping[curryId][msg.sender] = jobs.CurryJob(price, jobs.JobStatus.Requested);

        emit CurryRequested(curryId, msg.sender);
    }
}