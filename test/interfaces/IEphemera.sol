// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

interface IEphemera {
    function registerExtension(address extension, string memory baseUri) external;
}
