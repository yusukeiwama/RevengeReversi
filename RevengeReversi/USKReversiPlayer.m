//
//  USKPlayer.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversiPlayer.h"
#import "USKReversiMove.h"

@implementation USKReversiPlayer

@synthesize occupiedCount = _occupiedCount;
@synthesize score = _score;
@synthesize record = _record;

- (id)init
{
    self = [super init];
    if (self) {
        _occupiedCount = 0;
		_score = 0;
		_record = [NSMutableArray array];
    }
    return self;
}

- (int)numberOfValidMoves
{
	int count = 0;
	
	for (int i = 0; i < self.record.count; i++) {
		USKReversiMove *aMove;
		if (aMove.validity == YES) {
			count++;
		}
	}
	
	return count;
}

- (int)numberOfValidMovesWithoutPass
{
	int count = 0;
	
	for (int i = 0; i < self.record.count; i++) {
		USKReversiMove *aMove;
		if (aMove.validity == YES || aMove.pass == NO) {
			count++;
		}
	}
	
	return count;
}

- (int)numberOfInvalidMoves
{
	int count = 0;
	
	for (int i = 0; i < self.record.count; i++) {
		USKReversiMove *aMove;
		if (aMove.validity == NO) {
			count++;
		}
	}
	
	return count;
}

- (BOOL)isPassing
{
	USKReversiMove *lastMove = [self.record lastObject];
	if (lastMove.pass == YES) {
		return YES;
	} else {
		return NO;
	}
}

@end