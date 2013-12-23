//
//  USKReversi.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USKReversiDisk.h"
#import "USKReversiPlayer.h"
#import "USKReversiMove.h"

#define MAX_BOARD_SIZE 20

#define DRAW -1

typedef enum USKReversiRule {
	USKReversiRuleClassic = 0
} USKReversiRule;

@interface USKReversi : NSObject

@property (readonly) int row;
@property (readonly) int column;
@property (readonly) int numberOfPlayers;
@property (readonly) USKReversiRule rule;

@property (readonly) int turn;
@property NSMutableArray *players;
@property (readonly) NSMutableArray *disks;
@property (readonly) BOOL isFinished;
@property (readonly) int attacker;
@property (readonly) int winner;

@property id delegate;


+ (id)reversiWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule;
- (id)initWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule;

/**
 Attempts to place a move at specified square.
 @param row The row index of the move.
 @param column The column index of the move.
 @return If the move is valid, YES will be returned. Otherwise, No will be returned.
 */
- (BOOL)attemptMoveAtRow:(int)row column:(int)column;

/**
 Play pass to the next player.
 */
- (void)pass;

@end


/*
 TODO:
 saveRecord

*/