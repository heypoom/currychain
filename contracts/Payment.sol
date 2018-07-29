pragma solidity ^0.4.24;

import "./Base.sol";
import "./Jobs.sol";
import "./Token.sol";
import "./Profiles.sol";

contract CurryPayment is CurryBase {
    using Jobs for *;
    using Profiles for *;

    CurryJobs jobs = CurryJobs(msg.sender);
    CurryToken token = CurryToken(msg.sender);
    CurryProfiles profiles = CurryProfiles(msg.sender);

    // A curry was paid by a customer
    event CurryPaid(uint curryId, address customer);

    // After the job is done, pay the curry.
    function payCurry(uint curryId) public {
        (, address wallet,) = profiles.getProfile(curryId);
        (uint price, Jobs.Status status) = jobs.getJob(curryId);

        uint balance = token.balanceOf(msg.sender);

        // The customer must be using the curry to be able to pay
        require(msg.sender == ownerOf(curryId));

        // The customer must have enough money to pay the curry.
        require(balance > price);

        // The job status should be In Progress or Awaiting Payment.
        require(
            status == Jobs.Status.InProgress ||
            status == Jobs.Status.AwaitingPayment
        );

        // Approve the money transfer
        token.approve(wallet, price);

        // Transfer the money to the curry
        token.transferFrom(msg.sender, wallet, price);

        // Update the status to Paid
        jobs.updateJobStatus(msg.sender, Jobs.Status.Paid);

        // TODO: Transition the state from active to completed.
        emit CurryPaid(curryId, msg.sender);
    }
}
