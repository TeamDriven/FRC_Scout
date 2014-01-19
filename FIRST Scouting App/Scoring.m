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
#import "Regional.h"
#import "Regional+Category.h"
#import "Team.h"
#import "Team+Category.h"
#import "Match.h"
#import "Match+Category.h"
#import "UIAlertView+Blocks.h"

@interface LocationsFirstViewController ()

@end

@implementation LocationsFirstViewController


// Match Data Variables
NSInteger autoHighHotScore;
NSInteger autoHighNotScore;
NSInteger autoHighMissScore;
NSInteger autoLowHotScore;
NSInteger autoLowNotScore;
NSInteger autoLowMissScore;
NSInteger mobilityBonus;

NSInteger teleopHighMake;
NSInteger teleopHighMiss;
NSInteger teleopLowMake;
NSInteger teleopLowMiss;
NSInteger teleopOver;
NSInteger teleopCatch;
NSInteger teleopPassed;
NSInteger teleopReceived;
NSInteger smallPenaltyTally;
NSInteger largePenaltyTally;


// Match Defining Variables
NSString *initials;
NSString *scoutTeamNum;
NSString *currentMatchNum;
NSString *currentTeamNum;
NSString *currentRegional;
NSString *pos;
NSString *currentMatchType;


// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;


// Finger Swipes
UISwipeGestureRecognizer *twoFingerUp;
UISwipeGestureRecognizer *twoFingerDown;
NSArray *autoScreenObjects;
NSArray *teleopScreenObjects;
Boolean autoYN;


// SetUp Screen Declarations
UIControl *greyOut;
UIControl *setUpView;
UISegmentedControl *red1Selector;
NSInteger red1SelectedPos;
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
UILabel *red1Lbl;


// Share Screen Declarations
UIView *shareScreen;
UILabel *instaShareTitle;
UIButton *closeButton;
UILabel *hostSwitchLbl;
UISwitch *hostSwitch;
UILabel *visibleSwitchLbl;
UISwitch *visibleSwitch;
UIButton *inviteMoreBtn;
UIButton *doneButton;
BOOL host;
BOOL visible;
UIAlertView *inviteAlert;
NSMutableDictionary *dictToSend;
NSMutableDictionary *receivedDataDict;


// Regional Arrays
NSArray *regionalNames;
NSArray *week1Regionals;
NSArray *week2Regionals;
NSArray *week3Regionals;
NSArray *week4Regionals;
NSArray *week5Regionals;
NSArray *week6Regionals;
NSArray *week7Regionals;
NSArray *allWeekRegionals;


// Core Data Helpers
NSInteger secs;
Team *teamWithDuplicate;
Match *duplicateMatch;
NSDictionary *duplicateMatchDict;
UIAlertView *overWriteAlert;
MCPeerID *senderPeer;
NSArray *posUpdateArray;
UILabel *red1UpdaterLbl;
UILabel *red2UpdaterLbl;
UILabel *red3UpdaterLbl;
UILabel *blue1UpdaterLbl;
UILabel *blue2UpdaterLbl;
UILabel *blue3UpdaterLbl;


/***********************************
 ************ Set Up ***************
 ***********************************/

