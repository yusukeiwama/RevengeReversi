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
@synthesize isValid = _isValid;
@synthesize isPass = _isPass;

+ (id)moveWithRow:(int)row column:(int)column
{
	return [[USKReversiMove alloc] initWithRow:row column:column];
}

- (id)initWithRow:(int)row column:(int)column
{
	self = [super init];
	
	if (self) {
		_row = row;
		_column = column;
	}
	
	return self;
}

+ (id)pass
{
	USKReversiMove *passMove = [[USKReversiMove alloc] initWithRow:-1 column:-1];
	passMove.isValid = YES;
	passMove.isPass = YES;
	
	return passMove;
}

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
		_isValid = validity;
		_isPass = pass;
	}
	
	return self;
}

@end
