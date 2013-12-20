//
//  USKViewController.m
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKViewController.h"
#import "USKReversi.h"
#import <QuartzCore/QuartzCore.h>
#import "USKDiskView.h"

@interface USKViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *boardImageView;
@property (weak, nonatomic) IBOutlet UILabel *blackScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)grandCrossButtonAction:(id)sender;

@end

@implementation USKViewController {
	USKReversi *reversi;
	NSMutableArray *reverseLabels;
}

@synthesize boardImageView;
@synthesize blackScoreLabel;
@synthesize whiteScoreLabel;
@synthesize helpLabel;
@synthesize backgroundImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	reversi = [USKReversi reversiWithRow:8 column:8 numberOfPlayers:2 rule:USKReversiRuleClassic];
	reverseLabels = [NSMutableArray array];
	[self drawBoard];
	[self redrawBoard];
	[self updateHelpLabel];
	
	boardImageView.userInteractionEnabled = YES;
	boardImageView.multipleTouchEnabled = NO;
	
//	blackScoreLabel.transform = CGAffineTransformRotate(blackScoreLabel.transform, M_PI);
	
	[self updateScoreLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawBoard
{
	// Draw guidelines
	UIGraphicsBeginImageContextWithOptions((boardImageView.frame.size), YES, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[boardImageView.image drawInRect:CGRectMake(0, 0, boardImageView.frame.size.width, boardImageView.frame.size.height)];
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetLineWidth(context, 2);
	for (int i = 0; i < 9; i++) {
		// Draw vertical lines.
		CGContextMoveToPoint(context, boardImageView.frame.size.width / 8.0 * i, 0.0);
		CGContextAddLineToPoint(context, boardImageView.frame.size.width / 8.0 * i, boardImageView.frame.size.height);
		
		// Draw horizontal lines.
		CGContextMoveToPoint(context, 0.0, boardImageView.frame.size.height / 8.0 * i);
		CGContextAddLineToPoint(context, boardImageView.frame.size.width, boardImageView.frame.size.height / 8.0 * i);
	}
	CGContextStrokePath(context);
	boardImageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
		
	for (int i = 0; i < reversi.row; i++) {
		for (int j = 0; j < reversi.column; j++) {
			CGFloat margin = boardImageView.frame.size.width / reversi.column * 0.12;
			CGRect rect = CGRectMake(boardImageView.frame.size.width / reversi.column * j + margin,
									 boardImageView.frame.size.height / reversi.row * i + margin,
									 boardImageView.frame.size.width / reversi.column - 2.0 * margin,
									 boardImageView.frame.size.height / reversi.row - 2.0 * margin);
			USKDiskView *aDiskView = [[USKDiskView alloc] initWithFrame:rect];
			aDiskView.backgroundColor = [UIColor clearColor];
			aDiskView.label.textColor = [UIColor clearColor];
			aDiskView.tag = 0;
			aDiskView.label.text = [NSString stringWithFormat:@"%d", aDiskView.tag];
			aDiskView.label.textAlignment = NSTextAlignmentCenter;
			aDiskView.label.font = [UIFont fontWithName:@"Futura" size:32.0];
			aDiskView.layer.cornerRadius = aDiskView.frame.size.width / 2.0;
//			aDiskView.layer.shadowColor = [[UIColor blackColor] CGColor];
//			aDiskView.layer.shadowOffset = CGSizeMake(2.0, 2.0);
//			aDiskView.layer.shadowOpacity = 0.7;
			[boardImageView addSubview:aDiskView];
			[reverseLabels addObject:aDiskView];
		}
	}
}

- (void)updateScoreLabels
{
	blackScoreLabel.text = [NSString stringWithFormat:@"Black: %d", [(NSNumber *)reversi.scores[0] intValue]];
	whiteScoreLabel.text = [NSString stringWithFormat:@"White: %d", [(NSNumber *)reversi.scores[1] intValue]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint p = [[touches anyObject] locationInView:boardImageView];
	int row = p.y / boardImageView.frame.size.height * reversi.row;
	int column = p.x / boardImageView.frame.size.width * reversi.column;
	NSLog(@"INDEX:(%d, %d), COOD:(%3.1f, %3.1f)", row, column, p.x, p.y);

	[reversi changeStateWithRow:row column:column];
	[self redrawBoard];
	[self updateHelpLabel];
	[self updateScoreLabels];
}

- (void)redrawBoard
{
	for (int i = 0; i < reversi.row * reversi.column; i++) {
		if (reversi.states[i].changed == YES) {
			switch (reversi.states[i].color) {
				case 0:
					[UIView beginAnimations:@"flipping view" context:nil];
					[UIView setAnimationDuration:0.5];
					[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
					[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:((UILabel *)reverseLabels[i]) cache:YES];
					((USKDiskView *)reverseLabels[i]).backgroundColor = [UIColor blackColor];
					((USKDiskView *)reverseLabels[i]).label.textColor = [UIColor whiteColor];
					if (reversi.scores.count == 2) {
						reversi.scores[0] = [NSNumber numberWithInt:([reversi.scores[0] intValue] + reversi.states[i].reverseCount)];
					}
					[UIView commitAnimations];
					break;
				case 1:
					[UIView beginAnimations:@"flipping view" context:nil];
					[UIView setAnimationDuration:0.5];
					[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
					[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:((UILabel *)reverseLabels[i]) cache:YES];
					((USKDiskView *)reverseLabels[i]).backgroundColor = [UIColor whiteColor];
					((USKDiskView *)reverseLabels[i]).label.textColor = [UIColor blackColor];
					if (reversi.scores.count == 2) {
						reversi.scores[1] = [NSNumber numberWithInt:([reversi.scores[1] intValue] + reversi.states[i].reverseCount)];
					}
					[UIView commitAnimations];
					break;
				default:
					break;
			}
			((USKDiskView *)reverseLabels[i]).label.text = [NSString stringWithFormat:@"%d", reversi.states[i].reverseCount];
		}
	}
}

- (void)updateHelpLabel
{
	switch ([reversi attacker]) {
		case 0:
			helpLabel.text = @"Black's Turn";
			break;
		case 1:
			helpLabel.text = @"White's Turn";
			break;
		default:
			break;
	}
}



- (IBAction)grandCrossButtonAction:(id)sender {
	reversi.ability = USKReversiAbilityGrandCross;
}

@end
