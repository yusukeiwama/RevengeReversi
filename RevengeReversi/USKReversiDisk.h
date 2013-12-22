//
//  USKDisk.h
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USKReversiDisk : NSObject

@property int playerNumber; // -1:free,
@property int flipCount;
@property int lastChangedTurn;

- (void)changeColorTo:(int)color turn:(int)turn;

@end
