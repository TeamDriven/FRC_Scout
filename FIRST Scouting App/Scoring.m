//
//  LocationsFirstViewController.m
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Scoring.h"

@interface LocationsFirstViewController ()

@end

@implementation LocationsFirstViewController

Boolean autoYN;

NSInteger teleopHighScore;
NSInteger autoHighScore;
NSInteger teleopMidScore;
NSInteger autoMidScore;
NSInteger teleopLowScore;
NSInteger autoLowScore;

NSString *initials;
NSString *scoutTeamNum;
NSString *currentMatchNum;
NSString *teamNum;
NSString *currentRegional;

NSArray *paths;
NSString *scoutingDirectory;
NSString *path;
NSMutableDictionary *dataDict;

NSString *pos;

UISwipeGestureRecognizer *twoFingerUp;
UISwipeGestureRecognizer *twoFingerDown;

UIControl *greyOut;
UIControl *setUpView;
UISegmentedControl *red1Selector;
UITextField *matchNumField;
UITextField *teamNumField;
UITextField *initialsField;
UIPickerView *regionalPicker;

NSArray *regionalNames;

- (void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    scoutingDirectory = [paths objectAtIndex:0];
    path = [scoutingDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"] toPath:path error:nil];
    }
    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    
    twoFingerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOn)];
    [twoFingerUp setNumberOfTouchesRequired:2];
    [twoFingerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:twoFingerUp];
    
    
    twoFingerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOff)];
    [twoFingerDown setNumberOfTouchesRequired:2];
    [twoFingerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:twoFingerDown];
    
    autoYN = true;
    
    regionalNames = @[@"Central Illinois Regional",@"Palmetto Regional",@"Alamo Regional",@"Greater Toronto West Regional",@"Inland Empire Regional",@"Center Line FIRST Robotics District Competition",@"Southfield FIRST Robotics District Competition",@"Granite State District Event",@"PNW FIRST Robotics Auburn Mountainview District Event",@"MAR FIRST Robotics Mt. Olive District Competition",@"MAR FIRST Robotics Hatboro-Horsham District Competition",@"Israel Regional",@"Greater Toronto East Regional",@"Arkansas Regional",@"San Diego Regional",@"Crossroads Regional",@"Lake Superior Regional",@"Northern Lights Regional",@"Hub City Regional",@"UNH District Event",@"Central Valley Regional",@"Kettering University FIRSTRobotics District Competition",@"Gull Lake FIRST Robotics District Competition",@"PNW FIRST Robotics Oregon City District Event",@"PNW FIRST Robotics Glacier Peak District Event",@"Groton District Event",@"Mexico City Regional",@"Sacramento Regional",@"Orlando Regional",@"Greater Kansas City Regional",@"St. Louis Regional",@"North Carolina Regional",@"New York Tech Valley Regional",@"Dallas Regional",@"Utah Regional",@"WPI District Event",@"Escanaba FIRST Robotics District Competition",@"Howell FIRST Robotics District Competition",@"MAR FIRST Robotics Springside Chestnut Hill District Competition",@"PNW FIRST Robotics Eastern Washington University District Event",@"PNW FIRST Robotics Mt. Vernon District Event",@"MAR FIRST Robotics Clifton District Competition",@"Waterloo Regional",@"Festival de Robotique FRC a Montreal Regional",@"Arizona Regional",@"Los Angeles Regional",@"Boilermaker Regional",@"Buckeye Regional",@"Virginia Regional",@"Wisconsin Regional",@"West Michigan FIRST Robotics District Competition",@"Great Lakes Bay Region FIRSTRobotics District Competition",@"Traverse City FIRST Robotics District Competition",@"PNW FIRST Robotics Wilsonville District Event",@"Rhode Island District Event",@"PNW FIRST Robotics Shorewood District Event",@"Southington District Event",@"MAR FIRST Robotics Lenape-Seneca District Competition",@"North Bay Regional",@"Peachtree Regional",@"Hawaii Regional",@"Minnesota 10000 Lakes Regional",@"Minnesota North Star Regional",@"SBPLI Long Island Regional",@"Finger Lakes Regional",@"Queen City Regional",@"Oklahoma Regional",@"Greater Pittsburgh Regional",@"Smoky Mountains Regional",@"Greater DC Regional",@"Northeastern University District Event",@"Livonia FIRST Robotics District Competition",@"St. Joseph FIRST Robotics District Competition",@"Waterford FIRST Robotics District Competition",@"PNW FIRST Robotics Auburn District Event",@"PNW FIRST Robotics Central Washington University District Event",@"Hartford District Event",@"MAR FIRST Robotics Bridgewater-Raritan District Competition",@"Western Canada Regional",@"Windsor Essex Great Lakes Regional",@"Silicon Valley Regional",@"Colorado Regional",@"South Florida Regional",@"Midwest Regional",@"Bayou Regional",@"Chesapeake Regional",@"Las Vegas Regional",@"New York City Regional",@"Lone Star Regional",@"Pine Tree District Event",@"Bedford FIRST Robotics District Competition",@"Troy FIRST Robotics District Competition",@"PNW FIRST Robotics",@"Oregon State University District Event",@"New England FRC Region Championship",@"Michigan FRC State Championship",@"Autodesk PNW FRC Championship",@"Mid-Atlantic Robotics FRC Region Championship",@"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:0.3];
    [self setUpScreen];
    
}

