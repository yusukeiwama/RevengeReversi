//
//  USKPlayer.h
//  RevengeReversi
//
//  Created by Yusuke Iwama on 12/22/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum USKReversiAbility {
	USKReversiAbilityNone = 0,
	USKReversiAbilityGrandCross
} USKReversiAbility;


/**
 Each player has their special ability.
 */
@interface USKReversiPlayer : NSObject

@property int occupiedCount;
@property int score;
@property NSMutableArray *record;

- (int)numberOfValidMoves;
- (int)numberOfValidMovesWithoutPass;
- (int)numberOfInvalidMoves;
- (BOOL)isPassing;

@end

/*
 キャラごとに違う能力を
 ・3ターン後に決着
 ・トーラスフリップ（境界を無効化）
 ・トランスレーション（平行移動）
 ・トランスポーズ（転置）
 ・グランドクロス（ルークスラッシュ＋オーバーライド）
 ・ナイトシュート
 ・キングスタンプ
 ・ルークスラッシュ
 ・ランダムレイン（ランダムに色変化）
 ・オーバーライド（既にあるセル上にディスクを置く）
 ・フラット（裏返り数を平均化）
 ・ヴォイド（特定ディスクの裏返り数をゼロ化）
 ・レボリューション（裏返り数が反転）
*/