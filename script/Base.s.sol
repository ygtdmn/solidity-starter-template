// SPDX-License-Identifier: MIT
pragma solidity >=0.8.27 <0.9.0;

import { Script } from "forge-std/src/Script.sol";

abstract contract BaseScript is Script {
  /// @dev Included to enable compilation of the script without a $PRIVATE_KEY environment variable.
  string internal constant TEST_PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

  /// @dev Needed for the deterministic deployments.
  bytes32 internal constant ZERO_SALT = bytes32(0);

  /// @dev The address of the transaction broadcaster.
  address internal broadcaster;

  /// @dev Used to store the broadcaster's private key if $ETH_FROM is not defined.
  uint256 internal privateKey;

  /// @dev Initializes the transaction broadcaster like this:
  ///
  /// - If $ETH_FROM is defined, use it.
  /// - Otherwise, derive the broadcaster address from $PRIVATE_KEY.
  /// - If $PRIVATE_KEY is not defined, default to a test private key.
  ///
  /// The use case for $ETH_FROM is to specify the broadcaster key and its address via the command line.
  constructor() {
    address from = vm.envOr({ name: "ETH_FROM", defaultValue: address(0) });
    if (from != address(0)) {
      broadcaster = from;
    } else {
      string memory pkString = vm.envOr({ name: "PRIVATE_KEY", defaultValue: TEST_PRIVATE_KEY });
      privateKey = vm.parseUint(pkString);
      broadcaster = vm.addr(privateKey);
    }
  }

  modifier broadcast() {
    vm.startBroadcast(broadcaster);
    _;
    vm.stopBroadcast();
  }
}
