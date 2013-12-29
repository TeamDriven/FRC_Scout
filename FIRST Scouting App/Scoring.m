//
//  LocationsFirstViewController.m
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Scoring.h"
#import "Foundation/Foundation.h"
#import "CoreData/CoreData.h"
#import "Recorder.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"

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
NSInteger smallPenaltyTally;
NSInteger largePenaltyTally;

NSString *initials;
NSString *scoutTeamNum;
NSString *currentMatchNum;
NSString *currentTeamNum;
NSString *currentRegional;

NSString *currentMatchType;

NSArray *paths;
NSString *scoutingDirectory;
NSString *path;
NSMutableDictionary *dataDict;

NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSString *pos;

UISwipeGestureRecognizer *twoFingerUp;
UISwipeGestureRecognizer *twoFingerDown;

UIControl *greyOut;
UIControl *setUpView;
UISegmentedControl *red1Selector;
NSInteger red1Pos;
UITextField *currentMatchNumField;
UISegmentedControl *matchTypeSelector;
NSAttributedString *currentMatchNumAtString;
UITextField *scoutTeamNumField;
NSAttributedString *currentTeamNumAtString;
UITextField *initialsField;
UIPickerView *regionalPicker;
UISegmentedControl *weekSelector;
NSInteger weekSelected;

NSArray *regionalNames;
NSArray *week1Regionals;
NSArray *week2Regionals;
NSArray *week3Regionals;
NSArray *week4Regionals;
NSArray *week5Regionals;
NSArray *week6Regionals;
NSArray *week7Regionals;
NSArray *allWeekRegionals;

Team *teamWithDuplicate;
Match *duplicateMatch;

