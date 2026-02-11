// SPDX-License-Identifier: MIT
pragma solidity >=0.8.33 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { IEphemera } from "./interfaces/IEphemera.sol";

contract ArtworkRendererTest is Test {
    function testFork_Example() external {
        // Silently pass this test if there is no API key.
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        if (bytes(alchemyApiKey).length == 0) {
            return;
        }

        // Otherwise, run the test against the mainnet fork.
        vm.createSelectFork({ urlOrAlias: "mainnet" });
        vm.startPrank(address(0x28996f7DECe7E058EBfC56dFa9371825fBfa515A));

        // solhint-disable-next-line no-unused-vars
        IEphemera ephemera = IEphemera(address(0xCb337152b6181683010D07e3f00e7508cd348BC7));
        // TODO: Add tests for ArtworkRenderer
    }
}
