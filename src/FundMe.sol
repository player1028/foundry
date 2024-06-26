// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    //address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address => uint256) public funderToAmount;
    AggregatorV3Interface s_priceFeed;

    address public immutable i_owner;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "not funded"
        );
        funders.push(msg.sender);
        funderToAmount[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 funderLength = funders.length;
        for (uint256 i; i < funderLength; i++) {
            address funder = funders[i];
            funderToAmount[funder] = 0;
        }

        funders = new address[](0);

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool isSend = payable(msg.sender).send(address(this).balance);
        // require(isSend, 'not sent');
        //call
        (bool isCalled, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(isCalled, "not called");
    }

    function withdraw() public onlyOwner {
        for (uint256 i; i < funders.length; i++) {
            address funder = funders[i];
            funderToAmount[funder] = 0;
        }

        funders = new address[](0);

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //send
        // bool isSend = payable(msg.sender).send(address(this).balance);
        // require(isSend, 'not sent');
        //call
        (bool isCalled, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(isCalled, "not called");
    } //address 0x694AA1769357215DE4FAC081bf1f309aDC325306

    modifier onlyOwner() {
        if (i_owner != msg.sender) revert NotOwner();
        _;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function getAmountToFunder(address funder) public view returns (uint256) {
        return funderToAmount[funder];
    }

    function getFunder(uint256 number) public view returns (address) {
        return funders[number];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