// Sets up variables and things at beginning
-(void)viewDidLoad{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // *** Map to Core Data ***
    FSAfileManager = [NSFileManager defaultManager];
    FSAdocumentsDirectory = [[FSAfileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    FSAdocumentName = @"FSA";
    FSApathurl = [FSAdocumentsDirectory URLByAppendingPathComponent:FSAdocumentName];
    FSAdocument = [[UIManagedDocument alloc] initWithFileURL:FSApathurl];
    context = FSAdocument.managedObjectContext;
    
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
    // *** Done Mapping to Core Data **
    
    
    // Helps prepare for keyboard to appear/disappear (on storyboard UI)
    self.matchNumField.delegate = self;
    self.teamNumField.delegate = self;
    
    // Autonomous On Gesture
    twoFingerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOn)];
    [twoFingerUp setNumberOfTouchesRequired:2];
    [twoFingerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:twoFingerUp];
    
    // Autonomous Off Gesture
    twoFingerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoOff)];
    [twoFingerDown setNumberOfTouchesRequired:2];
    [twoFingerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:twoFingerDown];
    
    // Autonomous Boolean
    autoYN = true;
    
    // Helps prepare the setUpView
    red1Pos = -1;
    pos = nil;
    
    _saveBtn.layer.cornerRadius = 5;
    
    // All Regionals in 2014
    regionalNames = @[@"Central Illinois Regional",@"Palmetto Regional",@"Alamo Regional",@"Greater Toronto West Regional",@"Inland Empire Regional",@"Center Line District Competition",@"Southfield District Competition",@"Granite State District Event",@"PNW Auburn Mountainview District Event",@"MAR Mt. Olive District Competition",@"MAR Hatboro-Horsham District Comp.",@"Israel Regional",@"Greater Toronto East Regional",@"Arkansas Regional",@"San Diego Regional",@"Crossroads Regional",@"Lake Superior Regional",@"Northern Lights Regional",@"Hub City Regional",@"UNH District Event",@"Central Valley Regional",@"Kettering University District Competition",@"Gull Lake District Competition",@"PNW Oregon City District Event",@"PNW Glacier Peak District Event",@"Groton District Event",@"Mexico City Regional",@"Sacramento Regional",@"Orlando Regional",@"Greater Kansas City Regional",@"St. Louis Regional",@"North Carolina Regional",@"New York Tech Valley Regional",@"Dallas Regional",@"Utah Regional",@"WPI District Event",@"Escanaba District Competition",@"Howell District Competition",@"MAR Springside Chestnut Hill District Comp.",@"PNW Eastern Wash. University District Event",@"PNW Mt. Vernon District Event",@"MAR Clifton District Competition",@"Waterloo Regional",@"Festival de Robotique FRC a Montreal Regional",@"Arizona Regional",@"Los Angeles Regional",@"Boilermaker Regional",@"Buckeye Regional",@"Virginia Regional",@"Wisconsin Regional",@"West Michigan District Competition",@"Great Lakes Bay Region District Competition",@"Traverse City District Competition",@"PNW Wilsonville District Event",@"Rhode Island District Event",@"PNW Shorewood District Event",@"Southington District Event",@"MAR Lenape-Seneca District Competition",@"North Bay Regional",@"Peachtree Regional",@"Hawaii Regional",@"Minnesota 10000 Lakes Regional",@"Minnesota North Star Regional",@"SBPLI Long Island Regional",@"Finger Lakes Regional",@"Queen City Regional",@"Oklahoma Regional",@"Greater Pittsburgh Regional",@"Smoky Mountains Regional",@"Greater DC Regional",@"Northeastern University District Event",@"Livonia District Competition",@"St. Joseph District Competition",@"Waterford District Competition",@"PNW Auburn District Event",@"PNW Central Wash. University District Event",@"Hartford District Event",@"MAR Bridgewater-Raritan District Competition",@"Western Canada Regional",@"Windsor Essex Great Lakes Regional",@"Silicon Valley Regional",@"Colorado Regional",@"South Florida Regional",@"Midwest Regional",@"Bayou Regional",@"Chesapeake Regional",@"Las Vegas Regional",@"New York City Regional",@"Lone Star Regional",@"Pine Tree District Event",@"Bedford District Competition",@"Troy District Competition",@"PNW Oregon State University District Event",@"New England FRC Region Championship",@"Michigan FRC State Championship",@"Autodesk PNW FRC Championship",@"Mid-Atlantic Robotics FRC Region Championship",@"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
   
    // Week 1 Regionals of 2014
    week1Regionals = @[@"Central Illinois Regional",@"Palmetto Regional",@"Alamo Regional",@"Greater Toronto West Regional",@"Inland Empire Regional",@"Center Line District Competition",@"Southfield District Competition",@"Granite State District Event",@"PNW Auburn Mountainview District Event",@"MAR Mt. Olive District Competition",@"MAR Hatboro-Horsham District Comp.",@"Israel Regional"];
    
    // Week 2 Regionals of 2014
    week2Regionals = @[@"Greater Toronto East Regional",@"Arkansas Regional",@"San Diego Regional",@"Crossroads Regional",@"Lake Superior Regional",@"Northern Lights Regional",@"Hub City Regional",@"UNH District Event",@"Central Valley Regional",@"Kettering University District Competition",@"Gull Lake District Competition",@"PNW Oregon City District Event",@"PNW Glacier Peak District Event",@"Groton District Event"];
    
    // Week 3 Regionals of 2014
    week3Regionals = @[@"Mexico City Regional",@"Sacramento Regional",@"Orlando Regional",@"Greater Kansas City Regional",@"St. Louis Regional",@"North Carolina Regional",@"New York Tech Valley Regional",@"Dallas Regional",@"Utah Regional",@"WPI District Event",@"Escanaba District Competition",@"Howell District Competition",@"MAR Springside Chestnut Hill District Comp.",@"PNW Eastern Wash. University District Event",@"PNW Mt. Vernon District Event",@"MAR Clifton District Competition"];
    
    // Week 4 Regionals of 2014
    week4Regionals = @[@"Waterloo Regional",@"Festival de Robotique FRC a Montreal Regional",@"Arizona Regional",@"Los Angeles Regional",@"Boilermaker Regional",@"Buckeye Regional",@"Virginia Regional",@"Wisconsin Regional",@"West Michigan District Competition",@"Great Lakes Bay Region District Competition",@"Traverse City District Competition",@"PNW Wilsonville District Event",@"Rhode Island District Event",@"PNW Shorewood District Event",@"Southington District Event",@"MAR Lenape-Seneca District Competition"];
    
    // Week 5 Regionals of 2014
    week5Regionals = @[@"North Bay Regional",@"Peachtree Regional",@"Hawaii Regional",@"Minnesota 10000 Lakes Regional",@"Minnesota North Star Regional",@"SBPLI Long Island Regional",@"Finger Lakes Regional",@"Queen City Regional",@"Oklahoma Regional",@"Greater Pittsburgh Regional",@"Smoky Mountains Regional",@"Greater DC Regional",@"Northeastern University District Event",@"Livonia District Competition",@"St. Joseph District Competition",@"Waterford District Competition",@"PNW Auburn District Event",@"PNW Central Wash. University District Event",@"Hartford District Event",@"MAR Bridgewater-Raritan District Competition"];
    
    // Week 6 Regionals of 2014
    week6Regionals = @[@"Western Canada Regional",@"Windsor Essex Great Lakes Regional",@"Silicon Valley Regional",@"Colorado Regional",@"South Florida Regional",@"Midwest Regional",@"Bayou Regional",@"Chesapeake Regional",@"Las Vegas Regional",@"New York City Regional",@"Lone Star Regional",@"Pine Tree District Event",@"Bedford District Competition",@"Troy District Competition",@"PNW Oregon State University District Event"];
    
    // Week 7+ Regionals of 2014
    week7Regionals = @[@"New England FRC Region Championship",@"Michigan FRC State Championship",@"Autodesk PNW FRC Championship",@"Mid-Atlantic Robotics FRC Region Championship",@"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
    
    allWeekRegionals = @[regionalNames,week1Regionals,week2Regionals,week3Regionals,week4Regionals,week5Regionals,week6Regionals,week7Regionals];
    
    // Value for WeekSelector UISegmentedControl to start at
    weekSelected = 0;
    
    // Match type: Qualifying vs. Elimination
    currentMatchType = @"Q";
    
    // Visible and Host booleans to control roles
    host = false;
    visible = false;
    
    autoScreenObjects = @[_autoTitleLbl, _autoHotHighMinus, _autoHotHighDispLbl, _autoHotHighLbl, _autoHotHighPlus, _autoNotHighMinus, _autoNotHighDispLbl, _autoNotHighLbl, _autoNotHighPlus, _autoMissHighMinus, _autoMissHighDispLbl, _autoMissHighLbl, _autoMissHighPlus, _autoHotLowMinus, _autoHotLowDispLbl, _autoHotLowLbl, _autoHotLowPlus, _autoNotLowMinus, _autoNotLowDispLbl, _autoNotLowLbl, _autoNotLowPlus, _autoMissLowMinus, _autoMissLowDispLbl, _autoMissLowLbl, _autoMissLowPlus, _mobilityBonusLbl, _movementLine, _movementRobot, _swipeUpArrow];
    
    teleopScreenObjects = @[_teleopTitleLbl, _teleopMakeHighMinus, _teleopMakeHighDispLbl, _teleopMakeHighLbl, _teleopMakeHighPlus, _teleopMissHighMinus, _teleopMissHighDispLbl, _teleopMissHighLbl, _teleopMissHighPlus, _teleopMakeLowMinus, _teleopMakeLowDispLbl, _teleopMakeLowLbl, _teleopMakeLowPlus, _teleopMissLowMinus, _teleopMissLowDispLbl, _teleopMissLowLbl, _teleopMissLowPlus, _teleopTrussLbl, _teleopOverMinus, _teleopOverDispLbl, _teleopOverLbl, _teleopOverPlus, _teleopCatchMinus, _teleopCatchDispLbl, _teleopCatchLbl, _teleopCatchPlus, _teleopAssistsLbl, _teleopPassedMinus, _teleopPassedDispLbl, _teleopPassedLbl, _teleopPassedPlus, _teleopReceivedMinus, _teleopReceivedDispLbl, _teleopReceivedLbl, _teleopReceivedPlus, _smallPenaltyLbl, _smallPenaltyStepper, _smallPenaltyTitleLbl, _largePenaltyLbl, _largePenaltyStepper, _largePenaltyTitleLbl];
    
    
    
    for (UIView *v in autoScreenObjects) {
        if ([v isKindOfClass:[UIButton class]] || [v isKindOfClass:[UIImage class]]) {
            v.userInteractionEnabled = NO;
        }
        v.alpha = 0;
        v.hidden = true;
    }
    for (UIView *v in teleopScreenObjects) {
        if ([v isKindOfClass:[UIResponder class]]) {
            v.userInteractionEnabled = NO;
        }
        v.alpha = 0;
        v.hidden = true;
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sets up UI and setUpView. Recreates setUpView if it already exists (fixes crash when switching pages before interaction)
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSThread sleepForTimeInterval:0.3];
    if (setUpView) {
        [setUpView removeFromSuperview];
        [greyOut removeFromSuperview];
    }
    [self setUpScreen];
//    [self autoOn];
    
    _movementRobot.userInteractionEnabled = YES;
    
    NSInteger lastX = 55;
    
    UILabel *lastUpdatedLbl = [[UILabel alloc] initWithFrame:CGRectMake(lastX, 920, 70, 30)];
    lastUpdatedLbl.text = @"Last Updated Matches";
    lastUpdatedLbl.textAlignment = NSTextAlignmentCenter;
    lastUpdatedLbl.font = [UIFont systemFontOfSize:11];
    lastUpdatedLbl.numberOfLines = 2;
    [self.view addSubview:lastUpdatedLbl];
    
    lastX += 85;
    UIView *red1Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    red1Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    red1Updater.layer.cornerRadius = 5;
    [self.view addSubview:red1Updater];
    red1UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    red1UpdaterLbl.text = @"Red 1 : ??";
    red1UpdaterLbl.textColor = [UIColor whiteColor];
    red1UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    red1UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [red1Updater addSubview:red1UpdaterLbl];
    
    lastX += 95;
    UIView *red2Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    red2Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    red2Updater.layer.cornerRadius = 5;
    [self.view addSubview:red2Updater];
    red2UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    red2UpdaterLbl.text = @"Red 2 : ??";
    red2UpdaterLbl.textColor = [UIColor whiteColor];
    red2UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    red2UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [red2Updater addSubview:red2UpdaterLbl];
    
    lastX += 95;
    UIView *red3Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    red3Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    red3Updater.layer.cornerRadius = 5;
    [self.view addSubview:red3Updater];
    red3UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    red3UpdaterLbl.text = @"Red 3 : ??";
    red3UpdaterLbl.textColor = [UIColor whiteColor];
    red3UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    red3UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [red3Updater addSubview:red3UpdaterLbl];
    
    lastX += 95;
    UIView *blue1Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    blue1Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    blue1Updater.layer.cornerRadius = 5;
    [self.view addSubview:blue1Updater];
    blue1UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    blue1UpdaterLbl.text = @"Blue 1 : ??";
    blue1UpdaterLbl.textColor = [UIColor whiteColor];
    blue1UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    blue1UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [blue1Updater addSubview:blue1UpdaterLbl];
    
    lastX += 95;
    UIView *blue2Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    blue2Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    blue2Updater.layer.cornerRadius = 5;
    [self.view addSubview:blue2Updater];
    blue2UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    blue2UpdaterLbl.text = @"Blue 2 : ??";
    blue2UpdaterLbl.textColor = [UIColor whiteColor];
    blue2UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    blue2UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [blue2Updater addSubview:blue2UpdaterLbl];
    
    lastX += 95;
    UIView *blue3Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
    blue3Updater.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    blue3Updater.layer.cornerRadius = 5;
    [self.view addSubview:blue3Updater];
    blue3UpdaterLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
    blue3UpdaterLbl.text = @"Blue 3 : ??";
    blue3UpdaterLbl.textColor = [UIColor whiteColor];
    blue3UpdaterLbl.textAlignment = NSTextAlignmentCenter;
    blue3UpdaterLbl.font = [UIFont systemFontOfSize:12];
    [blue3Updater addSubview:blue3UpdaterLbl];
    
    posUpdateArray = @[lastUpdatedLbl, red1Updater, red2Updater, red3Updater, blue1Updater, blue2Updater, blue3Updater];
    
    for (UIView *v in posUpdateArray) {
        v.hidden = true;
    }
}

// Creates the initial UIView that the user interacts with
-(void)setUpScreen{
    if (initials == nil && !greyOut.superview) {
        
        twoFingerUp.enabled = false;
        twoFingerDown.enabled = false;
        
        // Grays out the screen behind the setUpScreen
        CGRect greyOutRect = CGRectMake(0, 0, 768, 1024);
        greyOut = [[UIControl alloc] initWithFrame:greyOutRect];
        [greyOut addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self.view addSubview:greyOut];
        
        // The white rectangle UIView that is the setUpView
        CGRect setUpViewRect = CGRectMake(70, 100, 628, 700);
        setUpView = [[UIControl alloc] initWithFrame:setUpViewRect];
        [setUpView addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        setUpView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        setUpView.layer.cornerRadius = 10;
        
        // Title at the top of the setUpView
        CGRect setUpTitleRect = CGRectMake(214, 50, 200, 50);
        UILabel *setUpTitle = [[UILabel alloc] initWithFrame:setUpTitleRect];
        [setUpTitle setFont:[UIFont systemFontOfSize:25]];
        [setUpTitle setTextAlignment:NSTextAlignmentCenter];
        [setUpTitle setText:@"Sign in to Scout"];
        [setUpView addSubview:setUpTitle];
        
        // UISegmentedControl for selecting what position the scout is
        CGRect red1SelectorRect = CGRectMake(124, 130, 380, 30);
        red1Selector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red 1", @"Red 2", @"Red 3", @"Blue 1", @"Blue 2", @"Blue 3",  nil]];
        [red1Selector addTarget:self action:@selector(red1Changed) forControlEvents:UIControlEventValueChanged];
        [red1Selector setFrame:red1SelectorRect];
        [setUpView addSubview:red1Selector];
        red1Selector.selectedSegmentIndex = red1Pos;
        NSLog(@"Red 1 Pos: %ld", (long)red1Pos);
        
        // Labels the scout initials field
        CGRect initialsFieldLblRect = CGRectMake(129, 190, 100, 15);
        UILabel *initialsFieldLbl = [[UILabel alloc] initWithFrame:initialsFieldLblRect];
        initialsFieldLbl.textAlignment = NSTextAlignmentCenter;
        initialsFieldLbl.text = @"Enter YOUR three initials";
        initialsFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:initialsFieldLbl];
        
        // Textfield for the user to enter their initials in
        CGRect initialsFieldRect = CGRectMake(114, 210, 130, 40);
        initialsField = [[UITextField alloc] initWithFrame:initialsFieldRect];
        [initialsField addTarget:self action:@selector(checkNumber) forControlEvents:UIControlEventEditingChanged];
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
        
        // Labels the scout's team number field
        CGRect scoutTeamNumFieldLblRect = CGRectMake(264, 190, 100, 15);
        UILabel *scoutTeamNumFieldLbl = [[UILabel alloc] initWithFrame:scoutTeamNumFieldLblRect];
        scoutTeamNumFieldLbl.textAlignment = NSTextAlignmentCenter;
        scoutTeamNumFieldLbl.text = @"Enter YOUR team number";
        scoutTeamNumFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:scoutTeamNumFieldLbl];
        
        // Textfield for the scout's own team number to be entered in
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
        
        // Labels the current match field textfield
        CGRect currentMatchNumFieldLblRect = CGRectMake(384, 190, 130, 15);
        UILabel *currentMatchNumFieldLbl = [[UILabel alloc] initWithFrame:currentMatchNumFieldLblRect];
        currentMatchNumFieldLbl.textAlignment = NSTextAlignmentCenter;
        currentMatchNumFieldLbl.text = @"Enter the current match number";
        currentMatchNumFieldLbl.adjustsFontSizeToFitWidth = YES;
        [setUpView addSubview:currentMatchNumFieldLbl];
        
        // Textfield for the user to input whatever the match number is for the match they are about to watch (only needed on the initial setup, it's taken care of afterwards)
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
        
        // Select either Qual or Elim match type (for data storage purposes)
        CGRect matchTypeSelectorRect = CGRectMake(364, 255, 170, 30);
        matchTypeSelector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Qualification", @"Elimination", nil]];
        matchTypeSelector.frame = matchTypeSelectorRect;
        [matchTypeSelector addTarget:self action:@selector(changeMatchType) forControlEvents:UIControlEventValueChanged];
        [setUpView addSubview:matchTypeSelector];
        matchTypeSelector.selectedSegmentIndex = 0;
        matchTypeSelector.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        // Title for week selector UISegmentedControl
        CGRect weekSelectorLblRect = CGRectMake(54, 310, 30, 30);
        UILabel *weekSelectorLbl = [[UILabel alloc] initWithFrame:weekSelectorLblRect];
        weekSelectorLbl.textAlignment = NSTextAlignmentCenter;
        weekSelectorLbl.text = @"Week";
        weekSelectorLbl.adjustsFontSizeToFitWidth = YES;
        weekSelectorLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [setUpView addSubview:weekSelectorLbl];
        
        // Narrows the selection list by week selected by user
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
        
        // Label for the Regional Picker
        CGRect regionalPickerLblRect = CGRectMake(194, 305, 240, 30);
        UILabel *regionalPickerLbl = [[UILabel alloc] initWithFrame:regionalPickerLblRect];
        [regionalPickerLbl setFont:[UIFont systemFontOfSize:18]];
        regionalPickerLbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [regionalPickerLbl setTextAlignment:NSTextAlignmentCenter];
        [regionalPickerLbl setText:@"Select the event you are at"];
        [setUpView addSubview:regionalPickerLbl];
        
        // Displays all regionals for user to select from
        CGRect regionalPickerRect = CGRectMake(104, 340, 420, 300);
        regionalPicker = [[UIPickerView alloc] initWithFrame:regionalPickerRect];
        regionalPicker.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        regionalPicker.layer.cornerRadius = 5;
        regionalPicker.delegate = self;
        regionalPicker.showsSelectionIndicator = YES;
        [setUpView addSubview:regionalPicker];
        if (currentRegional) {
            [regionalPicker selectRow:[[allWeekRegionals objectAtIndex:weekSelected] indexOfObject:currentRegional] inComponent:0 animated:YES];
        }
        
        // Save and exit button
        UIButton *saveSetupButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [saveSetupButton addTarget:self action:@selector(eraseSetUpScreen) forControlEvents:UIControlEventTouchUpInside];
        [saveSetupButton setTitle:@"Save Settings" forState:UIControlStateNormal];
        saveSetupButton.frame = CGRectMake(254, 620, 120, 30);
        saveSetupButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        [setUpView addSubview:saveSetupButton];
        saveSetupButton.layer.cornerRadius = 5;
        
        // Zoom small animation
        setUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [greyOut addSubview:setUpView];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             setUpView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished){}];
        }
}
// Checks values and closes SetUpScreen after the "Save Settings" button is pressed
-(void)eraseSetUpScreen{
    initials = nil;
    scoutTeamNum = nil;
    currentMatchNum = nil;
    currentRegional = nil;
    
    initials = initialsField.text;
    scoutTeamNum = scoutTeamNumField.text;
    
    // Creates a random team number for the scout to watch to simulate a loaded match schedule
    NSInteger randomTeamNum = arc4random() % 4000;
    
    currentTeamNum = [[NSString alloc] initWithFormat:@"%ld", (long)randomTeamNum];
    currentMatchNum = currentMatchNumField.text;
    currentRegional = [[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex] objectAtIndex:[regionalPicker selectedRowInComponent:0]];
    
    // Checks for the correct number of initials
    if (!initials || initials.length != 3) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You didn't enter 3 initials!"
                                                       message: @"Please enter your three initials to show that you are scouting these matches"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // Checks for something to be entered in the scout's team number field
    else if (scoutTeamNumField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Enter your team number!"
                                                       message: @"Enter the team number of the team that you are on"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // Checks for the current match number to have something entered in it
    else if (!currentMatchNum || currentMatchNumField.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No match number!!"
                                                       message: @"What you tryin' to get away with?!? Please enter the match number you're about to scout"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // Checks to make sure that the user selected a scouting position
    else if(!pos){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You did not select which position you're scouting!"
                                                       message: @"Sorry to ruin your day, but in order to make this work out best for the both of us, you gotta select which position you are scouting (Red 1, Red 2, etc.)"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // If all tests pass, then the screen closes with a zoom small animation
    else{
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             setUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                         }
                         completion:^(BOOL finished){
                             
                             [setUpView removeFromSuperview];
                             [greyOut removeFromSuperview];
                             
                             // Updates editable values for the scout UI
                             currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
                             [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
                             _matchNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
                             [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
                             _teamNumEdit.titleLabel.font = [UIFont systemFontOfSize:25];
                             
                             // Shows the initials of the scout
                             _initialsLbl.text = [[NSString alloc] initWithFormat:@"Your Initials: %@", initials];
                             
                             // Displays the regional name in the top left corner in a box
                             _regionalNameLbl.text = currentRegional;
                             _regionalNameLbl.numberOfLines = 0;
                             [_regionalNameLbl sizeToFit];
                             _regionalNameLbl.adjustsFontSizeToFitWidth = YES;
                             _regionalNameLbl.textAlignment = NSTextAlignmentCenter;
                             _regionalNameLbl.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
                             _regionalNameLbl.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
                             _regionalNameLbl.layer.borderWidth = 1.0;
                             
                             twoFingerDown.enabled = true;
                             
                             // Shows the scouts position nice and large-like in the top center of the screen
                             CGRect red1Rect = CGRectMake(282, 145, 200, 60);
                             red1Lbl = [[UILabel alloc] initWithFrame:red1Rect];
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
                             
                             for (UIView *v in posUpdateArray) {
                                 v.hidden = false;
                             }
                             if (red1Pos >= 0 && red1Pos < 3) {[[posUpdateArray objectAtIndex:red1Pos+1] setBackgroundColor:[UIColor redColor]]; [_movementRobot setImage:[UIImage imageNamed:@"RedRobot"]];}
                             else if (red1Pos >= 3 && red1Pos < 6) {[[posUpdateArray objectAtIndex:red1Pos+1] setBackgroundColor:[UIColor blueColor]]; [_movementRobot setImage:[UIImage imageNamed:@"BlueRobot"]];}
                             
                             for (UIView *v in autoScreenObjects) {
                                 v.hidden = false;
                             }
                             _movementLine.alpha = 1;
                             [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                 for (UIView *v in autoScreenObjects) {
                                     if ([v isKindOfClass:[UIButton class]] || [v isKindOfClass:[UIImage class]]) {
                                         v.userInteractionEnabled = YES;
                                     }
                                     v.alpha = 1;
                                 }
                                 _mobilityBonusLbl.backgroundColor = [UIColor whiteColor];
                                 _mobilityBonusLbl.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
                                 _mobilityBonusLbl.layer.borderWidth = 1;
                             } completion:^(BOOL finished) {}];

//                             self.myPeerIDS = [[MCPeerID alloc] initWithDisplayName:pos];
//                             [self.browserSession disconnect];
//                             self.browserSession = nil;
//                             if (visible) {
//                                 visible = false;
//                                 [self.advertiserS stop];
//                             }
//                             else if (host){
//                                 host = false;
//                             }
                         }];
        NSLog(@"\n Position: %@ \n Initials: %@ \n Scout Team Number: %@ \n Regional Title: %@ \n Match Number: %@", pos, initials, scoutTeamNum, currentRegional, currentMatchNum);
    }
}
// Opens up the SetUpScreen once more after it has been closed once already (if users rotate)
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

- (IBAction)instashare:(id)sender {
    [self shareScreen];
}
// Creates custom screen for Multipeer Connectivity
-(void)shareScreen{
    // Gray background behind the view
    CGRect greyOutRect = CGRectMake(0, 0, 768, 1024);
    greyOut = [[UIControl alloc] initWithFrame:greyOutRect];
    [greyOut addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:greyOut];
    
    // The view itself
    CGRect shareScreenRect = CGRectMake(0, 0, 400, 200);
    shareScreen = [[UIView alloc] initWithFrame:shareScreenRect];
    shareScreen.backgroundColor = [UIColor whiteColor];
    shareScreen.layer.cornerRadius = 10;
    
    // Title for the pop-up screen
    CGRect instaShareTitleRect = CGRectMake(100, 10, 200, 20);
    instaShareTitle = [[UILabel alloc] initWithFrame:instaShareTitleRect];
    instaShareTitle.text = @"Insta-Share Connect";
    instaShareTitle.textAlignment = NSTextAlignmentCenter;
    instaShareTitle.font = [UIFont boldSystemFontOfSize:18];
    instaShareTitle.textColor = [UIColor colorWithRed:63.0/255.0 green:192.0/255.0 blue:255.0/255.0 alpha:1];
    [shareScreen addSubview:instaShareTitle];
    
    // Exit button on the top right
    CGRect closeButtonRect = CGRectMake(340, 5, 60, 20);
    closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = closeButtonRect;
    [closeButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    [shareScreen addSubview:closeButton];
    closeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    // Labels the Host Switch
    CGRect hostSwitchLblRect = CGRectMake(75, 45, 50, 15);
    hostSwitchLbl = [[UILabel alloc] initWithFrame:hostSwitchLblRect];
    hostSwitchLbl.text = @"Host";
    hostSwitchLbl.textAlignment = NSTextAlignmentCenter;
    hostSwitchLbl.font = [UIFont systemFontOfSize:12];
    [shareScreen addSubview:hostSwitchLbl];
    
    // Initiates the Browser role of Multipeer Connectivity
    CGRect hostSwitchRect = CGRectMake(75, 60, 50, 30);
    hostSwitch = [[UISwitch alloc] initWithFrame:hostSwitchRect];
    [hostSwitch addTarget:self action:@selector(hostSwitch) forControlEvents:UIControlEventValueChanged];
    [shareScreen addSubview:hostSwitch];
    [hostSwitch setOn:host animated:YES];
    
    CGRect inviteMoreBtnRect = CGRectMake(60, 100, 80, 30);
    inviteMoreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    inviteMoreBtn.frame = inviteMoreBtnRect;
    [inviteMoreBtn setTitle:@"Invite More" forState:UIControlStateNormal];
    [inviteMoreBtn addTarget:self action:@selector(inviteMorePeers) forControlEvents:UIControlEventTouchUpInside];
    [shareScreen addSubview:inviteMoreBtn];
    
    // Labels the Visible Switch
    CGRect visibleSwitchLblRect = CGRectMake(275, 45, 50, 15);
    visibleSwitchLbl = [[UILabel alloc] initWithFrame:visibleSwitchLblRect];
    visibleSwitchLbl.text = @"Visible";
    visibleSwitchLbl.textAlignment = NSTextAlignmentCenter;
    visibleSwitchLbl.font = [UIFont systemFontOfSize:12];
    [shareScreen addSubview:visibleSwitchLbl];
    
    // Initiates the Advertiser role of Multipeer Connectivity
    CGRect visibleSwitchRect = CGRectMake(275, 60, 50, 30);
    visibleSwitch = [[UISwitch alloc] initWithFrame:visibleSwitchRect];
    [visibleSwitch addTarget:self action:@selector(visibleSwitch) forControlEvents:UIControlEventValueChanged];
    [shareScreen addSubview:visibleSwitch];
    [visibleSwitch setOn:visible animated:YES];
    
    // Finish process (only enabled after a connection is established)
    CGRect doneButtonRect = CGRectMake(170, 145, 60, 40);
    doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = doneButtonRect;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
    doneButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    doneButton.layer.cornerRadius = 5;
    [shareScreen addSubview:doneButton];
    
    // Hides and disables subviews of the ShareScreen so it doesn't look weird on the animation
    instaShareTitle.hidden = true;
    closeButton.hidden = true;
    closeButton.enabled = false;
    hostSwitchLbl.hidden = true;
    hostSwitch.hidden = true;
    hostSwitch.enabled = false;
    visibleSwitchLbl.hidden = true;
    visibleSwitch.hidden = true;
    visibleSwitch.enabled = false;
    inviteMoreBtn.enabled = false;
    inviteMoreBtn.hidden = true;
    doneButton.hidden = true;
    doneButton.enabled = false;
    
    // Animates the ShareScreen to zoom in from the top left corner (where the button is)
    shareScreen.frame = CGRectMake(0, 0, 1, 1);
    [greyOut addSubview:shareScreen];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         shareScreen.frame = CGRectMake(183, 364, 400, 200);
                     }
                     completion:^(BOOL finished){
                         // Shows and enables subviews of ShareScreen after animation is done
                         instaShareTitle.hidden = false;
                         closeButton.hidden = false;
                         closeButton.enabled = true;
                         hostSwitchLbl.hidden = false;
                         hostSwitch.hidden = false;
                         hostSwitch.enabled = true;
                         visibleSwitchLbl.hidden = false;
                         visibleSwitch.hidden = false;
                         visibleSwitch.enabled = true;
                         inviteMoreBtn.enabled = host;
                         inviteMoreBtn.hidden = !host;
                         doneButton.hidden = false;
                         doneButton.enabled = true;
                     }];
    
}
// Takes away the ShareView with animation
-(void)closeShareView{
    dispatch_async(dispatch_get_main_queue(), ^{
        instaShareTitle.hidden = true;
        closeButton.hidden = true;
        closeButton.enabled = false;
        hostSwitchLbl.hidden = true;
        hostSwitch.hidden = true;
        hostSwitch.enabled = false;
        visibleSwitchLbl.hidden = true;
        visibleSwitch.hidden = true;
        visibleSwitch.enabled = false;
        inviteMoreBtn.hidden = true;
        inviteMoreBtn.enabled = false;
        doneButton.hidden = true;
        doneButton.enabled = false;
        
        // Zooms the ShareScreen small and back up to the top left corner
        [greyOut addSubview:shareScreen];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             shareScreen.frame = CGRectMake(0, 0, 1, 1);
                         }
                         completion:^(BOOL finished){
                             [shareScreen removeFromSuperview];
                             [greyOut removeFromSuperview];
                         }];
    });
}


