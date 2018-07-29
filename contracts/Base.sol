pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract Base is ERC721 {
    using SafeMath for uint;

    mapping (uint => address) curryToOwner;
    mapping (address => uint) ownerCurryCount;

    function balanceOf(address _owner) public view returns (uint) {
        return ownerCurryCount[_owner];
    }

    function ownerOf(uint tokenId) public view returns (address) {
        return curryToOwner[tokenId];
    }
}
