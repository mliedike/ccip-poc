// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

contract Receiver is CCIPReceiver {
    address link;
    address router;
    address pongContract;
    uint64 chainId;
    address public latestSender;
    string public latestMessage;

    constructor(address _link, address _router) CCIPReceiver(_router) {
        link = _link;
        router = _router;
        LinkTokenInterface(link).approve(router, type(uint256).max);
    }

    function send(address receiver, string memory someText, uint64 destinationChainSelector) internal {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver),
            data: abi.encode(someText),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(Client.EVMExtraArgsV1({gasLimit: 400_000, strict: false})),
            feeToken: link
        });

        IRouterClient(router).ccipSend(destinationChainSelector, message);
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        latestSender = abi.decode(message.sender, (address));
        latestMessage = abi.decode(message.data, (string));

        send(pongContract, "PONG", chainId);
    }

    function setDestInfo(address _pongContract, uint64 _chainId) external {
        pongContract = _pongContract;
        chainId = _chainId;
    }
}
