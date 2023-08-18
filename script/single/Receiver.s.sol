// script/CCIPReceiver_Unsafe.s.sol

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import {Receiver} from "../../src/single/Receiver.sol";

contract DeployReceiver is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address sepoliaRouter = 0xD0daae2231E9CB96b94C8512223533293C3693Bf;
        address linkContract = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
        address receiverRouter = 0xD0daae2231E9CB96b94C8512223533293C3693Bf; //SEPOLIA

        Receiver receiver = new Receiver(
            linkContract,
            sepoliaRouter,
            receiverRouter

        );

        console.log("ReceiverS deployed to ", address(receiver));

        vm.stopBroadcast();
    }
}
