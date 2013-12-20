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
@synthesize turn, scores, states;

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
		
		switch (rule) {
			default: // USKReversiRuleClassic
			{
				// 奇数の時は偶数にする処理を追加すべき //
				for (int i = 0; i < row * column; i++) {
					states[i].color = -1;
					states[i].reverseCount = 0;
				}
				states[(row / 2 - 1) * column + (column / 2 - 1)].color = 0;
				states[(row / 2 - 1) * column + (column / 2)].color = 1;
				states[(row / 2) * column + (column / 2 - 1)].color = 1;
				states[(row / 2) * column + (column / 2)].color = 0;
			}
				break;
		}
	}
	
	[self printState];
	return self;
}

- (void)changeStateWithRow:(int)r column:(int)c
{
	if (states[r * column + c].color == -1) {
		int attackColor = turn % numberOfPlayers;
		int hit = [self reverseWithRow:r column:c attackColor:attackColor];
		if (hit > 0) {
			states[r * column + c].color = attackColor;
			turn++;
		}
		
		[self printState];
	}
}

- (void)printState
{
//	for (int i = 0; i < row; i++) {
//		for (int j = 0; j < column; j++) {
//			printf("%+d ", states[i * column + j].color);
//		}
//		printf("\n");
//	}
}

- (int)reverseWithRow:(int)r column:(int)c attackColor:(int)color
{
	int attackColor = color;
	int attackerIndex = r * column + c;
	int tempIndex = attackerIndex;
	int hit = 0;
	
	// attack up
	tempIndex = attackerIndex;
	int upperAllyIndex = tempIndex;
	tempIndex -= column;
	if (states[tempIndex].color != -1) {
		while (0 <= tempIndex) {
			if (states[tempIndex].color == attackColor) {
				upperAllyIndex = tempIndex;
				break;
			}
			tempIndex -= column;
		}
	}
	tempIndex = attackerIndex - column;
	while (upperAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		hit++;
		tempIndex -= column;
	}
	
	// attack up-right
	tempIndex = attackerIndex;
	int upperRightAllyIndex = tempIndex;
	if (states[tempIndex].color != -1) {
		while (0 <= tempIndex && tempIndex % column != column - 1) {
			if (states[tempIndex].color == attackColor) {
				upperRightAllyIndex = tempIndex;
				break;
			}
			tempIndex -= (column - 1);
		}
	}
	tempIndex = attackerIndex - (column - 1);
	while (upperRightAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		hit++;
		tempIndex -= (column - 1);
	}
	
	// attack right
	tempIndex = attackerIndex;
	int rightAllyIndex = tempIndex;
	tempIndex++;
	if (states[tempIndex].color != -1) {
		while (r == tempIndex / column) {
			if (states[tempIndex].color == attackColor) {
				rightAllyIndex = tempIndex;
				break;
			}
			tempIndex++;
		}
	}
	tempIndex = attackerIndex + 1;
	while (tempIndex < rightAllyIndex) {
		states[tempIndex].color = attackColor;
		hit++;
		tempIndex++;
	}
	
	// attack bottom
	tempIndex = attackerIndex;
	int bottomAllyIndex = tempIndex;
	tempIndex += column;
	if (states[tempIndex].color != -1) {
		while (tempIndex < row * column) {
			if (states[tempIndex].color == attackColor) {
				bottomAllyIndex = tempIndex;
				break;
			}
			tempIndex += column;
		}
	}
	tempIndex = attackerIndex + column;
	while (tempIndex < bottomAllyIndex) {
		states[tempIndex].color = attackColor;
		hit++;
		tempIndex += column;
	}
	
	// attack left
	tempIndex = attackerIndex;
	int leftAllyIndex = tempIndex;
	tempIndex--;
	if (states[tempIndex].color != -1) {
		while (r == tempIndex / column && 0 <= tempIndex) {
			if (states[tempIndex].color == attackColor) {
				leftAllyIndex = tempIndex;
				break;
			}
			tempIndex--;
		}
	}
	tempIndex = attackerIndex - 1;
	while (leftAllyIndex < tempIndex) {
		states[tempIndex].color = attackColor;
		hit++;
		tempIndex--;
	}
	
	return hit;
}

- (void)dealloc
{
	free(states);
}

@end
