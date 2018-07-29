pragma solidity ^0.4.24;

import "./Base.sol";
import "./Profiles.sol";

contract CurryJobs is CurryBase {
    CurryProfiles profiles = CurryProfiles(msg.sender);

    /// @title A curry has accepted the customer's offer.
    event JobAccepted(uint curryId, address customer);

    /// @title A curry has rejected the customer's offer.
    event JobRejected(uint curryId, address customer);

    /// @title Something gone wrong and they canceled. No big deal?
    event JobCanceled(uint curryId, address customer);

    /// @title They're doing something cool, I guess
    event JobInProgress(uint curryId, address customer);

    /// @title A curry is awaiting for payment.
    event JobAwaitingPayment(uint curryId, address customer);

    /// @title Curry ID -> Customer Address -> Job
    mapping (uint => mapping (address => CurryJob)) jobsMapping;

    /// @title Current Status of the Job
    enum JobStatus {
        Requested,
        Accepted,
        Rejected,
        Canceled,
        InProgress,
        AwaitingPayment,
        Paid
    }

    /// @title Job Metadata
    struct CurryJob {
        uint price;
        JobStatus status;
    }

    function updateJobStatus(address customer, JobStatus status) private {
        uint curryId = profiles.getCurryId();
        CurryJob storage job = jobsMapping[curryId][customer];

        job.status = status;

        if (status == JobStatus.Accepted) {
            emit JobAccepted(curryId, customer);
        }

        if (status == JobStatus.Rejected) {
            emit JobRejected(curryId, customer);
        }

        if (status == JobStatus.Canceled) {
            emit JobCanceled(curryId, customer);
        }

        if (status == JobStatus.InProgress) {
            emit JobInProgress(curryId, customer);
        }

        if (status == JobStatus.InProgress) {
            emit JobAwaitingPayment(curryId, customer);
        }
    }

    function acceptJobAsCurry(address customer) public {
        updateJobStatus(customer, JobStatus.Accepted);
    }

    function startJobAsCurry(address customer) public {
        updateJobStatus(customer, JobStatus.InProgress);
    }

    function markDoneAsCurry(address customer) public {
        updateJobStatus(customer, JobStatus.AwaitingPayment);
    }

    function cancelJob(address customer) public {
        updateJobStatus(customer, JobStatus.Canceled);
    }

    function rejectJobAsCurry(address customer) public {
        updateJobStatus(customer, JobStatus.Rejected);
    }

    /// @title Customer mark the job as done
    function markDoneAsCustomer(uint curryId) public {
        CurryJob storage job = jobsMapping[curryId][msg.sender];

        job.status = JobStatus.AwaitingPayment;
    }
}
