// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/*****************ERROR****************/
error MarvelNFT__NotEnoughETH();
error MarvelNFT__AllNftMinted();

/**
 * @author Raiyan Mukhtar
 *
 * @title An Collection of ERC721 NFTS.
 */

contract MarvelNftCollection is ERC721Enumerable, Ownable {
    /******LIBRARIES*******/
    using Strings for uint256;
    using Counters for Counters.Counter;

    /**********STATE VARIABLE**********/
    Counters.Counter private s_tokenIds;
    uint256 private minETHprice = 0.0001 ether;
    uint256 private constant _maxTokens = 5;
    string constant baseExtension = ".json";

    constructor() ERC721("MarvelNFT", "MVNFT") {}

    function mintNFT() external payable returns (uint256) {
        if (msg.value < minETHprice) {
            revert MarvelNFT__NotEnoughETH();
        }
        if (s_tokenIds._value > _maxTokens) {
            revert MarvelNFT__AllNftMinted();
        }

        s_tokenIds.increment();

        _mint(msg.sender, s_tokenIds._value);

        return s_tokenIds._value;
    }

    function withdraw() external returns (bool) {
        require(msg.sender != address(0), "Address invalid");
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");

        return sent;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmW8sBdA9s78Ew1HWxQs37SHRJCu9judGNjhi3TGKAbDNL/";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        super.tokenURI(tokenId);

        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(baseURI, tokenId.toString(), baseExtension)
                )
                : "";
    }
}
