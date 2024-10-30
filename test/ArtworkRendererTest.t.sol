// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27 <0.9.0;

import { Test } from "forge-std/src/Test.sol";
import { console2 } from "forge-std/src/console2.sol";

import { ArtworkRenderer } from "../src/ArtworkRenderer.sol";
import { Artwork } from "../src/Artwork.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
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

        IEphemera ephemera = IEphemera(address(0xCb337152b6181683010D07e3f00e7508cd348BC7));
        // TODO: Add tests for ArtworkRenderer
    }
}
