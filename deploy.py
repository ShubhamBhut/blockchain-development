from solcx import compile_standard, install_solc
import json
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

with open("SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

# Compile our solidity code
install_solc("0.6.0")
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

# print(compiled_sol)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# for connecting to ganache
w3 = Web3(
    Web3.HTTPProvider("https://goerli.infura.io/v3/e3709c235bd34a558a3039f97fb3b870")
)
chain_id = 5
my_address = "0x206c8EdE1797d04e929Cc9A2F3f7079Ba2F57c90"
private_key = os.getenv("PRIVATE_KEY")
# print(private_key)

# create a contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get the latest transaction
nonce = w3.eth.getTransactionCount(my_address)

# print(nonce)

# Buid a transaction
# Sign a teansaction
# Send a transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)
# print(transaction)

signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
print("Deploying contract")
tx_hash = w3.eth.sendRawTransaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Contract deployed")

# While working with a contract, we will always need
# Contract address and contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
# print(simple_storage.functions.retrieve().call())
# print(simple_storage.functions.store(711).call())
print("Updating contract")
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
    }
)
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
rx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)
print(simple_storage.functions.retrieve().call())
print("Contract updated")