/**********************************
 ********** SetUpScreen ***********
 **********************************/

// Called by the red1Selector UISegmentedControl in the SetUpView so that the scout's position is changed precisely when user changes it
-(void)red1Changed{
    red1SelectedPos = red1Selector.selectedSegmentIndex;
    pos = [red1Selector titleForSegmentAtIndex:red1Selector.selectedSegmentIndex];
    NSLog(@"%@", pos);
}
// Called by the matchTypeSelector UISegmentedControl
-(void)changeMatchType{
    if (matchTypeSelector.selectedSegmentIndex == 0) {
        currentMatchType = @"Q";
    }
    else{
        currentMatchType = @"E";
    }
}
// Called by the weekSelector UISegmentedControl
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

// Limits the three UITextFields in the SetUpView to only allow inputs that they are meant to have
-(void)checkNumber{
    // Makes sure only numbers are entered in these two fields
    if (scoutTeamNumField.isEditing) {
        NSMutableString *txt1 = [[NSMutableString alloc] initWithString:scoutTeamNumField.text];
        for (unsigned int i = 0; i < [txt1 length]; i++) {
            NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt1 characterAtIndex:i]];
            if ([character integerValue] == 0 && ![character isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Numbers only please!"
                                                               message: @"Please only enter numbers in the \"Your Team Number\" text field"
                                                              delegate: nil
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
                                                              delegate: nil
                                                     cancelButtonTitle:@"Sorry..."
                                                     otherButtonTitles:nil];
                [alert show];
                [txt2 deleteCharactersInRange:NSMakeRange(i, 1)];
                currentMatchNumField.text = [[NSString alloc] initWithString:txt2];
            }
        }
    }
    // Limits the initialsField to 3 characters
    if (initialsField.isEditing) {
        NSMutableString *txt3 = [[NSMutableString alloc] initWithString:initialsField.text];
        for (unsigned int i = 0; i < [txt3 length]; i++) {
            NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt3 characterAtIndex:i]];
            if ([character isEqualToString:@" "]) {
                [txt3 deleteCharactersInRange:NSMakeRange(i, 1)];
                initialsField.text = [[NSString alloc] initWithString:txt3];
            }
        }
        if ([txt3 length] > 3) {
            [txt3 deleteCharactersInRange:NSMakeRange(3, 1)];
            initialsField.text = [[NSString alloc] initWithString:txt3];
        }
    }
}
// Removes textfield if the return key is pressed
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*---------------------------------
 --------- UIPicker code ----------
 ---------------------------------*/

