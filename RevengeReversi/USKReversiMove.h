//
//  USKReversiMove.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USKReversiMove : NSObject

@property int row;
@property int column;
@property BOOL validity;
@property BOOL pass;

+ (id)moveWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass;
- (id)initWithRow:(int)row column:(int)column validity:(BOOL)validity pass:(BOOL)pass;

@end
