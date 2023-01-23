from brownie import Lottery, accounts, config, network
from web3 import Web3
from scripts.deploy_lottery import deploy_lottery


def test_get_entrance_fee():
    #Arrange
    lottery = deploy_lottery()
    #Act
    #according to our mocks, 2000ETH = 1usd hence 2000/1 == 50/x and so x==0.025
    expected_entrance_fee = Web3.toWei(0.025, "ether")
    entrance_fee = lottery.getEntranceFee()
    #Assert
    assert expected_entrance_fee == entrance_fee

