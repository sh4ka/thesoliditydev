import json
import web3

from web3 import Web3, HTTPProvider, TestRPCProvider
from solc import compile_source
from web3.contract import ConciseContract

class Blockchain:
    
    w3 = None
    
    def __init__(self):
        self.w3 = Web3(HTTPProvider('http://localhost:8545'))
    
    def get_contract_address(self, tx_hash):
        tx_receipt = self.w3.eth.getTransactionReceipt(tx_hash)
        if tx_receipt:
            return tx_receipt['contractAddress']
        return None
    
    def contract_is_deployed(self, tx_hash):
        was_deployed = self.get_contract_address(tx_hash) is not None
        print('Contract was deployed: {}'.format(was_deployed))
        return was_deployed
        
    def get_contract_instance(
        self,
        interface,
        contract_hexcode,
        contract_factory
    ):
        return self.w3.eth.contract(
                interface,
                contract_hexcode,
                ContractFactoryClass=contract_factory
            )
        
    def deploy_contract(self, contract_interface):
        contract = self.w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])
        tx_hash = contract.deploy(transaction={'from': self.w3.eth.accounts[0]})
        return tx_hash
        
    def getAccount(self, num):
        return self.w3.eth.accounts[num]