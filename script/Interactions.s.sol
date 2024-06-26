// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {console} from "forge-std/console.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address most_recent_deployed) public {
        vm.startBroadcast();
        FundMe(payable(most_recent_deployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("funded with %s", SEND_VALUE);
    }

    function run() external {
        address most_recent_deployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFundMe(most_recent_deployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address most_recent_deployed) public {
        vm.startBroadcast();
        FundMe(payable(most_recent_deployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address most_recent_deployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMe(most_recent_deployed);
    }
}
