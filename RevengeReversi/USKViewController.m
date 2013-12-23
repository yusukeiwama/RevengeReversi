//
//  USKViewController.m
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "USKReversi.h"

typedef enum USKReversiSkin {
	USKReversiSkinDefault	= 0,
	USKReversiSkinPrecure,
	USKReversiSkinDebug
} USKReversiSkin;

@interface USKViewController () // <USKReversiDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (weak, nonatomic) IBOutlet UILabel *blackScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *player0ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *player1ImageView;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;

@property USKReversi *reversi;
@property NSMutableArray *diskViews;
@property NSArray *players;
@property USKReversiSkin skin;

- (IBAction)functionButtonAction:(id)sender;
- (IBAction)tapAction:(id)sender;

@end

@implementation USKViewController

@synthesize boardImageView = _boardImageView;
@synthesize blackScoreLabel = _blackScoreLabel;
@synthesize whiteScoreLabel = _whiteScoreLabel;
@synthesize helpLabel = _helpLabel;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize reversi = _reversi;
@synthesize diskViews = _diskViews;
@synthesize players = _players;
@synthesize skin = _skin;
@synthesize player0ImageView = _player0ImageView;
@synthesize player1ImageView = _player1ImageView;
@synthesize functionButton = _functionButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_skin = USKReversiSkinDefault;

	switch (_skin) {
		case USKReversiSkinPrecure:
			_players = @[@{@"Name": @"Cure Heart",
						   @"Image": @"cureHeart.jpg"},
						 @{@"Name": @"Cure Sword",
						   @"Image": @"cureSword.jpg"}];
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {	// iPad
				_reversi = [USKReversi reversiWithRow:6 column:6 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			} else { // iPhone
				_reversi = [USKReversi reversiWithRow:4 column:4 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			}
			break;
		case USKReversiSkinDebug:
			_players = @[@{@"Name": @"Red",
						   @"Image": @"diskRed.png"},
						 @{@"Name": @"White",
						   @"Image": @"diskWhite.png"}];
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {	// iPad
				_reversi = [USKReversi reversiWithRow:4 column:4 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			} else { // iPhone
				_reversi = [USKReversi reversiWithRow:4 column:4 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			}
			break;

		default:
			_players = @[@{@"Name": @"Black",
						   @"Image": @"diskBlack.png"},
						 @{@"Name": @"White",
						   @"Image": @"diskWhite.png"}];
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {	// iPad
				_reversi = [USKReversi reversiWithRow:8 column:8 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			} else { // iPhone
				_reversi = [USKReversi reversiWithRow:6 column:6 numberOfPlayers:(int)_players.count rule:USKReversiRuleClassic];
			}
			break;
	}
	
	_player0ImageView.image = [UIImage imageNamed:[(NSDictionary *)self.players[0] objectForKey:@"Image"]];
	_player1ImageView.image = [UIImage imageNamed:[(NSDictionary *)self.players[1] objectForKey:@"Image"]];
	
	_blackScoreLabel.hidden = YES;
	_whiteScoreLabel.hidden = YES;

	[self drawGrid];
	
	// Draw disk views.
	_diskViews = [NSMutableArray array];
	for (int i = 0; i < _reversi.row; i++) {
		NSMutableArray *aRow = [NSMutableArray array];
		for (int j = 0; j < _reversi.column; j++) {
			CGFloat margin = self.boardImageView.frame.size.width / _reversi.column * 0.05;
			CGRect rect = CGRectMake(self.boardImageView.frame.size.width / _reversi.column * j + margin,
									 self.boardImageView.frame.size.height / _reversi.row * i + margin,
									 self.boardImageView.frame.size.width / _reversi.column - 2.0 * margin,
									 self.boardImageView.frame.size.height / _reversi.row - 2.0 * margin);
			UIImageView *aDiskView = [[UIImageView alloc] initWithFrame:rect];
//			aDiskView.label.font = [UIFont fontWithName:@"Futura" size:aDiskView.frame.size.height / 2.0];
			[self.boardImageView addSubview:aDiskView];
			[aRow addObject:aDiskView];
		}
		[_diskViews addObject:aRow];
	}
	
	[self updateBoardView];
	[self updateHelpLabel];
	[self updatePlayerInfoViews];
}

- (void)drawGrid
{
	UIGraphicsBeginImageContextWithOptions((self.boardImageView.frame.size), YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.boardImageView.image drawInRect:CGRectMake(0, 0, self.boardImageView.frame.size.width, self.boardImageView.frame.size.height)];
	CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
	CGContextSetLineWidth(context, 2);
	for (int i = 0; i < _reversi.column + 1; i++) {
		// Draw vertical lines.
		CGContextMoveToPoint(context, self.boardImageView.frame.size.width / _reversi.column * i, 0.0);
		CGContextAddLineToPoint(context, self.boardImageView.frame.size.width / _reversi.column * i, self.boardImageView.frame.size.height);
	}
	for (int i = 0; i < _reversi.row + 1; i++) {
		// Draw horizontal lines.
		CGContextMoveToPoint(context, 0.0, self.boardImageView.frame.size.height / _reversi.row * i);
		CGContextAddLineToPoint(context, self.boardImageView.frame.size.width, self.boardImageView.frame.size.height / _reversi.row * i);
	}
	CGContextStrokePath(context);
	self.boardImageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updatePlayerInfoViews
{
	double duration = 0.3;

	CATransition *transitionAnimation = [CATransition animation];
	[transitionAnimation setType:kCATransitionFade];
	[transitionAnimation setDuration:duration];
	[transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[transitionAnimation setFillMode:kCAFillModeBoth];
//	[self.blackScoreLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
//	[self.whiteScoreLabel.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
//	[self.player0ImageView.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
//	[self.player1ImageView.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];

	double lowAlpha = 0.0;
	switch (self.reversi.attacker) {
		case 0:
			self.player0ImageView.alpha = 1.0;
			self.player1ImageView.alpha = lowAlpha;
			break;
		case 1:
			self.player0ImageView.alpha = lowAlpha;
			self.player1ImageView.alpha = 1.0;
			break;
		default:
			break;
	}
	
	self.blackScoreLabel.text = [NSString stringWithFormat:@"%d", [self.reversi.players[0] occupiedCount]];
	self.whiteScoreLabel.text = [NSString stringWithFormat:@"%d", [self.reversi.players[1] occupiedCount]];
}

- (void)updateHelpLabel
{
	if (self.reversi.isFinished) {
		switch (self.reversi.winner) {
			case 0:
				self.helpLabel.text = [NSString stringWithFormat:@"%@ Won!", [(NSDictionary *)self.players[0] objectForKey:@"Name"]];
				break;
			case 1:
				self.helpLabel.text = [NSString stringWithFormat:@"%@ Won!", [(NSDictionary *)self.players[1] objectForKey:@"Name"]];
				break;
			case DRAW:
				self.helpLabel.text = @"Draw!";
				break;
			default:
				break;
		}
		
		self.player0ImageView.alpha = 1.0;
		self.player1ImageView.alpha = 1.0;
		self.blackScoreLabel.hidden = NO;
		self.whiteScoreLabel.hidden = NO;
		[self.functionButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
		[self.functionButton setTitle:@"New" forState:UIControlStateNormal];
		return;
	}
//	
//	switch (self.reversi.attacker) {
//		case 0:
//			self.helpLabel.text = [NSString stringWithFormat:@"%@'s Turn", [(NSDictionary *)self.players[0] objectForKey:@"Name"]];
//			break;
//		case 1:
//			self.helpLabel.text = [NSString stringWithFormat:@"%@'s Turn", [(NSDictionary *)self.players[1] objectForKey:@"Name"]];
//			break;
//		default:
//			break;
//	}
}

- (void)newGame
{
	[self clearBoard];
	self.reversi = [[USKReversi alloc] initWithRow:self.reversi.row column:self.reversi.column numberOfPlayers:self.players.count rule:self.reversi.rule];
	[self updateBoardView];
	[self updatePlayerInfoViews];
	self.helpLabel.text = @"";
	self.blackScoreLabel.hidden = YES;
	self.whiteScoreLabel.hidden = YES;
	[self.functionButton setBackgroundImage:[UIImage imageNamed:@"diskRed.png"] forState:UIControlStateNormal];
	[self.functionButton setTitle:@"Pass" forState:UIControlStateNormal];
}

- (void)clearBoard
{
	for (int i = 0; i < _reversi.row; i++) {
		for (int j = 0; j < _reversi.column; j++) {
			double duration = 0.3;
			[UIView beginAnimations:@"flipping view" context:nil];
			[UIView setAnimationDuration:duration];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.diskViews[i][j] cache:NO];
			((UIImageView *)self.diskViews[i][j]).image = nil;
			[UIView commitAnimations];
		}
	}
}

- (IBAction)functionButtonAction:(id)sender {
	if (self.reversi.isFinished) {
		[self newGame];
	} else {
		[self.reversi pass];
		NSLog(@"\nTurn %3d: pass (%@ passed)", self.reversi.turn + 1, [(NSDictionary *)self.players[self.reversi.attacker] objectForKey:@"Name"]);
		[self updateBoardView];
		[self updatePlayerInfoViews];
		[self updateHelpLabel];
	}
}

- (IBAction)tapAction:(id)sender {
	UIGestureRecognizer *recognizer = sender;

	CGPoint p = [recognizer locationInView:self.boardImageView];
	int row = p.y / self.boardImageView.frame.size.height * self.reversi.row;
	int column = p.x / self.boardImageView.frame.size.width * self.reversi.column;
	NSLog(@"\nTurn %3d: %c%d (%@ Tapped at (%3.1f, %3.1f) in board view.)", self.reversi.turn + 1, 'a' + column, row + 1, [(NSDictionary *)self.players[self.reversi.attacker] objectForKey:@"Name"], p.x, p.y);
	
	self.view.userInteractionEnabled = NO;
	if ([self.reversi attemptMoveAtRow:row column:column]) {
		[self updateBoardView];
		[self updatePlayerInfoViews];
		[self updateHelpLabel];
	}
	self.view.userInteractionEnabled = YES;
}

- (void)updateBoardView
{
	for (int i = 0; i < _reversi.row; i++) {
		for (int j = 0; j < _reversi.column; j++) {
			if ([self.reversi.disks[i][j] lastChangedTurn] + 1 == self.reversi.turn) {
				double duration = 0.3;
				switch (((USKReversiDisk *)self.reversi.disks[i][j]).playerNumber) {
					case 0:
						[UIView beginAnimations:@"flipping view" context:nil];
						[UIView setAnimationDuration:duration];
						[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
						[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.diskViews[i][j] cache:NO];
						((UIImageView *)self.diskViews[i][j]).image = [UIImage imageNamed:[(NSDictionary *)self.players[0] objectForKey:@"Image"]];
						[UIView commitAnimations];
						break;
						
					case 1:
						[UIView beginAnimations:@"flipping view" context:nil];
						[UIView setAnimationDuration:duration];
						[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
						[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.diskViews[i][j] cache:NO];
						((UIImageView *)self.diskViews[i][j]).image = [UIImage imageNamed:[(NSDictionary *)self.players[1] objectForKey:@"Image"]];
						[UIView commitAnimations];
						break;
						
					default:
						break;
				}
			}
		}
	}
}

@end
