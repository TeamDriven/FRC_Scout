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

Boolean redOn;
Boolean orangeOn;
Boolean yellowOn;

NSNumber *autoAvg;
NSNumber *teleopAvg;
NSNumber *endgameAvg;
NSNumber *numMatches;

UIScrollView *scrollView;

NSIndexPath *selectedRowIndex;
UIView *greyOut;
UIView *matchDetailView;


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
    
    _teamSearchField.delegate = self;
    
    _matchTableView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _matchTableView.layer.borderWidth = 1;
    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    resultDict = [[NSMutableDictionary alloc] init];
    
    redOn = 1;
    orangeOn = 1;
    yellowOn = 1;
    
    [self createScrollViewWithDictionary:resultDict];
    
    _switchBackgroundView.layer.cornerRadius = 10;
    
    _redSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _orangeSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _yellowSwitch.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    
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

-(IBAction)teamNumEditingFinished:(id)sender {
    [resultDict removeAllObjects];
    autoAvg = nil;
    teleopAvg = nil;
    // endgameAvg = nil;
    numMatches = nil;
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
                    autoAvg = [NSNumber numberWithInteger:[[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"autoHighScore"] integerValue] + [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"autoMidScore"] integerValue] + [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"autoLowScore"] integerValue] + [autoAvg integerValue]];
                    teleopAvg = [NSNumber numberWithInteger: [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"teleopHighScore"] integerValue] + [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"teleopMidScore"] integerValue] + [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"teleopLowScore"] integerValue] + [teleopAvg integerValue]];
                    //endgameAvg += [[[[resultDict objectForKey:[regionalsKeys objectAtIndex:i]] objectForKey:[matchesKeys objectAtIndex:q]] objectForKey:@"endgameScore"] integerValue];
                    numMatches = [NSNumber numberWithInteger:[numMatches integerValue]+1];
                }
            }
        }
    }
    
    NSLog(@"%@", resultDict);
    if ([resultDict count] > 0) {
        autoAvg = [NSNumber numberWithFloat:[autoAvg floatValue]/[numMatches floatValue]];
        teleopAvg = [NSNumber numberWithFloat:[teleopAvg floatValue]/[numMatches floatValue]];
        //endgameAvg = endgameAvg/numMatches;
        
        _autoAvgNum.text = [[NSString alloc] initWithFormat:@"%0.2f", [autoAvg floatValue]];
        _teleopAvgNum.text = [[NSString alloc] initWithFormat:@"%0.2f", [teleopAvg floatValue]];
        //_endgameAvgNum.text = [[NSString alloc] initWithFormat:@"%ld", (long)endgameAvg];
        
        [self createScrollViewWithDictionary:resultDict];
        [[self matchTableView] setDelegate:self];
        [[self matchTableView] setDataSource:self];
        [[self matchTableView] reloadData];
    }
    else{
        if ([_teamSearchField.text length] > 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Uh Oh!"
                                                       message: @"That team number is not in this iPad's database!"
                                                      delegate: nil
                                             cancelButtonTitle:@"Dang, alright then."
                                             otherButtonTitles:nil];
            [alert show];
        }
    }
}

/* +++++++++++++++++++++++++++++++++++++++++
 +++++++++++++++  METHODS  +++++++++++++++++
 ++++++++++++++++++++++++++++++++++++++++++*/

-(void)createScrollViewWithDictionary:(NSDictionary *)dict{
    [scrollView removeFromSuperview];
    CGRect scrollRect = CGRectMake(40, 690, 688, 200);
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
    scrollView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    scrollView.layer.cornerRadius = 5;
    scrollView.layer.borderWidth = 2;
    scrollView.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1].CGColor;
    [self.view addSubview:scrollView];
    
    [self createBarsWithDictionary:dict];
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
            regionalLabel.font = [UIFont systemFontOfSize:8];
            regionalLabel.adjustsFontSizeToFitWidth = YES;
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
                matchLabel.adjustsFontSizeToFitWidth = YES;
                matchLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
                [scrollView addSubview:matchLabel];
                
                matchXCord+=40;
                
                regionalXCord += 40;
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(IBAction)screenTapped:(id)sender {
    [self hideKeyboard];
}

-(void)hideKeyboard{
    [_teamSearchField resignFirstResponder];
}


// Set the number of sections based on how many arrays the sections array has within it

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[resultDict allKeys] count];
}

// Set the number of rows in each individual section based on the amount of objects in each array
//   within the sections array

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *regionals = [resultDict allKeys];
    return [[resultDict objectForKey:[regionals objectAtIndex:section]] count];
}

