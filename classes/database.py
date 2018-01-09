import sqlite3

class ContractsDatabase:
    
    db = None # db connection
    c = None # cursor for db
    
    def __init__(self):
        self.init_db()
        
    def init_db(self):
        print('Starting DB')
        with sqlite3.connect('contracts.db') as self.db:
            self.c = self.db.cursor()
            table_exists = self.assert_table_exists()
            if not table_exists:
                print('Creating new table')
                self.create_contracts_table()
                print('Table created')
                
    def assert_table_exists(self):
        self.c.execute('''
        SELECT name FROM sqlite_master WHERE type='table' AND name='contracts';
        ''')
        table_exists = self.c.fetchone() is not None
        print('Table exists: {}'.format(table_exists))
        return table_exists
        
    def create_contracts_table(self):
        print('Creating table')
        self.c.execute('''
        CREATE TABLE contracts
        (name, hash, UNIQUE(name))
        ''')
        
    def store_hash(self, contract_name, tx_hash):
        result = False
        if contract_name and tx_hash:
            print('Storing contract: {} - {}'.format(contract_name, tx_hash))
            self.c.execute('''
            INSERT OR IGNORE INTO contracts(name, hash) VALUES (?, ?)
            ''',
            (contract_name, tx_hash))
            self.db.commit()
            result = self.c.lastrowid
        return result
        
    def contract_was_stored(self, name):
        was_stored = self.get_hash(name) is not None
        print('Contract was stored: {}'.format(was_stored))
        return was_stored
        
    def get_hash(self, name):
        t = (name,)
        print('Getting contract: {}'.format(name))
        self.c.execute('SELECT * FROM contracts WHERE name = ?', t)
        row = self.c.fetchone()
        if row:
            self.tx_hash = row[1]
            return self.tx_hash
        return None
    
    def close(self):
        self.db.close()