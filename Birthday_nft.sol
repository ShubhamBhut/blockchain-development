//Instructions to get your birthday gift NFT
// 1. You would need a metamask account, add the firefox addon and sign up
// 2. send your account address to Napoleon to get your 1st gift, 0.4 goerli ETH, you would need that
// 3. now go to remix ide, by googling it, and add this file
// 4. compile(Ctrl + s) and deploy(with orange button on the left) the contract on INJECTED WEB3 option, metamask will pop up, sign the contract on metamask
// 5. wait for transaction and Congratulations, MXN has been released. you can check it on etherscan.(look at output log below code editing window)
// 6. TO get MXN (your NFT), you need to click flipSaleState(2nd oragnge button on Deployed Contract menu on the left), sign in the metamask, pay gas fee
// 7/ wait for transaction and Now put 10000000000000000 (10^16) in VALUE box on left and enter 1 in mint (red button), 1 is amount of tokken and 10^16 Wei was its price
// 8. Click on mint button and sign on metamask. after transaction, you will get your NFT. you can check it on https://testnets.opensea.io/ - Sign up using same metamask wallet

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    uint public constant MAX_TOKENS = 6;
    uint private constant TOKENS_RESERVED = 0;
    uint public price = 1000000000000000;
    uint256 public constant MAX_MINT_PER_TX = 2;

    bool public isSaleActive;
    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtension = ".json";

    constructor() ERC721("Mx_birthdayNFT", "MXN") {
        baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;
    }

    // Public Functions
    function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused.");
        require(_numTokens <= MAX_MINT_PER_TX, "You cannot mint that many in one transaction.");
        require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many total.");
        uint256 curTotalSupply = totalSupply;
        require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
        require(_numTokens * price <= msg.value, "Insufficient funds.");

        for(uint256 i = 1; i <= _numTokens; ++i) {
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedPerWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;

    }

    // Owner-only functions
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdrawAll() external payable onlyOwner {
        uint256 balance = address(this).balance;
        uint256 balanceOne = balance * 70 / 100;
        uint256 balanceTwo = balance * 30 / 100;
        ( bool transferOne, ) = payable(0x206c8EdE1797d04e929Cc9A2F3f7079Ba2F57c90).call{value: balanceOne}("");
        ( bool transferTwo, ) = payable(0xD3A5CC2c3B69de01C62c64ACDd82549e7Fd750E5).call{value: balanceTwo}("");
        require(transferOne && transferTwo, "Transfer failed.");
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
 
        // string memory currentBaseURI = _baseURI();
        // return bytes(currentBaseURI).length > 0
        //     ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        //     : "";

        return "https://jsonkeeper.com/b/Y3EJ";
    }
 
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}


//Incase you wanna get basic idea of solidity, you can checkout - 
//https://github.com/ShubhamBhut/web3/blob/main/Learning.sol

//I would also recommend to have a look at fuondry project. It is lightning fast and written in Rust.
