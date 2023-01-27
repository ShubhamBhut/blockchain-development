from brownie import network
import time 
import pytest
from scripts.helpful_scripts import LOCAL_BLOCKCHAIN_ENVIRONMENTS, get_account, fund_with_link
from scripts.deploy_lottery import deploy_lottery

def test_can_pick_winner():
    if network.show_active in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        pytest.skip()
    lottery = deploy_lottery()
    account = get_account()
    lottery.startLottery({"from": account})
    lottery.enter({"from": account, "value": lottery.getEntranceFee() + 1000})
    lottery.enter({"from": account, "value": lottery.getEntranceFee() + 1000})
    fund_with_link(lottery)
    lottery.endLottery({"from": account})
    # it takes around 4 minutes for goerli chainlink node to respond with a random value, so unless a random 
    # value is recieved, the winner will be 0000000000000000000000000000000000x
    time.sleep(300)
    assert lottery.recentWinner() == account
    assert lottery.balance() == 0
