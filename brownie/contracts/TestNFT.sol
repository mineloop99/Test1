// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./Utils/Ownable.sol";
import "./Tokens/ERC721.sol";

contract TestNFT is Ownable, ERC721 {
    mapping(uint256 => string) internal _data;
    uint256 tokenCounter;

    constructor() ERC721("Non Fungible Test", "TEST") {
        tokenCounter = 0;
    }

    function contractURI() public pure returns (string memory) {
        return
            "https://example.test.finance/test/nft-market/collectible/meta.json";
    }

    function dataOf(uint256 tokenID) external view returns (string memory) {
        return _data[tokenID];
    }

    function updateData(uint256 tokenID, string memory data) external {
        _data[tokenID] = data;
    }

    function mint(address owner, string memory data) public onlyOwner {
        require(
            keccak256(abi.encodePacked((data))) !=
                keccak256(abi.encodePacked((""))),
            "Please Specify the name of an Item"
        );
        uint256 tokenId = tokenCounter;
        // set data
        _data[tokenId] = data;

        // mint token
        _mint(owner, tokenId);
        tokenCounter = tokenCounter + 1;
    }

    function mintMany(address[] memory owners, string[] memory data)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < owners.length; i++) {
            mint(owners[i], data[i]);
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        abi.encodePacked(
                            abi.encodePacked(
                                string(
                                    abi.encodePacked(baseURI, _data[tokenId])
                                ),
                                "/"
                            ),
                            Strings.toString(tokenId)
                        ),
                        ".meta"
                    )
                )
                : "";
    }
}
