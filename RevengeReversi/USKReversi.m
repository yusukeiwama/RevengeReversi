//
//  USKReversi.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversi.h"

typedef enum USKReversiDirection {
	USKReversiDirectionRight		= 1,
	USKReversiDirectionUpperRight	= 2,
	USKReversiDirectionUpper		= 4,
	USKReversiDirectionUpperLeft	= 8,
	USKReversiDirectionLeft			= 16,
	USKReversiDirectionLowerLeft	= 32,
	USKReversiDirectionLower		= 64,
	USKReversiDirectionLowerRight	= 128
} USKReversiDirection;

@interface USKReversi ()

@property const NSArray *directionsToFlip;

@end

@implementation USKReversi

@synthesize ability;

@synthesize row = _row;
@synthesize column = _column;
@synthesize rule = _rule;
@synthesize numberOfPlayers = _numberOfPlayers;
@synthesize disks = _disks;
@synthesize turn = _turn;
@synthesize players = _players;
@synthesize directionsToFlip = _directionsToFlip;

+ (id)reversiWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule
{
	USKReversi *reversi = [[USKReversi alloc] initWithRow:row column:column numberOfPlayers:numberOfPlayers rule:rule];
	
	return reversi;
}

- (id)initWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule
{
	self = [super init];
	
	if (self) {
		_row = row;
		_column = column;
		_numberOfPlayers = numberOfPlayers;
		_rule = rule;
		
		_turn = 0;
		_directionsToFlip = @[@(USKReversiDirectionRight),
							  @(USKReversiDirectionUpperRight),
							  @(USKReversiDirectionUpper),
							  @(USKReversiDirectionUpperLeft),
							  @(USKReversiDirectionLeft),
							  @(USKReversiDirectionLowerLeft),
							  @(USKReversiDirectionLower),
							  @(USKReversiDirectionLowerRight)];
		
		// Add players.
		_players = [NSMutableArray array];
		for (int i = 0; i < _numberOfPlayers; i++) {
			USKReversiPlayer *aPlayer = [[USKReversiPlayer alloc] init];
			[_players addObject:aPlayer];
		}
		
		// Initialize disks.
		_disks = [NSMutableArray array];
		for (int i = 0; i < _row; i++) {
			NSMutableArray *aRow = [NSMutableArray array];
			for (int j = 0; j < _column; j++) {
				[aRow addObject:[[USKReversiDisk alloc] init]];
			}
			[_disks addObject:aRow];
		}
		
		// Set disks into initial state.
		switch (_rule) {
			default: // USKReversiRuleClassic
			{
				[_disks[_row / 2 - 1][_column / 2 - 1] changeColorTo:0 turn:_turn];
				[_disks[_row / 2 - 1][_column / 2 - 0] changeColorTo:1 turn:_turn];
				[_disks[_row / 2 - 0][_column / 2 - 1] changeColorTo:1 turn:_turn];
				[_disks[_row / 2 - 0][_column / 2 - 0] changeColorTo:0 turn:_turn];
			}
				break;
		}
	}
	
	[self printState];
	[self countOccupiedCells];
	[self numberOfFreeCells];
	
	return self;
}

- (int)rowDeltaToDirection:(USKReversiDirection)direction
{
	switch (direction) {
		case USKReversiDirectionUpperRight:
		case USKReversiDirectionUpper:
		case USKReversiDirectionUpperLeft:
			return -1;
		case USKReversiDirectionLowerLeft:
		case USKReversiDirectionLower:
		case USKReversiDirectionLowerRight:
			return 1;
		default:
			return 0;
	}
}

- (int)columnDeltaToDirection:(USKReversiDirection)direction
{
	switch (direction) {
		case USKReversiDirectionRight:
		case USKReversiDirectionUpperRight:
		case USKReversiDirectionLowerRight:
			return 1;
		case USKReversiDirectionUpperLeft:
		case USKReversiDirectionLeft:
		case USKReversiDirectionLowerLeft:
			return -1;
		default:
			return 0;
	}
}

