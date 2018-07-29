pragma solidity ^0.4.24;

import "./CurryBase.sol";
import "./CurryJobs.sol";
import "./CurryToken.sol";
import "./CurryProfiles.sol";

contract CurryPayment is CurryBase {
    CurryJobs jobs = CurryJobs(msg.sender);
    CurryToken token = CurryToken(msg.sender);
    CurryProfiles profiles = CurryProfiles(msg.sender);

    /// @title A curry was paid by a customer
    event CurryPaid(uint curryId, address customer);

    /// @title After the job is done, pay the curry.
    function payCurry(uint curryId) public {
        CurryProfile memory curry = curryList[curryId];
        CurryJob storage job = jobs.jobsMapping[curryId][msg.sender];

        uint balance = token.balanceOf(msg.sender);

        // The customer must be using the curry to be able to pay
        require(msg.sender == ownerOf(curryId));

        // The customer must have enough money to pay the curry.
        require(balance > job.price);

        // The job status should be In Progress or Awaiting Payment.
        require(
            job.status == jobs.JobStatus.InProgress ||
            job.status == jobs.JobStatus.AwaitingPayment
        );

        // Approve the money transfer
        token.approve(curry.wallet, job.price);

        // Transfer the money to the curry
        token.transferFrom(msg.sender, curry.wallet, job.price);

        // Update the status to Paid
        job.status = jobs.JobStatus.Paid;

        // TODO: Transition the state from active to completed.
        emit CurryPaid(curryId, msg.sender);
    }
}
