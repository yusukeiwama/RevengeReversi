//
//  USKReversiMove.m
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKReversiMove.h"

@implementation USKReversiMove

@synthesize row = _row;
@synthesize column = _column;
@synthesize validity = _validity;
@synthesize pass = _pass;

+(id)moveWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass
{
	return [[USKReversiMove alloc] initWithRow:row column:column validity:validity pass:pass];
}

- (id)initWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass
{
	self = [super init];
	
	if (self) {
		_row = row;
		_column = column;
		_validity = validity;
		_pass = pass;
	}
	
	return self;
}

@end
