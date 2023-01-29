from scripts.helpful_scripts import get_account
from web3 import Web3
from brownie import network, config, interface
from scripts.get_weth import get_weth


def get_lending_pool():
    lending_pool_addresses_provider = interface.ILendingPoolAddressesProvider(
        config["networks"][network.show_active()]["lending_pool_addresses_provider"]
    )
    lending_pool_address = lending_pool_addresses_provider.getLendingPool()
    lending_pool = interface.ILendingPool(lending_pool_address)
    return lending_pool


def approve_erc20(amount, spender, erc20_address, account):
    print("Approving ERC20 token.....")
    # ABI
    erc20 = interface.IERC20(erc20_address)
    tx = erc20.approve(spender, amount, {"from": account})
    tx.wait(1)
    print("Approved!")
    return tx


amount = 0.1 * 10**18


def get_borrowable_data(lending_pool, account):
    (
        total_collateral_eth,
        total_debt_eth,
        available_borrow_eth,
        current_liquidation_threshold,
        ltv,
        health_factor,
    ) = lending_pool.getUserAccountData(account.address)
    available_borrow_eth = Web3.fromWei(available_borrow_eth, "ether")
    total_collateral_eth= Web3.fromWei(total_collateral_eth, "ether")
    total_debt_eth = Web3.fromWei(total_debt_eth, "ether")
    print(f"You have {total_collateral_eth} worth of ETH deposited")
    print(f"You have {total_debt_eth} worth of ETH borrowed")
    print(f"You can borrow {available_borrow_eth} worth of ETH.")
    return (float(available_borrow_eth), float(total_debt_eth))

def get_asset_price(price_feed_address):
    pass




def main():
    account = get_account()
    erc20_address = config["networks"][network.show_active()]["weth_token"]
    if network.show_active() in ["mainnet-fork"]:
        get_weth()
    # ABI
    # Address
    lending_pool = get_lending_pool()
    print(lending_pool)

    # Approve of sending out ERC20 tokens
    approve_erc20(amount, lending_pool.address, erc20_address, account)

    # Depositing process
    print("Depositing...")
    tx = lending_pool.deposit(
        erc20_address, amount, account.address, 0, {"from": account}
    )
    tx.wait(1)
    print("Deposited!")

    # Borrowning process
    borrowable_eth, total_debt =  get_borrowable_data(lending_pool, account)
    print("Let's borrow!")
    #DAI in terms of ether
    if network.show_active() == 'goerli':
        dai_usd_price = get_asset_price(config['networks'][network.show_active()]['dai_eth_price_feed'])
        eth_usd_price = get_asset_price(config['networks'][network.show_active()]['dai_eth_price_feed'])
        dai_eth_price =  dai_usd_price / eth_usd_price
    else:
        dai_eth_price = get_asset_price(config['networks'][network.show_active()]['dai_eth_price_feed'])
