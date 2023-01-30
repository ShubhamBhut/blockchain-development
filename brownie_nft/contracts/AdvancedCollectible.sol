//SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721{
	
	uint256 public tokenCounter;
	bytes32 public keyHash;
	uint256 public fee;
	enum Breed{PUG, SHIBA_INU, ST_BERNARD}
	mapping(uint256 => Breed) public tokenIdToBreed;
	mapping(bytes32 => address) public requestIdToSender;
	event requestedCollectable(bytes32 indexed requestId, address requester);
	event breedAssigned(uint256 index, Breed breed);

	constructor(address _vrfCoordinator, address _linkToken, bytes32 _keyHash, uint256 _fee) public
		VRFConsumerBase(_vrfCoordinator, _linkToken)
		ERC721("Dog", "DOG")
		{
			tokenCounter = 0;
			keyHash = _keyHash;
			fee = _fee;
		}

	function createCollectible() public returns (bytes32) {
		bytes32 requestId = requestRandomness(keyHash, fee);
		requestIdToSender[requestId] = msg.sender;
		emit requestedCollectable(requestId, msg.sender);
	}

	function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
		Breed breed = Breed(randomNumber % 3);
		uint256 newTokenId = tokenCounter;
		tokenIdToBreed[newTokenId] == breed;
		emit breedAssigned(newTokenId, breed);
		address owner = requestIdToSender[requestId];
		_safeMint(owner, newTokenId);
		tokenCounter += 1;
	}

	function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not owner nor approved");
		_setTokenURI(tokenId, _tokenURI);
	}

	
}

