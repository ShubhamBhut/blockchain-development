from scripts.helpful_scripts import get_account
from brownie import network, config, interface
from scripts.get_weth import get_weth


def get_lending_pool():
    lending_pool_addresses_provider = interface.ILendingPoolAddressesProvider(
            config['networks'][network.show_active()]['lending_pool_addresses_provider']
            )
    lending_pool_address = lending_pool_addresses_provider.getLendingPool()
    lending_pool = interface.ILendingPool(lending_pool_address)
    return lending_pool
    

def main():
    account = get_account()
    erc20_address = config['networks'][network.show_active()]['weth_token']
    if network.show_active() in ['mainnet-fork']:
        get_weth()
    #ABI
    #Address
    lending_pool = get_lending_pool()
    print(lending_pool)



