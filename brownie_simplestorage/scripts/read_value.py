from brownie import SimpleStorage, accounts, config


def read_contract():
    simple_storage = SimpleStorage[-1]
    # go take the index that is one less than the length to get most recent deployment
    # brownie already knows the abi and address of the contract as it was previously deployed
    # print(simple_storage)
    print(simple_storage.retrieve())


def main():
    read_contract()
