pragma solidity ^0.4.24;

import "./Base.sol";
import "./Jobs.sol";
import "./Payment.sol";
import "./Profiles.sol";
import "./Bookings.sol";

contract CurryRegistry is CurryJobs, CurryProfiles, CurryBookings, CurryPayment {}
