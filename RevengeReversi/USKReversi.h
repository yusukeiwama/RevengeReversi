//
//  USKReversi.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum USKReversiAbility {
	USKReversiAbilityNone = 0,
	USKReversiAbilityGrandCross
} USKReversiAbility;

typedef enum USKReversiRule {
	USKReversiRuleClassic = 0
} USKReversiRule;

typedef struct USKDiskState {
	int color; // cell color. -1:sentinel, 0:none, 1~:playerColor
	BOOL changed;
	int reverseCount; // how many times the cell was reversed
} USKDiskState;

@interface USKReversi : NSObject

@property (readonly) int row;
@property (readonly) int column;
@property (readonly) int numberOfPlayers;
@property (readonly) USKReversiRule rule;

@property (readonly) int turn;
@property USKReversiAbility ability;
@property (readonly) NSMutableArray *scores;
@property (readonly) int passCount; // if passCount become equal to numberOfPlayers, the game will be over.
@property (readonly) BOOL gameOver;

+ (id)reversiWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)r;
- (id)initWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)r;
- (void)changeStateWithRow:(int)r column:(int)c;
- (int)attacker;


@end