// Set headers of sections from the "headers" array

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *regionals = [resultDict allKeys];
    return [regionals objectAtIndex:section];
}

// Create cells as the user scrolls

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *regionals = [resultDict allKeys];
    NSMutableArray *matches = [[NSMutableArray alloc] initWithArray:[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] allKeys]];
    [matches sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:(NSNumericSearch)];
    }];
    
    static NSString *cellIdentifier = @"matchCell";
    MatchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[MatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.matchNumLbl.text = [[NSString alloc] initWithFormat:@"%@ %@", [[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"currentMatchType"],[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"currentMatchNum"]];
    cell.autoTotalNum.text = [[NSString alloc] initWithFormat:@"%ld", (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"autoHighScore"] integerValue] + (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"autoMidScore"] integerValue] + (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"autoLowScore"] integerValue]];
    cell.teleopTotalNum.text = [[NSString alloc] initWithFormat:@"%ld", (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"teleopHighScore"] integerValue] + (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"teleopMidScore"] integerValue] + (long)[[[[resultDict objectForKey:[regionals objectAtIndex:indexPath.section]] objectForKey:[matches objectAtIndex:indexPath.row]] objectForKey:@"teleopLowScore"] integerValue]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRowIndex = indexPath;
    MatchCell *selectedCell = (MatchCell *)[_matchTableView cellForRowAtIndexPath:indexPath];
    
    CGRect greyOutRect = CGRectMake(0, 0, 768, 1024);
    greyOut = [[UIView alloc] initWithFrame:greyOutRect];
    greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:greyOut];
    
    CGRect matchDetailViewRect = CGRectMake(84, 162, 600, 600);
    matchDetailView = [[UIView alloc] initWithFrame:matchDetailViewRect];
    matchDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:matchDetailView];
    matchDetailView.layer.cornerRadius = 10;
    
    CGRect closeButtonRect = CGRectMake(530, 10, 60, 20);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = closeButtonRect;
    [closeButton addTarget:self action:@selector(closeMatchDetailView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    [matchDetailView addSubview:closeButton];
    
    CGRect regionalTitleLblRect = CGRectMake(150, 27, 70, 20);
    UILabel *regionalTitleLbl = [[UILabel alloc] initWithFrame:regionalTitleLblRect];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    regionalTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:@"Event" attributes:underlineAttribute];
    regionalTitleLbl.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    regionalTitleLbl.font = [UIFont systemFontOfSize:11];
    regionalTitleLbl.textAlignment = NSTextAlignmentCenter;
    [matchDetailView addSubview:regionalTitleLbl];
    
    CGRect regionalLblRect = CGRectMake(60, 45, 240, 20);
    UILabel *regionalLbl = [[UILabel alloc] initWithFrame:regionalLblRect];
    regionalLbl.text = [[NSString alloc] initWithFormat:@"%@", [_matchTableView headerViewForSection:selectedRowIndex.section].textLabel.text];
    regionalLbl.font = [UIFont systemFontOfSize:18];
    regionalLbl.adjustsFontSizeToFitWidth = YES;
    regionalLbl.textAlignment = NSTextAlignmentCenter;
    [matchDetailView addSubview:regionalLbl];
    
    CGRect matchTitleLblRect = CGRectMake(370, 27, 70, 20);
    UILabel *matchTitleLbl = [[UILabel alloc] initWithFrame:matchTitleLblRect];
    matchTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:@"Match" attributes:underlineAttribute];
    matchTitleLbl.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    matchTitleLbl.font = [UIFont systemFontOfSize:11];
    matchTitleLbl.textAlignment = NSTextAlignmentCenter;
    [matchDetailView addSubview:matchTitleLbl];
    
    CGRect matchTitleRect = CGRectMake(330, 40, 150, 30);
    UILabel *matchTitle = [[UILabel alloc] initWithFrame:matchTitleRect];
    matchTitle.text = [[NSString alloc] initWithFormat:@"%@", selectedCell.matchNumLbl.text];
    matchTitle.font = [UIFont systemFontOfSize:20];
    matchTitle.textAlignment = NSTextAlignmentCenter;
    [matchDetailView addSubview:matchTitle];
    
    
    
    matchDetailView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         matchDetailView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                     }];
    

}

-(void)closeMatchDetailView{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        matchDetailView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
                     completion:^(BOOL finished){
                         [greyOut removeFromSuperview];
                         [matchDetailView removeFromSuperview];
                         [_matchTableView deselectRowAtIndexPath:selectedRowIndex animated:YES];
                         selectedRowIndex = nil;
                     }];
}

@end










