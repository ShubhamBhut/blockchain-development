from brownie import OurToken, accounts, config

def deploy_erc20():
    account = accounts[0]
    OurToken.deploy({"from": account})

def main():
    deploy_erc20()
