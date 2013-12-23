//
//  USKReversiMove.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USKReversiMove : NSObject

@property (readonly) int row;
@property (readonly) int column;
@property BOOL isValid;
@property BOOL isPass;

+ (id)moveWithRow:(int)row column:(int)column;
- (id)initWithRow:(int)row column:(int)column;

+ (id)pass;

+ (id)moveWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass;
- (id)initWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass;

@end
