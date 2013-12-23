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

typedef enum USKReversiRule {
	USKReversiRuleClassic = 0
} USKReversiRule;

//@protocol USKReversiDelegate <NSObject>
//
//- (void)updateBoardView;
//
//@end


@interface USKReversi : NSObject

@property (readonly) int row;
@property (readonly) int column;
@property (readonly) int numberOfPlayers;
@property (readonly) USKReversiRule rule;

@property (readonly) int turn;
@property USKReversiAbility ability;
@property (readonly) NSMutableArray *players;
@property (readonly) NSMutableArray *disks;
@property (readonly) BOOL finished;
@property (readonly) int attacker;
@property (readonly) int winner;

@property id delegate;


+ (id)reversiWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule;
- (id)initWithRow:(int)row column:(int)column numberOfPlayers:(int)numberOfPlayers rule:(USKReversiRule)rule;

- (BOOL)attemptMoveAtRow:(int)row column:(int)column;
- (void)pass;

@end


/*
 TODO:
 saveRecord

*/