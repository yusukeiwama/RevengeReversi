//
//  USKReversi.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversi.h"

@implementation USKReversi

@synthesize row, column, numberOfPlayers, rule;
@synthesize turn, scores, states, passCount, gameOver, ability;

+ (id)reversiWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)rl
{
	USKReversi *reversi = [[USKReversi alloc] initWithRow:r column:c numberOfPlayers:n rule:rl];
	
	return reversi;
}

- (id)initWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)rl
{
	if (self = [super init]) {
		row = r;
		column = c;
		numberOfPlayers = n;
		rule = rl;
		
		states = calloc(row * column, sizeof(USKReversiState));
		scores = [NSMutableArray array];
		[scores addObject:@0];
		[scores addObject:@0];
		
		switch (rule) {
			default: // USKReversiRuleClassic
			{
				// 奇数の時は偶数にする処理を追加すべき //
				for (int i = 0; i < row * column; i++) {
					states[i].color = -1;
					states[i].reverseCount = 0;
				}
				states[(row / 2 - 1) * column + (column / 2 - 1)].color = 0;
				states[(row / 2 - 1) * column + (column / 2 - 1)].changed = YES;
				states[(row / 2 - 1) * column + (column / 2)].color = 1;
				states[(row / 2 - 1) * column + (column / 2)].changed = YES;
				states[(row / 2) * column + (column / 2 - 1)].color = 1;
				states[(row / 2) * column + (column / 2 - 1)].changed = YES;
				states[(row / 2) * column + (column / 2)].color = 0;
				states[(row / 2) * column + (column / 2)].changed = YES;
			}
				break;
		}
	}
	[self updateScores];
	
//	[self printState];
	return self;
}

- (void)changeStateWithRow:(int)r column:(int)c
{
	switch (ability) {
		case USKReversiAbilityGrandCross:
		{
			int attackColor = turn % numberOfPlayers;
			scores[attackColor] = [NSNumber numberWithInt:[scores[attackColor] intValue] - 50];
			
			for (int i = 0; i < row; i++) {
				states[i * column + c].color = attackColor;
				states[i * column + c].changed = YES;
				states[i * column + c].reverseCount++;
			}
			for (int j = 0; j < column; j++) {
				states[r * column + j].color = attackColor;
				states[r * column + j].changed = YES;
				states[r * column + j].reverseCount++;
			}
			ability = USKReversiAbilityNone;
			turn++;
			break;
		}
		default:
		{
			// reset changed flags
			for (int i = 0; i < row * column; i++) {
				states[i].changed = NO;
			}
			
			// change states if the place is valid
			if (states[r * column + c].color == -1) {
				int attackColor = turn % numberOfPlayers;
				if ([self reverseWithRow:r column:c attackColor:attackColor]) {
					states[r * column + c].color = attackColor;
					states[r * column + c].changed = YES;
					turn++;
				}
				
				//		[self printState];
			}
		}
			break;
	}
	
	[self updateScores];
//	[self passCheck];
}

//- (void)passCheck
//{
//	int attackColor = turn % numberOfPlayers;
//
//	for (int i = 0; i < row * column; i++) {
//		if ([self checkWithRow:i / column column:i % column attackColor:attackColor]) {
//			return;
//		}
//	}
//	
//	// if there is no available place, increment passCount
//	passCount++;
//	NSLog(@"passCount = %d", passCount);
//	if (passCount >= numberOfPlayers) {
//		gameOver = YES;
//		NSLog(@"The game is over...");
//	}
//}

- (void)updateScores
{
//	[scores removeAllObjects];
//	for (int i = 0; i < numberOfPlayers; i++) {
//		int aScore = 0;
//		for (int j = 0; j < row * column; j++) {
//			if (states[j].color == i) {
//				aScore++;
//			}
//		}
//		NSNumber *aScoreNumber = [NSNumber numberWithInt:aScore];
//		[scores insertObject:aScoreNumber atIndex:i];
//	}
}

- (void)printState
{
	for (int i = 0; i < row; i++) {
		for (int j = 0; j < column; j++) {
			printf("%+d ", states[i * column + j].color);
		}
		printf("\n");
	}
}

