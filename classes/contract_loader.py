import os.path
import argparse

import json
import web3

from web3 import Web3, HTTPProvider, TestRPCProvider
from solc import compile_source
from web3.contract import ConciseContract

import classes.blockchain as blockchain

class ContractLoader(object):
    
    parser = None
    
    contract_name = 'lottery'
    contract_extension = 'sol'
    contract_path = './contracts/'
    contract_address = ''
    contract_instance = None
    tx_hash = ''
    
    bch = None # blockchain class for contract operation
    
    def __init__(self, name):
        self.init_blockchain()
        self.contract_name = name
    
    def load(self):
        file = self.get_file(self.get_fullpath(self.contract_name))
        if file:
            contract_source_code = file.read()
            compiled_sol = compile_source(contract_source_code)
            interface_name = '<stdin>:'+self.contract_name.capitalize()
            contract_interface = compiled_sol[interface_name]
            
            # deploy new contract
            self.tx_hash = self.bch.deploy_contract(contract_interface)
            print('Deployed: {}'.format(self.tx_hash))
            
            # using the tx_hash of the deployment tx_receipt 
            # you can get the contract address as many times as you need
            self.contract_address = self.bch.get_contract_address(self.tx_hash)
            self.contract_instance = self.bch.get_contract_instance(
                contract_interface['abi'],
                self.contract_address,
                ConciseContract
            )
        
    def init_blockchain(self):
        self.bch = blockchain.Blockchain()
    
    def get_fullpath(self, name):
        fullpath = '{}{}.{}'.format(
            self.contract_path,
            name,
            self.contract_extension
        )
        return fullpath
        
    def get_file(self, file):
        if os.path.isfile(file):
            # Solidity source code only
            print('Loaded file: {}'.format(file))
            return open(file, 'r')
        return None
        
    def getAccount(self, number):
        return self.bch.getAccount(number)
        
    def getBalance(self, account):
        return self.bch.getBalance(account)