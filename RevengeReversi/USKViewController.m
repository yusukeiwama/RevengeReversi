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

@interface USKViewController ()

@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UILabel *blackScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteScoreLabel;

@end

@implementation USKViewController {
	USKReversi *reversi;
	NSMutableArray *reverseLabels;
	UIColor *boardColor;
}

@synthesize boardView;
@synthesize blackScoreLabel;
@synthesize whiteScoreLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	reversi = [USKReversi reversiWithRow:8 column:8 numberOfPlayers:2 rule:USKReversiRuleClassic];
	reverseLabels = [NSMutableArray array];
	boardColor = [UIColor colorWithHue:0.4 saturation:1.0 brightness:0.3 alpha:1.0];
	[self drawBoard];
	[self redrawBoard];
	
	boardView.userInteractionEnabled = YES;
	boardView.multipleTouchEnabled = NO;
	
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
//	UIGraphicsBeginImageContextWithOptions((boardView.frame.size), YES, 0);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
//	CGContextSetLineWidth(context, 0.5);
//	for (int i = 0; i < 9; i++) {
//		// Draw vertical lines.
//		CGContextMoveToPoint(context, boardView.frame.size.width / 8.0 * i, 0.0);
//		CGContextAddLineToPoint(context, boardView.frame.size.width / 8.0 * i, boardView.frame.size.height);
//		
//		// Draw horizontal lines.
//		CGContextMoveToPoint(context, 0.0, boardView.frame.size.height / 8.0 * i);
//		CGContextAddLineToPoint(context, boardView.frame.size.width, boardView.frame.size.height / 8.0 * i);
//	}
//	CGContextStrokePath(context);
//	boardView.image = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
	
	boardView.backgroundColor = boardColor;
	
	for (int i = 0; i < reversi.row; i++) {
		for (int j = 0; j < reversi.column; j++) {
			CGRect rect = CGRectMake(boardView.frame.size.width / reversi.column * j + 0.5,
									 boardView.frame.size.height / reversi.row * i + 0.5,
									 boardView.frame.size.width / reversi.column - 1.0,
									 boardView.frame.size.height / reversi.row - 1.0);
			UILabel *reverseLabel = [[UILabel alloc] initWithFrame:rect];
			reverseLabel.backgroundColor = [UIColor clearColor];
			reverseLabel.textColor = [UIColor clearColor];
//			reverseLabel.tag = 0;
//			reverseLabel.text = [NSString stringWithFormat:@"%d", reverseLabel.tag];
//			reverseLabel.textAlignment = NSTextAlignmentCenter;
//			reverseLabel.font = [UIFont fontWithName:@"Futura" size:32.0];
			reverseLabel.layer.cornerRadius = reverseLabel.frame.size.width / 2.0;
			reverseLabel.layer.borderColor = [boardColor CGColor];
			reverseLabel.layer.borderWidth = 5.0;
			[boardView addSubview:reverseLabel];
			[reverseLabels addObject:reverseLabel];
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
	CGPoint p = [[touches anyObject] locationInView:boardView];
	int row = p.y / boardView.frame.size.height * reversi.row;
	int column = p.x / boardView.frame.size.width * reversi.column;
	NSLog(@"INDEX:(%d, %d), COOD:(%3.1f, %3.1f)", row, column, p.x, p.y);

	[reversi changeStateWithRow:row column:column];
	[self redrawBoard];
}

- (void)redrawBoard
{
	for (int i = 0; i < reversi.row * reversi.column; i++) {
		switch (reversi.states[i].color) {
			case 0:
				((UILabel *)reverseLabels[i]).backgroundColor = [UIColor blackColor];
				break;
			case 1:
				((UILabel *)reverseLabels[i]).backgroundColor = [UIColor whiteColor];
				break;
			default:
				break;
		}
	}
}



@end
