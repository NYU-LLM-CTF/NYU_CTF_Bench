# Code taken from https://github.com/prowlett/lottery-guaranteed-win
from itertools import combinations
from tqdm import tqdm

# Used my own created fano planes to come up with these tickets
tickets = ((1, 2, 3, 26, 27, 28),
			(1, 4, 26, 30, 31, 34),
			(3, 4, 28, 29, 30, 33),
			(2, 4, 5, 27, 30, 32),
			(3, 5, 28, 31, 32, 34),
			(1, 5, 26, 29, 32, 33),
			(2, 27, 29, 31, 33, 34),
			(6, 35, 36, 42, 7, 37),
			(6, 35, 41, 43, 9, 39),
			(7, 37, 8, 38, 9, 39),
			(6, 35, 10, 40, 8, 38),
			(7, 37, 10, 40, 41, 43),
			(9, 39, 10, 40, 36, 42),
			(36, 42, 8, 38, 41, 43),
			(11, 44, 49, 51, 12, 47),
			(11, 44, 14, 45, 13, 46),
			(12, 47, 50, 52, 13, 46),
			(12, 47, 15, 48, 14, 45),
			(11, 44, 15, 48, 50, 52),
			(13, 46, 15, 48, 49, 51),
			(49, 51, 50, 52, 14, 45),
			(16, 53, 17, 54, 18, 55),
			(16, 53, 58, 61, 20, 59),
			(16, 53, 57, 60, 19, 56),
			(18, 55, 57, 60, 58, 61),
			(18, 55, 19, 56, 20, 59),
			(20, 59, 57, 60, 17, 54),
			(17, 54, 19, 56, 58, 61),
			(21, 62, 63, 69, 25, 64),
			(21, 62, 24, 65, 67, 70),
			(21, 62, 22, 68, 23, 66),
			(25, 64, 67, 70, 22, 68),
			(25, 64, 24, 65, 23, 66),
			(23, 66, 67, 70, 63, 69),
			(63, 69, 24, 65, 22, 68))

total_winnings = 0
balls_matched = [0 for i in range(0,7)]
winning_tickets = [0 for i in range(0,36)]
i = 1
for comb in tqdm(combinations(range(1, 71), 6)):
	i += 1
	this_prize_total = 0
	this_winning_tickets = 0
	for ticket in tickets:
		matches = len(set(comb).intersection(ticket))
		if matches > 1: # Caring about 2+ matches per draw
			this_winning_tickets += 1
			balls_matched[matches] += 1
	if this_winning_tickets == 0:
		print(f"Draw {i}: {comb}: This is the first error!")
		break 
	winning_tickets[this_winning_tickets] += 1
print(f"Draw {i}: {comb}: {winning_tickets}, {balls_matched}")