// Tell the picker how many rows are available for a given component based on WeekSelector selection
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

// Tell the picker how many components it will have (1)
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Give the picker its source of list items based on WeekSelector's selection
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

// Tell the picker the width of each row for a given component (420)
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int sectionWidth = 420;
    
    return sectionWidth;
}

// Sets up the match data to be sent
-(void)setUpData{
    dictToSend = nil;
    dictToSend = [[NSMutableDictionary alloc] init];
    [dictToSend setObject:[[NSMutableDictionary alloc] init] forKey:currentRegional];
    [[dictToSend objectForKey:currentRegional] setObject:[[NSMutableDictionary alloc] init] forKey:currentTeamNum];
//    [[[dictToSend objectForKey:currentRegional] objectForKey:currentTeamNum] setObject:[[NSDictionary alloc] initWithObjectsAndKeys:
//                                                                                        [NSNumber numberWithInteger:teleopHighScore], @"teleHighScore",
//                                                                                        [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
//                                                                                        [NSNumber numberWithInteger:teleopMidScore], @"teleMidScore",
//                                                                                        [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
//                                                                                        [NSNumber numberWithInteger:teleopLowScore], @"teleLowScore",
//                                                                                        [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
//                                                                                        //[NSNumber numberWithInteger:[m.endGame integerValue]], @"endGame",
//                                                                                        [NSNumber numberWithInteger:largePenaltyTally], @"penaltyLarge",
//                                                                                        [NSNumber numberWithInteger:smallPenaltyTally], @"penaltySmall",
//                                                                                        [NSString stringWithString:pos], @"red1Pos",
//                                                                                        [NSString stringWithString:scoutTeamNum], @"recordingTeam",
//                                                                                        [NSString stringWithString:currentMatchType], @"matchType",
//                                                                                        [NSString stringWithString:currentMatchNum], @"matchNum",
//                                                                                        [NSNumber numberWithInteger:secs], @"uniqueID", nil] forKey:currentMatchNum];
}

