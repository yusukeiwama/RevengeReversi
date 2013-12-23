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

 能力を体系化
 ・時間系（独立）
	・タイムマシン（1手戻す）
	・クイック（2回攻撃）
	・フェイト（3ターン後に決着）
 
 ・重ね打ち系（塗りつぶし系の上位）
	・オーバーライド（既にあるセル上にディスクを置く）
	・グランドクロス（ルークスラッシュ＋オーバーライド）＝塗りつぶし系
 
 ・塗りつぶし系
	・キングスタンプ（隣接8方向を攻撃）
	・ルークスラッシュ（飛車の方向を攻撃）
	・エックス（角の方向を攻撃）
	・クロス（隣接4方向を攻撃）
	・ランダムレイン（ランダムに色変化）
	・ホーリーナイトシュート（桂馬の位置を攻撃）＝位置変化系

 ・位置変化系（ほぼ独立）
 	・ナイトシュート（桂馬の位置8方向を挟める）
	・トーラス（境界を無効化）
	・トランスレーション（平行移動）
	・トランスポーズ（転置）
	・ローテーション（回転）
	・エキスパンド（フィールドが拡大）
	・ペネトレーション（自ディスクを1つ貫通して裏返せる）

 ・重み作用系
	・フラット（裏返り数を平均化）
	・ヴォイド（特定ディスクの裏返り数をゼロ化）
	・レボリューション（裏返り数が反転）
	・インフレーション（ディスクの重みを倍にする）
	・デフレーション（ディスクの重みを半分にする）
	・スタグフレーション（相手ディスクの重みを倍にして、自ディスクの重みを半分にする）
	・バブル（相手ディスクの重みを半分にして、自ディスクの重みを倍にする）
 
 ・消去系
	・ホライゾン（1行消去）
	・バーティカル（1列消去）
	・キャビティ（特定のディスクを消去）
 
 ・防御系
	・アブソリュート（裏返せないディスクを作る）
 
 ・阻害系
	・ソロ（置けるが裏返せない）
	・サドンデス（ランダムな4方向の攻撃が不能になる）
	・チャーム（相手の色を置かなくてはいけない）
	・パスエージョン（指定された場所にしか置けない）
 
*/