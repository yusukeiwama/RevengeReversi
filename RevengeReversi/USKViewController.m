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
#import "USKDiskView.h"

@interface USKViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (weak, nonatomic) IBOutlet UILabel *blackScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property USKReversi *reversi;
@property NSMutableArray *diskViews;

- (IBAction)grandCrossButtonAction:(id)sender;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Select proper board size according to user's device.
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {	// iPad
		_reversi = [USKReversi reversiWithRow:8 column:8 numberOfPlayers:2 rule:USKReversiRuleClassic];
	} else { // iPhone
		_reversi = [USKReversi reversiWithRow:6 column:6 numberOfPlayers:2 rule:USKReversiRuleClassic];
	}
	
	// Draw guidelines
	UIGraphicsBeginImageContextWithOptions((self.boardImageView.frame.size), YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.boardImageView.image drawInRect:CGRectMake(0, 0, self.boardImageView.frame.size.width, self.boardImageView.frame.size.height)];
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
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
	
	// Draw disk views.
	_diskViews = [NSMutableArray array];
	for (int i = 0; i < _reversi.row; i++) {
		NSMutableArray *aRow = [NSMutableArray array];
		for (int j = 0; j < _reversi.column; j++) {
			CGFloat margin = self.boardImageView.frame.size.width / _reversi.column * 0.12;
			CGRect rect = CGRectMake(self.boardImageView.frame.size.width / _reversi.column * j + margin,
									 self.boardImageView.frame.size.height / _reversi.row * i + margin,
									 self.boardImageView.frame.size.width / _reversi.column - 2.0 * margin,
									 self.boardImageView.frame.size.height / _reversi.row - 2.0 * margin);
			USKDiskView *aDiskView = [[USKDiskView alloc] initWithFrame:rect];
			aDiskView.backgroundColor = [UIColor clearColor];
			aDiskView.label.textAlignment = NSTextAlignmentCenter;
			aDiskView.label.font = [UIFont fontWithName:@"Futura" size:32.0];
			aDiskView.layer.cornerRadius = aDiskView.frame.size.width / 2.0;
			aDiskView.layer.shadowColor = [[UIColor blackColor] CGColor];
			aDiskView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
			aDiskView.layer.shadowOpacity = 0.7;
			[self.boardImageView addSubview:aDiskView];
			[aRow addObject:aDiskView];
		}
		[_diskViews addObject:aRow];
	}
	
	[self redrawBoard];
	[self updateHelpLabel];
	
	self.boardImageView.userInteractionEnabled = YES;
	self.boardImageView.multipleTouchEnabled = NO;
	
//	blackScoreLabel.transform = CGAffineTransformRotate(blackScoreLabel.transform, M_PI);
	
	[self updateScoreLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScoreLabels
{
	self.blackScoreLabel.text = [NSString stringWithFormat:@"Black: %d", ((USKReversiPlayer *)_reversi.players[0]).score];
	self.whiteScoreLabel.text = [NSString stringWithFormat:@"White: %d", ((USKReversiPlayer *)_reversi.players[1]).score];
}

- (void)redrawBoard
{
	for (int i = 0; i < _reversi.row; i++) {
		for (int j = 0; j < _reversi.column; j++) {
//			if ([self.reversi.disks[i][j] lastChangedTurn] == self.reversi.turn) {
				switch (((USKReversiDisk *)self.reversi.disks[i][j]).playerNumber) {
					case 0:
						[UIView beginAnimations:@"flipping view" context:nil];
						[UIView setAnimationDuration:0.5];
						[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
						[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:((USKDiskView *)self.diskViews[i][j]) cache:YES];
						((USKDiskView *)self.diskViews[i][j]).backgroundColor = [UIColor blackColor];
						((USKDiskView *)self.diskViews[i][j]).label.textColor = [UIColor whiteColor];
//						if (self.reversi.scores.count == 2) {
//							self.reversi.scores[0] = [NSNumber numberWithInt:([self.reversi.scores[0] intValue] + board[i][j].flipCount)];
//						}
						[UIView commitAnimations];
						break;
					case 1:
						[UIView beginAnimations:@"flipping view" context:nil];
						[UIView setAnimationDuration:0.5];
						[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
						[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:((USKDiskView *)self.diskViews[i][j]) cache:YES];
						((USKDiskView *)self.diskViews[i][j]).backgroundColor = [UIColor whiteColor];
						((USKDiskView *)self.diskViews[i][j]).label.textColor = [UIColor blackColor];
//						if (self.reversi.scores.count == 2) {
//							self.reversi.scores[1] = [NSNumber numberWithInt:([self.reversi.scores[1] intValue] + self.reversi.disks[i][j].flipCount)];
//						}
						[UIView commitAnimations];
						break;
					default:
						break;
				}
//				((USKDiskView *)self.diskViews[i][j]).label.text = [NSString stringWithFormat:@"%d", board[i][j].flipCount];
			}
//		}
	}
}

- (void)updateHelpLabel
{
	switch (self.reversi.attacker) {
		case 0:
			self.helpLabel.text = @"Black's Turn";
			break;
		case 1:
			self.helpLabel.text = @"White's Turn";
			break;
		default:
			break;
	}
}

- (IBAction)grandCrossButtonAction:(id)sender {
	_reversi.ability = USKReversiAbilityGrandCross;
}

- (IBAction)tapAction:(id)sender {
	UIGestureRecognizer *recognizer = sender;

	CGPoint p = [recognizer locationInView:self.boardImageView];
	int row = p.y / self.boardImageView.frame.size.height * self.reversi.row;
	int column = p.x / self.boardImageView.frame.size.width * self.reversi.column;
	NSLog(@"INDEX:(%d, %d), COOD:(%3.1f, %3.1f)", row, column, p.x, p.y);
	
	if ([self.reversi validateMoveWithRow:row column:column playerNumber:self.reversi.attacker]) {
		[self.reversi flipFromRow:row column:column playerNumber:self.reversi.attacker];
		[self redrawBoard];
		[self updateHelpLabel];
		[self updateScoreLabels];
	}
}

@end