-(void)setUpScreen{
    if (initials == nil) {
        twoFingerUp.enabled = false;
        twoFingerDown.enabled = false;
        
        CGRect greyOutRect = CGRectMake(0, 0, 768, 1024);
        greyOut = [[UIControl alloc] initWithFrame:greyOutRect];
        [greyOut addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self.view addSubview:greyOut];
        
        CGRect setUpViewRect = CGRectMake(70, 100, 628, 700);
        setUpView = [[UIControl alloc] initWithFrame:setUpViewRect];
        [setUpView addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        setUpView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        setUpView.layer.cornerRadius = 10;
        
        
        CGRect setUpTitleRect = CGRectMake(214, 50, 200, 50);
        UILabel *setUpTitle = [[UILabel alloc] initWithFrame:setUpTitleRect];
        [setUpTitle setFont:[UIFont systemFontOfSize:25]];
        [setUpTitle setTextAlignment:NSTextAlignmentCenter];
        [setUpTitle setText:@"Sign in to Scout"];
        [setUpView addSubview:setUpTitle];
        
        CGRect red1SelectorRect = CGRectMake(124, 150, 380, 30);
        red1Selector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red 1", @"Red 2", @"Red 3", @"Blue 1", @"Blue 2", @"Blue 3",  nil]];
        [red1Selector setFrame:red1SelectorRect];
        [setUpView addSubview:red1Selector];
        
        CGRect matchNumFieldRect = CGRectMake(384, 220, 130, 40);
        matchNumField = [[UITextField alloc] initWithFrame:matchNumFieldRect];
        [matchNumField setBorderStyle:UITextBorderStyleRoundedRect];
        [matchNumField setFont:[UIFont systemFontOfSize:15]];
        [matchNumField setPlaceholder:@"Current Match #"];
        [matchNumField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [matchNumField setKeyboardType:UIKeyboardTypeNumberPad];
        [matchNumField setReturnKeyType:UIReturnKeyDone];
        [matchNumField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [matchNumField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [matchNumField setTextAlignment:NSTextAlignmentCenter];
        [setUpView addSubview:matchNumField];
        
        CGRect teamNumFieldRect = CGRectMake(264, 220, 100, 40);
        teamNumField = [[UITextField alloc] initWithFrame:teamNumFieldRect];
        [teamNumField setBorderStyle:UITextBorderStyleRoundedRect];
        [teamNumField setFont:[UIFont systemFontOfSize:15]];
        [teamNumField setPlaceholder:@"Your Team #"];
        [teamNumField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [teamNumField setKeyboardType:UIKeyboardTypeNumberPad];
        [teamNumField setReturnKeyType:UIReturnKeyDone];
        [teamNumField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [teamNumField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [teamNumField setTextAlignment:NSTextAlignmentCenter];
        [setUpView addSubview:teamNumField];
        
        CGRect initialsFieldRect = CGRectMake(114, 220, 130, 40);
        initialsField = [[UITextField alloc] initWithFrame:initialsFieldRect];
        [initialsField setBorderStyle:UITextBorderStyleRoundedRect];
        [initialsField setFont:[UIFont systemFontOfSize:15]];
        [initialsField setPlaceholder:@"Your 3 Initials"];
        [initialsField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [initialsField setKeyboardType:UIKeyboardTypeDefault];
        [initialsField setReturnKeyType:UIReturnKeyDone];
        [initialsField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [initialsField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [initialsField setTextAlignment:NSTextAlignmentCenter];
        [setUpView addSubview:initialsField];
        
        CGRect regionalPickerLblRect = CGRectMake(194, 305, 240, 30);
        UILabel *regionalPickerLbl = [[UILabel alloc] initWithFrame:regionalPickerLblRect];
        [regionalPickerLbl setFont:[UIFont systemFontOfSize:18]];
        regionalPickerLbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [regionalPickerLbl setTextAlignment:NSTextAlignmentCenter];
        [regionalPickerLbl setText:@"Select the regional you are at"];
        [setUpView addSubview:regionalPickerLbl];
        
        CGRect regionalPickerRect = CGRectMake(104, 340, 420, 300);
        regionalPicker = [[UIPickerView alloc] initWithFrame:regionalPickerRect];
        regionalPicker.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        regionalPicker.layer.cornerRadius = 5;
        regionalPicker.delegate = self;
        regionalPicker.showsSelectionIndicator = YES;
        [setUpView addSubview:regionalPicker];
        if (currentRegional) {
            [regionalPicker selectRow:[regionalNames indexOfObject:currentRegional] inComponent:0 animated:YES];
        }
        
        UIButton *saveSetupButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [saveSetupButton addTarget:self action:@selector(eraseSetUpScreen) forControlEvents:UIControlEventTouchUpInside];
        [saveSetupButton setTitle:@"Save Settings" forState:UIControlStateNormal];
        saveSetupButton.frame = CGRectMake(254, 620, 120, 30);
        saveSetupButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [setUpView addSubview:saveSetupButton];
        
        setUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [self.view addSubview:setUpView];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             setUpView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished){
                         }];

    }
    }

-(void)eraseSetUpScreen{
    pos = nil;
    initials = nil;
    scoutTeamNum = nil;
    currentMatchNum = nil;
    currentRegional = nil;
    
    if (red1Selector.selectedSegmentIndex >= 0 && red1Selector.selectedSegmentIndex <= 5) {
        pos = [red1Selector titleForSegmentAtIndex:red1Selector.selectedSegmentIndex];
    }
    initials = initialsField.text;
    scoutTeamNum = teamNumField.text;
    teamNum = @"1730";
    currentMatchNum = matchNumField.text;
    currentRegional = [regionalNames objectAtIndex:[regionalPicker selectedRowInComponent:0]];
    
    if (!initials || initials.length != 3) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You didn't enter 3 initials!"
                                                       message: @"Please enter your three initials to show that you are scouting these matches"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (teamNumField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Enter your team number!"
                                                       message: @"Enter the team number of the team that you are on"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (!currentMatchNum || matchNumField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No match number!!"
                                                       message: @"What you tryin' to get away with?!? Please enter the match number you're about to scout"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if(!pos){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You did not select which position you're scouting!"
                                                       message: @"Sorry to ruin your day, but in order to make this work out best for the both of us, you gotta select which position you are scouting (Red 1, Red 2, etc.)"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             setUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         }
                         completion:^(BOOL finished){
                             [greyOut removeFromSuperview];
                             [setUpView removeFromSuperview];
                             //teamNum = teamNumField.text;
                             
                             
                             NSAttributedString *matchNumString = [[NSAttributedString alloc] initWithString:currentMatchNum];
                             [_matchNumEdit setAttributedTitle:matchNumString forState:UIControlStateNormal];
                             _matchNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             
                             NSAttributedString *teamNumString = [[NSAttributedString alloc] initWithString:teamNum];
                             [_teamNumEdit setAttributedTitle:teamNumString forState:UIControlStateNormal];
                             _teamNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             _initialsLbl.text = [[NSString alloc] initWithFormat:@"Your Initials: %@", initials];
                             
                             _regionalNameLbl.text = currentRegional;
                             _regionalNameLbl.numberOfLines = 0;
                             [_regionalNameLbl sizeToFit];
                             
                             twoFingerDown.enabled = true;
                         }];
        NSLog(@"\n Position: %@ \n Initials: %@ \n Scout Team Number: %@ \n Regional Title: %@ \n Match Number: %@", pos, initials, scoutTeamNum, currentRegional, currentMatchNum);
    }
    
    
}

- (IBAction)reSignIn:(id)sender {
    initials = nil;
    _matchNumField.enabled = false;
    _matchNumField.hidden = true;
    _matchNumEdit.enabled = true;
    _matchNumEdit.hidden = false;
    
    _teamNumField.enabled = false;
    _teamNumField.hidden = true;
    _teamNumEdit.enabled = true;
    _teamNumEdit.hidden = false;
    [self setUpScreen];
}

/*****************************************
 ************ UIPicker code **************
 *****************************************/

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //handle selection
}

// tell the picker how many rows are available for a given component
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSUInteger numRows = regionalNames.count;
    
    return numRows;
}

// tell the picker how many components it will have
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        
        tView.text = [regionalNames objectAtIndex:row];
        
        tView.textAlignment = NSTextAlignmentCenter;
        tView.font = [UIFont systemFontOfSize:20];
        tView.minimumScaleFactor = 0.2;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    return tView;
}

// tell the picker the title for a given component
/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    title = [regionalNames objectAtIndex:row];
    
    return title;
}*/

// tell the picker the width of each row for a given component
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int sectionWidth = 420;
    
    return sectionWidth;
}


/*****************************************
 ********* Other code resume *************
 *****************************************/

-(void)autoOn{
    autoYN = true;
    twoFingerUp.enabled = false;
    twoFingerDown.enabled = true;
    
    _autoTitleLbl.alpha = 0;
    _autoHighScoreLbl.alpha = 0;
    _autoMidScoreLbl.alpha = 0;
    _autoLowScoreLbl.alpha = 0;
    
    _teleopTitleLbl.alpha = 1;
    _teleopHighScoreLbl.alpha = 1;
    _teleopMidScoreLbl.alpha = 1;
    _teleopLowScoreLbl.alpha = 1;
    
    [UIView animateWithDuration:0.3 animations:^{
        _autoTitleLbl.alpha = 1;
        _autoHighScoreLbl.alpha = 1;
        _autoMidScoreLbl.alpha = 1;
        _autoLowScoreLbl.alpha = 1;
        
        _teleopTitleLbl.alpha = 0;
        _teleopHighScoreLbl.alpha = 0;
        _teleopMidScoreLbl.alpha = 0;
        _teleopLowScoreLbl.alpha = 0;
    }];
    
    NSLog(@"AUTO ON");
}
-(void)autoOff{
    autoYN = false;
    twoFingerUp.enabled = true;
    twoFingerDown.enabled = false;
    
    _autoTitleLbl.alpha = 1;
    _autoHighScoreLbl.alpha = 1;
    _autoMidScoreLbl.alpha = 1;
    _autoLowScoreLbl.alpha = 1;
    
    _teleopTitleLbl.alpha = 0;
    _teleopHighScoreLbl.alpha = 0;
    _teleopMidScoreLbl.alpha = 0;
    _teleopLowScoreLbl.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _autoTitleLbl.alpha = 0;
        _autoHighScoreLbl.alpha = 0;
        _autoMidScoreLbl.alpha = 0;
        _autoLowScoreLbl.alpha = 0;
        
        _teleopTitleLbl.alpha = 1;
        _teleopHighScoreLbl.alpha = 1;
        _teleopMidScoreLbl.alpha = 1;
        _teleopLowScoreLbl.alpha = 1;
    }];
    
    NSLog(@"AUTO OFF");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)highPlus:(id)sender {
    if (autoYN) {
        autoHighScore++;
        _autoHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)autoHighScore];
    }
    else{
        teleopHighScore++;
        _teleopHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)teleopHighScore];
    }
}

