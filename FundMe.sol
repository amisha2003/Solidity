//Get fund from users
// Withdraw funds
// Set a minimum funding value in USD

//SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{

    using PriceConverter for uint256;
    uint256 public minimumUsd=50* 1e18;

    address [] public funders;
    mapping(address=>uint256) public addressToamountFunded;

    address public owner;

    constructor(){
        owner=msg.sender;        
    }

    function fund() public payable{
        // msg.value.getConversionRate();
        //want to be able to set a minimum fund amount in USD
        //1. how do we send ETH to this contract?
        require(msg.value.getConversionRate() >= minimumUsd ,"Didn't send enough"); // 1 eth = 1e18 == 1*10**18 wei
        funders.push(msg.sender);
        addressToamountFunded[msg.sender] = msg.value;

    }


    
    function withdraw() public onlyOwner{


        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++)
        {
            address funder = funders[funderIndex];
            addressToamountFunded[funder]=0;
        }
        //reset the array
        funders=new address[](0);
        //withdraw the funds

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

        //msg.sender=address
        // payable(msg.sender=payable address        
    }
    
    modifier onlyOwner{
        // require(msg.sender==owner,"Sender is not owner!");
        if(msg.sender!=owner){revert NotOwner();}
        _;
    }

}