-(void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    FSAfileManager = [NSFileManager defaultManager];
    FSAdocumentsDirectory = [[FSAfileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    FSAdocumentName = @"FSA";
    FSApathurl = [FSAdocumentsDirectory URLByAppendingPathComponent:FSAdocumentName];
    FSAdocument = [[UIManagedDocument alloc] initWithFileURL:FSApathurl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FSApathurl path]]) {
        [FSAdocument openWithCompletionHandler:^(BOOL success){
            if (success) NSLog(@"Found the document!");
            if (!success) NSLog(@"Couldn't find the document at path: %@", FSApathurl);
        }];
    }
    else{
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) NSLog(@"Created the document!");
            if (!success) NSLog(@"Couldn't create the document at path: %@", FSApathurl);
        }];
    }
    
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    scoutingDirectory = [paths objectAtIndex:0];
    path = [scoutingDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"] toPath:path error:nil];
    }
    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    self.matchNumField.delegate = self;
    self.teamNumField.delegate = self;
    
    twoFingerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOn)];
    [twoFingerUp setNumberOfTouchesRequired:2];
    [twoFingerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:twoFingerUp];
    
    
    twoFingerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOff)];
    [twoFingerDown setNumberOfTouchesRequired:2];
    [twoFingerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:twoFingerDown];
    
    red1Pos = -1;
    
    autoYN = true;
    
    _saveBtn.layer.cornerRadius = 5;
    
    regionalNames = @[@"Central Illinois Regional",@"Palmetto Regional",@"Alamo Regional",@"Greater Toronto West Regional",@"Inland Empire Regional",@"Center Line District Competition",@"Southfield District Competition",@"Granite State District Event",@"PNW Auburn Mountainview District Event",@"MAR Mt. Olive District Competition",@"MAR Hatboro-Horsham District Comp.",@"Israel Regional",@"Greater Toronto East Regional",@"Arkansas Regional",@"San Diego Regional",@"Crossroads Regional",@"Lake Superior Regional",@"Northern Lights Regional",@"Hub City Regional",@"UNH District Event",@"Central Valley Regional",@"Kettering University District Competition",@"Gull Lake District Competition",@"PNW Oregon City District Event",@"PNW Glacier Peak District Event",@"Groton District Event",@"Mexico City Regional",@"Sacramento Regional",@"Orlando Regional",@"Greater Kansas City Regional",@"St. Louis Regional",@"North Carolina Regional",@"New York Tech Valley Regional",@"Dallas Regional",@"Utah Regional",@"WPI District Event",@"Escanaba District Competition",@"Howell District Competition",@"MAR Springside Chestnut Hill District Comp.",@"PNW Eastern Wash. University District Event",@"PNW Mt. Vernon District Event",@"MAR Clifton District Competition",@"Waterloo Regional",@"Festival de Robotique FRC a Montreal Regional",@"Arizona Regional",@"Los Angeles Regional",@"Boilermaker Regional",@"Buckeye Regional",@"Virginia Regional",@"Wisconsin Regional",@"West Michigan District Competition",@"Great Lakes Bay Region District Competition",@"Traverse City District Competition",@"PNW Wilsonville District Event",@"Rhode Island District Event",@"PNW Shorewood District Event",@"Southington District Event",@"MAR Lenape-Seneca District Competition",@"North Bay Regional",@"Peachtree Regional",@"Hawaii Regional",@"Minnesota 10000 Lakes Regional",@"Minnesota North Star Regional",@"SBPLI Long Island Regional",@"Finger Lakes Regional",@"Queen City Regional",@"Oklahoma Regional",@"Greater Pittsburgh Regional",@"Smoky Mountains Regional",@"Greater DC Regional",@"Northeastern University District Event",@"Livonia District Competition",@"St. Joseph District Competition",@"Waterford District Competition",@"PNW Auburn District Event",@"PNW Central Wash. University District Event",@"Hartford District Event",@"MAR Bridgewater-Raritan District Competition",@"Western Canada Regional",@"Windsor Essex Great Lakes Regional",@"Silicon Valley Regional",@"Colorado Regional",@"South Florida Regional",@"Midwest Regional",@"Bayou Regional",@"Chesapeake Regional",@"Las Vegas Regional",@"New York City Regional",@"Lone Star Regional",@"Pine Tree District Event",@"Bedford District Competition",@"Troy District Competition",@"PNW Oregon State University District Event",@"New England FRC Region Championship",@"Michigan FRC State Championship",@"Autodesk PNW FRC Championship",@"Mid-Atlantic Robotics FRC Region Championship",@"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
   
    week1Regionals = @[@"Central Illinois Regional",@"Palmetto Regional",@"Alamo Regional",@"Greater Toronto West Regional",@"Inland Empire Regional",@"Center Line District Competition",@"Southfield District Competition",@"Granite State District Event",@"PNW Auburn Mountainview District Event",@"MAR Mt. Olive District Competition",@"MAR Hatboro-Horsham District Comp.",@"Israel Regional"];
    
    week2Regionals = @[@"Greater Toronto East Regional",@"Arkansas Regional",@"San Diego Regional",@"Crossroads Regional",@"Lake Superior Regional",@"Northern Lights Regional",@"Hub City Regional",@"UNH District Event",@"Central Valley Regional",@"Kettering University District Competition",@"Gull Lake District Competition",@"PNW Oregon City District Event",@"PNW Glacier Peak District Event",@"Groton District Event"];
    
    week3Regionals = @[@"Mexico City Regional",@"Sacramento Regional",@"Orlando Regional",@"Greater Kansas City Regional",@"St. Louis Regional",@"North Carolina Regional",@"New York Tech Valley Regional",@"Dallas Regional",@"Utah Regional",@"WPI District Event",@"Escanaba District Competition",@"Howell District Competition",@"MAR Springside Chestnut Hill District Comp.",@"PNW Eastern Wash. University District Event",@"PNW Mt. Vernon District Event",@"MAR Clifton District Competition"];
    
    week4Regionals = @[@"Waterloo Regional",@"Festival de Robotique FRC a Montreal Regional",@"Arizona Regional",@"Los Angeles Regional",@"Boilermaker Regional",@"Buckeye Regional",@"Virginia Regional",@"Wisconsin Regional",@"West Michigan District Competition",@"Great Lakes Bay Region District Competition",@"Traverse City District Competition",@"PNW Wilsonville District Event",@"Rhode Island District Event",@"PNW Shorewood District Event",@"Southington District Event",@"MAR Lenape-Seneca District Competition"];
    
    week5Regionals = @[@"North Bay Regional",@"Peachtree Regional",@"Hawaii Regional",@"Minnesota 10000 Lakes Regional",@"Minnesota North Star Regional",@"SBPLI Long Island Regional",@"Finger Lakes Regional",@"Queen City Regional",@"Oklahoma Regional",@"Greater Pittsburgh Regional",@"Smoky Mountains Regional",@"Greater DC Regional",@"Northeastern University District Event",@"Livonia District Competition",@"St. Joseph District Competition",@"Waterford District Competition",@"PNW Auburn District Event",@"PNW Central Wash. University District Event",@"Hartford District Event",@"MAR Bridgewater-Raritan District Competition"];
    
    week6Regionals = @[@"Western Canada Regional",@"Windsor Essex Great Lakes Regional",@"Silicon Valley Regional",@"Colorado Regional",@"South Florida Regional",@"Midwest Regional",@"Bayou Regional",@"Chesapeake Regional",@"Las Vegas Regional",@"New York City Regional",@"Lone Star Regional",@"Pine Tree District Event",@"Bedford District Competition",@"Troy District Competition",@"PNW Oregon State University District Event"];
    
    week7Regionals = @[@"New England FRC Region Championship",@"Michigan FRC State Championship",@"Autodesk PNW FRC Championship",@"Mid-Atlantic Robotics FRC Region Championship",@"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
    
    allWeekRegionals = @[regionalNames,week1Regionals,week2Regionals,week3Regionals,week4Regionals,week5Regionals,week6Regionals,week7Regionals];
    
    weekSelected = 0;
    
    currentMatchType = @"Q";
    
    _teleopHighMinusBtn.alpha = 0;
    _teleopHighMinusBtn.enabled = false;
    _teleopHighPlusBtn.alpha = 0;
    _teleopHighPlusBtn.enabled = false;
    _teleopMidMinusBtn.alpha = 0;
    _teleopMidMinusBtn.enabled = false;
    _teleopMidPlusBtn.alpha = 0;
    _teleopMidPlusBtn.enabled = false;
    _teleopLowMinusBtn.alpha = 0;
    _teleopLowMinusBtn.enabled = false;
    _teleopLowPlusBtn.alpha = 0;
    _teleopLowPlusBtn.enabled = false;
    
    _autoHighMinusBtn.alpha = 1;
    _autoHighMinusBtn.enabled = true;
    _autoHighPlusBtn.alpha = 1;
    _autoHighPlusBtn.enabled = true;
    _autoMidMinusBtn.alpha = 1;
    _autoMidMinusBtn.enabled = true;
    _autoMidPlusBtn.alpha = 1;
    _autoMidPlusBtn.enabled = true;
    _autoLowMinusBtn.alpha = 1;
    _autoLowMinusBtn.enabled = true;
    _autoLowPlusBtn.alpha = 1;
    _autoLowPlusBtn.enabled = true;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:0.3];
    [self setUpScreen];
    [self autoOn];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setUpScreen{
    if (initials == nil && !setUpView.superview) {
        
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
        
        CGRect red1SelectorRect = CGRectMake(124, 130, 380, 30);
        red1Selector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red 1", @"Red 2", @"Red 3", @"Blue 1", @"Blue 2", @"Blue 3",  nil]];
        [red1Selector setFrame:red1SelectorRect];
        [setUpView addSubview:red1Selector];
        red1Selector.selectedSegmentIndex = red1Pos;
        NSLog(@"Red 1 Pos: %ld", (long)red1Pos);
        
        CGRect initialsFieldLblRect = CGRectMake(129, 190, 100, 15);
        UILabel *initialsFieldLbl = [[UILabel alloc] initWithFrame:initialsFieldLblRect];
        initialsFieldLbl.textAlignment = NSTextAlignmentCenter;
        initialsFieldLbl.text = @"Enter YOUR three initials";
        initialsFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:initialsFieldLbl];
        
        CGRect initialsFieldRect = CGRectMake(114, 210, 130, 40);
        initialsField = [[UITextField alloc] initWithFrame:initialsFieldRect];
        [initialsField setBorderStyle:UITextBorderStyleRoundedRect];
        [initialsField setFont:[UIFont systemFontOfSize:15]];
        [initialsField setPlaceholder:@"3 Initials"];
        [initialsField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [initialsField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [initialsField setKeyboardType:UIKeyboardTypeDefault];
        [initialsField setReturnKeyType:UIReturnKeyDone];
        [initialsField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [initialsField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [initialsField setTextAlignment:NSTextAlignmentCenter];
        [initialsField setDelegate:self];
        [setUpView addSubview:initialsField];
        
        CGRect scoutTeamNumFieldLblRect = CGRectMake(264, 190, 100, 15);
        UILabel *scoutTeamNumFieldLbl = [[UILabel alloc] initWithFrame:scoutTeamNumFieldLblRect];
        scoutTeamNumFieldLbl.textAlignment = NSTextAlignmentCenter;
        scoutTeamNumFieldLbl.text = @"Enter YOUR team number";
        scoutTeamNumFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:scoutTeamNumFieldLbl];
        
        CGRect scoutTeamNumFieldRect = CGRectMake(264, 210, 100, 40);
        scoutTeamNumField = [[UITextField alloc] initWithFrame:scoutTeamNumFieldRect];
        [scoutTeamNumField addTarget:self action:@selector(checkNumber) forControlEvents:UIControlEventEditingChanged];
        [scoutTeamNumField setBorderStyle:UITextBorderStyleRoundedRect];
        [scoutTeamNumField setFont:[UIFont systemFontOfSize:15]];
        [scoutTeamNumField setPlaceholder:@"Your Team #"];
        [scoutTeamNumField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [scoutTeamNumField setKeyboardType:UIKeyboardTypeNumberPad];
        [scoutTeamNumField setReturnKeyType:UIReturnKeyDone];
        [scoutTeamNumField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [scoutTeamNumField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [scoutTeamNumField setTextAlignment:NSTextAlignmentCenter];
        [scoutTeamNumField setDelegate:self];
        [setUpView addSubview:scoutTeamNumField];
        if (scoutTeamNum) {
            scoutTeamNumField.text = scoutTeamNum;
        }
        
        CGRect currentMatchNumFieldLblRect = CGRectMake(384, 190, 130, 15);
        UILabel *currentMatchNumFieldLbl = [[UILabel alloc] initWithFrame:currentMatchNumFieldLblRect];
        currentMatchNumFieldLbl.textAlignment = NSTextAlignmentCenter;
        currentMatchNumFieldLbl.text = @"Enter the current match number";
        currentMatchNumFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:currentMatchNumFieldLbl];
        
        CGRect currentMatchNumFieldRect = CGRectMake(384, 210, 130, 40);
        currentMatchNumField = [[UITextField alloc] initWithFrame:currentMatchNumFieldRect];
        [currentMatchNumField addTarget:self action:@selector(checkNumber) forControlEvents:UIControlEventEditingChanged];
        [currentMatchNumField setBorderStyle:UITextBorderStyleRoundedRect];
        [currentMatchNumField setFont:[UIFont systemFontOfSize:15]];
        [currentMatchNumField setPlaceholder:@"Current Match #"];
        [currentMatchNumField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [currentMatchNumField setKeyboardType:UIKeyboardTypeNumberPad];
        [currentMatchNumField setReturnKeyType:UIReturnKeyDone];
        [currentMatchNumField setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [currentMatchNumField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [currentMatchNumField setTextAlignment:NSTextAlignmentCenter];
        [currentMatchNumField setDelegate:self];
        [setUpView addSubview:currentMatchNumField];
        
        CGRect matchTypeSelectorRect = CGRectMake(364, 255, 170, 30);
        matchTypeSelector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Qualification", @"Elimination", nil]];
        matchTypeSelector.frame = matchTypeSelectorRect;
        [matchTypeSelector addTarget:self action:@selector(changeMatchType) forControlEvents:UIControlEventValueChanged];
        [setUpView addSubview:matchTypeSelector];
        matchTypeSelector.selectedSegmentIndex = 0;
        matchTypeSelector.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        
        CGRect weekSelectorLblRect = CGRectMake(54, 310, 30, 30);
        UILabel *weekSelectorLbl = [[UILabel alloc] initWithFrame:weekSelectorLblRect];
        weekSelectorLbl.textAlignment = NSTextAlignmentCenter;
        weekSelectorLbl.text = @"Week";
        weekSelectorLbl.adjustsFontSizeToFitWidth = YES;
        weekSelectorLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [setUpView addSubview:weekSelectorLbl];
        
        CGRect weekSelectorRect = CGRectMake(-39, 433, 215, 30);
        weekSelector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All",@"1", @"2", @"3", @"4", @"5", @"6", @"7+",  nil]];
        [weekSelector setFrame:weekSelectorRect];
        [weekSelector addTarget:self action:@selector(changeWeek) forControlEvents:UIControlEventValueChanged];
        [setUpView addSubview:weekSelector];
        weekSelector.transform = CGAffineTransformMakeRotation(M_PI/2.0);
        NSArray *arr = [weekSelector subviews];
        for (int i = 0; i < [arr count]; i++) {
            UIView *v = (UIView*) [arr objectAtIndex:i];
            NSArray *subarr = [v subviews];
            for (int j = 0; j < [subarr count]; j++) {
                if ([[subarr objectAtIndex:j] isKindOfClass:[UILabel class]]) {
                    UILabel *l = (UILabel*) [subarr objectAtIndex:j];
                    l.transform = CGAffineTransformMakeRotation(- M_PI / 2.0);
                }
            }
        }
        weekSelector.selectedSegmentIndex = weekSelected;
        
        
        CGRect regionalPickerLblRect = CGRectMake(194, 305, 240, 30);
        UILabel *regionalPickerLbl = [[UILabel alloc] initWithFrame:regionalPickerLblRect];
        [regionalPickerLbl setFont:[UIFont systemFontOfSize:18]];
        regionalPickerLbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [regionalPickerLbl setTextAlignment:NSTextAlignmentCenter];
        [regionalPickerLbl setText:@"Select the event you are at"];
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
        saveSetupButton.layer.cornerRadius = 5;
        
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

-(void)checkNumber{
    if (scoutTeamNumField.isEditing) {
        NSMutableString *txt1 = [[NSMutableString alloc] initWithString:scoutTeamNumField.text];
        for (unsigned int i = 0; i < [txt1 length]; i++) {
            NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt1 characterAtIndex:i]];
            if ([character integerValue] == 0 && ![character isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Numbers only please!"
                                                               message: @"Please only enter numbers in the \"Your Team Number\" text field"
                                                              delegate: self
                                                     cancelButtonTitle:@"Sorry..."
                                                     otherButtonTitles:nil];
                [alert show];
                [txt1 deleteCharactersInRange:NSMakeRange(i, 1)];
                scoutTeamNumField.text = [[NSString alloc] initWithString:txt1];
            }
        }
    }
    if (currentMatchNumField.isEditing) {
        NSMutableString *txt2 = [[NSMutableString alloc] initWithString:currentMatchNumField.text];
        for (unsigned int i = 0; i < [txt2 length]; i++) {
            NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt2 characterAtIndex:i]];
            if ([character integerValue] == 0 && ![character isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Numbers only please!"
                                                               message: @"Please only enter numbers in the \"Current Match Number\" text field"
                                                              delegate: self
                                                     cancelButtonTitle:@"Sorry..."
                                                     otherButtonTitles:nil];
                [alert show];
                [txt2 deleteCharactersInRange:NSMakeRange(i, 1)];
                currentMatchNumField.text = [[NSString alloc] initWithString:txt2];
            }
        }
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
    scoutTeamNum = scoutTeamNumField.text;
    NSInteger randomTeamNum = arc4random() % 4000;
    currentTeamNum = [[NSString alloc] initWithFormat:@"%ld", (long)randomTeamNum];
    currentMatchNum = currentMatchNumField.text;
    currentRegional = [[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex] objectAtIndex:[regionalPicker selectedRowInComponent:0]];
    
    if (!initials || initials.length != 3) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You didn't enter 3 initials!"
                                                       message: @"Please enter your three initials to show that you are scouting these matches"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (scoutTeamNumField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Enter your team number!"
                                                       message: @"Enter the team number of the team that you are on"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (!currentMatchNum || currentMatchNumField.text.length == 0){
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
                             
                             
                             currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
                             [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
                             _matchNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             
                             currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
                             [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
                             _teamNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             _initialsLbl.text = [[NSString alloc] initWithFormat:@"Your Initials: %@", initials];
                             
                             _regionalNameLbl.text = currentRegional;
                             _regionalNameLbl.numberOfLines = 0;
                             [_regionalNameLbl sizeToFit];
                             _regionalNameLbl.adjustsFontSizeToFitWidth = YES;
                             _regionalNameLbl.textAlignment = NSTextAlignmentCenter;
                             _regionalNameLbl.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
                             _regionalNameLbl.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
                             _regionalNameLbl.layer.borderWidth = 1.0;
                             
                             twoFingerDown.enabled = true;
                             
                             CGRect red1Rect = CGRectMake(282, 150, 200, 60);
                             UILabel *red1Lbl = [[UILabel alloc] initWithFrame:red1Rect];
                             red1Lbl.text = pos;
                             red1Lbl.font = [UIFont boldSystemFontOfSize:25];
                             red1Lbl.textColor = [UIColor whiteColor];
                             red1Lbl.textAlignment = NSTextAlignmentCenter;
                             red1Lbl.layer.cornerRadius = 5;
                             if (red1Selector.selectedSegmentIndex < 3) {
                                 red1Lbl.backgroundColor = [UIColor redColor];
                             }
                             else{
                                 red1Lbl.backgroundColor = [UIColor blueColor];
                             }
                             [self.view addSubview:red1Lbl];
                             
                             red1Pos = red1Selector.selectedSegmentIndex;
                         }];
        NSLog(@"\n Position: %@ \n Initials: %@ \n Scout Team Number: %@ \n Regional Title: %@ \n Match Number: %@", pos, initials, scoutTeamNum, currentRegional, currentMatchNum);
    }
}

-(IBAction)reSignIn:(id)sender {
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //handle selection
}

// tell the picker how many rows are available for a given component
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numRows;
    if (weekSelector.selectedSegmentIndex == 0) {
        numRows = regionalNames.count;
    }
    else if (weekSelector.selectedSegmentIndex == 1){
        numRows = week1Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 2){
        numRows = week2Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 3){
        numRows = week3Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 4){
        numRows = week4Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 5){
        numRows = week5Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 6){
        numRows = week6Regionals.count;
    }
    else{
        numRows = week7Regionals.count;
    }
    
    return numRows;
}

// tell the picker how many components it will have
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// give the picker its source of list items
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        
        if (weekSelector.selectedSegmentIndex == 0) {
            tView.text = [regionalNames objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 1){
            tView.text = [week1Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 2){
            tView.text = [week2Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 3){
            tView.text = [week3Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 4){
            tView.text = [week4Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 5){
            tView.text = [week5Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 6){
            tView.text = [week6Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 7){
            tView.text = [week7Regionals objectAtIndex:row];
        }
        
        tView.textAlignment = NSTextAlignmentCenter;
        tView.font = [UIFont systemFontOfSize:20];
        tView.minimumScaleFactor = 0.2;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    return tView;
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
    
    _smallPenaltyLbl.enabled = true;
    _smallPenaltyStepper.enabled = true;
    _smallPenaltyStepper.tintColor = [UIColor redColor];
    _smallPenaltyStepper.alpha = 1;
    _smallPenaltyTitleLbl.enabled = true;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
    
    _largePenaltyLbl.enabled = true;
    _largePenaltyStepper.enabled = true;
    _largePenaltyStepper.tintColor = [UIColor redColor];
    _largePenaltyStepper.alpha = 1;
    _largePenaltyTitleLbl.enabled = true;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
    
    _teleopHighMinusBtn.alpha = 1;
    _teleopHighMinusBtn.enabled = true;
    _teleopHighPlusBtn.alpha = 1;
    _teleopHighPlusBtn.enabled = true;
    _teleopMidMinusBtn.alpha = 1;
    _teleopMidMinusBtn.enabled = true;
    _teleopMidPlusBtn.alpha = 1;
    _teleopMidPlusBtn.enabled = true;
    _teleopLowMinusBtn.alpha = 1;
    _teleopLowMinusBtn.enabled = true;
    _teleopLowPlusBtn.alpha = 1;
    _teleopLowPlusBtn.enabled = true;
    
    _autoHighMinusBtn.alpha = 0;
    _autoHighMinusBtn.enabled = false;
    _autoHighPlusBtn.alpha = 0;
    _autoHighPlusBtn.enabled = false;
    _autoMidMinusBtn.alpha = 0;
    _autoMidMinusBtn.enabled = false;
    _autoMidPlusBtn.alpha = 0;
    _autoMidPlusBtn.enabled = false;
    _autoLowMinusBtn.alpha = 0;
    _autoLowMinusBtn.enabled = false;
    _autoLowPlusBtn.alpha = 0;
    _autoLowPlusBtn.enabled = false;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _autoTitleLbl.alpha = 1;
        _autoHighScoreLbl.alpha = 1;
        _autoMidScoreLbl.alpha = 1;
        _autoLowScoreLbl.alpha = 1;
        
        _teleopTitleLbl.alpha = 0;
        _teleopHighScoreLbl.alpha = 0;
        _teleopMidScoreLbl.alpha = 0;
        _teleopLowScoreLbl.alpha = 0;
        
        _smallPenaltyLbl.enabled = false;
        _smallPenaltyStepper.enabled = false;
        _smallPenaltyStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _smallPenaltyTitleLbl.enabled = false;
        
        _largePenaltyLbl.enabled = false;
        _largePenaltyStepper.enabled = false;
        _largePenaltyStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _largePenaltyTitleLbl.enabled = false;
        
        _teleopHighMinusBtn.alpha = 0;
        _teleopHighMinusBtn.enabled = false;
        _teleopHighPlusBtn.alpha = 0;
        _teleopHighPlusBtn.enabled = false;
        _teleopMidMinusBtn.alpha = 0;
        _teleopMidMinusBtn.enabled = false;
        _teleopMidPlusBtn.alpha = 0;
        _teleopMidPlusBtn.enabled = false;
        _teleopLowMinusBtn.alpha = 0;
        _teleopLowMinusBtn.enabled = false;
        _teleopLowPlusBtn.alpha = 0;
        _teleopLowPlusBtn.enabled = false;
        
        _autoHighMinusBtn.alpha = 1;
        _autoHighMinusBtn.enabled = true;
        _autoHighPlusBtn.alpha = 1;
        _autoHighPlusBtn.enabled = true;
        _autoMidMinusBtn.alpha = 1;
        _autoMidMinusBtn.enabled = true;
        _autoMidPlusBtn.alpha = 1;
        _autoMidPlusBtn.enabled = true;
        _autoLowMinusBtn.alpha = 1;
        _autoLowMinusBtn.enabled = true;
        _autoLowPlusBtn.alpha = 1;
        _autoLowPlusBtn.enabled = true;
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
    
    _smallPenaltyLbl.enabled = false;
    _smallPenaltyStepper.enabled = false;
    _smallPenaltyStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _smallPenaltyTitleLbl.enabled = false;
    
    _largePenaltyLbl.enabled = false;
    _largePenaltyStepper.enabled = false;
    _largePenaltyStepper.tintColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _largePenaltyTitleLbl.enabled = false;
    
    _teleopHighMinusBtn.alpha = 0;
    _teleopHighMinusBtn.enabled = false;
    _teleopHighPlusBtn.alpha = 0;
    _teleopHighPlusBtn.enabled = false;
    _teleopMidMinusBtn.alpha = 0;
    _teleopMidMinusBtn.enabled = false;
    _teleopMidPlusBtn.alpha = 0;
    _teleopMidPlusBtn.enabled = false;
    _teleopLowMinusBtn.alpha = 0;
    _teleopLowMinusBtn.enabled = false;
    _teleopLowPlusBtn.alpha = 0;
    _teleopLowPlusBtn.enabled = false;
    
    _autoHighMinusBtn.alpha = 1;
    _autoHighMinusBtn.enabled = true;
    _autoHighPlusBtn.alpha = 1;
    _autoHighPlusBtn.enabled = true;
    _autoMidMinusBtn.alpha = 1;
    _autoMidMinusBtn.enabled = true;
    _autoMidPlusBtn.alpha = 1;
    _autoMidPlusBtn.enabled = true;
    _autoLowMinusBtn.alpha = 1;
    _autoLowMinusBtn.enabled = true;
    _autoLowPlusBtn.alpha = 1;
    _autoLowPlusBtn.enabled = true;
    
    [UIView animateWithDuration:0.3 animations:^{
        _autoTitleLbl.alpha = 0;
        _autoHighScoreLbl.alpha = 0;
        _autoMidScoreLbl.alpha = 0;
        _autoLowScoreLbl.alpha = 0;
        
        _teleopTitleLbl.alpha = 1;
        _teleopHighScoreLbl.alpha = 1;
        _teleopMidScoreLbl.alpha = 1;
        _teleopLowScoreLbl.alpha = 1;
        
        _smallPenaltyLbl.enabled = true;
        _smallPenaltyStepper.enabled = true;
        _smallPenaltyStepper.tintColor = [UIColor redColor];
        _smallPenaltyStepper.alpha = 1;
        _smallPenaltyTitleLbl.enabled = true;
        
        _largePenaltyLbl.enabled = true;
        _largePenaltyStepper.enabled = true;
        _largePenaltyStepper.tintColor = [UIColor redColor];
        _largePenaltyStepper.alpha = 1;
        _largePenaltyTitleLbl.enabled = true;
        
        _teleopHighMinusBtn.alpha = 1;
        _teleopHighMinusBtn.enabled = true;
        _teleopHighPlusBtn.alpha = 1;
        _teleopHighPlusBtn.enabled = true;
        _teleopMidMinusBtn.alpha = 1;
        _teleopMidMinusBtn.enabled = true;
        _teleopMidPlusBtn.alpha = 1;
        _teleopMidPlusBtn.enabled = true;
        _teleopLowMinusBtn.alpha = 1;
        _teleopLowMinusBtn.enabled = true;
        _teleopLowPlusBtn.alpha = 1;
        _teleopLowPlusBtn.enabled = true;
        
        _autoHighMinusBtn.alpha = 0;
        _autoHighMinusBtn.enabled = false;
        _autoHighPlusBtn.alpha = 0;
        _autoHighPlusBtn.enabled = false;
        _autoMidMinusBtn.alpha = 0;
        _autoMidMinusBtn.enabled = false;
        _autoMidPlusBtn.alpha = 0;
        _autoMidPlusBtn.enabled = false;
        _autoLowMinusBtn.alpha = 0;
        _autoLowMinusBtn.enabled = false;
        _autoLowPlusBtn.alpha = 0;
        _autoLowPlusBtn.enabled = false;
    }];
    
    NSLog(@"AUTO OFF");
}

-(void)changeMatchType{
    if (matchTypeSelector.selectedSegmentIndex == 0) {
        currentMatchType = @"Q";
    }
    else{
        currentMatchType = @"E";
    }
}

-(void)changeWeek{
    if ([[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex]containsObject:[[allWeekRegionals objectAtIndex:weekSelected] objectAtIndex:[regionalPicker selectedRowInComponent:0]]]) {
        NSString *regional = [[allWeekRegionals objectAtIndex:weekSelected] objectAtIndex:[regionalPicker selectedRowInComponent:0]];
        [regionalPicker reloadAllComponents];
        [regionalPicker selectRow:[[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex]indexOfObject:regional] inComponent:0 animated:YES];
    }
    else{
       [regionalPicker reloadAllComponents];
       [regionalPicker selectRow:0 inComponent:0 animated:YES];
    }
    
    weekSelected = weekSelector.selectedSegmentIndex;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)autoHighPlus:(id)sender {
    autoHighScore++;
    _autoHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)autoHighScore];
}
- (IBAction)teleopHighPlus:(id)sender {
    teleopHighScore++;
    _teleopHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)teleopHighScore];
}

- (IBAction)autoHighMinus:(id)sender {
    if (autoHighScore > 0) {
        autoHighScore--;
        _autoHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)autoHighScore];
    }
}
- (IBAction)teleopHighMinus:(id)sender {
    if (teleopHighScore > 0) {
        teleopHighScore--;
        _teleopHighScoreLbl.text = [[NSString alloc] initWithFormat:@"High: %ld", (long)teleopHighScore];
    }
}

- (IBAction)autoMidPlus:(id)sender {
    autoMidScore++;
    _autoMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)autoMidScore];
}
- (IBAction)teleopMidPlus:(id)sender {
    teleopMidScore++;
    _teleopMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)teleopMidScore];
}

- (IBAction)autoMidMinus:(id)sender {
    if (autoMidScore > 0) {
        autoMidScore--;
        _autoMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)autoMidScore];
    }
}
- (IBAction)teleopMidMinus:(id)sender {
    if (teleopMidScore > 0) {
        teleopMidScore--;
        _teleopMidScoreLbl.text = [[NSString alloc] initWithFormat:@"Mid: %ld", (long)teleopMidScore];
    }
}

- (IBAction)autoLowPlus:(id)sender {
    autoLowScore++;
    _autoLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)autoLowScore];
}
- (IBAction)teleopLowPlus:(id)sender {
    teleopLowScore++;
    _teleopLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)teleopLowScore];
}

