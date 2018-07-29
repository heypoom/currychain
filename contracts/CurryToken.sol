pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract CurryToken is ERC20 {
    using SafeMath for uint;

    uint supplies = 1000000;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) internal allowances;

    function totalSupply() public view returns (uint) {
        return supplies;
    }

    function balanceOf(address who) public view returns (uint) {
        return balances[who];
    }

    function transfer(address to, uint amount)
    public returns (bool) {
        // Amount must be less than or equal the amount in wallet
        require(amount <= balances[msg.sender]);

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function allowance(address owner, address spender)
    public view returns (uint) {
        return allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint amount)
    public returns (bool) {
        require(to != address(0));
        require(amount <= allowance(from, to));
        require(amount <= balances[from]);

        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(amount);

        allowances[from][msg.sender] = allowances[from][msg.sender].sub(amount);

        emit Transfer(from, to, amount);

        return true;
    }

    function approve(address spender, uint amount)
    public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }
}
