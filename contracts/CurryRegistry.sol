pragma solidity ^0.4.24;

import "./CurryBase.sol";
import "./CurryJobs.sol";
import "./CurryPayment.sol";
import "./CurryProfiles.sol";
import "./CurryBookings.sol";

contract CurryRegistry is CurryJobs, CurryProfiles, CurryBookings, CurryPayment {}
