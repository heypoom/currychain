pragma solidity ^0.4.24;

contract CurryProfiles {
    /// @title A curry has registered.
    event CurryRegistered(uint curryId);

    /// @title A curry has updated their wallet address.
    event CurryAddressUpdated(uint curryId, address newAddress);

    /// @title List of Curry
    CurryProfile[] curryList;

    /// @title Contract Mappings of Curry
    mapping (address => uint) addressToCurry;

    /// @title Personal Profile of the curry
    struct CurryProfile {
        string name;
        address wallet;
        uint rank;
    }

    function getCurryId() public returns (uint) {
        return addressToCurry[msg.sender];
    }

    /// @title Register as a curry
    function registerAsCurry(string name, uint price)
    public returns (uint) {
        // Create the Curry Profile
        CurryProfile memory curry = CurryProfile(name, msg.sender, 0);

        // Adds the profile to curryList
        uint id = curryList.push(curry);

        // Assigns your wallet address to addressToCurry
        addressToCurry[msg.sender] = id;

        emit CurryRegistered(id);

        return id;
    }

    /// @title Update the wallet address as a curry
    function updateAddressAsCurry(address newAddress) public {
        address currentAddress = msg.sender;

        // Set the new wallet address in CurryProfile List
        uint id = addressToCurry[currentAddress];
        curryList[id].wallet = newAddress;

        // Set the new wallet address to your CurryProfile ID
        addressToCurry[newAddress] = id;

        // Remove the old wallet address from the list.
        delete addressToCurry[msg.sender];

        emit CurryAddressUpdated(id, newAddress);
    }
}
