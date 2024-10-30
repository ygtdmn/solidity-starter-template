// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25 <0.9.0;

import { BaseScript } from "./Base.s.sol";
import { ArtworkRenderer } from "../src/ArtworkRenderer.sol";
import { Artwork } from "../src/Artwork.sol";

contract Deploy is BaseScript {
    function run() public broadcast returns (ArtworkRenderer renderer, Artwork artwork) {
        address ephemera = address(0xCb337152b6181683010D07e3f00e7508cd348BC7); // mainnet
        // address ephemera = address(0xBF6b69aF9a0f707A9004E85D2ce371Ceb665237B); // sepolia
        string memory metadata = unicode"\"name\": \"Artwork\",\"description\": \"Description for the artwork.\"";
        renderer = new ArtworkRenderer(metadata, ephemera);
        artwork = new Artwork(address(renderer), address(ephemera));
        renderer.setArtwork(address(artwork));
    }
}