- (void)countOccupiedCells
{
	for (int p = 0; p < self.numberOfPlayers; p++) {
		((USKReversiPlayer *)self.players[p]).occupiedCount = 0;
	}
	
	for (int p = 0; p < self.numberOfPlayers; p++) {
		for (int i = 0; i < self.row; i++) {
			for (int j = 0; j < self.column; j++) {
				if (((USKReversiDisk *)self.disks[i][j]).playerNumber == p) {
					((USKReversiPlayer *)self.players[p]).occupiedCount++;
				}
			}
		}
	}
	
	[self printNumberOfOccupiedCells];
}

- (void)printNumberOfOccupiedCells
{
	for (int p = 0; p < self.numberOfPlayers; p++) {
		printf("Player%d's number of occupied cells = %d\n", p, ((USKReversiPlayer *)self.players[p]).occupiedCount);
	}
}

- (int)numberOfFreeCells
{
	int count = 0;
	
	for (int i = 0; i < self.row; i++) {
		for (int j = 0; j < self.column; j++) {
			if (((USKReversiDisk *)self.disks[i][j]).playerNumber == -1) {
				count++;
			}
		}
	}
	
	[self printNumberOfFreeCells:count];
	
	return count;
}

- (void)printNumberOfFreeCells:(int)n
{
	printf("Number of free cells = %d\n", n);
}

- (BOOL)isFinished
{
	if ([self numberOfFreeCells] == 0 || [self everyonePasses]) {
		return YES;
	} else {
		return NO;
	}
}

- (int)countPasses
{
	return 0;
}

- (int)numberOfAvailableMovesWithPlayerNumber:(int)player
{
	return 0;
}

- (BOOL)everyonePasses
{
	for (int p = 0; p < self.numberOfPlayers; p++) {
		if ([((USKReversiPlayer *)self.players[p]) isPassing] == NO) {
			return NO;
		}
	}
	
	return YES;
}

- (BOOL)diskIsOnBoardWithRow:(int)row column:(int)column
{
	return ((0 <= row && row < self.row) && (0 <= column && column < self.column));
}

- (int)flipCountWithRow:(int)row column:(int)column player:(int)player direction:(USKReversiDirection)direction
{
	int flipCount = 0;
	
	int rowDelta = [self rowDeltaToDirection:direction];
	int columnDelta = [self columnDeltaToDirection:direction];
	
	int r = row + rowDelta;
	int c = column + columnDelta;

	while ([self diskIsOnBoardWithRow:r column:c]
		   && ((USKReversiDisk *)self.disks[r][c]).playerNumber != player
		   && ((USKReversiDisk *)self.disks[r][c]).playerNumber != -1) {
		r += rowDelta;
		c += columnDelta;
		flipCount++;
	}
	
	if ([self diskIsOnBoardWithRow:r column:c]
		&& ((USKReversiDisk *)self.disks[r][c]).playerNumber == player) {
		return flipCount;
	} else {
		return 0;
	}
}

- (BOOL)moveValidityOnRow:(int)row column:(int)column byPlayer:(int)playerNumber
{
	if ([self diskIsOnBoardWithRow:row column:column] == NO) {
		return NO;
	}
	
	if (((USKReversiDisk *)self.disks[row][column]).playerNumber != -1) {
		return NO;
	}
	
	int flipCount = 0;
	for (NSNumber *aDirection in self.directionsToFlip) {
		USKReversiDirection d = [aDirection intValue];
		flipCount += [self flipCountWithRow:row column:column player:playerNumber direction:d];
	}
	if (flipCount == 0) {
		return NO;
	}
	
	return YES;
}


//- (void)commitFlipWithRow:(int)row column:(int)column playerNumber:(int)playerNumber
//{
//	int flipCount = 0;
//	for (NSNumber *aDirection in self.directionsToFlip) {
//		USKReversiDirection d = [aDirection intValue];
//		flipCount += [self flipCountWithRow:row column:column player:playerNumber direction:d];
//	}
//}

- (void)printState
{
	for (int i = 0; i < self.row; i++) {
		for (int j = 0; j < self.column; j++) {
			printf("%+d ", ((USKReversiDisk *)self.disks[i][j]).playerNumber);
		}
		printf("\n");
	}
}

- (int)attacker
{
	return self.turn % self.numberOfPlayers;
}

- (BOOL)finished
{
	return [self isFinished];
}

- (void)dealloc
{
}

@end
