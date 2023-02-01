//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Box {
	
	uint256 private value;

	event valueChanged(uint256 newValue);

	function store(uint256 newValue) public {
		value = newValue;
		emit valueChanged(newValue);
	}

	function retrieve() public returns (uint256) {
		return value;
		
	}

	function increment() public {
		value = value + 1;
		emit valueChanged(value);
	}
}