- (int)reverseWithRow:(int)r column:(int)c attackColor:(int)color
{
	int attackColor = color;
	int attackerIndex = r * column + c;
	int tempIndex = attackerIndex;
	int hit = 0;
	
	// attack up
	tempIndex = attackerIndex;
	int upperAllyIndex = attackerIndex;
	tempIndex -= column;
	if (0 <= tempIndex) {
		if (states[tempIndex].color != -1) {
			while (0 <= tempIndex) {
				if (states[tempIndex].color == attackColor) {
					upperAllyIndex = tempIndex;
					break;
				} else if (states[tempIndex].color == -1) {
					break;
				}
				tempIndex -= column;
			}
		}
	}
	tempIndex = attackerIndex - column;
	while (upperAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex -= column;
	}
	
	// attack up-right
	tempIndex = attackerIndex - (column - 1);
	int upperRightAllyIndex = attackerIndex;
	if (0 <= tempIndex) {
		if (states[tempIndex].color != -1 && tempIndex % column != column - 1) {
			while (0 <= tempIndex && tempIndex % column != column - 1) {
				if (states[tempIndex].color == attackColor) {
					upperRightAllyIndex = tempIndex;
					break;
				} else if (states[tempIndex].color == -1) {
					break;
				}
				tempIndex -= (column - 1);
			}
		}
	}
	tempIndex = attackerIndex - (column - 1);
	while (upperRightAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex -= (column - 1);
	}
	
	// attack right
	tempIndex = attackerIndex;
	int rightAllyIndex = attackerIndex;
	tempIndex++;
	if (tempIndex < row * column) {
		if (states[tempIndex].color != -1) {
			while (r == tempIndex / column) {
				if (states[tempIndex].color == attackColor) {
					rightAllyIndex = tempIndex;
					break;
				} else if (states[tempIndex].color == -1) {
					break;
				}
				tempIndex++;
			}
		}
	}
	tempIndex = attackerIndex + 1;
	while (tempIndex < rightAllyIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex++;
	}
	
	// attack bottom-right
	tempIndex = attackerIndex + (column + 1);
	int bottomRightAllyIndex = attackerIndex;
	if (states[tempIndex].color != -1 && (tempIndex - (column + 1)) % column != column - 1) {
		while (tempIndex < row * column && tempIndex % column != column - 1) {
			if (states[tempIndex].color == attackColor) {
				bottomRightAllyIndex = tempIndex;
				break;
			} else if (states[tempIndex].color == -1) {
				break;
			}
			tempIndex += (column + 1);
		}
	}
	tempIndex = attackerIndex + (column + 1);
	while (tempIndex < bottomRightAllyIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex += (column + 1);
	}

	
	// attack bottom
	tempIndex = attackerIndex;
	int bottomAllyIndex = attackerIndex;
	tempIndex += column;
	if (states[tempIndex].color != -1) {
		while (tempIndex < row * column) {
			if (states[tempIndex].color == attackColor) {
				bottomAllyIndex = tempIndex;
				break;
			} else if (states[tempIndex].color == -1) {
				break;
			}
			tempIndex += column;
		}
	}
	tempIndex = attackerIndex + column;
	while (tempIndex < bottomAllyIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex += column;
	}
	
	// attack bottom-left
	tempIndex = attackerIndex + (column - 1);
	int bottomLeftAllyIndex = attackerIndex;
	if (states[tempIndex].color != -1 && (tempIndex - (column - 1)) % column != 0) {
		while (tempIndex < row * column && tempIndex % column != 0) {
			if (states[tempIndex].color == attackColor) {
				bottomLeftAllyIndex = tempIndex;
				break;
			} else if (states[tempIndex].color == -1) {
				break;
			}
			tempIndex += (column - 1);
		}
	}
	tempIndex = attackerIndex + (column - 1);
	while (tempIndex < bottomLeftAllyIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex += (column - 1);
	}
	
	// attack left
	tempIndex = attackerIndex;
	int leftAllyIndex = attackerIndex;
	tempIndex--;
	if (states[tempIndex].color != -1) {
		while (r == tempIndex / column && 0 <= tempIndex) {
			if (states[tempIndex].color == attackColor) {
				leftAllyIndex = tempIndex;
				break;
			} else if (states[tempIndex].color == -1) {
				break;
			}
			tempIndex--;
		}
	}
	tempIndex = attackerIndex - 1;
	while (leftAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex--;
	}
	
	// attack top-left
	tempIndex = attackerIndex - (column + 1);
	int topLeftAllyIndex = attackerIndex;
	if (0 <= tempIndex - (column + 1)) {
		if (states[tempIndex - (column + 1)].color != -1 && (tempIndex + (column + 1)) % column != 0) {
			while (0 <= tempIndex && tempIndex % column != 0) {
				if (states[tempIndex].color == attackColor) {
					topLeftAllyIndex = tempIndex;
					break;
				} else if (states[tempIndex].color == -1) {
					break;
				}
				tempIndex -= (column + 1);
			}
		}
	}
	tempIndex = attackerIndex - (column + 1);
	while (topLeftAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		states[tempIndex].changed = YES;
		states[tempIndex].reverseCount++;
		hit++;
		tempIndex -= (column + 1);
	}
	
	return hit;
}
//
//- (int)checkWithRow:(int)r column:(int)c attackColor:(int)color
//{
//	int attackColor = color;
//	int attackerIndex = r * column + c;
//	int tempIndex = attackerIndex;
//	int hit = 0;
//	
//	// attack up
//	tempIndex = attackerIndex;
//	int upperAllyIndex = attackerIndex;
//	tempIndex -= column;
//	if (0 <= tempIndex) {
//		if (states[tempIndex].color != -1) {
//			while (0 <= tempIndex) {
//				if (states[tempIndex].color == attackColor) {
//					upperAllyIndex = tempIndex;
//					break;
//				} else if (states[tempIndex].color == -1) {
//					break;
//				}
//				tempIndex -= column;
//			}
//		}
//	}
//	tempIndex = attackerIndex - column;
//	while (upperAllyIndex < tempIndex) {
//		hit++;
//		tempIndex -= column;
//	}
//	
//	// attack up-right
//	tempIndex = attackerIndex - (column - 1);
//	int upperRightAllyIndex = attackerIndex;
//	if (states[tempIndex].color != -1 && tempIndex % column != column - 1) {
//		while (0 <= tempIndex && tempIndex % column != column - 1) {
//			if (states[tempIndex].color == attackColor) {
//				upperRightAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex -= (column - 1);
//		}
//	}
//	tempIndex = attackerIndex - (column - 1);
//	while (upperRightAllyIndex < tempIndex) {
//		hit++;
//		tempIndex -= (column - 1);
//	}
//	
//	// attack right
//	tempIndex = attackerIndex;
//	int rightAllyIndex = attackerIndex;
//	tempIndex++;
//	if (states[tempIndex].color != -1) {
//		while (r == tempIndex / column) {
//			if (states[tempIndex].color == attackColor) {
//				rightAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex++;
//		}
//	}
//	tempIndex = attackerIndex + 1;
//	while (tempIndex < rightAllyIndex) {
//		hit++;
//		tempIndex++;
//	}
//	
//	// attack bottom-right
//	tempIndex = attackerIndex + (column + 1);
//	int bottomRightAllyIndex = attackerIndex;
//	if (states[tempIndex].color != -1 && (tempIndex - (column + 1)) % column != column - 1) {
//		while (tempIndex < row * column && tempIndex % column != column - 1) {
//			if (states[tempIndex].color == attackColor) {
//				bottomRightAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex += (column + 1);
//		}
//	}
//	tempIndex = attackerIndex + (column + 1);
//	while (tempIndex < bottomRightAllyIndex) {
//		hit++;
//		tempIndex += (column + 1);
//	}
//	
//	
//	// attack bottom
//	tempIndex = attackerIndex;
//	int bottomAllyIndex = attackerIndex;
//	tempIndex += column;
//	if (states[tempIndex].color != -1) {
//		while (tempIndex < row * column) {
//			if (states[tempIndex].color == attackColor) {
//				bottomAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex += column;
//		}
//	}
//	tempIndex = attackerIndex + column;
//	while (tempIndex < bottomAllyIndex) {
//		hit++;
//		tempIndex += column;
//	}
//	
//	// attack bottom-left
//	tempIndex = attackerIndex + (column - 1);
//	int bottomLeftAllyIndex = attackerIndex;
//	if (states[tempIndex].color != -1 && (tempIndex - (column - 1)) % column != 0) {
//		while (tempIndex < row * column && tempIndex % column != 0) {
//			if (states[tempIndex].color == attackColor) {
//				bottomLeftAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex += (column - 1);
//		}
//	}
//	tempIndex = attackerIndex + (column - 1);
//	while (tempIndex < bottomLeftAllyIndex) {
//		hit++;
//		tempIndex += (column - 1);
//	}
//	
//	// attack left
//	tempIndex = attackerIndex;
//	int leftAllyIndex = attackerIndex;
//	tempIndex--;
//	if (states[tempIndex].color != -1) {
//		while (r == tempIndex / column && 0 <= tempIndex) {
//			if (states[tempIndex].color == attackColor) {
//				leftAllyIndex = tempIndex;
//				break;
//			} else if (states[tempIndex].color == -1) {
//				break;
//			}
//			tempIndex--;
//		}
//	}
//	tempIndex = attackerIndex - 1;
//	while (leftAllyIndex < tempIndex) {
//		hit++;
//		tempIndex--;
//	}
//	
//	// attack top-left
//	tempIndex = attackerIndex - (column + 1);
//	int topLeftAllyIndex = attackerIndex;
//	if (0 <= tempIndex - (column + 1)) {
//		if (states[tempIndex - (column + 1)].color != -1 && (tempIndex + (column + 1)) % column != 0) {
//			while (0 <= tempIndex && tempIndex % column != 0) {
//				if (states[tempIndex].color == attackColor) {
//					topLeftAllyIndex = tempIndex;
//					break;
//				} else if (states[tempIndex].color == -1) {
//					break;
//				}
//				tempIndex -= (column + 1);
//			}
//		}
//	}
//	tempIndex = attackerIndex - (column + 1);
//	while (topLeftAllyIndex < tempIndex) {
//		hit++;
//		tempIndex -= (column + 1);
//	}
//	
//	return hit;
//}

- (int)attacker
{
	return turn % numberOfPlayers;
}

- (void)dealloc
{
	free(states);
}

@end
