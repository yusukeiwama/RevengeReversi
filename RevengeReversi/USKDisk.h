//
//  USKDisk.h
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USKDisk : NSObject

/// disk color ... -1:sentinel, 0:none, 1~:playerColor
@property int color;
@property int flipCount;
@property BOOL changed;

@end
