//
//  USKReversi.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum USKReversiRule{
	USKReversiRuleClassic = 0
} USKReversiRule;

typedef struct USKReversiState {
	int reverseCount; // how many times the cell was reversed
	int color; // cell color
} USKReversiState;

@interface USKReversi : NSObject

@property (readonly) int row;
@property (readonly) int column;
@property (readonly) int numberOfPlayers;
@property (readonly) USKReversiRule rule;

@property (readonly) int turn;
@property (readonly) NSMutableArray *scores;
@property (readonly) USKReversiState *states;

+ (id)reversiWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)r;
- (id)initWithRow:(int)r column:(int)c numberOfPlayers:(int)n rule:(USKReversiRule)r;
- (void)changeStateWithRow:(int)r column:(int)c;

@end
