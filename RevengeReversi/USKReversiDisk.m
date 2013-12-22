//
//  USKDisk.m
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversiDisk.h"

@implementation USKReversiDisk

@synthesize playerNumber = _playerNumber;
@synthesize flipCount = _flipCount;
@synthesize lastChangedTurn = _lastChangedTurn;

- (id)init
{
    self = [super init];
    if (self) {
        _playerNumber = -1; // no disk
		_flipCount = 0;
		_lastChangedTurn = 0;
    }
    return self;
}

- (void)changeColorTo:(int)color turn:(int)turn
{
	self.playerNumber = color;
	self.lastChangedTurn = turn;
}

@end
