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
@synthesize winner = _winner;

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
				[_disks[_row / 2 - 1][_column / 2 - 1] changeColorTo:1 turn:_turn - 1];
				[_disks[_row / 2 - 1][_column / 2 - 0] changeColorTo:0 turn:_turn - 1];
				[_disks[_row / 2 - 0][_column / 2 - 1] changeColorTo:0 turn:_turn - 1];
				[_disks[_row / 2 - 0][_column / 2 - 0] changeColorTo:1 turn:_turn - 1];
			}
				break;
		}
	}
	
	[self printBoard];
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

- (int)numberOfAvailableMovesWithPlayerNumber:(int)player
{
	int numberOfAvailableMoves = 0;
	
	for (int i = 0; i < self.row; i++) {
		for (int j = 0; j < self.column; j++) {
			if ([self validateMoveWithRow:i column:j playerNumber:player]) {
				numberOfAvailableMoves++;
			}
		}
	}
	
	return numberOfAvailableMoves;
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

- (int)flipCountFromRow:(int)row column:(int)column toward:(USKReversiDirection)direction playerNumber:(int)playerNumber
{
	int flipCount = 0;
	
	int rowDelta = [self rowDeltaToDirection:direction];
	int columnDelta = [self columnDeltaToDirection:direction];
	
	int r = row + rowDelta;
	int c = column + columnDelta;

	while ([self diskIsOnBoardWithRow:r column:c]
		   && ((USKReversiDisk *)self.disks[r][c]).playerNumber != playerNumber
		   && ((USKReversiDisk *)self.disks[r][c]).playerNumber != -1) {
		r += rowDelta;
		c += columnDelta;
		flipCount++;
	}
	
	if ([self diskIsOnBoardWithRow:r column:c]
		&& ((USKReversiDisk *)self.disks[r][c]).playerNumber == playerNumber) {
		return flipCount;
	} else {
		return 0;
	}
}

- (BOOL)validateMoveWithRow:(int)row column:(int)column playerNumber:(int)playerNumber
{
	if ([self diskIsOnBoardWithRow:row column:column] == NO) {
		return NO;
	}
	
	if (((USKReversiDisk *)self.disks[row][column]).playerNumber != -1) {
		return NO;
	}
	
	for (int i = 0; i < self.directionsToFlip.count; i++) {
		USKReversiDirection direction = [self.directionsToFlip[i] intValue];
		if ([self flipCountFromRow:row column:column toward:direction playerNumber:playerNumber]) {
			return YES;
		}
	}

	return NO;
}


- (void)flipFromRow:(int)row column:(int)column toward:(USKReversiDirection)direction playerNumber:(int)playerNumber
{
	int flipCount = 0;
	flipCount = [self flipCountFromRow:row column:column toward:direction playerNumber:playerNumber];
	
	int rowDelta = [self rowDeltaToDirection:direction];
	int columnDelta = [self columnDeltaToDirection:direction];
	
	for (int i = 1; i <= flipCount; i++) {
		[((USKReversiDisk *)self.disks[row + rowDelta * i][column + columnDelta * i]) changeColorTo:playerNumber turn:self.turn];
	}
}

- (void)flipFromRow:(int)row column:(int)column playerNumber:(int)playerNumber
{
	[((USKReversiDisk *)self.disks[row][column]) changeColorTo:playerNumber turn:self.turn];
	
	for (int i = 0; i < self.directionsToFlip.count; i++) {
		USKReversiDirection direction = [self.directionsToFlip[i] intValue];
		[self flipFromRow:row column:column toward:direction playerNumber:playerNumber];
	}
	
	[self countOccupiedCells];
	
	_turn++;
	
	if ([self numberOfAvailableMovesWithPlayerNumber:self.attacker] == 0) {
		_turn++;
	}

	
	[self printBoard];
}

- (void)printBoard
{
	for (int i = 0; i < self.row; i++) {
		if (i == 0) {
			printf(" ");
			for (int j = 0; j < self.column; j++) {
				printf(" %c", 'a' + j);
			}
			printf("\n");
		}
		printf("%d ", i + 1);
		for (int j = 0; j < self.column; j++) {
			if (((USKReversiDisk *)self.disks[i][j]).playerNumber == -1) {
				printf("- ");
			} else {
				printf("%d ", ((USKReversiDisk *)self.disks[i][j]).playerNumber);
			}
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

- (int)winner
{
	switch (self.rule) {
		default:
		{
			int maxOccupiedCells = 0;
			int winner = -1;
			for (int i = 0; i < self.players.count; i++) {
				if (maxOccupiedCells < ((USKReversiPlayer *)self.players[i]).occupiedCount) {
					maxOccupiedCells = ((USKReversiPlayer *)self.players[i]).occupiedCount;
					winner = i;
				}
			}
			return winner;
		}
	}
}

@end