- (IBAction)highMinus:(id)sender {
    if (autoYN) {
        if (autoHighScore > 0) {
            autoHighScore--;
            _autoHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)autoHighScore];
        }
    }
    else{
        if (teleopHighScore > 0) {
            teleopHighScore--;
            _teleopHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)teleopHighScore];
    }
    }
    
}

- (IBAction)midPlus:(id)sender {
    if (autoYN) {
        autoMidScore++;
        _autoMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)autoMidScore];
    }
    else{
        teleopMidScore++;
        _teleopMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)teleopMidScore];
    }
    
}

- (IBAction)midMinus:(id)sender {
    if (autoYN) {
        if (autoMidScore > 0) {
            autoMidScore--;
            _autoMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)autoMidScore];
        }
    }
    else{
        if (teleopMidScore > 0) {
            teleopMidScore--;
            _teleopMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)teleopMidScore];
        }
    }
    
}

- (IBAction)lowPlus:(id)sender {
    if (autoYN) {
        autoLowScore++;
        _autoLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)autoLowScore];
    }
    else{
        teleopLowScore++;
        _teleopLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)teleopLowScore];
    }
}

- (IBAction)lowMinus:(id)sender {
    if (autoYN) {
        if (autoLowScore > 0) {
            autoLowScore--;
            _autoLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)autoLowScore];
        }
    }
    else{
        if (teleopLowScore > 0) {
            teleopLowScore--;
            _teleopLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)teleopLowScore];
        }
    }
    
}

