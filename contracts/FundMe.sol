// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PrivateContract.sol";

error FundMe___NOTOWNER();

/**@title a contract for crowd funding
   @author okhamena azeez kehinde
   @notice this contract is to demo a sampling contract
   @dev this implement pricefeed as our library
 */

contract FundMe {
    using PrivateContract for uint256;

    uint256 public constant MINIMUM_USD = 10 * 1e18;

    address[] private s_funders;

    mapping(address => uint256) private s_fundermap;

    address private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "sender is not the owner");
        if (msg.sender != i_owner) revert FundMe___NOTOWNER();
        _;
    }

    constructor(address priceFeedAdress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAdress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    /**
            @notice this contract is to demo a sampling contract
            @dev this implement pricefeed as our library
    */
    function fund() public payable {
        //want to sent a certain amount of money in USD
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didn't send enough!!!"
        );
        s_funders.push(msg.sender);
        s_fundermap[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < s_funders.length; i++) {
            address fundam = s_funders[i];
            s_fundermap[fundam] = 0;
        }

        s_funders = new address[](0);

        //  //transfer
        //  payable(msg.sender).transfer(address(this).balance);

        //  //send
        //  bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //  require(sendSuccess,"send failed");

        //call
        (bool callSucesss, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucesss, "send failed");
    }

    function cheaperwithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 i = 0; i < funders.length; i++) {
            address fundam = funders[i];
            s_fundermap[fundam] = 0;
        }

        s_funders = new address[](0);
        (bool callSucesss, ) = i_owner.call{value: address(this).balance}("");
        require(callSucesss, "send failed");
    }

    function gerOwner() public view returns (address) {
        return i_owner;
    }

    function getFunders(uint256 _index) public view returns (address) {
        return s_funders[_index];
    }

    function getAmountFunded(address _funder) public view returns (uint256) {
        return s_fundermap[_funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