- (IBAction)autoLowMinus:(id)sender {
    if (autoLowScore > 0) {
        autoLowScore--;
        _autoLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)autoLowScore];
    }
}
- (IBAction)teleopLowMinus:(id)sender {
    if (teleopLowScore > 0) {
        teleopLowScore--;
        _teleopLowScoreLbl.text = [[NSString alloc] initWithFormat:@"Low: %ld", (long)teleopLowScore];
    }
}


-(IBAction)matchNumberEdit:(id)sender {
    _matchNumEdit.hidden = true;
    _matchNumEdit.enabled = false;
    _matchNumField.hidden = false;
    _matchNumField.enabled = true;
    _matchNumField.text = _matchNumEdit.titleLabel.text;
    [_matchNumField becomeFirstResponder];
}

-(IBAction)teamNumberEdit:(id)sender {
    _teamNumEdit.hidden = true;
    _teamNumEdit.enabled = false;
    _teamNumField.hidden = false;
    _teamNumField.enabled = true;
    _teamNumField.text = _teamNumEdit.titleLabel.text;
    _teamNumField.selected = true;
    [_teamNumField becomeFirstResponder];
}

-(IBAction)smallPenaltyChange:(id)sender {
    smallPenaltyTally = _smallPenaltyStepper.value;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
}

