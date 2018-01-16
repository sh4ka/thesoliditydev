import sys
import argparse

sys.path.insert(0, './classes/contract_loader.py')

from contracts.lottery import Lottery

parser = argparse.ArgumentParser(description='Load a contract.')
#parser.add_argument('name', metavar='name', type=str, nargs='?',
#help='contract name to be loaded from ./contracts')
args = parser.parse_args()

lottery = Lottery()
lottery.load()
print('Accumulated: {}'.format(lottery.accumulated()))
print('Placing 5 bets')
print('--------------')
lottery.placeBet(12345, lottery.getAccount(1))
lottery.placeBet(12346, lottery.getAccount(2))
lottery.placeBet(12347, lottery.getAccount(3))
lottery.placeBet(12348, lottery.getAccount(4))
lottery.placeBet(12345, lottery.getAccount(4)) # this guy makes 2 bets
print('Number of bets: {}'.format(lottery.getNumberOfBets()))
print('Bet at position 2: {}'.format(lottery.getBet(2)))
print('Accumulated: {}'.format(lottery.accumulated()))
print('Closing Lottery')
print('--------------')
lottery.closeLottery(lottery.getAccount(0)) # from owner address
print('Setting winning number to 12345, 2 winners take all')
print('---------------------------------------------------')
lottery.setWinningNumber(12345, lottery.getAccount(0)) # from owner address
print('Price per winner: {}'.format(lottery.getPricePerWinner()))
print('Balance in account 1 BEFORE: {}'.format(lottery.getBalance(lottery.getAccount(1))))
print('Balance in account 4 BEFORE: {}'.format(lottery.getBalance(lottery.getAccount(4))))
lottery.withdrawAccumulated(lottery.getAccount(1))
lottery.withdrawAccumulated(lottery.getAccount(4))
print('Balance in account 1 AFTER: {}'.format(lottery.getBalance(lottery.getAccount(1))))
print('Balance in account 4 AFTER: {}'.format(lottery.getBalance(lottery.getAccount(4))))