- (IBAction)matchNumberEdit:(id)sender {
    _matchNumEdit.hidden = true;
    _matchNumEdit.enabled = false;
    _matchNumField.hidden = false;
    _matchNumField.enabled = true;
    _matchNumField.text = _matchNumEdit.titleLabel.text;
    [_matchNumField becomeFirstResponder];
}

- (IBAction)teamNumberEdit:(id)sender {
    _teamNumEdit.hidden = true;
    _teamNumEdit.enabled = false;
    _teamNumField.hidden = false;
    _teamNumField.enabled = true;
    _teamNumField.text = _teamNumEdit.titleLabel.text;
    _teamNumField.selected = true;
    [_teamNumField becomeFirstResponder];
}

- (IBAction)saveMatch:(id)sender {
    
    if (_matchNumEdit.isHidden) {
        currentMatchNum = _matchNumField.text;
    }
    else{
        currentMatchNum = _matchNumEdit.titleLabel.text;
    }
    
    if (_teamNumEdit.isHidden) {
        teamNum = teamNumField.text;
    }
    else{
        teamNum = _teamNumEdit.titleLabel.text;
    }
    
    if (currentMatchNum == nil || [currentMatchNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO MATCH NUMBER"
                                                       message: @"Please enter a match number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    else if (teamNum == nil || [teamNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO TEAM NUMBER"
                                                       message: @"Please enter a team number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        
        if ([pos  isEqualToString: @"Red 1"]) {
            if ([dataDict objectForKey:@"Red1"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red1"];
            }
            if ([[dataDict objectForKey:@"Red1"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Red1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                               [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                               [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                               [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                               [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                               [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                               [NSString stringWithString:teamNum], @"teamNum",
                                                               [NSString stringWithString:initials], @"initials",
                                                               [NSString stringWithString:currentRegional], @"regional",
                                                               nil] forKey:currentMatchNum];
                [self saveSuccess];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos  isEqualToString: @"Red 2"]) {
            if ([dataDict objectForKey:@"Red2"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red2"];
            }
            if ([[dataDict objectForKey:@"Red2"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Red2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                            [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                            [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                            [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                            [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                            [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            [NSString stringWithString:initials], @"initials",
                                                            [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos  isEqualToString: @"Red 3"]) {
            if ([dataDict objectForKey:@"Red3"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red3"];
            }
            if ([[dataDict objectForKey:@"Red3"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Red3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                            [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                            [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                            [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                            [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                            [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            [NSString stringWithString:initials], @"initials",
                                                            [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 1"]) {
            if ([dataDict objectForKey:@"Blue1"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue1"];
            }
            if ([[dataDict objectForKey:@"Blue1"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Blue1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSString stringWithString:teamNum], @"teamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 2"]) {
            if ([dataDict objectForKey:@"Blue2"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue2"];
            }
            if ([[dataDict objectForKey:@"Blue2"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Blue2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSString stringWithString:teamNum], @"teamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 3"]) {
            if ([dataDict objectForKey:@"Blue3"] == nil) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue3"];
            }
            if ([[dataDict objectForKey:@"Blue3"] objectForKey:currentMatchNum] == nil) {
                [[dataDict objectForKey:@"Blue3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSString stringWithString:teamNum], @"teamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
                [self autoOn];
            }
            else{
                [self overWriteAlert];
            }
        }
        NSLog(@"%@", dataDict);
        [dataDict writeToFile:path atomically:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([pos isEqualToString:@"Red 1"]) {
            [[dataDict objectForKey:@"Red1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSString stringWithString:teamNum], @"teamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if([pos isEqualToString:@"Red 2"]){
            [[dataDict objectForKey:@"Red2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSString stringWithString:teamNum], @"teamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if([pos isEqualToString:@"Red 3"]){
            [[dataDict objectForKey:@"Red3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSString stringWithString:teamNum], @"teamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 1"]){
            [[dataDict objectForKey:@"Blue1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSString stringWithString:teamNum], @"teamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 2"]){
            [[dataDict objectForKey:@"Blue2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSString stringWithString:teamNum], @"teamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 3"]){
            [[dataDict objectForKey:@"Blue3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSString stringWithString:teamNum], @"teamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
      NSLog(@"%@", dataDict);
    }
}

-(void)overWriteAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"MATCH ALREADY EXISTS"
                                                   message: @"Did you mean a different match number? Or would you like to overwrite the existing match?"
                                                  delegate: self
                                         cancelButtonTitle:@"Different Match Number"
                                         otherButtonTitles:@"Overwrite",nil];
    [alert show];
}

-(void)saveSuccess{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Success!"
                                                   message: @"You have saved the match!"
                                                  delegate: nil
                                         cancelButtonTitle:@"Cool story bro."
                                         otherButtonTitles:nil];
    [alert show];
    
    teleopHighScore = 0;
    _teleopHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)teleopHighScore];
    autoHighScore = 0;
    _autoHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)autoHighScore];
    teleopMidScore = 0;
    _teleopMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)teleopMidScore];
    autoMidScore = 0;
    _autoMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)autoMidScore];
    teleopLowScore = 0;
    _teleopLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)teleopLowScore];
    autoLowScore = 0;
    _autoLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)autoLowScore];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [_matchNumField resignFirstResponder];
    [_teamNumField resignFirstResponder];
    [teamNumField resignFirstResponder];
    [matchNumField resignFirstResponder];
    [initialsField resignFirstResponder];
}
    










@end
