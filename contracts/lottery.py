import sys

sys.path.insert(0, '../classes/contract_loader.py')

from classes.contract_loader import ContractLoader

class Lottery(ContractLoader):
    
    bet_size = 500000000000000
    
    def __init__(self):
        ContractLoader.__init__(self, 'lottery')
        
    def accumulated(self):
        return self.contract_instance.accumulated()
        
    def placeBet(self, number, account):
        tx_receipt = self.contract_instance.placeBet(number, transact={
            'from': account,
            'value': self.bet_size
        })
        return tx_receipt
        
    def getBet(self, position):
        return self.contract_instance.getBet(position)
        
    def getNumberOfBets(self):
        return self.contract_instance.getNumberOfBets()
        
    def closeLottery(self, account):
        return self.contract_instance.closeLottery(transact={
            'from': account
        })
        
    def setWinningNumber(self, winningNumber, account):
        self.contract_instance.setWinningNumber(winningNumber, transact={
            'from': account
        })
    
    def getPricePerWinner(self):
        return self.contract_instance.getPricePerWinner()
    
        
    def withdrawAccumulated(self, account):
        return self.contract_instance.withdrawAccumulated(transact={
            'from': account
        })