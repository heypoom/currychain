pragma solidity ^0.4.24;

library Profiles {
    // Personal Profile of the curry
    struct Profile {
        string name;
        address wallet;
        uint rank;
    }
}

contract CurryProfiles {
    using Profiles for *;

    // A curry has registered.
    event Registered(uint curryId);

    // A curry has updated their wallet address.
    event AddressUpdated(uint curryId, address newAddress);

    // List of Curry
    Profiles.Profile[] public curryList;

    // Contract Mappings of Curry
    mapping (address => uint) addressToCurry;

    function getProfile(uint curryId)
    public view returns (string, address, uint) {
        Profiles.Profile memory curry = curryList[curryId];

        return (curry.name, curry.wallet, curry.rank);
    }

    function getCurryId() public view returns (uint) {
        return addressToCurry[msg.sender];
    }

    // Register as a curry
    function registerAsCurry(string name, uint price)
    public returns (uint) {
        // Create the Curry Profile
        Profiles.Profile memory curry = Profiles.Profile(name, msg.sender, 0);

        // Adds the profile to curryList
        uint id = curryList.push(curry);

        // Assigns your wallet address to addressToCurry
        addressToCurry[msg.sender] = id;

        emit Registered(id);

        return id;
    }

    // Update the wallet address as a curry
    function updateAddressAsCurry(address newAddress) public {
        address currentAddress = msg.sender;

        // Set the new wallet address in Profile List
        uint id = addressToCurry[currentAddress];
        curryList[id].wallet = newAddress;

        // Set the new wallet address to your Profile ID
        addressToCurry[newAddress] = id;

        // Remove the old wallet address from the list.
        delete addressToCurry[msg.sender];

        emit AddressUpdated(id, newAddress);
    }
}
