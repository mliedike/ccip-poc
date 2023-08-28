# (One Way)
forge script ./script/verify/Sender.s.sol:DeploySender --rpc-url avalancheFuji \
    --etherscan-api-key $SNOWTRACE_API_KEY --verifier-url $AVAX_FUJI_RPC_URL \
    --broadcast --verify -vvvv

forge script ./script/verify/ReceiverS.s.sol:DeployReceiverS --rpc-url ethereumSepolia \
    --etherscan-api-key $ETHERSCAN_API_KEY --verifier-url $ETHEREUM_SEPOLIA_RPC_URL \
    --broadcast --verify -vvvv

cast send <SENDER_CONTRACT> --rpc-url avalancheFuji --private-key=$PRIVATE_KEY "send(address, string memory, uint64)" <RECEIVER_CONTRACT> "PING" <RECEIVER_CHAIN_ID>

cast call <RECEIVER_CONTRACT> --rpc-url ethereumSepolia --private-key=$PRIVATE_KEY "latestMessage()"