-(IBAction)largePenaltyChange:(id)sender {
    largePenaltyTally = _largePenaltyStepper.value;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
}


-(IBAction)saveMatch:(id)sender {
    
    if (_matchNumEdit.isHidden) {
        currentMatchNum = _matchNumField.text;
    }
    else{
        currentMatchNum = _matchNumEdit.titleLabel.text;
    }
    
    if (_teamNumEdit.isHidden) {
        currentTeamNum = _teamNumField.text;
    }
    else{
        currentTeamNum = _teamNumEdit.titleLabel.text;
    }
    
    if (currentMatchNum == nil || [currentMatchNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO MATCH NUMBER"
                                                       message: @"Please enter a match number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    else if (currentTeamNum == nil || [currentTeamNum isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO TEAM NUMBER"
                                                       message: @"Please enter a team number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    else{
        
        if ([pos  isEqualToString: @"Red 1"]) {
            if (![dataDict objectForKey:@"Red1"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red1"];
            }
            if (![[dataDict objectForKey:@"Red1"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Red1"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Red1"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Red1"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                               [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                               [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                               [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                               [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                               [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                               [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                               [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                               [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                               [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                               [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                               [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                               [NSString stringWithString:initials], @"initials",
                                                               [NSString stringWithString:currentRegional], @"regional",
                                                               nil] forKey:currentMatchNum];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos  isEqualToString: @"Red 2"]) {
            if (![dataDict objectForKey:@"Red2"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red2"];
            }
            if (![[dataDict objectForKey:@"Red2"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Red2"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Red2"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Red2"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                            [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                            [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                            [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                            [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                            [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                            [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                            [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                            [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                            [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                            [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                            [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                            [NSString stringWithString:initials], @"initials",
                                                            [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos  isEqualToString: @"Red 3"]) {
            if (![dataDict objectForKey:@"Red3"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Red3"];
            }
            if (![[dataDict objectForKey:@"Red3"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Red3"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Red3"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Red3"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                            [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                            [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                            [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                            [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                            [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                            [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                            [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                            [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                            [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                            [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                            [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                            [NSString stringWithString:initials], @"initials",
                                                            [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 1"]) {
            if (![dataDict objectForKey:@"Blue1"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue1"];
            }
            if (![[dataDict objectForKey:@"Blue1"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Blue1"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Blue1"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Blue1"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                             [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                             [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                             [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                             [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                             [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 2"]) {
            if (![dataDict objectForKey:@"Blue2"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue2"];
            }
            if (![[dataDict objectForKey:@"Blue2"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Blue2"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Blue2"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Blue2"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                             [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                             [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                             [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                             [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                             [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
            }
            else{
                [self overWriteAlert];
            }
        }
        else if ([pos isEqualToString:@"Blue 3"]) {
            if (![dataDict objectForKey:@"Blue3"]) {
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:@"Blue3"];
            }
            if (![[dataDict objectForKey:@"Blue3"] objectForKey:currentRegional]) {
                [[dataDict objectForKey:@"Blue3"] setObject:[NSMutableDictionary dictionary] forKey:currentRegional];
            }
            if (![[[dataDict objectForKey:@"Blue3"] objectForKey:currentRegional] objectForKey:currentMatchNum]) {
                [[[dataDict objectForKey:@"Blue3"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                             [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                             [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                             [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                             [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                             [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                             [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                             [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                             [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                             [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                             [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                             [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                             [NSString stringWithString:initials], @"initials",
                                                             [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
                [self autoOn];
            }
            else{
                [self overWriteAlert];
            }
        }
        [dataDict writeToFile:path atomically:YES];
        
        
        
        context = FSAdocument.managedObjectContext;
        
        
        NSFetchRequest *recorderRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recorder"];
        NSPredicate *recorderPredicate = [NSPredicate predicateWithFormat:@"name contains %@", scoutTeamNum];
        recorderRequest.predicate = recorderPredicate;
        
        NSError *recorderError = nil;
        NSUInteger recorderCount = [context countForFetchRequest:recorderRequest error:&recorderError];
        
        //Searched and found no recorders saved
        if (recorderCount == NSNotFound || recorderCount == 0) {
            NSLog(@"Recorder couldn't be found");
            [context performBlock:^{
                [self createRecorder];
            }];
        }
        //Some fetch error
        else if (recorderError){
            NSLog(@"Recorder Error: %@", recorderError);
        }
        //Found a recorder already present and proceeds to adding a regional
        else{
            NSLog(@"Found %lu recorder instances", (unsigned long)recorderCount);
            NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
            NSPredicate *regionalPredicate = [NSPredicate predicateWithFormat:@"(name contains %@) AND (whoRecorded.name contains %@)", currentRegional, scoutTeamNum];
            regionalRequest.predicate = regionalPredicate;
            
            NSError *regionalError = nil;
            NSUInteger regionalCount = [context countForFetchRequest:regionalRequest error:&regionalError];
            
            //Searched and found no regionals saved for that regional title
            if (regionalCount == NSNotFound || regionalCount == 0) {
                [context performBlock:^{
                    NSLog(@"Regional couldn't be found");
                    NSError *error;
                    NSArray *recorders = [context executeFetchRequest:recorderRequest error:&error];
                    
                    Recorder *resultRecorder = [recorders firstObject];
                    
                    NSSet *regionalSet = [[NSSet alloc] initWithSet:resultRecorder.regionals];
                    NSLog(@"\n Regionals Recorded by %@:", resultRecorder.name);
                    for (Regional *r in regionalSet) {
                        NSLog(@"Regional: %@", r.name);
                    }
                    
                    [self createRegionalWithRecorder:resultRecorder];
                    
                }];
            }
            //Some fetch error
            else if (regionalError){
                NSLog(@"Regional Error: %@", regionalError);
            }
            //Found a regional named the same as the current regional
            else{
                NSLog(@"Found %lu regional instances", (unsigned long)regionalCount);
                NSFetchRequest *teamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
                NSPredicate *teamPredicate = [NSPredicate predicateWithFormat:@"(name contains %@) AND (regionalIn.name contains %@) AND (regionalIn.whoRecorded.name contains %@)", currentTeamNum, currentRegional, scoutTeamNum];
                teamRequest.predicate = teamPredicate;
                
                NSError *teamError = nil;
                NSUInteger teamCount = [context countForFetchRequest:teamRequest error:&teamError];
                
                //Searched and found no team saved for that team number in the regional
                if (teamCount == NSNotFound || teamCount == 0) {
                    [context performBlock:^{
                        NSLog(@"Team couldn't be found");
                        
                        NSError *error;
                        NSArray *regionals = [context executeFetchRequest:regionalRequest error:&error];
                        
                        Regional *resultRegional = [regionals firstObject];
                        
                        NSSet *teamSet = [[NSSet alloc] initWithSet:resultRegional.teams];
                        NSLog(@"\n Teams Saved in %@:", resultRegional.name);
                        for (Team *t in teamSet) {
                            NSLog(@"Team: %@", t.name);
                        }
                        
                        [self createTeamWithRegional:resultRegional];
                    }];
                    
                }
                //Some error in fetching the team
                else if(teamError){
                    NSLog(@"Team Error: %@", teamError);
                }
                //Found more than zero teams labeled as the searched team number
                else{
                    NSLog(@"Found %lu team instances", (unsigned long)teamCount);
                    NSFetchRequest *matchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
                    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"(matchNum contains %@) AND (teamNum.name contains %@) AND (teamNum.regionalIn.name contains %@) AND (teamNum.regionalIn.whoRecorded.name contains %@)", currentMatchNum, currentTeamNum, currentRegional, scoutTeamNum];
                    matchRequest.predicate = matchPredicate;
                    
                    NSError *matchError = nil;
                    NSUInteger matchCount = [context countForFetchRequest:matchRequest error:&matchError];
                    
                    //Searched and found no matches with specified title
                    if (matchCount == NSNotFound || matchCount == 0) {
                        [context performBlock:^{
                            NSLog(@"Match couldn't be found");
                            
                            NSError *error;
                            NSArray *teams = [context executeFetchRequest:teamRequest error:&error];
                            
                            Team *resultTeam = [teams firstObject];
                            
                            NSSet *matchSet = [[NSSet alloc] initWithSet:resultTeam.matches];
                            NSLog(@"\n Matches Saved under %@:", resultTeam.name);
                            for (Match *m in matchSet) {
                                NSLog(@"Match: %@", m.matchNum);
                            }
                            
                            [self createMatchWithTeam:resultTeam];
                        }];
                    }
                    //Some sort of error in fetching the match
                    else if (matchError){
                        NSLog(@"Match Error: %@", matchError);
                    }
                    //A match already exists for the one attempting to save
                    else{
                        NSLog(@"DUPLICATE");
                        
                        NSError *error;
                        NSArray *teams = [context executeFetchRequest:teamRequest error:&error];
                        
                        teamWithDuplicate = [teams firstObject];
                        
                        NSError *error1;
                        NSArray *matches = [context executeFetchRequest:matchRequest error:&error1];
                        
                        duplicateMatch = [matches firstObject];
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

-(void)createRecorder{
    Recorder *newRecorder = [NSEntityDescription insertNewObjectForEntityForName:@"Recorder" inManagedObjectContext:context];
    newRecorder.name = scoutTeamNum;
    NSLog(@"Created new recorder named: %@", newRecorder.name);
    [self createRegionalWithRecorder:newRecorder];
}
-(void)createRegionalWithRecorder:(Recorder *)recorder{
    Regional *newRegional = [NSEntityDescription insertNewObjectForEntityForName:@"Regional" inManagedObjectContext:context];
    newRegional.name = currentRegional;
    [recorder addRegionalsObject:newRegional];
    NSLog(@"Created new regional named: %@", newRegional.name);
    [self createTeamWithRegional:newRegional];
}
-(void)createTeamWithRegional:(Regional *)regional{
    Team *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
    newTeam.name = currentTeamNum;
    [regional addTeamsObject:newTeam];
    NSLog(@"Created new team titled: %@", newTeam.name);
    [self createMatchWithTeam:newTeam];
}
-(void)createMatchWithTeam:(Team *)team{
    Match *newMatch = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:context];
    newMatch.matchNum = currentMatchNum;
    newMatch.matchType = currentMatchType;
    newMatch.teleHighScore = [NSNumber numberWithInteger:teleopHighScore];
    newMatch.autoHighScore = [NSNumber numberWithInteger:autoHighScore];
    newMatch.teleMidScore = [NSNumber numberWithInteger:teleopMidScore];
    newMatch.autoMidScore = [NSNumber numberWithInteger:autoMidScore];
    newMatch.teleLowScore = [NSNumber numberWithInteger:teleopLowScore];
    newMatch.autoLowScore = [NSNumber numberWithInteger:autoLowScore];
    //newMatch.endGame = [NSNumber numberWithInteger:endgame];
    newMatch.penaltySmall = [NSNumber numberWithInteger:smallPenaltyTally];
    newMatch.penaltyLarge = [NSNumber numberWithInteger:largePenaltyTally];
    newMatch.red1Pos = pos;
    newMatch.scoutInitials = initials;
    [team addMatchesObject:newMatch];
    NSLog(@"Created new match titled: %@", newMatch.matchNum);
    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){}];
    duplicateMatch = nil;
    teamWithDuplicate = nil;
    [self saveSuccess];
}
-(void)overWriteMatch{
    [context performBlock:^{
        [FSAdocument.managedObjectContext deleteObject:duplicateMatch];
        [self createMatchWithTeam:teamWithDuplicate];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([pos isEqualToString:@"Red 1"]) {
            [[[dataDict objectForKey:@"Red1"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                        [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                        [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                        [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                        [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
        else if([pos isEqualToString:@"Red 2"]){
            [[[dataDict objectForKey:@"Red2"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                        [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                        [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                        [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                        [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                        [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
        else if([pos isEqualToString:@"Red 3"]){
            [[[dataDict objectForKey:@"Red3"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                        [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                        [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                        [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                        [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                        [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                        [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                        [NSString stringWithString:initials], @"initials",
                                                        [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
        else if ([pos isEqualToString:@"Blue 1"]){
            [[[dataDict objectForKey:@"Blue1"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                         [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                         [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                         [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                         [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                         [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
        else if ([pos isEqualToString:@"Blue 2"]){
            [[[dataDict objectForKey:@"Blue2"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                         [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                         [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                         [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                         [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                         [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
        else if ([pos isEqualToString:@"Blue 3"]){
            [[[dataDict objectForKey:@"Blue3"] objectForKey:currentRegional] setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSNumber numberWithInteger:teleopHighScore], @"teleopHighScore",
                                                         [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
                                                         [NSNumber numberWithInteger:teleopMidScore], @"teleopMidScore",
                                                         [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
                                                         [NSNumber numberWithInteger:teleopLowScore], @"teleopLowScore",
                                                         [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
                                                         [NSNumber numberWithInteger:smallPenaltyTally], @"smallPenalties",
                                                         [NSNumber numberWithInteger:largePenaltyTally], @"largePenalties",
                                                         [NSString stringWithString:currentMatchNum], @"currentMatchNum",
                                                         [NSString stringWithString:currentMatchType], @"currentMatchType",
                                                         [NSString stringWithString:currentTeamNum], @"currentTeamNum",
                                                         [NSString stringWithString:scoutTeamNum], @"scoutTeamNum",
                                                         [NSString stringWithString:initials], @"initials",
                                                         [NSString stringWithString:currentRegional], @"regional",
                                                            nil] forKey:currentMatchNum];
        }
      //NSLog(@"%@", dataDict);
        [self overWriteMatch];
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
    smallPenaltyTally = 0;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
    largePenaltyTally = 0;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
    
    NSInteger matchNumTranslator = [currentMatchNum integerValue];
    matchNumTranslator++;
    currentMatchNum = [[NSString alloc] initWithFormat:@"%ld", (long)matchNumTranslator];
    currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
    [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
    
    NSInteger randomTeamNum = arc4random() % 4000;
    currentTeamNum = [[NSString alloc] initWithFormat:@"%ld", (long)randomTeamNum];
    currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
    [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
    
    if (_matchNumEdit.hidden) {
        _matchNumField.enabled = false;
        _matchNumField.hidden = true;
        _matchNumEdit.enabled = true;
        _matchNumEdit.hidden = false;
    }
    if (_teamNumEdit.hidden) {
        _teamNumField.enabled = false;
        _teamNumField.hidden = true;
        _teamNumEdit.enabled = true;
        _teamNumEdit.hidden = false;
    }
    
    //NSLog(@"%@", dataDict);
    
    [self autoOn];
    
}

-(IBAction)hideKeyboard:(id)sender {
    [_matchNumField resignFirstResponder];
    [_teamNumField resignFirstResponder];
    [scoutTeamNumField resignFirstResponder];
    [currentMatchNumField resignFirstResponder];
    [initialsField resignFirstResponder];
}








@end
