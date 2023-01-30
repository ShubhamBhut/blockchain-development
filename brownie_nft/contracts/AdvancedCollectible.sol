//SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721{
	
	uint256 public tokenCounter;
	bytes32 public keyHash;
	uint256 public fee;

	constructor(address _vrfCoordinator, address _linkToken, bytes32 _keyHash, uint256 fee) public
		VRFConsumerBase(_vrfCoordinator, _linkToken)
		ERC721("Dog", "DOG")
		{
			tokenCounter = 0;
			keyHash = _keyHash;
			fee = _fee;
		}
	
}

