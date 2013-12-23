//
//  USKReversi.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversi.h"

#define FREE -1

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
@synthesize delegate = _delegate;

+ (id)reversiWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule
{
	USKReversi *reversi = [[USKReversi alloc] initWithRow:row column:column numberOfPlayers:numberOfPlayers rule:rule];
	
	return reversi;
}

- (id)initWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule
{
	self = [super init];
	
	if (self) {
		(row > MAX_BOARD_SIZE) ? (_row = MAX_BOARD_SIZE) : (_row = row);
		(column > MAX_BOARD_SIZE) ? (_column = MAX_BOARD_SIZE) : (_column = column);
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
			if (((USKReversiDisk *)self.disks[i][j]).playerNumber == FREE) {
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

- (int)numberOfAvailableMoves
{
	int numberOfAvailableMoves = 0;
	
	for (int i = 0; i < self.row; i++) {
		for (int j = 0; j < self.column; j++) {
			USKReversiMove *aMove = [USKReversiMove moveWithRow:i column:j];
			if ([self validateMove:aMove]) {
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

- (int)flipCountByMove:(USKReversiMove *)move toward:(USKReversiDirection)direction
{
	int flipCount = 0;
	
	int rowDelta = [self rowDeltaToDirection:direction];
	int columnDelta = [self columnDeltaToDirection:direction];
	
	int r = move.row + rowDelta;
	int c = move.column + columnDelta;

	while ([self diskIsOnBoardWithRow:r column:c]
		   && [self.disks[r][c] playerNumber] != self.attacker
		   && [self.disks[r][c] playerNumber] != FREE) {
		r += rowDelta;
		c += columnDelta;
		flipCount++;
	}
	
	if ([self diskIsOnBoardWithRow:r column:c]
		&& ((USKReversiDisk *)self.disks[r][c]).playerNumber == self.attacker) {
		return flipCount;
	} else {
		return 0;
	}
}

- (BOOL)validateMove:(USKReversiMove *)move
{
	if ([self diskIsOnBoardWithRow:move.row column:move.column] == NO) {
		return move.isValid = NO;
	}
	
	if ([self.disks[move.row][move.column] playerNumber] != FREE) {
		return move.isValid = NO;
	}
	
	for (int i = 0; i < self.directionsToFlip.count; i++) {
		if ([self flipCountByMove:move toward:[self.directionsToFlip[i] intValue]]) {
			return move.isValid = YES;
		}
	}

	return move.isValid = NO;
}


- (void)flipByMove:(USKReversiMove *)move toward:(USKReversiDirection)direction
{
	int flipCount = 0;
	flipCount = [self flipCountByMove:move toward:direction];
	
	int rowDelta = [self rowDeltaToDirection:direction];
	int columnDelta = [self columnDeltaToDirection:direction];
	

	for (int i = 1; i <= flipCount; i++) {
		((USKReversiPlayer *)_players[self.attacker]).score += [self.disks[move.row + rowDelta * i][move.column + columnDelta * i] flipCount];
		[self.disks[move.row + rowDelta * i][move.column + columnDelta * i] changeColorTo:self.attacker turn:self.turn];
	}
}

- (void)flipByMove:(USKReversiMove *)move
{
	[((USKReversiDisk *)self.disks[move.row][move.column]) changeColorTo:self.attacker turn:self.turn];
	
	for (int i = 0; i < self.directionsToFlip.count; i++) {
		USKReversiDirection direction = [self.directionsToFlip[i] intValue];
		[self flipByMove:move toward:direction];
	}
	
	[self countOccupiedCells];
	
	_turn++;
	
	if ([self numberOfAvailableMoves] == 0) {
		_turn++;
	}
	
	[self printBoard];
}

- (void)printBoard
{
	for (int i = 0; i < self.row; i++) {
		if (i == 0) { // print column characters
			printf("  ");
			for (int j = 0; j < self.column; j++) {
				printf(" %c", 'a' + j);
			}
			printf("\n");
		}
		printf("%2d ", i + 1);
		for (int j = 0; j < self.column; j++) {
			if ([self.disks[i][j] playerNumber] == FREE) {
				printf("- ");
			} else {
				printf("%d ", [self.disks[i][j] playerNumber]);
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
			int winner;
			for (int i = 0; i < self.players.count; i++) {
				if (maxOccupiedCells < [self.players[i] occupiedCount]) {
					maxOccupiedCells = [self.players[i] occupiedCount];
					winner = i;
				}
			}
			return winner;
		}
	}
}

- (BOOL)attemptMoveAtRow:(int)row column:(int)column
{
	USKReversiMove *move = [USKReversiMove moveWithRow:row column:column];
	
	if ([self validateMove:move]) {
		[self flipByMove:move];
		[[_players[self.attacker] record] addObject:move];
		return YES;
	} else {
		[[_players[self.attacker] record] addObject:move];
		return NO;
	}
}

- (void)pass
{
	USKReversiMove *pass = [USKReversiMove pass];
	
	[[_players[self.attacker] record] addObject:pass];
	
	_turn++;
}

@end