/**********************************
 ********** Insta-Share ***********
 **********************************/

-(void)setUpMultiPeer{
    self.myPeerIDS = [[MCPeerID alloc] initWithDisplayName:pos];
    
    self.browserSession = [[MCSession alloc] initWithPeer:self.myPeerIDS];
    
    self.browserSession.delegate = self;
    
    self.browserVCS = [[MCBrowserViewController alloc] initWithServiceType:@"firstscout" session:self.browserSession];
    
    self.browserVCS.delegate = self;
    
    self.advertiserSession = [[MCSession alloc] initWithPeer:self.myPeerIDS];
    
    self.advertiserSession.delegate = self;
    
    self.advertiserS = [[MCAdvertiserAssistant alloc] initWithServiceType:@"firstscout" discoveryInfo:nil session:self.advertiserSession];
}


// Starts Browser role and initiates the MCSession
-(void)hostSwitch{
    if (hostSwitch.on) {
        if (visible) {
//            [self.advertiserS stop];
        }
//        host = true;
//        visible = false;
        [self setUpMultiPeer];
//        inviteMoreBtn.enabled = true;
//        inviteMoreBtn.hidden = false;
        [self presentViewController:self.browserVCS animated:YES completion:nil];
//        self.browserVCS.view.layer.cornerRadius = 5;
//        self.browserVCS.view.superview.layer.cornerRadius = 5;
    }
    else{
        if (!visibleSwitch.on) {
            NSLog(@"Should disconnect");
//            inviteMoreBtn.enabled = false;
//            inviteMoreBtn.hidden = true;
//            [self.browserSession disconnect];
        }
    }
}
// Starts Advertiser role
-(void)visibleSwitch{
    if (visibleSwitch.on) {
//        visible = true;
//        host = false;
//        [hostSwitch setOn:false animated:YES];
        [self setUpMultiPeer];
        [self.advertiserS start];
    }
    else{
        [self.advertiserS stop];
//        [self hostSwitch];
    }
}
-(void)inviteMorePeers{
    [self presentViewController:self.browserVCS animated:YES completion:nil];
}

