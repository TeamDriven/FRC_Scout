//
//  Data.m
//  FIRST Scouting App
//
//  Created by Eris on 11/5/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Data.h"

@interface Data ()

@end

@implementation Data

NSMutableArray *redScores;
NSMutableArray *orangeScores;
NSMutableArray *yellowScores;

NSNumber *numberOfRows;

NSInteger redOn;
NSInteger orangeOn;
NSInteger yellowOn;

UIScrollView *scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    numberOfRows = [NSNumber numberWithInt:4];
    
    redOn = 1;
    orangeOn = 1;
    yellowOn = 1;
    
    [self createScrollViewWithWidth:[numberOfRows integerValue]];
    
    [self createBogusValues:[numberOfRows integerValue]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moreGraphsBtn:(id)sender {
    NSArray *viewsToRemove = [scrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    numberOfRows = [NSNumber numberWithInt:(arc4random()%20) + 1];
    [self createScrollViewWithWidth:[numberOfRows integerValue]];
    [self createBogusValues:[numberOfRows integerValue]];
}

- (IBAction)redSwitcher:(id)sender {
    if (_redSwitch.on) {
        redOn = 1;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
    else{
        redOn = 0;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
}
- (IBAction)orangeSwitcher:(id)sender {
    if (_orangeSwitch.on) {
        orangeOn = 1;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
    else{
        orangeOn = 0;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
}
- (IBAction)yellowSwitcher:(id)sender {
    if (_yellowSwitch.on) {
        yellowOn = 1;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
    else{
        yellowOn = 0;
        NSArray *viewsToRemove = [scrollView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        [self createScrollViewWithWidth:[numberOfRows integerValue]];
        [self createBogusValues:[numberOfRows integerValue]];
    }
}










/* +++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++  METHODS  +++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++*/

-(void)createScrollViewWithWidth:(NSInteger)width{
    CGRect scrollRect = CGRectMake(40, 660, 688, 200);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(width*60 + 10, 200)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:scrollView];
}


-(void)createBogusValues:(NSInteger)amount{
    
    redScores = [[NSMutableArray alloc] init];
    orangeScores = [[NSMutableArray alloc] init];
    yellowScores = [[NSMutableArray alloc] init];
    
    [redScores removeAllObjects];
    [orangeScores removeAllObjects];
    [yellowScores removeAllObjects];
    
    
    for (int r = 0; r < amount; r++) {
        [redScores addObject:[NSNumber numberWithInt:(arc4random() %60) + 1]];
        //NSLog(@"R Loop %d", r);
    }
    
    
    for (int o = 0; o < amount; o++) {
        [orangeScores addObject:[NSNumber numberWithInt:(arc4random() % 50) + 1]];
    }
    
    
    for (int y = 0; y < amount; y++) {
        [yellowScores addObject:[NSNumber numberWithInt:(arc4random() %40) + 1]];
    }
    
    //NSLog(@"\n RED: %@ \n ORANGE: %@ \n YELLOW: %@", redScores, orangeScores, yellowScores);
    
    [self numberOfBars:amount redValues:redScores orangeValues:orangeScores yellowValues:yellowScores];
}


-(void)numberOfBars:(NSInteger)numBars redValues:(NSArray *)redVals orangeValues:(NSArray *)orangeVals yellowValues:(NSArray *)yellowVals{
    
    NSInteger width = 30;
    
    //numBars = numBars-1;
    
    
    for (NSInteger i = 0; i < numBars; i++) {
        //NSLog(@"TIME NUMBER %d", i);
        NSInteger xCord = 60*i + 20;
        if (redOn == 1) {
            
            NSInteger heightR = [redVals[i] integerValue];
            NSInteger yCordR = 150-heightR;
            
            CGRect redRect = CGRectMake(xCord, yCordR, width, heightR);
            UIView *redBar = [[UIView alloc] initWithFrame:redRect];
            
            redBar.backgroundColor = [UIColor redColor];
            
            NSInteger heightO = [orangeVals[i] integerValue];
            NSInteger yCordO = yCordR-heightO;
            UIView *orangeBar;
            
            if (orangeOn == 1) {
                CGRect orangeRect = CGRectMake(xCord, yCordO, width, heightO);
                orangeBar = [[UIView alloc] initWithFrame:orangeRect];
                
                orangeBar.backgroundColor = [UIColor orangeColor];
            }
            
            NSInteger heightY = [yellowVals[i] integerValue];
            NSInteger yCordY = yCordO-heightY;
            UIView *yellowBar;
            
            if (yellowOn == 1) {
                if (orangeOn == 0) {
                    yCordY = yCordR-heightY;
                }
                
                CGRect yellowRect = CGRectMake(xCord, yCordY, width, heightY);
                yellowBar = [[UIView alloc] initWithFrame:yellowRect];
                
                yellowBar.backgroundColor = [UIColor yellowColor];
            }
            
            
            
            [scrollView addSubview:redBar];
            
            if (orangeOn == 1) {
                [scrollView addSubview:orangeBar];
            }
            if (yellowOn == 1) {
                [scrollView addSubview:yellowBar];
            }
        }
        else if (redOn == 0 && orangeOn == 1){
            
            NSInteger heightO = [orangeVals[i] integerValue];
            NSInteger yCordO = 150-heightO;
            
            CGRect orangeRect = CGRectMake(xCord, yCordO, width, heightO);
            UIView *orangeBar = [[UIView alloc] initWithFrame:orangeRect];
            
            orangeBar.backgroundColor = [UIColor orangeColor];
            
            NSInteger heightY = [yellowVals[i] integerValue];
            NSInteger yCordY = yCordO-heightY;
            
            CGRect yellowRect = CGRectMake(xCord, yCordY, width, heightY);
            UIView *yellowBar = [[UIView alloc] initWithFrame:yellowRect];
            
            yellowBar.backgroundColor = [UIColor yellowColor];
            
            
            [scrollView addSubview:orangeBar];
            if (yellowOn == 1) {
                [scrollView addSubview:yellowBar];
            }
        }
        else if (redOn == 0 && orangeOn == 0 && yellowOn == 1){
            NSInteger heightY = [yellowVals[i] integerValue];
            NSInteger yCordY = 150-heightY;
            
            CGRect yellowRect = CGRectMake(xCord, yCordY, width, heightY);
            UIView *yellowBar = [[UIView alloc] initWithFrame:yellowRect];
            
            yellowBar.backgroundColor = [UIColor yellowColor];
            
            [scrollView addSubview:yellowBar];
        }
        if (redOn == 1 || orangeOn == 1 || yellowOn == 1) {
            NSInteger yCordLbl = 155;
            CGRect lblRect = CGRectMake(xCord-4, yCordLbl, 40, width);
            UILabel *matchLabel = [[UILabel alloc] initWithFrame:lblRect];
        
            matchLabel.numberOfLines = 1;
            matchLabel.text = [[NSString alloc] initWithFormat:@"Match %ld", (long)i+1];
            matchLabel.backgroundColor = [UIColor clearColor];
            matchLabel.textColor = [UIColor blackColor];
            matchLabel.font = [UIFont systemFontOfSize:8];
            matchLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
            [scrollView addSubview:matchLabel];
        }
        
    }
}








@end
