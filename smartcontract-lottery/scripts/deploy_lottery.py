from scripts.helpful_scripts import get_account, get_contract
from brownie import Lottery, network, config


def deploy_lottery():
    account = get_account()
    Lottery.deploy(
            get_contract("eth_usd_price_feed").address,
            get_contract("vrf_coordinator").address,
            get_contract("link_token").address,
            config["networks"][network.show_active()]["fee"],
            config["networks"][network.show_active()]["keyhash"],
            {"from": account},
            publish_source = config["networks"][network.show_active()].get("verify", False)
    )
    print("Deployed lottery!")

def start_lottery():
    account = get_account()
    lottery = Lottery[-1]
    starting_tx = lottery.startLottery({"from": account})
    starting_tx.wait(1)
    print("lottery started!")

def enter_lottery():
    account = get_account()
    lottery = Lottery[-1]
    value  = lottery.getEntranceFee() + 100000000
    tx = lottery.enter({"from": account, "value": value})
    tx.wait(1)
    print("You have successfully entered the lottery!")

def end_lottery():
    account = get_account()
    lottery = Lottery[-1]
    #first we will have to fund the contract with LINK as out endLottery function requires LINK to get random no.
    tx = Lottery

def main():
    deploy_lottery()
    start_lottery()
    enter_lottery()

