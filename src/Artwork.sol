// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27;

import { IERC1155CreatorCore } from "@manifoldxyz/creator-core-solidity/contracts/core/IERC1155CreatorCore.sol";
import { ICreatorExtensionTokenURI } from "@manifoldxyz/creator-core-solidity/contracts/extensions/ICreatorExtensionTokenURI.sol";
import { IERC1155CreatorExtensionApproveTransfer } from "@manifoldxyz/creator-core-solidity/contracts/extensions/ERC1155/IERC1155CreatorExtensionApproveTransfer.sol";
import { IERC165, ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { ERC165Checker } from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ArtworkRenderer } from "./ArtworkRenderer.sol";

/**
 * @title <title of the artwork>
 * @notice <description of the artwork>
 */
contract Artwork is ICreatorExtensionTokenURI, IERC1155CreatorExtensionApproveTransfer, ERC165, Ownable {
    ArtworkRenderer public metadataRenderer;
    address public creatorContractAddress;
    uint256 public tokenId;
    address public currentOwner;

    error AlreadyMinted();
    error CreatorMustBeTheCreatorContractAddress();
    error CreatorMustImplementIERC1155CreatorCore();

    /**
     * @dev Constructor initializes the contract with a metadata renderer and creator contract address.
     * @param _metadataRenderer Address of the ArtworkRenderer contract
     * @param _creatorContractAddress Address of the creator contract
     */
    constructor(address _metadataRenderer, address _creatorContractAddress) Ownable() {
        metadataRenderer = ArtworkRenderer(_metadataRenderer);
        creatorContractAddress = _creatorContractAddress;
    }

    /**
     * @dev Allows the owner to set a new metadata renderer.
     * @param _metadataRenderer Address of the new ArtworkRenderer contract
     */
    function setMetadataRenderer(address _metadataRenderer) public onlyOwner {
        metadataRenderer = ArtworkRenderer(_metadataRenderer);
    }

    /**
     * @dev Allows the owner to set a new creator contract address.
     * @param _creatorContractAddress Address of the new creator contract
     */
    function setCreatorContractAddress(address _creatorContractAddress) public onlyOwner {
        creatorContractAddress = _creatorContractAddress;
    }

    /**
     * @dev Returns the metadata for the given token.
     * @return string The metadata URI for the token
     */
    function tokenURI(address, uint256) external view override returns (string memory) {
        return metadataRenderer.renderMetadata();
    }

    /**
     * @dev Mints a new token to the contract owner. Can only be called once.
     */
    function mint() external onlyOwner {
        require(tokenId == 0, AlreadyMinted());
        address[] memory dest = new address[](1);
        uint256[] memory quantities = new uint256[](1);
        string[] memory uris = new string[](1);

        dest[0] = msg.sender;
        quantities[0] = 1;

        tokenId = IERC1155CreatorCore(creatorContractAddress).mintExtensionNew(dest, quantities, uris)[0];
        currentOwner = msg.sender;
    }

    /**
     * @dev Checks if the contract supports a given interface.
     * @param interfaceId The interface identifier to check
     * @return bool True if the interface is supported, false otherwise
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return interfaceId == type(ICreatorExtensionTokenURI).interfaceId
            || interfaceId == type(IERC1155CreatorExtensionApproveTransfer).interfaceId
            || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Sets the approve transfer status for the creator contract.
     * @param creator Address of the creator contract
     * @param enabled Boolean indicating whether to enable or disable approve transfer
     */
    function setApproveTransfer(address creator, bool enabled) external override {
        require(
            ERC165Checker.supportsInterface(creator, type(IERC1155CreatorCore).interfaceId),
            CreatorMustImplementIERC1155CreatorCore()
        );
        require(creator == creatorContractAddress, CreatorMustBeTheCreatorContractAddress());
        IERC1155CreatorCore(creator).setApproveTransferExtension(enabled);
    }

    /**
     * @dev Approves token transfers and updates the current owner.
     * @param from Address transferring the token
     * @param to Address receiving the token
     * @return bool Always returns true to approve the transfer
     */
    function approveTransfer(
        address,
        address from,
        address to,
        uint256[] calldata,
        uint256[] calldata
    ) external override returns (bool) {
        if (from != to) {
            currentOwner = to;
        }
        return true;
    }
}
