// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address ethPriceFeed = helperConfig.activeConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
