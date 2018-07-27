pragma solidity ^0.4.24;
contract Allowance
{address o;uint b;uint x;uint l;
mapping(address=>uint)t;
constructor()
{o=msg.sender;b=100;l=block.number;x=5;}
function disburse(address _A) public payable
{require(msg.sender==o);require(block.number-l==105);x=l%100;t[_A]=t[_A]+(x*b/100);b=b-(x*b/100);l=block.number;}
}