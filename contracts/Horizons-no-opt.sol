// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract HorizonsNoOpt is ERC721, Ownable {
    using Strings for uint256;

    string constant TITLE = "Horizon";
    string constant DESCRIPTION =
        "81 Horizons is a collection of 81 on-chain landscapes.\\nEach work consists of a unique combination of two colored rectangles.";
    string constant AUTHOR = unicode"Rafaël Rozendaal";

    string constant SVG_PROTOCOL_URI = "data:image/svg+xml;utf8,";
    /*
    string constant SVG_TOKEN_0 =
        '<svg id="_81_horizons" data-name="81 horizons" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800"><defs><style>.cls-1{fill:#';
    string constant SVG_TOKEN_1 = ";}.cls-2{fill:#";
    string constant SVG_TOKEN_2 =
        ';}</style></defs><rect class="cls-1" y="576" width="1200" height="224"/><rect class="cls-2" width="1200" height="576"/></svg>';
    */

    string constant SVG_TOKEN_0 =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800" shape-rendering="crispEdges"><rect fill="#';
    string constant SVG_TOKEN_1 =
        '" y="576" width="1210" height="224"/><rect fill="#';
    string constant SVG_TOKEN_2 = '" width="1210" height="576"/></svg>';

    // 17 colors, RBG format.
    /*
    bytes PALETTE =
        hex"00a7a872d0eb00a545006837b8ffdeffff9bffb43ec4e9fb29abe2bfbfbf00"
        hex"71bc060e9f060e574f4f4f000000ffe3fffea0c9";

    bytes constant PALETTE =
        "00a7a872d0eb00a545006837b8ffdeffff9bffb43ec4e9fb29abe2bfbfbf0071bc060e9f060e574f4f4f000000ffe3fffea0c9";

    // Every byte represents the color palette of an artwork.
    bytes ARTWORKS =
        hex"01213141516171819107273747576787970a2a3a4a5a6a7a8abacada0b2b3b"
        hex"7b8bcbbedb9b3c8cbccedc3ebecede9e0d2d3d8dbdcdde9d09293949596979"
        hex"89b9c99ed90f4f5f6f7f8f9f"
        // Artworks 75, 76, 77, 78, 79, 80, 81 have as secondary color the last
        // one in the palette, even if it's 0 here.
        hex"00405060708090";

        */

    constructor() ERC721("81 Horizons", "81H") {}

    function safeMintAll(address to, uint8 amount) public onlyOwner {
        //_safeMint(to, tokenId);
    }

    function getSVG(uint256 tokenId) public pure returns (bytes memory) {
        string[162] memory colors = [
            "00a7a8",
            "72d0eb",
            "00a545",
            "72d0eb",
            "006837",
            "72d0eb",
            "b8ffde",
            "72d0eb",
            "ffff9b",
            "72d0eb",
            "ffb43e",
            "72d0eb",
            "c4e9fb",
            "72d0eb",
            "29abe2",
            "72d0eb",
            "bfbfbf",
            "72d0eb",
            "00a7a8",
            "c4e9fb",
            "00a545",
            "c4e9fb",
            "006837",
            "c4e9fb",
            "b8ffde",
            "c4e9fb",
            "ffff9b",
            "c4e9fb",
            "ffb43e",
            "c4e9fb",
            "29abe2",
            "c4e9fb",
            "bfbfbf",
            "c4e9fb",
            "00a7a8",
            "0071bc",
            "00a545",
            "0071bc",
            "006837",
            "0071bc",
            "b8ffde",
            "0071bc",
            "ffff9b",
            "0071bc",
            "ffb43e",
            "0071bc",
            "c4e9fb",
            "0071bc",
            "29abe2",
            "0071bc",
            "060e9f",
            "0071bc",
            "060e57",
            "0071bc",
            "4f4f4f",
            "0071bc",
            "00a7a8",
            "060e9f",
            "00a545",
            "060e9f",
            "006837",
            "060e9f",
            "c4e9fb",
            "060e9f",
            "29abe2",
            "060e9f",
            "060e57",
            "060e9f",
            "060e9f",
            "000000",
            "4f4f4f",
            "060e9f",
            "bfbfbf",
            "060e9f",
            "006837",
            "060e57",
            "29abe2",
            "060e57",
            "060e9f",
            "060e57",
            "060e57",
            "000000",
            "4f4f4f",
            "060e57",
            "006837",
            "000000",
            "060e9f",
            "000000",
            "060e57",
            "000000",
            "4f4f4f",
            "000000",
            "bfbfbf",
            "000000",
            "00a7a8",
            "4f4f4f",
            "00a545",
            "4f4f4f",
            "006837",
            "4f4f4f",
            "29abe2",
            "4f4f4f",
            "060e9f",
            "4f4f4f",
            "060e57",
            "4f4f4f",
            "4f4f4f",
            "000000",
            "bfbfbf",
            "4f4f4f",
            "00a7a8",
            "bfbfbf",
            "00a545",
            "bfbfbf",
            "006837",
            "bfbfbf",
            "b8ffde",
            "bfbfbf",
            "ffff9b",
            "bfbfbf",
            "ffb43e",
            "bfbfbf",
            "c4e9fb",
            "bfbfbf",
            "29abe2",
            "bfbfbf",
            "060e9f",
            "bfbfbf",
            "060e57",
            "bfbfbf",
            "bfbfbf",
            "000000",
            "4f4f4f",
            "bfbfbf",
            "00a7a8",
            "ffe3ff",
            "b8ffde",
            "ffe3ff",
            "ffff9b",
            "ffe3ff",
            "ffb43e",
            "ffe3ff",
            "c4e9fb",
            "ffe3ff",
            "29abe2",
            "ffe3ff",
            "bfbfbf",
            "ffe3ff",
            "00a7a8",
            "fea0c9",
            "b8ffde",
            "fea0c9",
            "ffff9b",
            "fea0c9",
            "ffb43e",
            "fea0c9",
            "c4e9fb",
            "fea0c9",
            "29abe2",
            "fea0c9",
            "bfbfbf",
            "fea0c9"
        ];
        string memory color1 = colors[(tokenId - 1) * 2];
        string memory color2 = colors[(tokenId - 1) * 2 + 1];

        return
            abi.encodePacked(
                SVG_TOKEN_0,
                color1,
                SVG_TOKEN_1,
                color2,
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
