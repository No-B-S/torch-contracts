//Contract based on [https://docs.openzeppelin.com/contracts/4.x/erc721](https://docs.openzeppelin.com/contracts/4.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "./MultiOwnable.sol";


contract GenericNFT is ERC721, ERC721URIStorage, ERC721Enumerable, MultiOwnable, ERC2981 {
    using Counters for Counters.Counter;
    struct ContractConfig {
      string name;
      string symbol;
      address owner;
    }

    Counters.Counter private _tokenIds;
    ContractConfig internal _config;

    constructor(ContractConfig memory config) ERC721("", "") {
      _transferOwnership(config.owner);
      _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
      _config = config;
    }

    // This one is overridden to show name from config
    function name() public view  override returns (string memory) {
        return _config.name;
    }

    // This one is overridden to show symbol from config
    function symbol() public view  override returns (string memory) {
        return _config.symbol;
    }

    function mint(address recipient, string memory _tokenURI)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        return newItemId;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControl, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
