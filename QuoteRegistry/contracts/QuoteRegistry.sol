pragma solidity ^0.4.20;

    contract QuoteRegistry
    {
        mapping(string=>address) map;
        address public owner;
        
        function QuoteRegistry() public
        {
            owner=msg.sender;
        }
        
        function register(string _quote) public
        {
            map[_quote]=msg.sender;
        }
        
        function ownership(string _quote) public view returns (address)
        {
            owner=map[_quote];
            return owner;
        }
        
        function transfer(string _quote,address _newOwner) public payable
        {
	    require(map[_quote]==msg.sender);
            require(msg.value>=0.5 ether);
            map[_quote].transfer(msg.value);
            map[_quote]=_newOwner;
        }
        
        function Owner() public view returns (address)
        {
            return owner;
        }
    }
        

