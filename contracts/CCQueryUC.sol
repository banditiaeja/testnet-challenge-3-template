//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "./base/UniversalChanIbcApp.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CCQueryUC is UniversalChanIbcApp {
    // app specific state
    uint64 private counter;
    mapping(uint64 => address) public counterMap;
    mapping(address => bool) public addressMap;

    event LogQuery(address indexed caller, string query, uint64 counter);
    event LogAcknowledgement(string message);

    string private constant SECRET_MESSAGE = "Polymer is not a bridge: ";
    string private constant LIMIT_MESSAGE = "Sorry, but the 500 limit has been reached, stay tuned for challenge 4";

    constructor(address _middleware) UniversalChanIbcApp(_middleware) {}

    // app specific logic
    function resetCounter() internal {
        counter = 0;
    }

    function increment() internal {
        counter++;
    }

    function getCounter() internal view returns (uint64) {
        return counter;
    }

    // IBC logic

    /**
     * @dev Sends a packet with the caller's address over the universal channel.
     * @param destPortAddr The address of the destination application.
     * @param channelId The ID of the channel to send the packet to.
     * @param timeoutSeconds The timeout in seconds (relative).
     */
    function sendUniversalPacket(address destPortAddr, bytes32 channelId, uint64 timeoutSeconds) external {
function sendUniversalPacket(address destPortAddr, bytes32 channelId, uint64 timeoutSeconds) external {
       string memory query = "crossChainQueryMint";
       bytes memory payload = abi.encode(msg.sender, query);
       uint64 timeoutTimestamp = uint64((block.timestamp + timeoutSeconds) * 1000000000);


       IbcUniversalPacketSender(mw).sendUniversalPacket(
           channelId, IbcUtils.toBytes32(destPortAddr), payload, timeoutTimestamp
       );
   }


# Other Functions


   function onUniversalAcknowledgement(bytes32 channelId, UniversalPacket memory packet, AckPacket calldata ack)
       external
       override
       onlyIbcMw
   {
       ackPackets.push(UcAckWithChannel(channelId, packet, ack));


       // decode the counter from the ack packet
       (address caller, string memory _functionCall) = abi.decode(ack.data, (address, string));
       require(balanceOf(caller) == 0, "Caller already has an NFT");


       if (currentTokenId < 500) {
           require(keccak256(bytes(_functionCall)) == keccak256(bytes("mint")), "Invalid function call");
           mint(caller);
           emit MintAckReceived(caller, currentTokenId, "NFT minted successfully");
       } else {
           emit MintAckReceived(caller, 0, "NFT minting limit reached");
       }
    }
        */
    }

    /**
     * @dev Packet lifecycle callback that implements packet acknowledgment logic.
     *      MUST be overriden by the inheriting contract.
     *
     * @param channelId the ID of the channel (locally) the ack was received on.
     * @param packet the Universal packet encoded by the source and relayed by the relayer.
     * @param ack the acknowledgment packet encoded by the destination and relayed by the relayer.
     */
    function onUniversalAcknowledgement(bytes32 channelId, UniversalPacket memory packet, AckPacket calldata ack)
        external
        override
        onlyIbcMw
    {
        // TODO - Implement onUniversalAcknowledgement to handle the received acknowledgment packet
        // The packet should contain the secret message from the Base Contract at address: 0x528f7971cE3FF4198c3e6314AA223C83C7755bf7
        // Steps:
        // 1. Decode the counter from the ack packet
        // 2. Emit a LogAcknowledgement event with the message

        // An example of how to properly decode and handle an ack packet can be found in XCounterUC.sol
    }

    /**
     * @dev Packet lifecycle callback that implements packet receipt logic and return and acknowledgement packet.
     *      MUST be overriden by the inheriting contract.
     *      NOT SUPPORTED YET
     *
     * @param channelId the ID of the channel (locally) the timeout was submitted on.
     * @param packet the Universal packet encoded by the counterparty and relayed by the relayer
     */
    function onTimeoutUniversalPacket(bytes32 channelId, UniversalPacket calldata packet) external override onlyIbcMw {
        timeoutPackets.push(UcPacketWithChannel(channelId, packet));
        // do logic
    }
}
