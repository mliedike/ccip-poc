// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

contract Sender is CCIPReceiver {
    address link;
    address senderRouter;
    address receiverRouter;
    address public latestSender;
    string public latestMessage;

    constructor(address _link, address _senderRouter, address _receiverRouter) CCIPReceiver(_receiverRouter) {
        link = _link;
        senderRouter = _senderRouter;
        receiverRouter = _receiverRouter;
        LinkTokenInterface(link).approve(senderRouter, type(uint256).max);
    }

    function send(address receiver, string memory someText, uint64 destinationChainSelector) external {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(someText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(Client.EVMExtraArgsV1({gasLimit: 400_000, strict: false})),
            feeToken: link
        });

        IRouterClient(senderRouter).ccipSend(destinationChainSelector, message);
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        latestSender = abi.decode(message.sender, (address));
        latestMessage = abi.decode(message.data, (string));
    }
}