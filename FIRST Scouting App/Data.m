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

NSArray *paths;
NSString *scoutingDirectory;
NSString *path;
NSMutableDictionary *dataDict;

NSMutableDictionary *resultDict;

NSMutableArray *redScores;
NSMutableArray *orangeScores;
NSMutableArray *yellowScores;

NSNumber *numberOfRows;

Boolean redOn;
Boolean orangeOn;
Boolean yellowOn;

UIScrollView *scrollView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    scoutingDirectory = [paths objectAtIndex:0];
    path = [scoutingDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"] toPath:path error:nil];
    }
    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    resultDict = [[NSMutableDictionary alloc] init];
    
    numberOfRows = [NSNumber numberWithInt:4];
    
    redOn = 1;
    orangeOn = 1;
    yellowOn = 1;
    
    [self createScrollViewWithDictionary:resultDict];
    
    NSLog(@"%@", dataDict);
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)redSwitcher:(id)sender {
    if (_redSwitch.on) {
        redOn = true;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
    else{
        redOn = false;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
}
-(IBAction)orangeSwitcher:(id)sender {
    if (_orangeSwitch.on) {
        orangeOn = true;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
    else{
        orangeOn = false;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
}
-(IBAction)yellowSwitcher:(id)sender {
    if (_yellowSwitch.on) {
        yellowOn = true;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
    else{
        yellowOn = false;
        if ([resultDict count] > 0) {
            [self createBarsWithDictionary:resultDict];
        }
    }
}


/* +++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++  METHODS  +++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++*/

-(void)createScrollViewWithDictionary:(NSDictionary *)dict{
    [scrollView removeFromSuperview];
    CGRect scrollRect = CGRectMake(40, 660, 688, 200);
    scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    [scrollView setScrollEnabled:YES];
    if (_teamSearchField.text.length > 0) {
        NSArray *regionalKeys = [dict allKeys];
        NSInteger lengthNeeded = 10;
        for (int r  = 0; r < regionalKeys.count; r++) {
            NSArray *matchKeys = [[dict objectForKey:[regionalKeys objectAtIndex:r]] allKeys];
            for (int m = 0; m < matchKeys.count; m++) {
                lengthNeeded += 40;
            }
            lengthNeeded += 30;
        }
        [scrollView setContentSize:CGSizeMake(lengthNeeded + 10, 200)];
        NSLog(@"%ld", (long)lengthNeeded);
    }
    scrollView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    [self.view addSubview:scrollView];
    
    [self createBarsWithDictionary:dict];
}

-(IBAction)teamNumEditingFinished:(id)sender {
    [resultDict removeAllObjects];
    NSArray *rAndBKeys = [dataDict allKeys];
    for (int j = 0; j < rAndBKeys.count; j++) {
        NSArray *regionalsKeys = [[dataDict objectForKey:[rAndBKeys objectAtIndex:j]] allKeys];
        for (int i = 0; i < regionalsKeys.count; i++) {
            NSArray *matchesKeys = [[[dataDict objectForKey:[rAndBKeys objectAtIndex:j]] objectForKey:[regionalsKeys objectAtIndex:i]] allKeys];
            for (int q = 0; q < matchesKeys.count; q++) {
                if ([[[[[dataDict objectForKey:[rAndBKeys objectAtIndex:j]] objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"currentTeamNum"] isEqualToString:_teamSearchField.text]) {
                    if (![resultDict objectForKey:[regionalsKeys objectAtIndex:i]]) {
                        [resultDict setObject:[NSMutableDictionary dictionary] forKey:[regionalsKeys objectAtIndex:i]];
                    }
                    [[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] setObject:[[[dataDict objectForKey:[rAndBKeys objectAtIndex:j]] objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] forKey:[matchesKeys objectAtIndex:q]];
                }
            }
        }
    }
    
    NSLog(@"%@", resultDict);
    [self createScrollViewWithDictionary:resultDict];
}

-(void)createBarsWithDictionary:(NSDictionary *)dict{
    for (UIView *v in [scrollView subviews]) {
        [v removeFromSuperview];
    }
    if (_teamSearchField.text.length > 0) {
        NSInteger regionalXCord = -70;
        NSInteger matchXCord = 25;
        NSArray *regionalKeys = [dict allKeys];
        NSInteger barWidth = 30;
        for (int r  = 0; r < regionalKeys.count; r++) {
            CGRect regionalLabelRect = CGRectMake(regionalXCord, 95, 180, 10);
            UILabel *regionalLabel = [[UILabel alloc] initWithFrame:regionalLabelRect];
            NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            regionalLabel.attributedText = [[NSAttributedString alloc] initWithString:[regionalKeys objectAtIndex:r]
                                                                     attributes:underlineAttribute];
            regionalLabel.textAlignment = NSTextAlignmentCenter;
            regionalLabel.numberOfLines = 1;
            regionalLabel.adjustsFontSizeToFitWidth = YES;
            regionalLabel.font = [UIFont systemFontOfSize:8];
            [scrollView addSubview:regionalLabel];
            regionalLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
            regionalXCord += 30;
            if (r > 0) {
                matchXCord += 30;
            }
            else{
                matchXCord += 10;
            }
            NSMutableArray *matchKeys = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:[regionalKeys objectAtIndex:r]] allKeys] ];
            [matchKeys sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
                return [str1 compare:str2 options:(NSNumericSearch)];
            }];
            for (int m = 0; m < matchKeys.count; m++) {
                NSInteger heightR;
                NSInteger yCordR;
                NSInteger heightO;
                NSInteger yCordO;
                NSInteger heightY;
                NSInteger yCordY;
                if (redOn) {
                    heightR = [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"autoHighScore"] integerValue] + [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"autoMidScore"] integerValue] + [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"autoLowScore"] integerValue];
                    yCordR = 150-heightR;
                    CGRect redRect = CGRectMake(matchXCord, yCordR, barWidth, heightR);
                    UIView *redBar = [[UIView alloc] initWithFrame:redRect];
                    redBar.backgroundColor = [UIColor redColor];
                    [scrollView addSubview:redBar];
                }
                else{
                    heightR = 0;
                    yCordR = 150-heightR;
                    CGRect redRect = CGRectMake(matchXCord, yCordR, barWidth, heightR);
                    UIView *redBar = [[UIView alloc] initWithFrame:redRect];
                    redBar.backgroundColor = [UIColor redColor];
                    [scrollView addSubview:redBar];
                }
                if (orangeOn) {
                    heightO = [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"teleopHighScore"] integerValue] + [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"teleopMidScore"] integerValue] + [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"teleopLowScore"] integerValue];
                    yCordO = yCordR - heightO;
                    CGRect orangeRect = CGRectMake(matchXCord, yCordO, barWidth, heightO);
                    UIView *orangeBar = [[UIView alloc] initWithFrame:orangeRect];
                    orangeBar.backgroundColor = [UIColor orangeColor];
                    [scrollView addSubview:orangeBar];
                }
                else{
                    heightO = 0;
                    yCordO = yCordR - heightO;
                    CGRect orangeRect = CGRectMake(matchXCord, yCordO, barWidth, heightO);
                    UIView *orangeBar = [[UIView alloc] initWithFrame:orangeRect];
                    orangeBar.backgroundColor = [UIColor orangeColor];
                    [scrollView addSubview:orangeBar];
                }
                if (yellowOn) {
                    heightY = [[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"endGameScore"] integerValue];
                    yCordY = yCordO - heightY;
                    CGRect yellowRect = CGRectMake(matchXCord, yCordY, barWidth, heightY);
                    UIView *yellowBar = [[UIView alloc] initWithFrame:yellowRect];
                    yellowBar.backgroundColor = [UIColor yellowColor];
                    [scrollView addSubview:yellowBar];
                }
                else{
                    heightY = 0;
                    yCordY = yCordO - heightY;
                    CGRect yellowRect = CGRectMake(matchXCord, yCordY, barWidth, heightY);
                    UIView *yellowBar = [[UIView alloc] initWithFrame:yellowRect];
                    yellowBar.backgroundColor = [UIColor yellowColor];
                    [scrollView addSubview:yellowBar];
                }
                
                NSInteger yCordLbl = 157;
                CGRect lblRect = CGRectMake(matchXCord-4, yCordLbl, 40, barWidth);
                UILabel *matchLabel = [[UILabel alloc] initWithFrame:lblRect];
                matchLabel.numberOfLines = 1;
                matchLabel.text = [[NSString alloc] initWithFormat:@"Match %ld", (long)[[[[dict objectForKey:[regionalKeys objectAtIndex:r]] objectForKey:[matchKeys objectAtIndex:m]] objectForKey:@"currentMatchNum"] integerValue]];
                matchLabel.backgroundColor = [UIColor clearColor];
                matchLabel.textColor = [UIColor blackColor];
                matchLabel.font = [UIFont systemFontOfSize:8];
                matchLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
                [scrollView addSubview:matchLabel];
                
                matchXCord+=40;
                
                regionalXCord += 40;
            }
        }
    }
}








@end
