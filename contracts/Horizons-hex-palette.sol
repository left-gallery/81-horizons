// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HorizonsHexPalette is ERC721, Ownable {
    using Strings for uint256;

    string constant TITLE = "Horizon";
    string constant DESCRIPTION =
        "81 Horizons is a collection of 81 on-chain landscapes.\\nEach work consists of a unique combination of two colored rectangles.";
    string constant AUTHOR = unicode"Rafaël Rozendaal";

    string constant SVG_PROTOCOL_URI = "data:image/svg+xml;utf8,";

    string constant SVG_TOKEN_0 =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800" shape-rendering="crispEdges"><rect fill="#';
    string constant SVG_TOKEN_1 = '" y="576" width="1210" height="224"/><rect fill="#';
    string constant SVG_TOKEN_2 = '" width="1210" height="576"/></svg>';

    // 17 colors, RBG format.
    bytes PALETTE =
        hex"00a7a872d0eb00a545006837b8ffdeffff9bffb43ec4e9fb29abe2bfbfbf00"
        hex"71bc060e9f060e574f4f4f000000ffe3fffea0c9";

    // Every byte represents the color palette of an artwork.
    bytes ARTWORKS =
        hex"01213141516171819107273747576787970a2a3a4a5a6a7a8abacada0b2b3b"
        hex"7b8bcbbedb9b3c8cbccedc3ebecede9e0d2d3d8dbdcdde9d09293949596979"
        hex"89b9c99ed90f4f5f6f7f8f9f"
        // Artworks 75, 76, 77, 78, 79, 80, 81 have as secondary color the last
        // one in the palette, even if it's 0 here.
        hex"00405060708090";
    
    uint[] public vector = new uint[](2);

    constructor() ERC721("81 Horizons", "81H") {}

    function safeMintAll(address to, uint8 amount) public onlyOwner {
        //_safeMint(to, tokenId);
    }

    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    function toHexString(uint256 value) internal pure returns (bytes memory) {
        bytes memory buffer = new bytes(6);
        for (int256 i = 5; i >= 0; i--) {
            buffer[uint(i)] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        return buffer;
    }

    function getSVG(uint256 tokenId) public view returns (bytes memory) {
        uint8 artwork = uint8(ARTWORKS[tokenId-1]);
        uint8 colorIndex1 = (artwork >> 4) * 3;
        uint8 colorIndex2;
        if (tokenId <75) {
            //colorIndex2 = (artwork % 0x10) * 3;
            colorIndex2 = (artwork & 0x0f) * 3;
        }else {
            colorIndex2 = 16 * 3;
        }
        uint24 color1 = uint8(PALETTE[colorIndex1])<<16 + uint8(PALETTE[colorIndex1+1])<<8+uint8(PALETTE[colorIndex1+2]);
        uint24 color2 = uint8(PALETTE[colorIndex2])<<16 + uint8(PALETTE[colorIndex2+1])<<8+uint8(PALETTE[colorIndex2+2]);

        return
            abi.encodePacked(
                SVG_TOKEN_0,
                toHexString(color1),
                SVG_TOKEN_1,
                toHexString(color2),
                SVG_TOKEN_2
            );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        bytes memory image = abi.encodePacked(
            SVG_PROTOCOL_URI,
            getSVG(tokenId)
        );

        bytes memory number;
        if (tokenId < 10) {
            number = abi.encodePacked("0", tokenId.toString());
        } else {
            number = abi.encodePacked(tokenId.toString());
        }
        bytes memory json = abi.encodePacked(
            '{"name":"',
            TITLE,
            " ",
            number,
            '",',
            '"description":"',
            DESCRIPTION,
            '",',
            '"created_by":"',
            AUTHOR,
            '"',
            '"image":"',
            image,
            '"}'
        );
        return string(abi.encodePacked("data:application/json,", json));
    }

}
