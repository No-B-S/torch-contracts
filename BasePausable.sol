// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";

contract BasePausable is Pausable {
    constructor() Pausable() {}
}
