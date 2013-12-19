//
//  USKViewController.m
//  RevengeReversi
//
//  Created by Yusuke IWAMA on 12/20/13.
//  Copyright (c) 2013 Yusuke Iwama. All rights reserved.
//

#import "USKViewController.h"

typedef enum Turn {
	TurnBlack = 0,
	TurnWhite = 1
	} Turn;

@interface USKViewController ()

@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet UILabel *blackScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteScoreLabel;

@end

@implementation USKViewController {
	int boardSize;
	NSMutableArray *reverseLabels;
	int blackScore;
	int whiteScore;
	Turn turn;
}

@synthesize boardView;
@synthesize blackScoreLabel;
@synthesize whiteScoreLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	boardSize = 8;
	reverseLabels = [NSMutableArray array];
	[self drawBoard];
	
	boardView.userInteractionEnabled = YES;
	boardView.multipleTouchEnabled = NO;
	
	blackScore = 0;
	whiteScore = 0;
	[self updateScoreLabels];
	
	turn = TurnBlack;
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
	
	boardView.backgroundColor = [UIColor lightGrayColor];
	
	for (int i = 0; i < boardSize; i++) {
		for (int j = 0; j < boardSize; j++) {
			CGRect rect = CGRectMake(boardView.frame.size.width / boardSize * j + 0.5,
									 boardView.frame.size.height / boardSize * i + 0.5,
									 boardView.frame.size.width / boardSize - 1.0,
									 boardView.frame.size.height / boardSize - 1.0);
			UILabel *reverseLabel = [[UILabel alloc] initWithFrame:rect];
			reverseLabel.backgroundColor = [UIColor clearColor];
			reverseLabel.textColor = [UIColor clearColor];
			reverseLabel.tag = 0;
			reverseLabel.text = [NSString stringWithFormat:@"%d", reverseLabel.tag];
			reverseLabel.textAlignment = NSTextAlignmentCenter;
			reverseLabel.font = [UIFont fontWithName:@"Futura" size:32.0];
			[boardView addSubview:reverseLabel];
			[reverseLabels addObject:reverseLabel];
		}
	}
	((UILabel *)(reverseLabels[3 * boardSize + 3])).backgroundColor = [UIColor whiteColor];
	((UILabel *)(reverseLabels[3 * boardSize + 3])).textColor = [UIColor blackColor];
	((UILabel *)(reverseLabels[3 * boardSize + 3])).tag = 1;
	((UILabel *)(reverseLabels[3 * boardSize + 3])).text = [NSString stringWithFormat:@"%d", ((UILabel *)(reverseLabels[3 * boardSize + 3])).tag];
	((UILabel *)(reverseLabels[3 * boardSize + 4])).backgroundColor = [UIColor blackColor];
	((UILabel *)(reverseLabels[3 * boardSize + 4])).textColor = [UIColor whiteColor];
	((UILabel *)(reverseLabels[3 * boardSize + 4])).tag = 1;
	((UILabel *)(reverseLabels[3 * boardSize + 4])).text = [NSString stringWithFormat:@"%d", ((UILabel *)(reverseLabels[3 * boardSize + 4])).tag];
	((UILabel *)(reverseLabels[4 * boardSize + 3])).backgroundColor = [UIColor blackColor];
	((UILabel *)(reverseLabels[4 * boardSize + 3])).textColor = [UIColor whiteColor];
	((UILabel *)(reverseLabels[4 * boardSize + 3])).tag = 1;
	((UILabel *)(reverseLabels[4 * boardSize + 3])).text = [NSString stringWithFormat:@"%d", ((UILabel *)(reverseLabels[4 * boardSize + 3])).tag];
	((UILabel *)(reverseLabels[4 * boardSize + 4])).backgroundColor = [UIColor whiteColor];
	((UILabel *)(reverseLabels[4 * boardSize + 4])).textColor = [UIColor blackColor];
	((UILabel *)(reverseLabels[4 * boardSize + 4])).tag = 1;
	((UILabel *)(reverseLabels[4 * boardSize + 4])).text = [NSString stringWithFormat:@"%d", ((UILabel *)(reverseLabels[4 * boardSize + 4])).tag];

}

- (void)updateScoreLabels
{
	blackScoreLabel.text = [NSString stringWithFormat:@"Black: %d", blackScore];
	whiteScoreLabel.text = [NSString stringWithFormat:@"White: %d", whiteScore];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	CGPoint p = [[touches anyObject] locationInView:boardView];
	NSLog(@"%4.1f, %4.1f", p.x, p.y);
	int row = p.y / boardView.frame.size.height * boardSize;
	int column = p.x / boardView.frame.size.width * boardSize;

	if (((UILabel *)(reverseLabels[row * boardSize + column])).tag == 0) {
		if (turn == TurnBlack) {
			((UILabel *)(reverseLabels[row * boardSize + column])).backgroundColor = [UIColor blackColor];
			((UILabel *)(reverseLabels[row * boardSize + column])).textColor = [UIColor whiteColor];
		} else {
			((UILabel *)(reverseLabels[row * boardSize + column])).backgroundColor = [UIColor whiteColor];
			((UILabel *)(reverseLabels[row * boardSize + column])).textColor = [UIColor blackColor];
		}
		((UILabel *)(reverseLabels[row * boardSize + column])).tag = 1;
		((UILabel *)(reverseLabels[row * boardSize + column])).text = [NSString stringWithFormat:@"%d", ((UILabel *)(reverseLabels[row * boardSize + column])).tag];
		[self reverseWithRow:row column:column];
	}
}

- (void)reverseWithRow:(int)r column:(int)c
{
	int index = r * boardSize + c;
	index -= boardSize;
	while (index >= 0) {
		index -= boardSize;
	}
	
	if (turn == TurnBlack) {
		turn = TurnWhite;
	} else {
		turn = TurnBlack;
	}
}

@end
