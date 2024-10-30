// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Base64 } from "solady/utils/Base64.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import { Artwork } from "./Artwork.sol";
import { LibString } from "solady/utils/LibString.sol";
import { DateTimeLib } from "solady/utils/DateTimeLib.sol";
import { ENS } from "@ensdomains/ens-contracts/contracts/registry/ENS.sol";
import { IReverseRegistrar } from "@ensdomains/ens-contracts/contracts/reverseRegistrar/IReverseRegistrar.sol";
import { INameResolver } from "@ensdomains/ens-contracts/contracts/resolvers/profiles/INameResolver.sol";

/**
 * @title ArtworkRenderer
 * @dev Contract for rendering metadata and SVG image.
 */
contract ArtworkRenderer is Ownable {
    string public metadata;

    Artwork public artwork;
    IERC1155 public ephemera;

    /**
     * @dev Constructor to initialize the contract with various parameters
     * @param _metadata Base metadata for the token
     * @param _ephemera Address of the ERC1155 contract for Ephemera
     */
    constructor(string memory _metadata, address _ephemera) Ownable() {
        metadata = _metadata;
        ephemera = IERC1155(_ephemera);
    }

    /**
     * @dev Renders the complete metadata JSON for the token
     * @return string The base64 encoded metadata JSON
     */
    function renderMetadata() public view returns (string memory) {
        return string(abi.encodePacked("data:application/json;utf8,{", metadata, ', "image": "', renderImage(), '"}'));
    }

    /**
     * @dev Renders the SVG image for the token
     * @return string The base64 encoded SVG image
     */
    function renderImage() public view returns (string memory) {
        return string(abi.encodePacked("data:image/svg+xml;base64,", "svg-content"));
    }

    /**
     * @dev Retrieves the current owner of the token
     * @return address The address of the current owner
     */
    function getOwner() public view returns (address) {
        return artwork.currentOwner();
    }

    // Setter functions (onlyOwner)
    function setArtwork(address _artwork) external onlyOwner {
        artwork = Artwork(_artwork);
    }

    function setEphemera(address _ephemera) external onlyOwner {
        ephemera = IERC1155(_ephemera);
    }

    function setMetadata(string memory _metadata) external onlyOwner {
        metadata = _metadata;
    }
}