-(void)dismissBrowserVCS{
    [self.browserVCS dismissViewControllerAnimated:NO completion: nil];//^(void){
//        [visibleSwitch setOn:false animated:YES];
//        [self closeShareView];
//    }];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserVCS{
    NSLog(@"Finished");
    [self dismissBrowserVCS];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    NSLog(@"Cancelled");
    [self dismissBrowserVCS];
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        NSLog(@"HOLY FRIGGIN CRAP YESSS!!!!");
        self.advertiserSession = session;
        
//        self.browserSession = session;
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
//            if (visible) {
//                [UIAlertView showWithTitle:@"Wahoo!" message:[[NSString alloc] initWithFormat:@"You connected with %@!", [peerID displayName]] cancelButtonTitle:@"Got it bro" otherButtonTitles:nil completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                    [self closeShareView];
//                }];
////                [self.advertiserS stop];
//            }
//            if ([[peerID displayName] isEqualToString:@"Red 1"]) {[[posUpdateArray objectAtIndex:1] setBackgroundColor:[UIColor redColor]];}
//            else if ([[peerID displayName] isEqualToString:@"Red 2"]) {[[posUpdateArray objectAtIndex:2] setBackgroundColor:[UIColor redColor]];}
//            else if ([[peerID displayName] isEqualToString:@"Red 3"]) {[[posUpdateArray objectAtIndex:3] setBackgroundColor:[UIColor redColor]];}
//            else if ([[peerID displayName] isEqualToString:@"Blue 1"]) {[[posUpdateArray objectAtIndex:4] setBackgroundColor:[UIColor blueColor]];}
//            else if ([[peerID displayName] isEqualToString:@"Blue 2"]) {[[posUpdateArray objectAtIndex:5] setBackgroundColor:[UIColor blueColor]];}
//            else if ([[peerID displayName] isEqualToString:@"Blue 3"]) {[[posUpdateArray objectAtIndex:6] setBackgroundColor:[UIColor blueColor]];}
//        });
    }
    else if (state == MCSessionStateNotConnected){
        NSLog(@"Disconnected");
//        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (host) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Uh Oh!"
                                                               message: [[NSString alloc] initWithFormat:@"%@ left the party!", [peerID displayName]]
                                                              delegate: nil
                                                     cancelButtonTitle:@"Got it bro"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            else if (visible){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Uh Oh!"
                                                               message: @"You disconnected from the party!"
                                                              delegate: nil
                                                     cancelButtonTitle:@"Got it bro"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            if ([[peerID displayName] isEqualToString:@"Red 1"]) {[[posUpdateArray objectAtIndex:1] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
            else if ([[peerID displayName] isEqualToString:@"Red 2"]) {[[posUpdateArray objectAtIndex:2] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
            else if ([[peerID displayName] isEqualToString:@"Red 3"]) {[[posUpdateArray objectAtIndex:3] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
            else if ([[peerID displayName] isEqualToString:@"Blue 1"]) {[[posUpdateArray objectAtIndex:4] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
            else if ([[peerID displayName] isEqualToString:@"Blue 2"]) {[[posUpdateArray objectAtIndex:5] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
            else if ([[peerID displayName] isEqualToString:@"Blue 3"]) {[[posUpdateArray objectAtIndex:6] setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1.0]];}
//        });
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSData *dataReceived = data;
    
    receivedDataDict = [[NSMutableDictionary alloc] init];
    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    
    senderPeer = [[MCPeerID alloc] initWithDisplayName:[peerID displayName]];
    
    NSLog(@"DATA RECEIVED: %lu bytes! \n FROM: %@", (unsigned long)data.length, senderPeer.displayName);
    NSLog(@"DICT: %@", receivedDataDict);
    
    [self dataDictToCoreData];
}

-(void)dataDictToCoreData{
    [context performBlock:^{
        for (NSString *r in receivedDataDict) {
            Regional *rgnl = [Regional createRegionalWithName:r inManagedObjectContext:context];
            for (NSString *t in [receivedDataDict objectForKey:r]) {
                Team *tm = [Team createTeamWithName:t inRegional:rgnl withManagedObjectContext:context];
                for (NSString *m in [[receivedDataDict objectForKey:r] objectForKey:t]) {
                    NSDictionary *matchDict = [[[receivedDataDict objectForKey:r] objectForKey:t] objectForKey:m];
                    NSNumber *uniqueID = [NSNumber numberWithInteger:[[matchDict objectForKey:@"uniqueID"] integerValue]];
                    Match *mtch = [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
                    
                    if ([mtch.uniqeID integerValue] == [uniqueID integerValue]) {
                        NSLog(@"No conflicts!");
                    }
                    else{
                        [FSAdocument.managedObjectContext deleteObject:mtch];
                        NSLog(@"Deleted the conflicting match");
                        [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
                    }
                }
            }
        }
        
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
            if (success) {
                NSLog(@"Saved transferred data");
            }
            else{
                NSLog(@"Didn't transfer regionals correctly.");
            }
        }];
        
        receivedDataDict = nil;
    }];
}

/*****************************************
 ******** User Interaction Code **********
 *****************************************/

// Activated by two finger swipe up (changes to auto UI)
-(void)autoOn{
    autoYN = true;
    twoFingerUp.enabled = false;
    twoFingerDown.enabled = true;
    for (UIView *v in autoScreenObjects) {
        if ([v isKindOfClass:[UIButton class]] || [v isKindOfClass:[UIImage class]]) {
            v.userInteractionEnabled = YES;
        }
        v.hidden = false;
    }
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *v in autoScreenObjects) {
            
            if (mobilityBonus) {
                if (![v isEqual:_swipeUpArrow]) {
                    v.alpha = 1.0;
                }
                else{
                    v.alpha = 0;
                }
            }
            else{
                v.alpha = 1.0;
            }
        }
        for (UIView *v in teleopScreenObjects) {
            v.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (UIView *v in teleopScreenObjects) {
            if ([v isKindOfClass:[UIResponder class]]) {
                v.userInteractionEnabled = NO;
            }
            v.hidden = true;
        }
    }];
    
    NSLog(@"AUTO ON");
}
// Activated by two finger swipe down (changes to telop UI)
-(void)autoOff{
    autoYN = false;
    twoFingerUp.enabled = true;
    twoFingerDown.enabled = false;
    
    for (UIView *v in teleopScreenObjects) {
        if ([v isKindOfClass:[UIResponder class]]) {
            v.userInteractionEnabled = YES;
        }
        v.hidden = false;
    }
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *v in teleopScreenObjects) {
            v.alpha = 1.0;
        }
        for (UIView *v in autoScreenObjects) {
            v.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (UIView *v in autoScreenObjects) {
            if ([v isKindOfClass:[UIButton class]] || [v isKindOfClass:[UIImage class]]) {
                v.userInteractionEnabled = NO;
            }
            v.hidden = true;
        }
    }];
    
    NSLog(@"AUTO OFF");
}

float startY;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startY = recognizer.view.center.y;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void){
            _swipeUpArrow.alpha = 0;
        }completion:^(BOOL finished) {}];
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y + translation.y);
    if (recognizer.view.center.y < _movementLine.center.y - 50) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x, _movementLine.center.y - 50);
    }
    else if (recognizer.view.center.y > _movementLine.center.y + 50){
        recognizer.view.center = CGPointMake(recognizer.view.center.x, _movementLine.center.y + 50);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_movementRobot.center.y < _movementLine.center.y - 10) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x, _movementLine.center.y - 50);
            } completion:^(BOOL finished) {}];
        }
        else if (_movementRobot.center.y > _movementLine.center.y + 10){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x, _movementLine.center.y + 50);
            } completion:^(BOOL finished) {}];
        }
        else{
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                recognizer.view.center = CGPointMake(recognizer.view.center.x, startY);
            } completion:^(BOOL finished) {}];
        }
        
        if (_movementRobot.center.y == _movementLine.center.y - 50) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _mobilityBonusLbl.backgroundColor = [UIColor greenColor];
                _mobilityBonusLbl.layer.borderColor = [[UIColor whiteColor] CGColor];
            } completion:^(BOOL finished) {}];
            mobilityBonus = 1;
        }
        else{
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                _mobilityBonusLbl.backgroundColor = [UIColor whiteColor];
                _mobilityBonusLbl.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
            } completion:^(BOOL finished) {}];
            mobilityBonus = 0;
        }
    }
}

