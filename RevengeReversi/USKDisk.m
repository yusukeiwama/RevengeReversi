//
//  USKDisk.m
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKDisk.h"

@implementation USKDisk

@synthesize color, flipCount, changed;

- (id)init
{
    self = [super init];
    if (self) {
        color = 0;
		flipCount = 0;
		changed = NO;
    }
    return self;
}

@end
