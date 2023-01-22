// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Lottery is VRFConsumerBase, Ownable {

	address payable[] public players; 
	uint256 public usdEntryFee;
	address payable public recentWinner;
	uint256 public randomness;

	AggregatorV3Interface internal ethUsdPriceFeed;
	enum LOTTERY_STATE{
		OPEN,
		CLOSED,
		CALCULATING_WINNER
	}
	LOTTERY_STATE public lottery_state;	

	uint256 public fee;
	bytes32 public keyhash;

	constructor(address _priceFeedAddress, address _vrfCoordinator, address _link, uint256 _fee, bytes32 _keyhash)
	public
	VRFConsumerBase(_vrfCoordinator, _link)
	{
		usdEntryFee = 50 * (10**18);
		ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
		lottery_state = LOTTERY_STATE.CLOSED;
		fee = _fee;
		keyhash = _keyhash;
	}

	function enter() public payable {
		//$50 minimum
		require(lottery_state == LOTTERY_STATE.OPEN);
		require(msg.value >= getEntranceFee(), "Not Enough ETH, min ETH required is $50");
		players.push(msg.sender);	
	}

	function getEntranceFee() public view returns (uint256) {
		(, int256 price, ,,) = ethUsdPriceFeed.latestRoundData();
		uint256 adjustedPrice = uint256(price) * (10 **10);//to keep decimal 18
		//$50 , $2000 /ETH
		uint256 costToEnter = (usdEntryFee * (10**18)) / adjustedPrice;
		return costToEnter;
	}

	function startLottery() public onlyOwner {
		require(lottery_state == LOTTERY_STATE.CLOSED, "Can't start a new lottery yet"); 
		lottery_state =  LOTTERY_STATE.OPEN;
	}

	//following is shown a very insecure way of generating random no.s in a smart contract
	//it is basically using golbally avaliable variable eg.block difficulty etc. and hashing it and 
	//considring the answer as a random value. Actually block difficulty can be manipulated by miners
	//function endLottery() public onlyOwner{
	//	uint256(keccack256(
	//		abi.encodePacked(
	//			nonce, //predictable aka transaction number
	//			msg.sender, //predictable
	//			block.difficulty, //can be manipulated
	//			block.timestamp //predictable
	//		)
	//	     )
	//	) % players.length;
	//
	//}

	function endLottery() public onlyOwner{

		lottery_state = LOTTERY_STATE.CALCULATING_WINNER;
		bytes32 requestId = requestRandomness(keyhash, fee);
	}

	function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
		require(lottery_state == LOTTERY_STATE.CALCULATING_WINNER, "You are not in calculating winner state");
		require(_randomness > 0, "random not found");
		uint256 indexOfWinner = _randomness % players.length;
		recentWinner = players[indexOfWinner];
		recentWinner.transfer(address(this).balance);

		//Rest the lottery
		players = new address payable[](0);
		lottery_state = LOTTERY_STATE.CLOSED;
		randomness = _randomness;
	}
}
