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

NSInteger highScore;
NSInteger midScore;
NSInteger lowScore;

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
    //bogus test
    
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
    [twoFingerUp setDelaysTouchesBegan:YES];
    [twoFingerUp setDelaysTouchesEnded:YES];
    [self.view addGestureRecognizer:twoFingerUp];
    
    twoFingerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOff)];
    [twoFingerDown setNumberOfTouchesRequired:2];
    [twoFingerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [twoFingerDown setDelaysTouchesBegan:YES];
    [self.view addGestureRecognizer:twoFingerDown];
    
    regionalNames = @[@"Greater KC Regional", @"Cincinnati Regional", @"Cooler Than the Coolest Regional", @"Greater Division District", @"Divide by Zero Regional", @"Razorback Regional", @"Bayou Regional", @"World Champs"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:0.3];
    [self setUpScreen];
    
}

-(void)setUpScreen{
    if (initials == nil) {
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
        
        UIButton *saveSetupButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [saveSetupButton addTarget:self action:@selector(eraseSetUpScreen) forControlEvents:UIControlEventTouchUpInside];
        [saveSetupButton setTitle:@"Save Settings" forState:UIControlStateNormal];
        saveSetupButton.frame = CGRectMake(254, 640, 120, 30);
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
                         }];
        NSLog(@"\n Position: %@ \n Initials: %@ \n Scout Team Number: %@ \n Regional Title: %@ \n Match Number: %@", pos, initials, scoutTeamNum, currentRegional, currentMatchNum);
    }
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

// tell the picker the title for a given component
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    title = [regionalNames objectAtIndex:row];
    
    return title;
}

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [_header setBarTintColor:[UIColor whiteColor]];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(160/255.0) blue:(55/255.0) alpha:1]];
        [_header setBarTintColor:[UIColor colorWithRed:(255/255.0) green:(160/255.0) blue:(55/255.0) alpha:1]];
    }];
    
    NSLog(@"AUTO ON");
}
-(void)autoOff{
    autoYN = false;
    [self.view setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(160/255.0) blue:(55/255.0) alpha:1]];
    [_header setBarTintColor:[UIColor colorWithRed:(255/255.0) green:(160/255.0) blue:(55/255.0) alpha:1]];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [_header setBarTintColor:[UIColor whiteColor]];
    }];
    
    NSLog(@"AUTO OFF");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)highPlus:(id)sender {
    highScore++;
    _highScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)highScore];
}

- (IBAction)highMinus:(id)sender {
    if (highScore > 0) {
        highScore--;
        _highScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)highScore];
    }
}

- (IBAction)midPlus:(id)sender {
    midScore++;
    _midScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)midScore];
}

- (IBAction)midMinus:(id)sender {
    if (midScore > 0) {
        midScore--;
        _midScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)midScore];
    }
}

- (IBAction)lowPlus:(id)sender {
    lowScore++;
    _lowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)lowScore];
}

- (IBAction)lowMinus:(id)sender {
    if (lowScore > 0) {
        lowScore--;
        _lowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)lowScore];
    }
}

- (IBAction)saveMatch:(id)sender {
    
    currentMatchNum = _matchNumField.text;
    teamNum = _teamNumField.text;
    
    if (currentMatchNum == nil || [currentMatchNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO MATCH NUMBER"
                                                       message: @"Please enter a match number for this bogus match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    else if (teamNum == nil || [teamNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO TEAM NUMBER"
                                                       message: @"Please enter a team number for this bogus match."
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
                                                               [NSNumber numberWithInteger:highScore], @"highScore",
                                                               [NSNumber numberWithInteger:midScore], @"midScore",
                                                               [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                               [NSString stringWithString:teamNum], @"teamNum",
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
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
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
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
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
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
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
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
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
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
                [self saveSuccess];
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
    initials = [[alertView textFieldAtIndex:0] text];
    if (initials.length != 3) {
        UIAlertView *initialsAlert = [[UIAlertView alloc] initWithTitle:@"Really?" message:@"Come on dude, just enter your three initials. It's not that difficult." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        initialsAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    if (buttonIndex == 1) {
        NSLog(@"Entered Button Chooser");
        if ([pos isEqualToString:@"Red 1"]) {
            [[dataDict objectForKey:@"Red1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if([pos isEqualToString:@"Red 2"]){
            [[dataDict objectForKey:@"Red2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if([pos isEqualToString:@"Red 3"]){
            [[dataDict objectForKey:@"Red3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 1"]){
            [[dataDict objectForKey:@"Blue1"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 2"]){
            [[dataDict objectForKey:@"Blue2"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
                                                            nil] forKey:currentMatchNum];
            [self saveSuccess];
        }
        else if ([pos isEqualToString:@"Blue 3"]){
            [[dataDict objectForKey:@"Blue3"] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:highScore], @"highScore",
                                                            [NSNumber numberWithInteger:midScore], @"midScore",
                                                            [NSNumber numberWithInteger:lowScore], @"lowScore",
                                                            [NSString stringWithString:teamNum], @"teamNum",
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
    
    highScore = 0;
    _highScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)highScore];
    midScore = 0;
    _midScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)midScore];
    lowScore = 0;
    _lowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)lowScore];
    
    _matchNumField.text = @"";
    _teamNumField.text = @"";
}

- (IBAction)hideKeyboard:(id)sender {
    [_matchNumField resignFirstResponder];
    [_teamNumField resignFirstResponder];
    [teamNumField resignFirstResponder];
    [matchNumField resignFirstResponder];
    [initialsField resignFirstResponder];
}
    










@end
