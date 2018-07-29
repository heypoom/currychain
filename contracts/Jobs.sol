pragma solidity ^0.4.24;

import "./Profiles.sol";

library Jobs {
    // Job Metadata
    struct Job {
        uint price;
        Status status;
    }

    // Current Status of the Job
    enum Status {
        Requested,
        Accepted,
        Rejected,
        Canceled,
        InProgress,
        AwaitingPayment,
        Paid
    }
}

contract CurryJobs {
    using Jobs for *;

    CurryProfiles profiles = CurryProfiles(msg.sender);

    // A curry has accepted the customer's offer.
    event Accepted(uint curryId, address customer);

    // A curry has rejected the customer's offer.
    event Rejected(uint curryId, address customer);

    // Something gone wrong and they canceled. No big deal?
    event Canceled(uint curryId, address customer);

    // They're doing something cool, I guess
    event InProgress(uint curryId, address customer);

    // A curry is awaiting for payment.
    event JobAwaitingPayment(uint curryId, address customer);

    // Curry ID -> Customer Address -> Job
    mapping (uint => mapping (address => Jobs.Job)) public jobsMapping;

    function createJob(uint curryId, uint price) public {
        jobsMapping[curryId][msg.sender] = Jobs.Job(price, Jobs.Status.Requested);
    }

    function getJob(uint curryId)
    view external returns (uint, Jobs.Status) {
        Jobs.Job storage job = jobsMapping[curryId][msg.sender];

        return (job.price, job.status);
    }

    function updateJobStatus(address customer, Jobs.Status status) public {
        uint curryId = profiles.getCurryId();
        Jobs.Job storage job = jobsMapping[curryId][customer];

        job.status = status;

        if (status == Jobs.Status.Accepted) {
            emit Accepted(curryId, customer);
        }

        if (status == Jobs.Status.Rejected) {
            emit Rejected(curryId, customer);
        }

        if (status == Jobs.Status.Canceled) {
            emit Canceled(curryId, customer);
        }

        if (status == Jobs.Status.InProgress) {
            emit InProgress(curryId, customer);
        }

        if (status == Jobs.Status.InProgress) {
            emit JobAwaitingPayment(curryId, customer);
        }
    }

    function acceptJobAsCurry(address customer) public {
        updateJobStatus(customer, Jobs.Status.Accepted);
    }

    function startJobAsCurry(address customer) public {
        updateJobStatus(customer, Jobs.Status.InProgress);
    }

    function markDoneAsCurry(address customer) public {
        updateJobStatus(customer, Jobs.Status.AwaitingPayment);
    }

    function cancelJob(address customer) public {
        updateJobStatus(customer, Jobs.Status.Canceled);
    }

    function rejectJobAsCurry(address customer) public {
        updateJobStatus(customer, Jobs.Status.Rejected);
    }

    // Customer mark the job as done
    function markDoneAsCustomer(uint curryId) public {
        Jobs.Job storage job = jobsMapping[curryId][msg.sender];

        job.status = Jobs.Status.AwaitingPayment;
    }
}
