//
//  USKReversi.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversi.h"

#define aite(player) (3-(player))

#define MAX_BOARD_SIZE 20

static USKDiskState board[MAX_BOARD_SIZE][MAX_BOARD_SIZE];

@implementation USKReversi {
	int row2;
	int col2;
}

@synthesize row, column, numberOfPlayers, rule;
@synthesize turn, scores, passCount, gameOver, ability;


+ (id)reversiWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)rl
{
	USKReversi *reversi = [[USKReversi alloc] initWithRow:r column:c numberOfPlayers:n rule:rl];
	
	return reversi;
}

- (id)initWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)rl
{
	if (self = [super init]) {
		row = r;
		row2 = r + 2;
		column = c;
		col2 = column + 2;
		numberOfPlayers = n;
		rule = rl;
		
		scores = [NSMutableArray array];
		[scores addObject:@0];
		[scores addObject:@0];
		
		switch (rule) {
			default: // USKReversiRuleClassic
			{
				// 3-step initialization
				// initialize board with sentinel (1/3)
				for (int i = 0; i < row2; i++) {
					for (int j = 0; j < col2; j++) {
						board[i][j].color = -1;
						board[i][j].changed = NO;
					}
				}
				
				// initialize board with none except for edges (2/3)
				for (int i = 1; i <= r; i++) {
					for (int j = 1; j <= c; j++) {
						board[i][j].color = 0;
					}
				}
				// initialize central disks (3/3)
				board[row2 / 2 - 1][col2 / 2 - 1].color = 1;
				board[row2 / 2 - 1][col2 / 2 - 1].changed = YES;
				board[row2 / 2 - 1][col2 / 2].color = 2;
				board[row2 / 2 - 1][col2 / 2].changed = YES;
				board[row2 / 2][col2 / 2 - 1].color = 2;
				board[row2 / 2][col2 / 2 - 1].changed = YES;
				board[row2 / 2][col2 / 2].color = 1;
				board[row2 / 2][col2 / 2].changed = YES;
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
//		case USKReversiAbilityGrandCross:
//		{
//			int attackColor = turn % numberOfPlayers;
//			scores[attackColor] = [NSNumber numberWithInt:[scores[attackColor] intValue] - 50];
//			
//			for (int i = 0; i < row; i++) {
//				states[i * column + c].color = attackColor;
//				states[i * column + c].changed = YES;
//				states[i * column + c].reverseCount++;
//			}
//			for (int j = 0; j < column; j++) {
//				states[r * column + j].color = attackColor;
//				states[r * column + j].changed = YES;
//				states[r * column + j].reverseCount++;
//			}
//			ability = USKReversiAbilityNone;
//			turn++;
//			break;
//		}
		default:
		{
			// reset changed flags
			for (int i = 1; i <= row; i++) {
				for (int j = 1; j <= column; j++) {
					board[i][j].changed = NO;
				}
			}
			
			// change states if the place is valid
			int attacker = turn % numberOfPlayers;
			if ([self isValidMoveWithRow:r column:c player:attacker]) {
				[self flipWithRow:r column:c attackColor:attacker];
				turn++;
			}
			break;
		}
	}
	
	[self updateScores];
//	[self passCheck];
}

int flip(int player, int p, int q, int d, int e)
{
    int i;
    
    for (i = 1; board[p+i*d][q+i*e].color == aite(player); i++) {};
    
    if (board[p+i*d][q+i*e].color == player) {
        return i-1;
    } else {
        return 0;
    }
}

- (BOOL)isValidMoveWithRow:(int)r column:(int)c player:(int)p
{
	if (r < 1 || r > 8 || c < 1 || c > 8) return 0;
    if (board[r][c].color != 0) return 0;
    if (flip(p, r, c, -1,  0)) return 1;  /* 上 */
    if (flip(p, r, c,  1,  0)) return 1;  /* 下 */
    if (flip(p, r, c,  0, -1)) return 1;  /* 左 */
    if (flip(p, r, c,  0,  1)) return 1;  /* 右 */
    if (flip(p, r, c, -1, -1)) return 1;  /* 左上 */
    if (flip(p, r, c, -1,  1)) return 1;  /* 右上 */
    if (flip(p, r, c,  1, -1)) return 1;  /* 左下 */
    if (flip(p, r, c,  1,  1)) return 1;  /* 右下 */
	return NO;
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
	for (int i = 1; i <= row; i++) {
		for (int j = 1; j <= column; j++) {
			printf("%d ", board[i][j].color);
		}
		printf("\n");
	}
}

- (void)flipWithRow:(int)r column:(int)c attackColor:(int)color
{
	int attackColor = color;
	int attackerIndex = r * column + c;
	int tempIndex = attackerIndex;
	int hit = 0;
	

}

- (int)attacker
{
	return turn % numberOfPlayers;
}

- (void)dealloc
{
}

@end
