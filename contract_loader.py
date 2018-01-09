import os.path
import sqlite3
import argparse

import json
import web3

from web3 import Web3, HTTPProvider, TestRPCProvider
from solc import compile_source
from web3.contract import ConciseContract

import classes.database as contracts_db
import classes.blockchain as blockchain

class ContractLoader:
    
    parser = None
    
    contract_name = 'lottery'
    contract_extension = 'sol'
    contract_path = './contracts/'
    contract_address = ''
    tx_hash = ''
    
    db = None # Database class
    bch = None # blockchain class for contract operation
    
    def __init__(self, name):
        self.init_db()
        self.init_blockchain()
        self.contract_name = name
    
    def load(self):
        file = self.get_file(self.get_fullpath(self.contract_name))
        if file:
            contract_source_code = file.read()
            compiled_sol = compile_source(contract_source_code)
            interface_name = '<stdin>:'+self.contract_name.capitalize()
            contract_interface = compiled_sol[interface_name]
            # web3.py instance
            self.tx_hash = self.db.get_hash(self.contract_name)
            if self.tx_hash is not None:
                self.contract_address = self.bch.get_contract_address(self.tx_hash)
                contract_instance = self.bch.get_contract_instance(
                    contract_interface['abi'],
                    self.contract_address,
                    ConciseContract
                )
                print(contract_instance.accumulated())
            else:
                # deploy new contract and store result
                self.tx_hash = self.bch.deploy_contract(contract_interface)
                print('Deployed: {}'.format(self.tx_hash))
                print('Storing: {}'
                .format(self.db.store_hash(self.contract_name, self.tx_hash)))
        if self.db:
            self.db.close()
    
    def init_db(self):
        self.db = contracts_db.ContractsDatabase()
        
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
            return open(file, 'r')
        return None

    
        

parser = argparse.ArgumentParser(description='Load a contract.')
parser.add_argument('name', metavar='name', type=str, nargs='?',
help='contract name to be loaded from ./contracts')
args = parser.parse_args()

x = ContractLoader(args.name)
x.load()