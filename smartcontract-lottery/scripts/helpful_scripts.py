from brownie import (
    accounts,
    network,
    config,
)

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]


def get_account(index=None, id=None):
    # accounts[0]
    # accounts.add("env")
    # accounts.load("id")
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])

def get_contract():
    """
    This function will grab contract addresses from brownie config if defined, otherwise it will deploy a mock version 
    of that contract and return that mock contract.

        Args: 
            contract_name (string)

        Returns:
            brownie.network.contracts.ProjectContract - the most recently deployed version of this contract
    """
