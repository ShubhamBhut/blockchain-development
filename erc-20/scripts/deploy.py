from brownie import OurToken, accounts, config
from scripts.helpful_scripts import get_account
from web3 import Web3


initial_supply = Web3.toWei(1000, "ether")

def deploy_erc20():
    account = get_account()
    our_token = OurToken.deploy(initial_supply, {"from": account})
    print(f"{our_token.name()} has been successfully deployed!")

def main():
    deploy_erc20()
