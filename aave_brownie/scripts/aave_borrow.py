from scripts.helpful_scripts import get_account
from brownie import network, config
from scripts.get_weth import get_weth


def main():
    account = get_account()
    erc20_address = config['networks'][network.show_active()]['weth_token']
    #get_weth()
    if network.show_active() in ['mainnet-fork']:
        get_weth()
