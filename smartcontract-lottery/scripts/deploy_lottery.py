from scripts.helpful_scripts import get_account
from brownie import Lottery


def deploy_lottery():
    account = get_account(id="brownie-learning")
    lottery = Lottery.deploy(
            get_contract()
            )


def main():
    deploy_lottery()