- (IBAction)autoHotHighPlus:(id)sender {
    autoHighHotScore++;
    _autoHotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighHotScore];
}
- (IBAction)autoHotHighMinus:(id)sender {
    if (autoHighHotScore > 0) {
        autoHighHotScore--;
        _autoHotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighHotScore];
    }
}
- (IBAction)autoNotHighPlus:(id)sender {
    autoHighNotScore++;
    _autoNotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighNotScore];
}
- (IBAction)autoNotHighMinus:(id)sender {
    if (autoHighNotScore > 0) {
        autoHighNotScore--;
        _autoNotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighNotScore];
    }
}
- (IBAction)autoMissHighPlus:(id)sender {
    autoHighMissScore++;
    _autoMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighMissScore];
}
- (IBAction)autoMissHighMinus:(id)sender {
    if (autoHighMissScore > 0) {
        autoHighMissScore--;
        _autoMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighMissScore];
    }
}

- (IBAction)autoHotLowPlus:(id)sender {
    autoLowHotScore++;
    _autoHotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowHotScore];
}
- (IBAction)autoHotLowMinus:(id)sender {
    if (autoLowHotScore > 0) {
        autoLowHotScore--;
        _autoHotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowHotScore];
    }
}
- (IBAction)autoNotLowPlus:(id)sender {
    autoLowNotScore++;
    _autoNotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowNotScore];
}
- (IBAction)autoNotLowMinus:(id)sender {
    if (autoLowNotScore > 0) {
        autoLowNotScore--;
        _autoNotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowNotScore];
    }
}
- (IBAction)autoMissLowPlus:(id)sender {
    autoLowMissScore++;
    _autoMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowMissScore];
}
- (IBAction)autoMissLowMinus:(id)sender {
    if (autoLowMissScore > 0) {
        autoLowMissScore--;
        _autoMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowMissScore];
    }
}



- (IBAction)teleopMakeHighPlus:(id)sender {
    teleopHighMake++;
    _teleopMakeHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMake];
}
- (IBAction)teleopMakeHighMinus:(id)sender {
    if (teleopHighMake > 0) {
        teleopHighMake--;
        _teleopMakeHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMake];
    }
}
- (IBAction)teleopMissHighPlus:(id)sender {
    teleopHighMiss++;
    _teleopMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMiss];
}
- (IBAction)teleopMissHighMinus:(id)sender {
    if (teleopHighMiss > 0) {
        teleopHighMiss--;
        _teleopMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMiss];
    }
}

- (IBAction)teleopMakeLowPlus:(id)sender {
    teleopLowMake++;
    _teleopMakeLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMake];
}
- (IBAction)teleopMakeLowMinus:(id)sender {
    if (teleopLowMake > 0) {
        teleopLowMake--;
        _teleopMakeLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMake];
    }
}
- (IBAction)teleopMissLowPlus:(id)sender {
    teleopLowMiss++;
    _teleopMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMiss];
}
- (IBAction)teleopMissLowMinus:(id)sender {
    if (teleopLowMiss > 0) {
        teleopLowMiss--;
        _teleopMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMiss];
    }
}

- (IBAction)teleopOverPlus:(id)sender {
    teleopOver++;
    _teleopOverLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopOver];
}
- (IBAction)teleopOverMinus:(id)sender {
    if (teleopOver > 0) {
        teleopOver--;
        _teleopOverLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopOver];
    }
}
- (IBAction)teleopCatchPlus:(id)sender {
    teleopCatch++;
    _teleopCatchLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopCatch];
}
- (IBAction)teleopCatchMinus:(id)sender {
    if (teleopCatch > 0) {
        teleopCatch--;
        _teleopCatchLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopCatch];
    }
}

- (IBAction)teleopPassedPlus:(id)sender {
    teleopPassed++;
    _teleopPassedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopPassed];
}
- (IBAction)teleopPassedMinus:(id)sender {
    if (teleopPassed > 0) {
        teleopPassed--;
        _teleopPassedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopPassed];
    }
}
- (IBAction)teleopReceivedPlus:(id)sender {
    teleopReceived++;
    _teleopReceivedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopReceived];
}
- (IBAction)teleopReceivedMinus:(id)sender {
    if (teleopReceived > 0) {
        teleopReceived--;
        _teleopReceivedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopReceived];
    }
}



// Makes the match number editable
-(IBAction)matchNumberEdit:(id)sender {
    _matchNumEdit.hidden = true;
    _matchNumEdit.enabled = false;
    _matchNumField.hidden = false;
    _matchNumField.enabled = true;
    _matchNumField.text = _matchNumEdit.titleLabel.text;
    [_matchNumField becomeFirstResponder];
}
// Makes the team number editable
-(IBAction)teamNumberEdit:(id)sender {
    _teamNumEdit.hidden = true;
    _teamNumEdit.enabled = false;
    _teamNumField.hidden = false;
    _teamNumField.enabled = true;
    _teamNumField.text = _teamNumEdit.titleLabel.text;
    _teamNumField.selected = true;
    [_teamNumField becomeFirstResponder];
}

