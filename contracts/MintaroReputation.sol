// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintaroReputation is ERC721URIStorage, Ownable {
    uint256 public badgeCounter;

    struct Badge {
        address client;
        address freelancer;
        uint8 rating;
        string ipfsCID;
        uint256 timestamp;
    }

    mapping(uint256 => Badge) public badgeDetails;

    constructor() ERC721("MintaroBadge", "MTB") {}

    function mintBadge(address freelancer, uint8 rating, string memory ipfsCID) external {
        require(rating >= 1 && rating <= 5, "Rating must be 1–5");

        uint256 badgeId = badgeCounter;
        badgeCounter++;

        _mint(freelancer, badgeId);
        _setTokenURI(badgeId, ipfsCID); // Optional: link to IPFS metadata

        badgeDetails[badgeId] = Badge({
            client: msg.sender,
            freelancer: freelancer,
            rating: rating,
            ipfsCID: ipfsCID,
            timestamp: block.timestamp
        });
    }

    function getBadgesOf(address freelancer) external view returns (uint256[] memory) {
        uint256 total = badgeCounter;
        uint256 count;
        for (uint256 i = 0; i < total; i++) {
            if (ownerOf(i) == freelancer) count++;
        }

        uint256[] memory result = new uint256[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < total; i++) {
            if (ownerOf(i) == freelancer) {
                result[index++] = i;
            }
        }

        return result;
    }
}
