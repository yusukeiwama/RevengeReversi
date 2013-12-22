//
//  USKDisk.h
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USKReversiDisk : NSObject

@property (readonly) int playerNumber; // -1:free,
@property (readonly) int flipCount;
@property (readonly) int lastChangedTurn;

- (void)changeColorTo:(int)color turn:(int)turn;

@end