// Changes the value for the number of small penalties recorded
-(IBAction)smallPenaltyChange:(id)sender {
    smallPenaltyTally = _smallPenaltyStepper.value;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
}
// Changes the value for the number of large penalties recorded
-(IBAction)largePenaltyChange:(id)sender {
    largePenaltyTally = _largePenaltyStepper.value;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
}


// Saves data that the user recorded on their screen
-(IBAction)saveMatch:(id)sender {
//    
//    // If the match number was edited by the user during that match
//    if (_matchNumEdit.isHidden) {
//        currentMatchNum = _matchNumField.text;
//    }
//    else{
//        currentMatchNum = _matchNumEdit.titleLabel.text;
//    }
//    // If the team number was edited by the user during the match
//    if (_teamNumEdit.isHidden) {
//        currentTeamNum = _teamNumField.text;
//    }
//    else{
//        currentTeamNum = _teamNumEdit.titleLabel.text;
//    }
//    
//    // If for some reason there was no match number (Shouldn't occur, but just in case)
//    if (currentMatchNum == nil || [currentMatchNum isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO MATCH NUMBER"
//                                                       message: @"Please enter a match number for this match."
//                                                      delegate: nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        [alert show];
//    }
//    // Another unlikely case: No team number. Also shouldn't happen, but a good safety net
//    else if (currentTeamNum == nil || [currentTeamNum isEqualToString:@""]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"NO TEAM NUMBER"
//                                                       message: @"Please enter a team number for this match."
//                                                      delegate: nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles:nil];
//        [alert show];
//    }
//    // If everything checks out, save the match locally
//    else{
//        [context performBlock:^{
//            Regional *rgnl = [Regional createRegionalWithName:currentRegional inManagedObjectContext:context];
//            
//            Team *tm = [Team createTeamWithName:currentTeamNum inRegional:rgnl withManagedObjectContext:context];
//            
//            // Create a uniqueID for this match
//            NSDate *now = [NSDate date];
//            secs = [now timeIntervalSince1970];
//            
//            NSDictionary *matchDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [NSNumber numberWithInteger:teleopHighScore], @"teleHighScore",
//                                       [NSNumber numberWithInteger:autoHighScore], @"autoHighScore",
//                                       [NSNumber numberWithInteger:teleopMidScore], @"teleMidScore",
//                                       [NSNumber numberWithInteger:autoMidScore], @"autoMidScore",
//                                       [NSNumber numberWithInteger:teleopLowScore], @"teleLowScore",
//                                       [NSNumber numberWithInteger:autoLowScore], @"autoLowScore",
//                                       //[NSNumber numberWithInteger:endGame], @"endGame",
//                                       [NSNumber numberWithInteger:largePenaltyTally], @"penaltyLarge",
//                                       [NSNumber numberWithInteger:smallPenaltyTally], @"penaltySmall",
//                                       [NSString stringWithString:pos], @"red1Pos",
//                                       [NSString stringWithString:scoutTeamNum], @"recordingTeam",
//                                       [NSString stringWithString:initials], @"scoutInitials",
//                                       [NSString stringWithString:currentMatchType], @"matchType",
//                                       [NSString stringWithString:currentMatchNum], @"matchNum",
//                                       [NSNumber numberWithInteger:secs], @"uniqueID", nil];
//            
//            Match *match = [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
//            
//            // If the match doesn't exist
//            if ([match.uniqeID integerValue] == secs) {
//                [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
//                    if (success) {
//                        [self saveSuccess];
//                    }
//                    else{
//                        NSLog(@"Didn't save correctly");
//                    }
//                }];
//            }
//            else{
//                // Temporarily store the match and team that there was a duplicate of and call the AlertView
//                duplicateMatch = match;
//                teamWithDuplicate = tm;
//                duplicateMatchDict = matchDict;
//                [self overWriteAlert];
//            }
//        }];
//        
//    }
    
    [self saveSuccess];

}

// Handles UIAlertViews that appear for the user
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // If the user does want to overwrite the conflicting match
    if ([alertView isEqual:overWriteAlert] && buttonIndex == 1) {
        [self overWriteMatch];
    }
}

// Creates the UIAlertView for notifying the user that there is a conflict in saving matches
-(void)overWriteAlert{
    UIAlertView *overWriteAlert = [[UIAlertView alloc]initWithTitle: @"MATCH ALREADY EXISTS"
                                                   message: @"Did you mean a different match? Or would you like to overwrite the existing match?"
                                                  delegate: self
                                         cancelButtonTitle:@"Edit Match"
                                         otherButtonTitles:@"Overwrite",nil];
    [overWriteAlert show];
}

// Called by the overWriteAlert AlertView affirmative response
-(void)overWriteMatch{
    [context performBlock:^{
        [FSAdocument.managedObjectContext deleteObject:duplicateMatch];
        [Match createMatchWithDictionary:duplicateMatchDict inTeam:teamWithDuplicate withManagedObjectContext:context];
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
            if (success) {
                [self saveSuccess];
            }
            else{
                NSLog(@"Didn't overwrite correctly");
            }
        }];
    }];
}

// Alerts user that there was a successful save and sends the match data on to connected peers
-(void)saveSuccess{
    // AlertView to show there was a successful save
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Success!"
                                                   message: @"You have saved the match!"
                                                  delegate: nil
                                         cancelButtonTitle:@"Cool story bro."
                                         otherButtonTitles:nil];
    [alert show];
    
    // Sends data to connected peers
//    [self setUpData];
//    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dictToSend];
//    NSError *error;
//    [self.browserSession sendData:dataToSend toPeers:[self.browserSession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    
    // Reset all the scores and labels
    autoHighHotScore = 0;
    _autoHotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighHotScore];
    autoHighNotScore = 0;
    _autoNotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighNotScore];
    autoHighMissScore = 0;
    _autoMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighMissScore];
    autoLowHotScore = 0;
    _autoHotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowHotScore];
    autoLowNotScore = 0;
    _autoNotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowNotScore];
    autoLowMissScore = 0;
    _autoMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowMissScore];
    mobilityBonus = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _movementRobot.center = CGPointMake(_movementRobot.center.x, _movementLine.center.y + 50);
        _swipeUpArrow.alpha = 1.0;
        _mobilityBonusLbl.backgroundColor = [UIColor whiteColor];
        _mobilityBonusLbl.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
    }];
    
    
    smallPenaltyTally = 0;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
    largePenaltyTally = 0;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
    
    // Increment match number by 1
    NSInteger matchNumTranslator = [currentMatchNum integerValue];
    matchNumTranslator++;
    currentMatchNum = [[NSString alloc] initWithFormat:@"%ld", (long)matchNumTranslator];
    currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
    [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
    
    // Generate a random team number to simulate a loaded schedule
    NSInteger randomTeamNum = arc4random() % 4000;
    currentTeamNum = [[NSString alloc] initWithFormat:@"%ld", (long)randomTeamNum];
    currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
    [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
    
    // Reset editability of match and team numbers
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
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void){
        _movementRobot.center = CGPointMake(_movementRobot.center.x, _movementLine.center.y + 50);
        _swipeUpArrow.alpha = 1;
    }completion:^(BOOL finished) {}];
    
    // Turns autonomous mode on
    [self autoOn];
    
}

// Hides any given keyboard. Kinda self-explanatory
-(IBAction)hideKeyboard:(id)sender {
    [_matchNumField resignFirstResponder];
    [_teamNumField resignFirstResponder];
    [scoutTeamNumField resignFirstResponder];
    [currentMatchNumField resignFirstResponder];
    [initialsField resignFirstResponder];
}








@end
