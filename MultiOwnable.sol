// SPDX-License-Identifier: MIT
// Contract based on OpenZeppelin Ownable contract. Note that we cannot just inherit from Ownable,
// because its constructor will call _transferOwnership() unconditionally while we don't need it

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract MultiOwnable is AccessControl {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {}

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;

        _revokeRole(DEFAULT_ADMIN_ROLE, _owner);
        _owner = newOwner;
        _grantRole(DEFAULT_ADMIN_ROLE, _owner);
        
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
