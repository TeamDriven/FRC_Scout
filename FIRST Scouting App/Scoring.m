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
#import "PitTeam.h"
#import "PitTeam+Category.h"
#import "UIAlertView+Blocks.h"

@interface LocationsFirstViewController ()

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

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

NSMutableString *notes;


// Match Defining Variables
NSString *initials;
NSString *scoutTeamNum;
NSString *currentMatchNum;
NSString *currentTeamNum;
NSString *currentRegional;
NSString *pos;
NSString *currentMatchType;





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

// Notes Screen Declarations
UIControl *notesScreen;
UITextView *notesTextField;
UIControl *redZone;
BOOL inRedZone;
UIControl *whiteZone;
BOOL inWhiteZone;
UIControl *blueZone;
BOOL inBlueZone;
UIControl *greatDefense;
BOOL didGreatDefense;
UIControl *badDefense;
BOOL didBadDefense;
UIControl *didntMove;
BOOL didDidntMove;
UIControl *fastMovement;
BOOL didFastMovement;
UIControl *slowMovement;
BOOL didSlowMovement;
UIControl *greatBallPickup;
BOOL didGreatBallPickup;
UIControl *badBallPickup;
BOOL didBadBallPickup;
UIControl *greatHumanPlayer;
BOOL didGreatHumanPlayer;
UIControl *badHumanPlayer;
BOOL didBadHumanPlayer;
UIControl *brokeDownInMatch;
BOOL didBrokeDownInMatch;
UIControl *greatDriver;
BOOL didGreatDriver;
UIControl *averageDriver;
BOOL didAverageDriver;
UIControl *badDriver;
BOOL didBadDriver;
UIControl *greatCooperation;
BOOL didGreatCooperation;
UIControl *badCooperation;
BOOL didBadCooperation;


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
UIView *red1Updater;
UILabel *red1UpdaterLbl;
UIView *red2Updater;
UILabel *red2UpdaterLbl;
UIView *red3Updater;
UILabel *red3UpdaterLbl;
UIView *blue1Updater;
UILabel *blue1UpdaterLbl;
UIView *blue2Updater;
UILabel *blue2UpdaterLbl;
UIView *blue3Updater;
UILabel *blue3UpdaterLbl;

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

// Match Schedule Filepath
NSArray *schedulePaths;
NSString *scheduleDirectory;
NSString *schedulePath;
NSMutableDictionary *scheduleDictionary;


// Tutorial Items
UIControl *gruyOutview;
UILabel *starterLbl;
NSInteger tutorialStep;

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
    regionalNames = @[@"Central Illinois Regional", @"Palmetto Regional", @"Alamo Regional sponsored by Rackspace Hosting", @"Greater Toronto West Regional", @"Inland Empire Regional", @"Center Line FIRST Robotics District Competition", @"Southfield FIRST Robotics District Competition", @"Granite State District Event", @"PNW FIRST Robotics Auburn Mountainview District Event", @"MAR FIRST Robotics Mt. Olive District Competition", @"MAR FIRST Robotics Hatboro-Horsham District Competition", @"Israel Regional", @"Greater Toronto East Regional", @"Arkansas Regional", @"San Diego Regional", @"Crossroads Regional", @"Lake Superior Regional", @"Northern Lights Regional", @"Hub City Regional", @"UNH District Event", @"Central Valley Regional", @"Kettering University FIRST Robotics District Competition", @"Gull Lake FIRST Robotics District Competition", @"PNW FIRST Robotics Oregon City District Event", @"PNW FIRST Robotics Glacier Peak District Event", @"Groton District Event", @"Mexico City Regional", @"Sacramento Regional", @"Orlando Regional", @"Greater Kansas City Regional", @"St. Louis Regional", @"North Carolina Regional", @"New York Tech Valley Regional", @"Dallas Regional", @"Utah Regional", @"WPI District Event", @"Escanaba FIRST Robotics District Competition", @"Howell FIRST Robotics District Competition", @"MAR FIRST Robotics Springside Chestnut Hill District Competition", @"PNW FIRST Robotics Eastern Washington University District Event", @"PNW FIRST Robotics Mt. Vernon District Event", @"MAR FIRST Robotics Clifton District Competition", @"Waterloo Regional", @"Festival de Robotique FRC a Montreal Regional", @"Arizona Regional", @"Los Angeles Regional sponsored by The Roddenberry Foundation", @"Boilermaker Regional", @"Buckeye Regional", @"Virginia Regional", @"Wisconsin Regional", @"West Michigan FIRST Robotics District Competition", @"Great Lakes Bay Region FIRST Robotics District Competition", @"Traverse City FIRST Robotics District Competition", @"PNW FIRST Robotics Wilsonville District Event", @"Rhode Island District Event", @"PNW FIRST Robotics Shorewood District Event", @"Southington District Event", @"MAR FIRST Robotics Lenape-Seneca District Competition", @"North Bay Regional", @"Peachtree Regional", @"Hawaii Regional", @"Minnesota 10000 Lakes Regional", @"Minnesota North Star Regional", @"SBPLI Long Island Regional", @"Finger Lakes Regional", @"Queen City Regional", @"Oklahoma Regional", @"Greater Pittsburgh Regional", @"Smoky Mountains Regional", @"Greater DC Regional", @"Northeastern University District Event", @"Livonia FIRST Robotics District Competition", @"St. Joseph FIRST Robotics District Competition", @"Waterford FIRST Robotics District Competition", @"PNW FIRST Robotics Auburn District Event", @"PNW FIRST Robotics Central Washington University District Event", @"Hartford District Event", @"MAR FIRST Robotics Bridgewater-Raritan District Competition", @"Western Canada Regional", @"Windsor Essex Great Lakes Regional", @"Silicon Valley Regional", @"Colorado Regional", @"South Florida Regional", @"Midwest Regional", @"Bayou Regional", @"Chesapeake Regional", @"Las Vegas Regional", @"New York City Regional", @"Lone Star Regional", @"Pine Tree District Event", @"Lansing FIRST Robotics District Competition", @"Bedford FIRST Robotics District Competition", @"Troy FIRST Robotics District Competition", @"PNW FIRST Robotics Oregon State University District Event", @"New England FRC Region Championship", @"Michigan FRC State Championship", @"Autodesk PNW FRC Championship", @"Mid-Atlantic Robotics FRC Region Championship", @"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
   
    // Week 1 Regionals of 2014
    week1Regionals = @[@"Central Illinois Regional", @"Palmetto Regional", @"Alamo Regional sponsored by Rackspace Hosting", @"Greater Toronto West Regional", @"Inland Empire Regional", @"Center Line FIRST Robotics District Competition", @"Southfield FIRST Robotics District Competition", @"Granite State District Event", @"PNW FIRST Robotics Auburn Mountainview District Event", @"MAR FIRST Robotics Mt. Olive District Competition", @"MAR FIRST Robotics Hatboro-Horsham District Competition", @"Israel Regional"];
    
    // Week 2 Regionals of 2014
    week2Regionals = @[@"Greater Toronto East Regional", @"Arkansas Regional", @"San Diego Regional", @"Crossroads Regional", @"Lake Superior Regional", @"Northern Lights Regional", @"Hub City Regional", @"UNH District Event", @"Central Valley Regional", @"Kettering University FIRST Robotics District Competition", @"Gull Lake FIRST Robotics District Competition", @"PNW FIRST Robotics Oregon City District Event", @"PNW FIRST Robotics Glacier Peak District Event", @"Groton District Event"];
    
    // Week 3 Regionals of 2014
    week3Regionals = @[@"Mexico City Regional", @"Sacramento Regional", @"Orlando Regional", @"Greater Kansas City Regional", @"St. Louis Regional", @"North Carolina Regional", @"New York Tech Valley Regional", @"Dallas Regional", @"Utah Regional", @"WPI District Event", @"Escanaba FIRST Robotics District Competition", @"Howell FIRST Robotics District Competition", @"MAR FIRST Robotics Springside Chestnut Hill District Competition", @"PNW FIRST Robotics Eastern Washington University District Event", @"PNW FIRST Robotics Mt. Vernon District Event", @"MAR FIRST Robotics Clifton District Competition"];
    
    // Week 4 Regionals of 2014
    week4Regionals = @[@"Waterloo Regional", @"Festival de Robotique FRC a Montreal Regional", @"Arizona Regional", @"Los Angeles Regional sponsored by The Roddenberry Foundation", @"Boilermaker Regional", @"Buckeye Regional", @"Virginia Regional", @"Wisconsin Regional", @"West Michigan FIRST Robotics District Competition", @"Great Lakes Bay Region FIRST Robotics District Competition", @"Traverse City FIRST Robotics District Competition", @"PNW FIRST Robotics Wilsonville District Event", @"Rhode Island District Event", @"PNW FIRST Robotics Shorewood District Event", @"Southington District Event", @"MAR FIRST Robotics Lenape-Seneca District Competition"];
    
    // Week 5 Regionals of 2014
    week5Regionals = @[@"North Bay Regional", @"Peachtree Regional", @"Hawaii Regional", @"Minnesota 10000 Lakes Regional", @"Minnesota North Star Regional", @"SBPLI Long Island Regional", @"Finger Lakes Regional", @"Queen City Regional", @"Oklahoma Regional", @"Greater Pittsburgh Regional", @"Smoky Mountains Regional", @"Greater DC Regional", @"Northeastern University District Event", @"Livonia FIRST Robotics District Competition", @"St. Joseph FIRST Robotics District Competition", @"Waterford FIRST Robotics District Competition", @"PNW FIRST Robotics Auburn District Event", @"PNW FIRST Robotics Central Washington University District Event", @"Hartford District Event", @"MAR FIRST Robotics Bridgewater-Raritan District Competition"];
    
    // Week 6 Regionals of 2014
    week6Regionals = @[@"Western Canada Regional", @"Windsor Essex Great Lakes Regional", @"Silicon Valley Regional", @"Colorado Regional", @"South Florida Regional", @"Midwest Regional", @"Bayou Regional", @"Chesapeake Regional", @"Las Vegas Regional", @"New York City Regional", @"Lone Star Regional", @"Pine Tree District Event", @"Lansing FIRST Robotics District Competition", @"Bedford FIRST Robotics District Competition", @"Troy FIRST Robotics District Competition", @"PNW FIRST Robotics Oregon State University District Event"];
    
    // Week 7+ Regionals of 2014
    week7Regionals = @[@"New England FRC Region Championship", @"Michigan FRC State Championship", @"Autodesk PNW FRC Championship", @"Mid-Atlantic Robotics FRC Region Championship", @"FIRST Championship - Archimedes Division",@"FIRST Championship - Curie Division",@"FIRST Championship - Galileo Division",@"FIRST Championship - Newton Division",@"FIRST Championship - Einstein"];
    
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
    
    notes = [[NSMutableString alloc] initWithString:@""];
}

-(void)viewDidAppear:(BOOL)animated{
    // *** Map to Schedule plist ***
    schedulePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    scheduleDirectory = [schedulePaths objectAtIndex:0];
    schedulePath = [scheduleDirectory stringByAppendingPathComponent:@"plistData.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:schedulePath]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"plistData" ofType:@"plist"] toPath:schedulePath error:nil];
    }
    // *** Done Mapping to Schedule plist ***
    scheduleDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:schedulePath];
    
    NSLog(@"%@", scheduleDictionary);
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
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
    red1Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
    red2Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
    red3Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
    blue1Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
    blue2Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
    blue3Updater = [[UIView alloc] initWithFrame:CGRectMake(lastX, 920, 80, 30)];
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
        if (pos != nil) {
            if ([pos isEqualToString:@"Red 1"]) {red1Pos = 0;}
            else if ([pos isEqualToString:@"Red 2"]){red1Pos = 1;}
            else if ([pos isEqualToString:@"Red 3"]){red1Pos = 2;}
            else if ([pos isEqualToString:@"Blue 1"]){red1Pos = 3;}
            else if ([pos isEqualToString:@"Blue 2"]){red1Pos = 4;}
            else if ([pos isEqualToString:@"Blue 3"]){red1Pos = 5;}
        }
        red1Selector.selectedSegmentIndex = red1Pos;
        NSLog(@"Red 1 Pos: %ld", (long)red1Pos);
        
        // Labels the scout initials field
        CGRect initialsFieldLblRect = CGRectMake(129, 190, 100, 15);
        UILabel *initialsFieldLbl = [[UILabel alloc] initWithFrame:initialsFieldLblRect];
        initialsFieldLbl.textAlignment = NSTextAlignmentCenter;
        initialsFieldLbl.text = @"YOUR 3 initials";
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
        scoutTeamNumFieldLbl.text = @"YOUR team #";
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
        currentMatchNumFieldLbl.text = @"Current Match Number";
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
        currentMatchNumField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        [setUpView addSubview:currentMatchNumField];
        if (![currentMatchType isEqualToString:@"Q"]) {
            if ([currentMatchNum isEqualToString:@"Q1.1"]) {
                currentMatchNum = @"Q2.1";
            }
            else if ([currentMatchNum isEqualToString:@"Q2.1"]){
                currentMatchNum = @"Q3.1";
            }
            else if ([currentMatchNum isEqualToString:@"Q3.1"]){
                currentMatchNum = @"Q4.1";
            }
            else if ([currentMatchNum isEqualToString:@"Q4.1"]){
                currentMatchNum = @"Q1.2";
            }
            else if ([currentMatchNum isEqualToString:@"Q1.2"]){
                currentMatchNum = @"Q2.2";
            }
            else if ([currentMatchNum isEqualToString:@"Q2.2"]){
                currentMatchNum = @"Q3.2";
            }
            else if ([currentMatchNum isEqualToString:@"Q3.2"]){
                currentMatchNum = @"Q4.2";
            }
            else if ([currentMatchNum isEqualToString:@"Q4.2"]){
                currentMatchNum = @"Q1.3";
            }
            else if ([currentMatchNum isEqualToString:@"Q1.3"]){
                currentMatchNum = @"Q2.3";
            }
            else if ([currentMatchNum isEqualToString:@"Q2.3"]){
                currentMatchNum = @"Q3.3";
            }
            else if ([currentMatchNum isEqualToString:@"Q3.3"]){
                currentMatchNum = @"Q4.3";
            }
            else if ([currentMatchNum isEqualToString:@"Q4.3"]){
                currentMatchNum = @"S1.1";
            }
            else if ([currentMatchNum isEqualToString:@"S1.1"]){
                currentMatchNum = @"S2.1";
            }
            else if ([currentMatchNum isEqualToString:@"S2.1"]){
                currentMatchNum = @"S1.2";
            }
            else if ([currentMatchNum isEqualToString:@"S1.2"]){
                currentMatchNum = @"S2.2";
            }
            else if ([currentMatchNum isEqualToString:@"S2.2"]){
                currentMatchNum = @"S1.3";
            }
            else if ([currentMatchNum isEqualToString:@"S1.3"]){
                currentMatchNum = @"S2.3";
            }
            else if ([currentMatchNum isEqualToString:@"S2.3"]){
                currentMatchNum = @"F1.1";
            }
            else if ([currentMatchNum isEqualToString:@"F1.1"]){
                currentMatchNum = @"F1.2";
            }
            else if ([currentMatchNum isEqualToString:@"F1.2"]){
                currentMatchNum = @"F1.3";
            }
            else if ([currentMatchNum isEqualToString:@"F1.3"]){
                currentMatchNum = @"F1.4";
            }
            else if ([currentMatchNum isEqualToString:@"F1.4"]){
                currentMatchNum = @"";
            }
            currentMatchNumField.text = currentMatchNum;
        }
        
        // Select either Qual or Elim match type (for data storage purposes)
        CGRect matchTypeSelectorRect = CGRectMake(364, 255, 170, 30);
        matchTypeSelector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Qualification", @"Elimination", nil]];
        matchTypeSelector.frame = matchTypeSelectorRect;
        [matchTypeSelector addTarget:self action:@selector(changeMatchType) forControlEvents:UIControlEventValueChanged];
        [setUpView addSubview:matchTypeSelector];
        if ([currentMatchType isEqualToString:@"Q"]) {
            matchTypeSelector.selectedSegmentIndex = 0;
            currentMatchNumField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else{
            matchTypeSelector.selectedSegmentIndex = 1;
            currentMatchNumField.keyboardType = UIKeyboardTypeAlphabet;
        }
        
        matchTypeSelector.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        // Title for week selector UISegmentedControl
        CGRect weekSelectorLblRect = CGRectMake(43, 310, 30, 30);
        UILabel *weekSelectorLbl = [[UILabel alloc] initWithFrame:weekSelectorLblRect];
        weekSelectorLbl.textAlignment = NSTextAlignmentCenter;
        weekSelectorLbl.text = @"Week";
        weekSelectorLbl.adjustsFontSizeToFitWidth = YES;
        weekSelectorLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [setUpView addSubview:weekSelectorLbl];
        
        // Narrows the selection list by week selected by user
        CGRect weekSelectorRect = CGRectMake(-50, 433, 215, 30);
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
        CGRect regionalPickerRect = CGRectMake(90, 340, 495, 300);
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
//    NSInteger randomTeamNum = arc4random() % 4000;
    
    
    currentMatchNum = currentMatchNumField.text;
    currentRegional = [[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex] objectAtIndex:[regionalPicker selectedRowInComponent:0]];
    
    BOOL validMatchNumber = true;
    
    if ([currentMatchType isEqualToString:@"Q"]) {
        if ([scheduleDictionary objectForKey:currentRegional]) {
            if ([[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum]) {
                currentTeamNum = [[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum];
            }
            else{
                validMatchNumber = false;
            }
        }
        else{
            currentTeamNum = @"";
        }
    }
    else{
        currentTeamNum = @"";
    }
    
    BOOL badMatchFormat = true;
    if ([currentMatchType isEqualToString:@"E"]){
        if (currentMatchNum.length == 4) {
            if ([[currentMatchNum substringToIndex:2] isEqualToString:@"Q1"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q2"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q3"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q4"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"S1"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"S2"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"F1"]) {
                if ([[currentMatchNum substringWithRange:NSMakeRange(3, 1)] integerValue] > 0) {
                    badMatchFormat = false;
                }
            }
        }
    }
    else{
        badMatchFormat = false;
    }
    
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
    // Checks to make sure that the user selected a scouting position
    else if(!pos){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"You did not select which position you're scouting!"
                                                       message: @"Sorry to ruin your day, but in order to make this work out best for the both of us, you gotta select which position you are scouting (Red 1, Red 2, etc.)"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // Checks for the current match number to have something entered in it
    else if (!currentMatchNum || currentMatchNumField.text.length == 0 || !validMatchNumber){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Invalid Match Number!!"
                                                       message: @"What you tryin' to get away with?!? Please enter the match number you're about to scout"
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (badMatchFormat){
        UIAlertView *badMatchFormatAlert = [[UIAlertView alloc] initWithTitle:@"Bad Match Format!"
                                                                      message:@"Remember to follow the format: \n Quarterfinal Match -> Q1.1, Q1.2, etc. \n Semifinal Match -> S1.1, S1.2, etc. \n Final Match -> F1.1, F1.2, etc."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"My Bad" otherButtonTitles: nil];
        [badMatchFormatAlert show];
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
                             
                             if (currentTeamNum.length == 0) {
                                 _teamNumField.enabled = true;
                                 _teamNumField.hidden = false;
                                 _teamNumEdit.enabled = false;
                                 _teamNumEdit.hidden = true;
                                 _teamNumField.text = @"";
                             }
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
                             
                             if (red1Pos != red1SelectedPos && red1Pos > -1) {
                                 [[posUpdateArray objectAtIndex:red1Pos+1] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
                             }
                             
                             red1Pos = red1Selector.selectedSegmentIndex;
                             
                             NSFetchRequest *roboPicRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
                             NSPredicate *roboPicPredicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", currentTeamNum];
                             roboPicRequest.predicate = roboPicPredicate;
                             NSError *roboPicError = nil;
                             NSArray *roboPics = [context executeFetchRequest:roboPicRequest error:&roboPicError];
                             PitTeam *pt = [roboPics firstObject];
                             _robotPic.alpha = 0;
                             UIImage *image = [UIImage imageWithData:[pt valueForKey:@"image"]];
                             _robotPic.image = image;
                             
                             [UIView animateWithDuration:0.2 animations:^{
                                 _robotPic.alpha = 1;
                             }];
                             
                             for (UIView *v in posUpdateArray) {
                                 v.hidden = false;
                             }
                             if (red1Pos >= 0 && red1Pos < 3) {[[posUpdateArray objectAtIndex:red1Pos+1] setBackgroundColor:[UIColor redColor]]; [_movementRobot setImage:[UIImage imageNamed:@"RedRobot"]];}
                             else if (red1Pos >= 3 && red1Pos < 6) {[[posUpdateArray objectAtIndex:red1Pos+1] setBackgroundColor:[UIColor blueColor]]; [_movementRobot setImage:[UIImage imageNamed:@"BlueRobot"]];}
                             [self.view bringSubviewToFront:_movementRobot];
                             
                             for (UIView *v in autoScreenObjects) {
                                 v.hidden = false;
                             }
                             _movementLine.alpha = 1;
                             [self autoOn];
                             
                             
                             if ([[scheduleDictionary objectForKey:@"FirstOpening"] boolValue] == true) {
                                 for(UITabBarItem *item in self.tabBarController.tabBar.items){
                                     item.enabled = false;
                                 }
                                 
                                 twoFingerDown.enabled = false;
                                 twoFingerUp.enabled = false;
                                 
                                 NSLog(@"entered first opening");
                                 
                                 gruyOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
                                 gruyOutview.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
                                 [gruyOutview addTarget:self action:@selector(nextStepInTutorial) forControlEvents:UIControlEventTouchUpInside];
                                 [self.view addSubview:gruyOutview];
                                 
                                 tutorialStep = 0;
                                 
                                 starterLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 160, 300, 70)];
                                 starterLbl.text = @"A few things before you get going...";
                                 starterLbl.numberOfLines = 2;
                                 starterLbl.font = [UIFont boldSystemFontOfSize:22];
                                 starterLbl.textAlignment = NSTextAlignmentCenter;
                                 starterLbl.textColor = [UIColor whiteColor];
                                 starterLbl.alpha = 0;
                                 starterLbl.lineBreakMode = NSLineBreakByWordWrapping;
                                 [gruyOutview addSubview:starterLbl];
                                 
                                 UIImageView *twoFingerTouch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twoFinger"]];
                                 twoFingerTouch.frame = CGRectMake(450, 300, 120, 120);
                                 twoFingerTouch.alpha = 0;
                                 [gruyOutview addSubview:twoFingerTouch];
                                 
                                 UILabel *twoFingerTouchLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 350, 250, 30)];
                                 twoFingerTouchLbl.text = @"The two finger slide.";
                                 twoFingerTouchLbl.textColor = [UIColor whiteColor];
                                 twoFingerTouchLbl.alpha = 0;
                                 twoFingerTouchLbl.font = [UIFont boldSystemFontOfSize:22];
                                 [gruyOutview addSubview:twoFingerTouchLbl];
                                 
                                 UILabel *teleopModeLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 250, 40)];
                                 teleopModeLbl.text = @"Teleop Scoring";
                                 teleopModeLbl.textColor = [UIColor whiteColor];
                                 teleopModeLbl.alpha = 0;
                                 teleopModeLbl.font = [UIFont boldSystemFontOfSize:35];
                                 [gruyOutview addSubview:teleopModeLbl];
                                 
                                 UILabel *autonomousModeLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 500, 300, 40)];
                                 autonomousModeLbl.text = @"Autonomous Scoring";
                                 autonomousModeLbl.textColor = [UIColor whiteColor];
                                 autonomousModeLbl.alpha = 0;
                                 autonomousModeLbl.font = [UIFont boldSystemFontOfSize:30];
                                 [gruyOutview addSubview:autonomousModeLbl];
                                 
                                 UILabel *tapToContinueLbl = [[UILabel alloc] initWithFrame:CGRectMake(284, 650, 200, 20)];
                                 tapToContinueLbl.text = @"Tap to Continue";
                                 tapToContinueLbl.textColor = [UIColor whiteColor];
                                 tapToContinueLbl.font = [UIFont boldSystemFontOfSize:18];
                                 tapToContinueLbl.alpha = 0;
                                 tapToContinueLbl.textAlignment = NSTextAlignmentCenter;
                                 [gruyOutview addSubview:tapToContinueLbl];
                                 
                                 
                                 [UIView animateWithDuration:0.3 animations:^{
                                     starterLbl.alpha = 1;
                                 } completion:^(BOOL finished) {
                                     sleep(3.0);
                                     [UIView animateWithDuration:0.3 animations:^{
                                         twoFingerTouchLbl.alpha = 1;
                                         twoFingerTouch.alpha = 1;
                                         starterLbl.alpha = 0;
                                     } completion:^(BOOL finished) {
                                         sleep(2.0);
                                         [self autoOff];
                                         [UIView animateWithDuration:0.5 animations:^{
                                             twoFingerTouch.center = CGPointMake(twoFingerTouch.center.x, twoFingerTouch.center.y + 150);
                                             teleopModeLbl.alpha = 1;
                                         } completion:^(BOOL finished) {
                                             sleep(2.5);
                                             teleopModeLbl.alpha = 0;
                                             [self autoOn];
                                             [UIView animateWithDuration:0.5 animations:^{
                                                 autonomousModeLbl.alpha = 1;
                                                 twoFingerTouch.center = CGPointMake(twoFingerTouch.center.x, twoFingerTouch.center.y - 150);
                                             } completion:^(BOOL finished) {
                                                 sleep(1.0);
                                                 [UIView animateWithDuration:0.3 animations:^{
                                                     tapToContinueLbl.alpha = 1;
                                                 } completion:^(BOOL finished) {
                                                     tutorialStep = 1;
                                                 }];
                                             }];
                                         }];
                                     }];
                                 }];
                             }
                         }];
        NSLog(@"\n Position: %@ \n Initials: %@ \n Scout Team Number: %@ \n Regional Title: %@ \n Match Number: %@", pos, initials, scoutTeamNum, currentRegional, currentMatchNum);
    }
}

-(void)nextStepInTutorial{
    if (tutorialStep == 1) {
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *moreThanOneScoutLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 250, 300, 70)];
            moreThanOneScoutLbl.text = @"If you have other scouts sitting nearby...";
            moreThanOneScoutLbl.font = [UIFont boldSystemFontOfSize:22];
            moreThanOneScoutLbl.numberOfLines = 2;
            moreThanOneScoutLbl.lineBreakMode = NSLineBreakByWordWrapping;
            moreThanOneScoutLbl.textAlignment = NSTextAlignmentCenter;
            moreThanOneScoutLbl.textColor = [UIColor whiteColor];
            [gruyOutview addSubview:moreThanOneScoutLbl];
            moreThanOneScoutLbl.alpha = 0;
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            arrowImage.frame = CGRectMake(100, 35, 53, 120);
            arrowImage.transform = CGAffineTransformMakeRotation(-M_PI/4);
            arrowImage.alpha = 0;
            [gruyOutview addSubview:arrowImage];
            
            UILabel *useInstaShareLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 400, 300, 100)];
            useInstaShareLbl.text = @"You should check out Bluetooth Sharing with the Insta-Share feature";
            useInstaShareLbl.textAlignment = NSTextAlignmentCenter;
            useInstaShareLbl.font = [UIFont boldSystemFontOfSize:24];
            useInstaShareLbl.numberOfLines = 3;
            useInstaShareLbl.lineBreakMode = NSLineBreakByWordWrapping;
            useInstaShareLbl.textColor = [UIColor whiteColor];
            useInstaShareLbl.alpha = 0;
            [gruyOutview addSubview:useInstaShareLbl];
            
            UILabel *instaShareExplain = [[UILabel alloc] initWithFrame:CGRectMake(224, 550, 320, 100)];
            instaShareExplain.text = @"After connecting to other scouts, the labels at the bottom will update as you receive their matches";
            instaShareExplain.textAlignment = NSTextAlignmentCenter;
            instaShareExplain.font = [UIFont boldSystemFontOfSize:19];
            instaShareExplain.numberOfLines = 3;
            instaShareExplain.lineBreakMode = NSLineBreakByWordWrapping;
            instaShareExplain.textColor = [UIColor whiteColor];
            instaShareExplain.alpha = 0;
            [gruyOutview addSubview:instaShareExplain];
            
            UILabel *tapToContinueLbl = [[UILabel alloc] initWithFrame:CGRectMake(284, 750, 200, 20)];
            tapToContinueLbl.text = @"Tap to Continue";
            tapToContinueLbl.textColor = [UIColor whiteColor];
            tapToContinueLbl.font = [UIFont boldSystemFontOfSize:17];
            tapToContinueLbl.alpha = 0;
            tapToContinueLbl.textAlignment = NSTextAlignmentCenter;
            [gruyOutview addSubview:tapToContinueLbl];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                moreThanOneScoutLbl.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(2.0);
                [UIView animateWithDuration:0.3 animations:^{
                    arrowImage.alpha = 1;
                    useInstaShareLbl.alpha = 1;
                } completion:^(BOOL finished) {
                    sleep(3.0);
                    [UIView animateWithDuration:0.3 animations:^{
                        instaShareExplain.alpha = 1;
                    } completion:^(BOOL finished) {
                        sleep(3.0);
                        [UIView animateWithDuration:0.3 animations:^{
                            tapToContinueLbl.alpha = 1;
                        } completion:^(BOOL finished) {
                            tutorialStep = 2;
                        }];
                    }];
                }];
            }];
        }];
    }
    else if (tutorialStep ==2){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *sarcasticQuestionLbl = [[UILabel alloc] initWithFrame:CGRectMake(184, 80, 400, 30)];
            sarcasticQuestionLbl.text = @"You: \"What else is at my fingertips?\"";
            sarcasticQuestionLbl.textColor = [UIColor whiteColor];
            sarcasticQuestionLbl.font = [UIFont boldSystemFontOfSize:24];
            sarcasticQuestionLbl.alpha = 0;
            sarcasticQuestionLbl.textAlignment = NSTextAlignmentCenter;
            [gruyOutview addSubview:sarcasticQuestionLbl];
            
            UILabel *answerLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 110, 300, 30)];
            answerLbl.text = @"Me: \"Glad you asked!\"";
            answerLbl.textColor = [UIColor whiteColor];
            answerLbl.font = [UIFont boldSystemFontOfSize:24];
            answerLbl.alpha = 0;
            answerLbl.textAlignment = NSTextAlignmentCenter;
            [gruyOutview addSubview:answerLbl];
            
            UILabel *regionalLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 140, 30)];
            regionalLbl.text = @"Your Regional";
            regionalLbl.textColor = [UIColor whiteColor];
            regionalLbl.font = [UIFont boldSystemFontOfSize:18];
            regionalLbl.textAlignment = NSTextAlignmentCenter;
            regionalLbl.alpha = 0;
            [gruyOutview addSubview:regionalLbl];
            
            UILabel *initialsLbl = [[UILabel alloc] initWithFrame:CGRectMake(600, 100, 140, 30)];
            initialsLbl.text = @"Your Initials";
            initialsLbl.textColor = [UIColor whiteColor];
            initialsLbl.font = [UIFont boldSystemFontOfSize:18];
            initialsLbl.textAlignment = NSTextAlignmentCenter;
            initialsLbl.alpha = 0;
            [gruyOutview addSubview:initialsLbl];
            
            UILabel *positionLbl = [[UILabel alloc] initWithFrame:CGRectMake(284, 170, 200, 30)];
            positionLbl.text = @"Your Scouting Position";
            positionLbl.textColor = [UIColor whiteColor];
            positionLbl.font = [UIFont boldSystemFontOfSize:18];
            positionLbl.textAlignment = NSTextAlignmentCenter;
            positionLbl.alpha = 0;
            [gruyOutview addSubview:positionLbl];
            
            UILabel *currentMatchNumber = [[UILabel alloc] initWithFrame:CGRectMake(180, 250, 200, 30)];
            currentMatchNumber.text = @"Current Match Number";
            currentMatchNumber.textColor = [UIColor whiteColor];
            currentMatchNumber.font = [UIFont boldSystemFontOfSize:16];
            currentMatchNumber.textAlignment = NSTextAlignmentCenter;
            currentMatchNumber.alpha = 0;
            [gruyOutview addSubview:currentMatchNumber];
            
            UILabel *matchNubmerEditable = [[UILabel alloc] initWithFrame:CGRectMake(180, 280, 200, 30)];
            matchNubmerEditable.text = @"(editable in case there's a mistake)";
            matchNubmerEditable.textColor = [UIColor whiteColor];
            matchNubmerEditable.font = [UIFont boldSystemFontOfSize:12];
            matchNubmerEditable.textAlignment = NSTextAlignmentCenter;
            matchNubmerEditable.alpha = 0;
            [gruyOutview addSubview:matchNubmerEditable];
            
            UILabel *currentTeamNumber = [[UILabel alloc] initWithFrame:CGRectMake(400, 250, 200, 30)];
            currentTeamNumber.text = @"Current Team Number";
            currentTeamNumber.textColor = [UIColor whiteColor];
            currentTeamNumber.font = [UIFont boldSystemFontOfSize:16];
            currentTeamNumber.textAlignment = NSTextAlignmentCenter;
            currentTeamNumber.alpha = 0;
            [gruyOutview addSubview:currentTeamNumber];
            
            UILabel *teamNumberEditable = [[UILabel alloc] initWithFrame:CGRectMake(400, 275, 200, 40)];
            teamNumberEditable.text = @"(editable and updates if a match schedule is loaded for the regional)";
            teamNumberEditable.textColor = [UIColor whiteColor];
            teamNumberEditable.font = [UIFont boldSystemFontOfSize:12];
            teamNumberEditable.textAlignment = NSTextAlignmentCenter;
            teamNumberEditable.alpha = 0;
            teamNumberEditable.numberOfLines = 2;
            teamNumberEditable.lineBreakMode = NSLineBreakByWordWrapping;
            [gruyOutview addSubview:teamNumberEditable];
            
            UILabel *saveMatchLbl = [[UILabel alloc] initWithFrame:CGRectMake(284, 850, 200, 30)];
            saveMatchLbl.text = @"Save Match Button";
            saveMatchLbl.textColor = [UIColor whiteColor];
            saveMatchLbl.textAlignment = NSTextAlignmentCenter;
            saveMatchLbl.font = [UIFont boldSystemFontOfSize:18];
            saveMatchLbl.alpha = 0;
            [gruyOutview addSubview:saveMatchLbl];
            
            UILabel *selfExplanitory = [[UILabel alloc] initWithFrame:CGRectMake(284, 880, 200, 30)];
            selfExplanitory.text = @"(kinda self explanatory)";
            selfExplanitory.textColor = [UIColor whiteColor];
            selfExplanitory.textAlignment = NSTextAlignmentCenter;
            selfExplanitory.font = [UIFont boldSystemFontOfSize:15];
            selfExplanitory.alpha = 0;
            [gruyOutview addSubview:selfExplanitory];
            
            UILabel *tapToContinueLbl = [[UILabel alloc] initWithFrame:CGRectMake(284, 650, 200, 20)];
            tapToContinueLbl.text = @"Tap to Continue";
            tapToContinueLbl.textColor = [UIColor whiteColor];
            tapToContinueLbl.font = [UIFont boldSystemFontOfSize:17];
            tapToContinueLbl.alpha = 0;
            tapToContinueLbl.textAlignment = NSTextAlignmentCenter;
            [gruyOutview addSubview:tapToContinueLbl];
            
            [UIView animateWithDuration:0.3 animations:^{
                sarcasticQuestionLbl.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(1.8);
                [UIView animateWithDuration:0.3 animations:^{
                    answerLbl.alpha = 1;
                } completion:^(BOOL finished) {
                    sleep(2.0);
                    [UIView animateWithDuration:0.3 animations:^{
                        regionalLbl.alpha = 1;
                    } completion:^(BOOL finished) {
                        sleep(1.5);
                        [UIView animateWithDuration:0.3 animations:^{
                            initialsLbl.alpha = 1;
                        } completion:^(BOOL finished) {
                            sleep(1.5);
                            [UIView animateWithDuration:0.3 animations:^{
                                positionLbl.alpha = 1;
                            } completion:^(BOOL finished) {
                                sleep(1.5);
                                [UIView animateWithDuration:0.3 animations:^{
                                    currentMatchNumber.alpha = 1;
                                    matchNubmerEditable.alpha = 1;
                                } completion:^(BOOL finished) {
                                    sleep(1.8);
                                    [UIView animateWithDuration:0.3 animations:^{
                                        currentTeamNumber.alpha = 1;
                                        teamNumberEditable.alpha = 1;
                                    } completion:^(BOOL finished) {
                                        sleep(2.0);
                                        [UIView animateWithDuration:0.3 animations:^{
                                            saveMatchLbl.alpha = 1;
                                            selfExplanitory.alpha = 1;
                                        } completion:^(BOOL finished) {
                                            sleep(2.0);
                                            [UIView animateWithDuration:0.3 animations:^{
                                                tapToContinueLbl.alpha = 1;
                                            } completion:^(BOOL finished) {
                                                tutorialStep = 3;
                                            }];
                                        }];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        }];
        
    }
    else if (tutorialStep == 3){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *changeSignIn = [[UILabel alloc] initWithFrame:CGRectMake(500, 150, 200, 60)];
            changeSignIn.text = @"If you need to change scouts/regionals/etc.";
            changeSignIn.textColor = [UIColor whiteColor];
            changeSignIn.textAlignment = NSTextAlignmentCenter;
            changeSignIn.font = [UIFont boldSystemFontOfSize:18];
            changeSignIn.alpha = 0;
            changeSignIn.numberOfLines = 2;
            changeSignIn.lineBreakMode = NSLineBreakByWordWrapping;
            [gruyOutview addSubview:changeSignIn];
            
            UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            arrowImage.frame = CGRectMake(550, 25, 53, 120);
            arrowImage.transform = CGAffineTransformMakeRotation(M_PI/4);
            arrowImage.alpha = 0;
            [gruyOutview addSubview:arrowImage];
            
            UILabel *nowForPageExplanations = [[UILabel alloc] initWithFrame:CGRectMake(209, 400, 350, 30)];
            nowForPageExplanations.text = @"Now for Page Explanations!";
            nowForPageExplanations.textColor = [UIColor whiteColor];
            nowForPageExplanations.textAlignment = NSTextAlignmentCenter;
            nowForPageExplanations.font = [UIFont boldSystemFontOfSize:24];
            nowForPageExplanations.alpha = 0;
            [gruyOutview addSubview:nowForPageExplanations];
            
            UILabel *holdTightLbl = [[UILabel alloc] initWithFrame:CGRectMake(209, 440, 350, 20)];
            holdTightLbl.text = @"(Almost done, just hold tight a little longer)";
            holdTightLbl.textColor = [UIColor whiteColor];
            holdTightLbl.textAlignment = NSTextAlignmentCenter;
            holdTightLbl.font = [UIFont boldSystemFontOfSize:16];
            holdTightLbl.alpha = 0;
            [gruyOutview addSubview:holdTightLbl];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 550, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:16];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                changeSignIn.alpha = 1;
                arrowImage.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(3.0);
                [UIView animateWithDuration:0.3 animations:^{
                    nowForPageExplanations.alpha = 1;
                    holdTightLbl.alpha = 1;
                } completion:^(BOOL finished) {
                    sleep(2.0);
                    [UIView animateWithDuration:0.3 animations:^{
                        tapToContinue.alpha = 1;
                    } completion:^(BOOL finished) {
                        tutorialStep = 4;
                    }];
                }];
            }];
        }];
    }
    else if (tutorialStep == 4){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *pitViewDetail = [[UILabel alloc] initWithFrame:CGRectMake(210, 790, 240, 30)];
            pitViewDetail.text = @"The Pit Scouting View";
            pitViewDetail.textColor = [UIColor whiteColor];
            pitViewDetail.textAlignment = NSTextAlignmentCenter;
            pitViewDetail.font = [UIFont boldSystemFontOfSize:20];
            pitViewDetail.alpha = 0;
            [gruyOutview addSubview:pitViewDetail];
            
            UILabel *detailPit = [[UILabel alloc] initWithFrame:CGRectMake(230, 820, 200, 30)];
            detailPit.text = @"For all you Pit Scouting needs";
            detailPit.textAlignment = NSTextAlignmentCenter;
            detailPit.textColor = [UIColor whiteColor];
            detailPit.font = [UIFont boldSystemFontOfSize:14];
            detailPit.alpha = 0;
            [gruyOutview addSubview:detailPit];
            
            UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            downArrow.frame = CGRectMake(303, 850, 53, 120);
            downArrow.alpha = 0;
            downArrow.transform = CGAffineTransformMakeRotation(M_PI);
            [gruyOutview addSubview:downArrow];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 600, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:18];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                pitViewDetail.alpha = 1;
                detailPit.alpha = 1;
                downArrow.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(2.0);
                [UIView animateWithDuration:0.3 animations:^{
                    tapToContinue.alpha = 1;
                } completion:^(BOOL finished) {
                    tutorialStep = 5;
                }];
            }];
        }];
    }
    else if (tutorialStep == 5){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *dataViewDetail = [[UILabel alloc] initWithFrame:CGRectMake(325, 790, 240, 30)];
            dataViewDetail.text = @"The Data View";
            dataViewDetail.textColor = [UIColor whiteColor];
            dataViewDetail.textAlignment = NSTextAlignmentCenter;
            dataViewDetail.font = [UIFont boldSystemFontOfSize:20];
            dataViewDetail.alpha = 0;
            [gruyOutview addSubview:dataViewDetail];
            
            UILabel *detailDataView = [[UILabel alloc] initWithFrame:CGRectMake(325, 820, 240, 40)];
            detailDataView.text = @"Where you can view and analyze all recorded data";
            detailDataView.textAlignment = NSTextAlignmentCenter;
            detailDataView.textColor = [UIColor whiteColor];
            detailDataView.font = [UIFont boldSystemFontOfSize:14];
            detailDataView.alpha = 0;
            detailDataView.numberOfLines = 2;
            detailDataView.lineBreakMode = NSLineBreakByWordWrapping;
            [gruyOutview addSubview:detailDataView];
            
            UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            downArrow.frame = CGRectMake(413, 850, 53, 120);
            downArrow.alpha = 0;
            downArrow.transform = CGAffineTransformMakeRotation(M_PI);
            [gruyOutview addSubview:downArrow];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 600, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:18];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                dataViewDetail.alpha = 1;
                detailDataView.alpha = 1;
                downArrow.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(2.0);
                [UIView animateWithDuration:0.3 animations:^{
                    tapToContinue.alpha = 1;
                } completion:^(BOOL finished) {
                    tutorialStep = 6;
                }];
            }];
        }];
    }
    else if (tutorialStep == 6){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *moreViewDetail = [[UILabel alloc] initWithFrame:CGRectMake(430, 790, 240, 30)];
            moreViewDetail.text = @"The More View";
            moreViewDetail.textColor = [UIColor whiteColor];
            moreViewDetail.textAlignment = NSTextAlignmentCenter;
            moreViewDetail.font = [UIFont boldSystemFontOfSize:20];
            moreViewDetail.alpha = 0;
            [gruyOutview addSubview:moreViewDetail];
            
            UILabel *detailMoreView = [[UILabel alloc] initWithFrame:CGRectMake(440, 810, 220, 60)];
            detailMoreView.text = @"Where you can sync with others, get match schedules, and more (hence the name)";
            detailMoreView.textAlignment = NSTextAlignmentCenter;
            detailMoreView.textColor = [UIColor whiteColor];
            detailMoreView.font = [UIFont boldSystemFontOfSize:14];
            detailMoreView.alpha = 0;
            detailMoreView.numberOfLines = 3;
            detailMoreView.lineBreakMode = NSLineBreakByWordWrapping;
            [gruyOutview addSubview:detailMoreView];
            
            UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            downArrow.frame = CGRectMake(523, 850, 53, 120);
            downArrow.alpha = 0;
            downArrow.transform = CGAffineTransformMakeRotation(M_PI);
            [gruyOutview addSubview:downArrow];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 600, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:18];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                moreViewDetail.alpha = 1;
                detailMoreView.alpha = 1;
                downArrow.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(2.0);
                [UIView animateWithDuration:0.3 animations:^{
                    tapToContinue.alpha = 1;
                } completion:^(BOOL finished) {
                    tutorialStep = 7;
                }];
            }];
        }];
    }
    else if (tutorialStep == 7){
        tutorialStep = 0;
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *oneMoreThingLbl = [[UILabel alloc] initWithFrame:CGRectMake(420, 400, 300, 30)];
            oneMoreThingLbl.text = @"Oh, and one more thing...";
            oneMoreThingLbl.textColor = [UIColor whiteColor];
            oneMoreThingLbl.textAlignment = NSTextAlignmentCenter;
            oneMoreThingLbl.font = [UIFont boldSystemFontOfSize:24];
            oneMoreThingLbl.alpha = 0;
            [gruyOutview addSubview:oneMoreThingLbl];
            
            UILabel *passLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 620, 80, 30)];
            passLbl.text = @"Passes";
            passLbl.textAlignment = NSTextAlignmentRight;
            passLbl.textColor = [UIColor whiteColor];
            passLbl.font = [UIFont boldSystemFontOfSize:18];
            passLbl.alpha = 0;
            [gruyOutview addSubview:passLbl];
            
            UIImageView *passArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            passArrow.frame = CGRectMake(300, 575, 53, 120);
            passArrow.alpha = 0;
            passArrow.transform = CGAffineTransformMakeRotation(M_PI/2);
            [gruyOutview addSubview:passArrow];
            
            UILabel *receiveLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 680, 80, 30)];
            receiveLbl.text = @"Receives";
            receiveLbl.textAlignment = NSTextAlignmentRight;
            receiveLbl.textColor = [UIColor whiteColor];
            receiveLbl.font = [UIFont boldSystemFontOfSize:18];
            receiveLbl.alpha = 0;
            [gruyOutview addSubview:receiveLbl];
            
            UIImageView *receiveArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upArrow"]];
            receiveArrow.frame = CGRectMake(300, 635, 53, 120);
            receiveArrow.alpha = 0;
            receiveArrow.transform = CGAffineTransformMakeRotation(M_PI/2);
            [gruyOutview addSubview:receiveArrow];
            
            UILabel *dontWorryLbl = [[UILabel alloc] initWithFrame:CGRectMake(420, 770, 300, 80)];
            dontWorryLbl.text = @"Don't worry about assist bonuses, just record when the robot passes and receives the ball";
            dontWorryLbl.textColor = [UIColor whiteColor];
            dontWorryLbl.textAlignment = NSTextAlignmentCenter;
            dontWorryLbl.font = [UIFont boldSystemFontOfSize:18];
            dontWorryLbl.numberOfLines = 3;
            dontWorryLbl.lineBreakMode = NSLineBreakByWordWrapping;
            dontWorryLbl.alpha = 0;
            [gruyOutview addSubview:dontWorryLbl];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 450, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:18];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                oneMoreThingLbl.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(1.5);
                [self autoOff];
                [UIView animateWithDuration:0.4 animations:^{
                    oneMoreThingLbl.center = CGPointMake(oneMoreThingLbl.center.x, oneMoreThingLbl.center.y + 150);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        passLbl.alpha = 1;
                        passLbl.center = CGPointMake(passLbl.center.x + 50, passLbl.center.y);
                        passArrow.alpha = 1;
                        passArrow.center = CGPointMake(passArrow.center.x + 50, passArrow.center.y);
                        receiveLbl.alpha = 1;
                        receiveLbl.center = CGPointMake(receiveLbl.center.x + 50, receiveLbl.center.y);
                        receiveArrow.alpha = 1;
                        receiveArrow.center = CGPointMake(receiveArrow.center.x + 50, receiveArrow.center.y);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3 animations:^{
                            dontWorryLbl.alpha = 1;
                            dontWorryLbl.center = CGPointMake(dontWorryLbl.center.x, dontWorryLbl.center.y - 50);
                        } completion:^(BOOL finished) {
                            sleep(2.5);
                            [UIView animateWithDuration:0.3 animations:^{
                                tapToContinue.alpha = 1;
                            } completion:^(BOOL finished) {
                                tutorialStep = 8;
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }
    else if (tutorialStep == 8){
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            UILabel *finallyLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 300, 300, 30)];
            finallyLbl.text = @"And Finally...";
            finallyLbl.textAlignment = NSTextAlignmentCenter;
            finallyLbl.textColor = [UIColor whiteColor];
            finallyLbl.font = [UIFont boldSystemFontOfSize:24];
            finallyLbl.alpha = 0;
            [gruyOutview addSubview:finallyLbl];
            
            UILabel *fromAllOfTDLbl = [[UILabel alloc] initWithFrame:CGRectMake(134, 380, 500, 30)];
            fromAllOfTDLbl.text = @"For all of us here on Team Driven 1730,";
            fromAllOfTDLbl.textColor = [UIColor whiteColor];
            fromAllOfTDLbl.textAlignment = NSTextAlignmentCenter;
            fromAllOfTDLbl.font = [UIFont boldSystemFontOfSize:24];
            fromAllOfTDLbl.alpha = 0;
            [gruyOutview addSubview:fromAllOfTDLbl];
            
            UILabel *stayClassyLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 460, 300, 30)];
            stayClassyLbl.text = @"Stay classy FRC Scouts.";
            stayClassyLbl.textColor = [UIColor whiteColor];
            stayClassyLbl.textAlignment = NSTextAlignmentCenter;
            stayClassyLbl.font = [UIFont boldSystemFontOfSize:26];
            stayClassyLbl.alpha = 0;
            [gruyOutview addSubview:stayClassyLbl];
            
            UILabel *tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(284, 600, 200, 30)];
            tapToContinue.text = @"Tap to Continue";
            tapToContinue.textColor = [UIColor whiteColor];
            tapToContinue.textAlignment = NSTextAlignmentCenter;
            tapToContinue.font = [UIFont boldSystemFontOfSize:18];
            tapToContinue.alpha = 0;
            [gruyOutview addSubview:tapToContinue];
            
            [UIView animateWithDuration:0.3 animations:^{
                finallyLbl.alpha = 1;
            } completion:^(BOOL finished) {
                sleep(2.0);
                [UIView animateWithDuration:0.3 animations:^{
                    fromAllOfTDLbl.alpha = 1;
                } completion:^(BOOL finished) {
                    sleep(2.0);
                    [UIView animateWithDuration:0.3 animations:^{
                        stayClassyLbl.alpha = 1;
                    } completion:^(BOOL finished) {
                        sleep(1.5);
                        tutorialStep = 9;
                        [UIView animateWithDuration:0.3 delay:3.0 options:UIViewAnimationOptionTransitionNone animations:^{
                            tapToContinue.alpha = 1;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }];
    }
    else if (tutorialStep == 9){
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *v in gruyOutview.subviews) {
                v.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self autoOn];
            [UIView animateWithDuration:0.3 animations:^{
                gruyOutview.alpha = 0;
            } completion:^(BOOL finished) {
                [gruyOutview removeFromSuperview];
                [scheduleDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"FirstOpening"];
                [scheduleDictionary writeToFile:schedulePath atomically:YES];
                for (UIBarButtonItem *item in self.tabBarController.tabBar.items) {
                    item.enabled = true;
                }
                twoFingerDown.enabled = true;
            }];
        }];
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
    if (self.mySession == NULL) {
        [self setUpMultiPeer];
    }
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
    CGRect closeButtonRect = CGRectMake(340, 0, 60, 30);
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
    [inviteMoreBtn addTarget:self action:@selector(hostSwitch) forControlEvents:UIControlEventTouchUpInside];
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
                         [visibleSwitch setOn:visible animated:YES];
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
    [self.mySession disconnect];
    self.mySession = NULL;
    [self.advertiser stop];
    red1SelectedPos = red1Selector.selectedSegmentIndex;
    pos = [red1Selector titleForSegmentAtIndex:red1Selector.selectedSegmentIndex];
    NSLog(@"%@", pos);
}
// Called by the matchTypeSelector UISegmentedControl
-(void)changeMatchType{
    if (matchTypeSelector.selectedSegmentIndex == 0) {
        currentMatchType = @"Q";
        currentMatchNumField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else{
        currentMatchType = @"E";
        UIAlertView *elimMatchTypeAlert = [[UIAlertView alloc] initWithTitle:@"Just a heads up..."
                                                                     message:@"If you choose Elimination Match type, you must abide by the following format: \n Quarterfinal Match -> Q1.1, Q1.2, Q2.1, etc. \n Semifinal Match -> S1.1, S1.2, S2.1, etc. \n Finals Match -> F1.1, F1.2, F1.3, etc."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Affirmative."
                                                           otherButtonTitles: nil];
        [elimMatchTypeAlert show];
        currentMatchNumField.keyboardType = UIKeyboardTypeAlphabet;
        currentMatchNumField.text = @"Q1.1";
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
        if ([txt1 length] > 4) {
            [txt1 deleteCharactersInRange:NSMakeRange(4, 1)];
            scoutTeamNumField.text = [[NSString alloc] initWithString:txt1];
        }
    }
    if (currentMatchNumField.isEditing) {
        if ([currentMatchType isEqualToString:@"Q"]) {
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
        
        tView.textAlignment = NSTextAlignmentLeft;
        tView.font = [UIFont systemFontOfSize:20];
        tView.minimumScaleFactor = 0.2;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    return tView;
}

// Tell the picker the width of each row for a given component (420)
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int sectionWidth = 480;
    
    return sectionWidth;
}


/**********************************
 ********** Insta-Share ***********
 **********************************/

-(void)setUpMultiPeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[[NSString alloc] initWithFormat:@"%@ - %@", pos, scoutTeamNum]];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"frcScorer" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"frcScorer" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}


// Starts Browser role and initiates the MCSession
-(void)hostSwitch{
    if (hostSwitch.on) {
        [self presentViewController:self.browserVC animated:YES completion:nil];
        inviteMoreBtn.enabled = true;
        inviteMoreBtn.hidden = false;
        host = true;
    }
    else{
        inviteMoreBtn.enabled = false;
        inviteMoreBtn.hidden = true;
        host = false;
    }
}
// Starts Advertiser role
-(void)visibleSwitch{
    if (visibleSwitch.on) {
        [self setUpMultiPeer];
        visible = true;
        hostSwitch.enabled = true;
    }
    else{
        [self.mySession disconnect];
        [self.advertiser stop];
        visible = false;
        [hostSwitch setOn:NO animated:YES];
        hostSwitch.enabled = false;
        host = false;
    }
}

-(void)dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserVCS{
    [self dismissBrowserVC];
    [self closeShareView];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    [self dismissBrowserVC];
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSString *peerString = [peerID displayName];
    NSString *updatedPeerString = [[peerString componentsSeparatedByString:@" - "] firstObject];
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected with %@", updatedPeerString);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([updatedPeerString isEqualToString:@"Red 1"]) {[[posUpdateArray objectAtIndex:1] setBackgroundColor:[UIColor redColor]];}
            else if ([updatedPeerString isEqualToString:@"Red 2"]){[[posUpdateArray objectAtIndex:2] setBackgroundColor:[UIColor redColor]];}
            else if ([updatedPeerString isEqualToString:@"Red 3"]){[[posUpdateArray objectAtIndex:3] setBackgroundColor:[UIColor redColor]];}
            else if ([updatedPeerString isEqualToString:@"Blue 1"]){[[posUpdateArray objectAtIndex:4] setBackgroundColor:[UIColor blueColor]];}
            else if ([updatedPeerString isEqualToString:@"Blue 2"]){[[posUpdateArray objectAtIndex:5] setBackgroundColor:[UIColor blueColor]];}
            else if ([updatedPeerString isEqualToString:@"Blue 3"]){[[posUpdateArray objectAtIndex:6] setBackgroundColor:[UIColor blueColor]];}
            
            UIAlertView *connectedSuccessfullyAlert = [[UIAlertView alloc] initWithTitle:@"Woot Woot!"
                                                                                 message:[[NSString alloc] initWithFormat:@"You successfully connected to %@ on Insta-Share!", [peerID displayName]]
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"Great Odin's Raven!"
                                                                       otherButtonTitles: nil];
            [connectedSuccessfullyAlert show];
        });
        
        if ([updatedPeerString isEqualToString:pos]) {
            NSLog(@"Already Connected, send error!!");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *duplicateRolesAlert = [[UIAlertView alloc] initWithTitle:@"Hold Up!"
                                                                              message:[[NSString alloc] initWithFormat:@"There are two \"%@\" positions connected! One needs to disconnect (toggle the \"Visible\" switch off and on) for this to work right", pos]
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"I'm on it." otherButtonTitles: nil];
                [duplicateRolesAlert show];
            });
        }
    }
    else if (state == MCSessionStateNotConnected){
        NSLog(@"Disconnected");
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([updatedPeerString isEqualToString:@"Red 1"]) {[[posUpdateArray objectAtIndex:1] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];}
            else if ([updatedPeerString isEqualToString:@"Red 2"]){
                NSLog(@"Red 2");
                [[posUpdateArray objectAtIndex:2] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
            }
            else if ([updatedPeerString isEqualToString:@"Red 3"]){[[posUpdateArray objectAtIndex:3] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];}
            else if ([updatedPeerString isEqualToString:@"Blue 1"]){[[posUpdateArray objectAtIndex:4] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];}
            else if ([updatedPeerString isEqualToString:@"Blue 2"]){[[posUpdateArray objectAtIndex:5] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];}
            else if ([updatedPeerString isEqualToString:@"Blue 3"]){[[posUpdateArray objectAtIndex:6] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];}
            UIAlertView *disconnectedAlert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                                        message:[[NSString alloc] initWithFormat:@"You disconnected with %@ in Insta-Share!", updatedPeerString]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Son of a bee sting!"
                                                              otherButtonTitles:nil];
            [disconnectedAlert show];
        });
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self dataDictToCoreDataFromPeer:peerID];
}

-(void)dataDictToCoreDataFromPeer:(MCPeerID *)peer{
    [context performBlock:^{
        NSString *matchNumberReceived;
        for (NSString *rgnl in receivedDataDict) {
            Regional *regional = [Regional createRegionalWithName:rgnl inManagedObjectContext:context];
            for (NSString *tm in [receivedDataDict objectForKey:rgnl]) {
                Team *team = [Team createTeamWithName:tm inRegional:regional withManagedObjectContext:context];
                for (NSString *mtch in [[receivedDataDict objectForKey:rgnl] objectForKey:tm]) {
                    matchNumberReceived = mtch;
                    NSDictionary *matchDict = [[[receivedDataDict objectForKey:rgnl] objectForKey:tm] objectForKey:mtch];
                    Match *match = [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                    
                    if ([match.uniqeID integerValue] != [[matchDict objectForKey:@"uniqueID"] integerValue]) {
                        [[FSAdocument managedObjectContext] deleteObject:match];
                        [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                    }
                }
            }
        }
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {}];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *peerString = [[NSString alloc] initWithFormat:@"%@", [peer displayName]];
            NSString *identifiedPeerString = [[peerString componentsSeparatedByString:@" - "] firstObject];
            if ([identifiedPeerString isEqualToString:@"Red 1"]) {red1UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 1 : %@", matchNumberReceived];}
            else if ([identifiedPeerString isEqualToString:@"Red 2"]){red2UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 2 : %@", matchNumberReceived];}
            else if ([identifiedPeerString isEqualToString:@"Red 3"]){red3UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 3 : %@", matchNumberReceived];}
            else if ([identifiedPeerString isEqualToString:@"Blue 1"]){blue1UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 1 : %@", matchNumberReceived];}
            else if ([identifiedPeerString isEqualToString:@"Blue 2"]){blue2UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 2 : %@", matchNumberReceived];}
            else if ([identifiedPeerString isEqualToString:@"Blue 3"]){blue3UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 3 : %@", matchNumberReceived];}
        });
    }];
}

-(void)setUpData{
    NSDate *date = [NSDate date];
    NSInteger secs = [date timeIntervalSince1970];
    dictToSend = nil;
    dictToSend = [[NSMutableDictionary alloc]init];
    [dictToSend setObject:[[NSMutableDictionary alloc] init] forKey:currentRegional];
    [[dictToSend objectForKey:currentRegional] setObject:[[NSMutableDictionary alloc] init] forKey:currentTeamNum];
    [[[dictToSend objectForKey:currentRegional] objectForKey:currentTeamNum] setObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                [NSNumber numberWithInteger:autoHighHotScore], @"autoHighHotScore",
                [NSNumber numberWithInteger:autoHighNotScore], @"autoHighNotScore",
                [NSNumber numberWithInteger:autoHighMissScore], @"autoHighMissScore",
                [NSNumber numberWithInteger:autoLowHotScore], @"autoLowHotScore",
                [NSNumber numberWithInteger:autoLowNotScore], @"autoLowNotScore",
                [NSNumber numberWithInteger:autoLowMissScore], @"autoLowMissScore",
                [NSNumber numberWithInteger:mobilityBonus], @"mobilityBonus",
                [NSNumber numberWithInteger:teleopHighMake], @"teleopHighMake",
                [NSNumber numberWithInteger:teleopHighMiss], @"teleopHighMiss",
                [NSNumber numberWithInteger:teleopLowMake], @"teleopLowMake",
                [NSNumber numberWithInteger:teleopLowMiss], @"teleoplowMiss",
                [NSNumber numberWithInteger:teleopOver], @"teleopOver",
                [NSNumber numberWithInteger:teleopPassed], @"teleopPassed",
                [NSNumber numberWithInteger:largePenaltyTally], @"penaltyLarge",
                [NSNumber numberWithInteger:smallPenaltyTally], @"penaltySmall",
                [NSString stringWithString:notes], @"notes",
                [NSString stringWithString:pos], @"red1Pos",
                [NSString stringWithString:scoutTeamNum], @"recordingTeam",
                [NSString stringWithString:initials], @"scoutInitials",
                [NSString stringWithString:currentMatchType], @"matchType",
                [NSString stringWithString:currentMatchNum], @"matchNum",
                [NSNumber numberWithInteger:secs], @"uniqueID", nil]
        forKey:currentMatchNum];
    
                  
}

/*****************************************
 ******** User Interaction Code **********
 *****************************************/

// Activated by two finger swipe up (changes to auto UI)
-(void)autoOn{
    autoYN = true;
    if ([[self.tabBarController.tabBar.items firstObject] isEnabled]) {
        twoFingerUp.enabled = false;
        twoFingerDown.enabled = true;
    }
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
    
//    NSLog(@"AUTO ON");
}
// Activated by two finger swipe down (changes to telop UI)
-(void)autoOff{
    autoYN = false;
    if ([[self.tabBarController.tabBar.items firstObject] isEnabled]) {
        twoFingerUp.enabled = true;
        twoFingerDown.enabled = false;
    }
    
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
    
//    NSLog(@"AUTO OFF");
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
    if (autoHighHotScore < 3) {
        autoHighHotScore++;
        _autoHotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighHotScore];
    }
}
- (IBAction)autoHotHighMinus:(id)sender {
    if (autoHighHotScore > 0) {
        autoHighHotScore--;
        _autoHotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighHotScore];
    }
}
- (IBAction)autoNotHighPlus:(id)sender {
    if (autoHighNotScore < 3) {
        autoHighNotScore++;
        _autoNotHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoHighNotScore];
    }
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
    if (autoLowHotScore < 3) {
        autoLowHotScore++;
        _autoHotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowHotScore];
    }
}
- (IBAction)autoHotLowMinus:(id)sender {
    if (autoLowHotScore > 0) {
        autoLowHotScore--;
        _autoHotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowHotScore];
    }
}
- (IBAction)autoNotLowPlus:(id)sender {
    if (autoLowNotScore < 3) {
        autoLowNotScore++;
        _autoNotLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoLowNotScore];
    }
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
- (IBAction)matchNumberEditFinished:(id)sender {
    currentMatchNum = _matchNumField.text;
    if ([scheduleDictionary objectForKey:currentRegional]) {
        if ([[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum]) {
            currentTeamNum = [[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum];
            currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
            [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
            _teamNumEdit.enabled = true;
            _teamNumEdit.hidden = false;
            _teamNumField.enabled = false;
            _teamNumField.hidden = true;
        }
        else{
            UIAlertView *invalidMatchNumberAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Match Number!"
                                                                              message:@"You could have finished the last match for this regional, entered a bad match number, or there is some mistake with the schedule downloaded."
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"I see."
                                                                    otherButtonTitles:nil];
            [invalidMatchNumberAlert show];
            currentTeamNum = @"";
        }
    }
    else{
        currentTeamNum = @"";
    }
    if (currentTeamNum.length == 0) {
        _teamNumEdit.enabled = false;
        _teamNumEdit.hidden = true;
        _teamNumField.enabled = true;
        _teamNumField.hidden = false;
        _teamNumField.text = currentTeamNum;
    }
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
-(IBAction)teamNumberEditFinished:(id)sender {
    NSFetchRequest *roboPicRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
    NSPredicate *roboPicPredicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", _teamNumField.text];
    roboPicRequest.predicate = roboPicPredicate;
    NSError *roboPicError = nil;
    NSArray *roboPics = [context executeFetchRequest:roboPicRequest error:&roboPicError];
    _robotPic.alpha = 0;
    PitTeam *pt = [roboPics firstObject];
    UIImage *image = [UIImage imageWithData:[pt valueForKey:@"image"]];
    _robotPic.image = image;
    [UIView animateWithDuration:0.2 animations:^{
        _robotPic.alpha = 1;
    }];
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
    
    // If the match number was edited by the user during that match
    if (_matchNumEdit.isHidden) {
        currentMatchNum = _matchNumField.text;
    }
    else{
        currentMatchNum = _matchNumEdit.titleLabel.text;
    }
    // If the team number was edited by the user during the match
    if (_teamNumEdit.isHidden) {
        currentTeamNum = _teamNumField.text;
    }
    else{
        currentTeamNum = _teamNumEdit.titleLabel.text;
    }
    
    // If for some reason there was no match number (Shouldn't occur, but just in case)
    BOOL badMatchNumber = true;
    if ([currentMatchType isEqualToString:@"Q"]) {
        if ([currentMatchNum integerValue] > 0) {
            badMatchNumber = false;
        }
    }
    else{
        if ([[currentMatchNum substringToIndex:2] isEqualToString:@"Q1"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q2"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q3"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"Q4"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"S1"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"S2"] || [[currentMatchNum substringToIndex:2] isEqualToString:@"F1"]) {
            if ([[currentMatchNum substringWithRange:NSMakeRange(3, 1)] integerValue] > 0) {
                if (currentMatchNum.length == 4) {
                    badMatchNumber = false;
                }
            }
        }
    }
    if (currentMatchNum == nil || [currentMatchNum isEqualToString:@""] ||[[currentMatchNum substringToIndex:1] isEqualToString:@"0"] || badMatchNumber) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"INVALID MATCH NUMBER"
                                                       message: @"Please enter a valid match number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        
        [alert show];
    }
    // Another unlikely case: No team number. Also shouldn't happen, but a good safety net
    else if (currentTeamNum == nil || [currentTeamNum isEqualToString:@""] || [currentTeamNum integerValue] < 1 || [[currentTeamNum substringToIndex:1] isEqualToString:@"0"] || currentTeamNum.length > 4) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"INVALID TEAM NUMBER"
                                                       message: @"Please enter a valid team number for this match."
                                                      delegate: nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    // If everything checks out, save the match locally
    else{
        [self createNotesScreen];
    }

}

-(void)createNotesScreen{
    inRedZone = false;
    inWhiteZone = false;
    inBlueZone = false;
    didGreatDefense = false;
    didBadDefense = false;
    didDidntMove = false;
    didSlowMovement = false;
    didFastMovement = false;
    didBrokeDownInMatch = false;
    didGreatBallPickup = false;
    didBadBallPickup = false;
    didGreatCooperation = false;
    didBadCooperation = false;
    didGreatHumanPlayer = false;
    didBadHumanPlayer = false;
    didGreatDriver = false;
    didAverageDriver = false;
    didBadDriver = false;
    
    greyOut = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [greyOut addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
    [self.view addSubview:greyOut];
    
    notesScreen = [[UIControl alloc] initWithFrame:CGRectMake(159, 200, 450, 500)];
    [notesScreen addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    notesScreen.backgroundColor = [UIColor whiteColor];
    notesScreen.layer.cornerRadius = 10;
    
    UILabel *notesScreenLbl = [[UILabel alloc] initWithFrame:CGRectMake(125, 15, 200, 20)];
    notesScreenLbl.text = @"Add Some Notes!";
    notesScreenLbl.font = [UIFont systemFontOfSize:20];
    notesScreenLbl.textAlignment = NSTextAlignmentCenter;
    [notesScreen addSubview:notesScreenLbl];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(375, 10, 70, 15);
    [cancelButton setTitle:@"Cancel X" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelNotesScreen) forControlEvents:UIControlEventTouchUpInside];
    [notesScreen addSubview:cancelButton];
    
    UILabel *zoneSelectorLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 58, 250, 17)];
    zoneSelectorLbl.text = @"Zones They Hung Out In";
    zoneSelectorLbl.font = [UIFont systemFontOfSize:13];
    zoneSelectorLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    zoneSelectorLbl.textAlignment = NSTextAlignmentCenter;
    [notesScreen addSubview:zoneSelectorLbl];
    
    NSInteger redZoneX = 105;
    
    redZone = [[UIControl alloc] initWithFrame:CGRectMake(redZoneX, 75, 80, 30)];
    redZone.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    [redZone addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *redZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    redZoneLabel.textAlignment = NSTextAlignmentCenter;
    redZoneLabel.textColor = [UIColor whiteColor];
    redZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    redZoneLabel.text = @"Red";
    [redZone addSubview:redZoneLabel];
    [notesScreen addSubview:redZone];
    
    redZoneX+=80;
    whiteZone = [[UIControl alloc] initWithFrame:CGRectMake(redZoneX, 75, 80, 30)];
    whiteZone.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    [whiteZone addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *whiteZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    whiteZoneLabel.textAlignment = NSTextAlignmentCenter;
    whiteZoneLabel.textColor = [UIColor whiteColor];
    whiteZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    whiteZoneLabel.text = @"White";
    [whiteZone addSubview:whiteZoneLabel];
    [notesScreen addSubview:whiteZone];
    
    redZoneX+=80;
    blueZone = [[UIControl alloc] initWithFrame:CGRectMake(redZoneX, 75, 80, 30)];
    blueZone.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
    [blueZone addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *blueZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    blueZoneLabel.textAlignment = NSTextAlignmentCenter;
    blueZoneLabel.textColor = [UIColor whiteColor];
    blueZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    blueZoneLabel.text = @"Blue";
    [blueZone addSubview:blueZoneLabel];
    [notesScreen addSubview:blueZone];
    
    if (red1Pos < 3) {
        UIBezierPath *leftMaskPath;
        leftMaskPath = [UIBezierPath bezierPathWithRoundedRect:redZone.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *leftMaskLayer = [[CAShapeLayer alloc] init];
        leftMaskLayer.frame = redZone.bounds;
        leftMaskLayer.path = leftMaskPath.CGPath;
        redZone.layer.mask = leftMaskLayer;
        
        UIBezierPath *rightMaskPath;
        rightMaskPath = [UIBezierPath bezierPathWithRoundedRect:blueZone.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *rightMaskLayer = [[CAShapeLayer alloc] init];
        rightMaskLayer.frame = blueZone.bounds;
        rightMaskLayer.path = rightMaskPath.CGPath;
        blueZone.layer.mask = rightMaskLayer;
    }
    else {
        redZone.center = CGPointMake(redZone.center.x + 160, redZone.center.y);
        blueZone.center = CGPointMake(blueZone.center.x - 160, blueZone.center.y);
        
        UIBezierPath *leftMaskPath;
        leftMaskPath = [UIBezierPath bezierPathWithRoundedRect:redZone.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *leftMaskLayer = [[CAShapeLayer alloc] init];
        leftMaskLayer.frame = blueZone.bounds;
        leftMaskLayer.path = leftMaskPath.CGPath;
        blueZone.layer.mask = leftMaskLayer;
        
        UIBezierPath *rightMaskPath;
        rightMaskPath = [UIBezierPath bezierPathWithRoundedRect:blueZone.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(3.0, 3.0)];
        CAShapeLayer *rightMaskLayer = [[CAShapeLayer alloc] init];
        rightMaskLayer.frame = redZone.bounds;
        rightMaskLayer.path = rightMaskPath.CGPath;
        redZone.layer.mask = rightMaskLayer;
    }
    
    // **************************************************
    
    // **************************************************
    
    // ************** QUICK NOTES ***********************
    
    // **************************************************
    
    // **************************************************
    
    UILabel *quickNotesLbl = [[UILabel alloc] initWithFrame:CGRectMake(175, 130, 100, 13)];
    quickNotesLbl.text = @"Quick Notes (tap)";
    quickNotesLbl.textAlignment = NSTextAlignmentCenter;
    quickNotesLbl.font = [UIFont systemFontOfSize:10];
    quickNotesLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    [notesScreen addSubview:quickNotesLbl];
    
    greatDefense = [[UIControl alloc] initWithFrame:CGRectMake(55, 150, 110, 30)];
    greatDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [greatDefense addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    greatDefense.layer.cornerRadius = 5;
    UILabel *greatDefenseLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    greatDefenseLbl.text = @"Great Defense";
    greatDefenseLbl.textAlignment = NSTextAlignmentCenter;
    greatDefenseLbl.textColor = [UIColor whiteColor];
    greatDefenseLbl.font = [UIFont systemFontOfSize:14];
    [greatDefense addSubview:greatDefenseLbl];
    [notesScreen addSubview:greatDefense];
    
    badDefense = [[UIControl alloc] initWithFrame:CGRectMake(180, 150, 100, 30)];
    badDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [badDefense addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    badDefense.layer.cornerRadius = 5;
    UILabel *badDefenseLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    badDefenseLbl.text = @"Bad Defense";
    badDefenseLbl.textAlignment = NSTextAlignmentCenter;
    badDefenseLbl.textColor = [UIColor whiteColor];
    badDefenseLbl.font = [UIFont systemFontOfSize:14];
    [badDefense addSubview:badDefenseLbl];
    [notesScreen addSubview:badDefense];
    
    didntMove = [[UIControl alloc] initWithFrame:CGRectMake(295, 150, 100, 30)];
    didntMove.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [didntMove addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    didntMove.layer.cornerRadius = 5;
    UILabel *didntMoveLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    didntMoveLbl.text = @"Didn't Move";
    didntMoveLbl.textAlignment = NSTextAlignmentCenter;
    didntMoveLbl.textColor = [UIColor whiteColor];
    didntMoveLbl.font = [UIFont systemFontOfSize:14];
    [didntMove addSubview:didntMoveLbl];
    [notesScreen addSubview:didntMove];
    
    slowMovement = [[UIControl alloc] initWithFrame:CGRectMake(15, 190, 120, 30)];
    slowMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [slowMovement addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    slowMovement.layer.cornerRadius = 5;
    UILabel *slowMovementLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    slowMovementLbl.text = @"Slow Movement";
    slowMovementLbl.textAlignment = NSTextAlignmentCenter;
    slowMovementLbl.textColor = [UIColor whiteColor];
    slowMovementLbl.font = [UIFont systemFontOfSize:14];
    [slowMovement addSubview:slowMovementLbl];
    [notesScreen addSubview:slowMovement];
    
    fastMovement = [[UIControl alloc] initWithFrame:CGRectMake(150, 190, 120, 30)];
    fastMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [fastMovement addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    fastMovement.layer.cornerRadius = 5;
    UILabel *fastMovementLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    fastMovementLbl.text = @"Fast Movement";
    fastMovementLbl.textAlignment = NSTextAlignmentCenter;
    fastMovementLbl.textColor = [UIColor whiteColor];
    fastMovementLbl.font = [UIFont systemFontOfSize:14];
    [fastMovement addSubview:fastMovementLbl];
    [notesScreen addSubview:fastMovement];
    
    brokeDownInMatch = [[UIControl alloc] initWithFrame:CGRectMake(285, 190, 150, 30)];
    brokeDownInMatch.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [brokeDownInMatch addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    brokeDownInMatch.layer.cornerRadius = 5;
    UILabel *brokeDownInMatchLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    brokeDownInMatchLbl.text = @"Broke Down in Match";
    brokeDownInMatchLbl.textAlignment = NSTextAlignmentCenter;
    brokeDownInMatchLbl.textColor = [UIColor whiteColor];
    brokeDownInMatchLbl.font = [UIFont systemFontOfSize:14];
    [brokeDownInMatch addSubview:brokeDownInMatchLbl];
    [notesScreen addSubview:brokeDownInMatch];
    
    greatBallPickup = [[UIControl alloc] initWithFrame:CGRectMake(15, 230, 128, 30)];
    greatBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [greatBallPickup addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    greatBallPickup.layer.cornerRadius = 5;
    UILabel *greatBallPickupLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 30)];
    greatBallPickupLbl.text = @"Great Ball Pickup";
    greatBallPickupLbl.textAlignment = NSTextAlignmentCenter;
    greatBallPickupLbl.textColor = [UIColor whiteColor];
    greatBallPickupLbl.font = [UIFont systemFontOfSize:14];
    [greatBallPickup addSubview:greatBallPickupLbl];
    [notesScreen addSubview:greatBallPickup];
    
    badBallPickup = [[UIControl alloc] initWithFrame:CGRectMake(158, 230, 122, 30)];
    badBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [badBallPickup addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    badBallPickup.layer.cornerRadius = 5;
    UILabel *badBallPickupLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 122, 30)];
    badBallPickupLbl.text = @"Bad Ball Pickup";
    badBallPickupLbl.textAlignment = NSTextAlignmentCenter;
    badBallPickupLbl.textColor = [UIColor whiteColor];
    badBallPickupLbl.font = [UIFont systemFontOfSize:14];
    [badBallPickup addSubview:badBallPickupLbl];
    [notesScreen addSubview:badBallPickup];
    
    greatCooperation = [[UIControl alloc] initWithFrame:CGRectMake(295, 230, 140, 30)];
    greatCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [greatCooperation addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    greatCooperation.layer.cornerRadius = 5;
    UILabel *greatCooperationLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    greatCooperationLbl.text = @"Great Cooperation";
    greatCooperationLbl.textAlignment = NSTextAlignmentCenter;
    greatCooperationLbl.textColor = [UIColor whiteColor];
    greatCooperationLbl.font = [UIFont systemFontOfSize:14];
    [greatCooperation addSubview:greatCooperationLbl];
    [notesScreen addSubview:greatCooperation];
    
    badCooperation = [[UIControl alloc] initWithFrame:CGRectMake(10, 270, 125, 30)];
    badCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [badCooperation addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    badCooperation.layer.cornerRadius = 5;
    UILabel *badCooperationLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
    badCooperationLbl.text = @"Bad Cooperation";
    badCooperationLbl.textAlignment = NSTextAlignmentCenter;
    badCooperationLbl.textColor = [UIColor whiteColor];
    badCooperationLbl.font = [UIFont systemFontOfSize:13];
    [badCooperation addSubview:badCooperationLbl];
    [notesScreen addSubview:badCooperation];
    
    greatHumanPlayer = [[UIControl alloc] initWithFrame:CGRectMake(150, 270, 140, 30)];
    greatHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [greatHumanPlayer addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    greatHumanPlayer.layer.cornerRadius = 5;
    UILabel *greatHumanPlayerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
    greatHumanPlayerLbl.text = @"Great Human Player";
    greatHumanPlayerLbl.textAlignment = NSTextAlignmentCenter;
    greatHumanPlayerLbl.textColor = [UIColor whiteColor];
    greatHumanPlayerLbl.font = [UIFont systemFontOfSize:13];
    [greatHumanPlayer addSubview:greatHumanPlayerLbl];
    [notesScreen addSubview:greatHumanPlayer];
    
    badHumanPlayer = [[UIControl alloc] initWithFrame:CGRectMake(305, 270, 135, 30)];
    badHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [badHumanPlayer addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    badHumanPlayer.layer.cornerRadius = 5;
    UILabel *badHumanPlayerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 30)];
    badHumanPlayerLbl.text = @"Bad Human Player";
    badHumanPlayerLbl.textAlignment = NSTextAlignmentCenter;
    badHumanPlayerLbl.textColor = [UIColor whiteColor];
    badHumanPlayerLbl.font = [UIFont systemFontOfSize:13];
    [badHumanPlayer addSubview:badHumanPlayerLbl];
    [notesScreen addSubview:badHumanPlayer];
    
    greatDriver = [[UIControl alloc] initWithFrame:CGRectMake(55, 310, 100, 30)];
    greatDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [greatDriver addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    greatDriver.layer.cornerRadius = 5;
    UILabel *greatDriverLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    greatDriverLbl.text = @"Great Driver";
    greatDriverLbl.textAlignment = NSTextAlignmentCenter;
    greatDriverLbl.textColor = [UIColor whiteColor];
    greatDriverLbl.font = [UIFont systemFontOfSize:14];
    [greatDriver addSubview:greatDriverLbl];
    [notesScreen addSubview:greatDriver];
    
    averageDriver = [[UIControl alloc] initWithFrame:CGRectMake(170, 310, 110, 30)];
    averageDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [averageDriver addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    averageDriver.layer.cornerRadius = 5;
    UILabel *averageDriverLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    averageDriverLbl.text = @"Average Driver";
    averageDriverLbl.textAlignment = NSTextAlignmentCenter;
    averageDriverLbl.textColor = [UIColor whiteColor];
    averageDriverLbl.font = [UIFont systemFontOfSize:14];
    [averageDriver addSubview:averageDriverLbl];
    [notesScreen addSubview:averageDriver];
    
    badDriver = [[UIControl alloc] initWithFrame:CGRectMake(295, 310, 90, 30)];
    badDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    [badDriver addTarget:self action:@selector(notesControllerTapped:) forControlEvents:UIControlEventTouchUpInside];
    badDriver.layer.cornerRadius = 5;
    UILabel *badDriverLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    badDriverLbl.text = @"Bad Driver";
    badDriverLbl.textAlignment = NSTextAlignmentCenter;
    badDriverLbl.textColor = [UIColor whiteColor];
    badDriverLbl.font = [UIFont systemFontOfSize:14];
    [badDriver addSubview:badDriverLbl];
    [notesScreen addSubview:badDriver];

    
    notesTextField = [[UITextView alloc] initWithFrame:CGRectMake(75, 350, 300, 100)];
    notesTextField.textAlignment = NSTextAlignmentCenter;
    notesTextField.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
    notesTextField.layer.borderWidth = 1;
    notesTextField.layer.cornerRadius = 10;
    notesTextField.font = [UIFont systemFontOfSize:14];
    notesTextField.text = @"Custom Notes";
    notesTextField.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    notesTextField.delegate = self;
    [notesScreen addSubview:notesTextField];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.frame = CGRectMake(190, 460, 70, 30);
    saveButton.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(coreDataSave) forControlEvents:UIControlEventTouchUpInside];
    saveButton.layer.cornerRadius = 5;
    [notesScreen addSubview:saveButton];
    
    [greyOut addSubview:notesScreen];
    notesScreen.center = CGPointMake(notesScreen.center.x, 1524);
    [UIView animateWithDuration:0.3 animations:^{
        notesScreen.center = CGPointMake(notesScreen.center.x, 450);
    }];
}

-(void)cancelNotesScreen{
    [UIView animateWithDuration:0.3 animations:^{
        notesScreen.center = CGPointMake(notesScreen.center.x, 1524);
    } completion:^(BOOL finished) {
        [notesScreen removeFromSuperview];
        [greyOut removeFromSuperview];
    }];
}

-(void)notesControllerTapped:(UIControl *)controlView{
    if ([controlView isEqual:redZone]) {
        if (inRedZone) {
            [UIView animateWithDuration:0.2 animations:^{
                redZone.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
            }];
            inRedZone = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                redZone.backgroundColor = [UIColor redColor];
            }];
            inRedZone = true;
        }
    }
    else if ([controlView isEqual:whiteZone]) {
        if (inWhiteZone) {
            [UIView animateWithDuration:0.2 animations:^{
                whiteZone.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
            }];
            inWhiteZone = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                whiteZone.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            }];
            inWhiteZone = true;
        }
    }
    else if ([controlView isEqual:blueZone]) {
        if (inBlueZone) {
            [UIView animateWithDuration:0.2 animations:^{
                blueZone.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
            }];
            inBlueZone = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                blueZone.backgroundColor = [UIColor blueColor];
            }];
            inBlueZone = true;
        }
    }
    else if ([controlView isEqual:greatDefense]){
        if (didGreatDefense) {
            [UIView animateWithDuration:0.2 animations:^{
                greatDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatDefense = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatDefense.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                badDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatDefense = true;
            didBadDefense = false;
        }
    }
    else if ([controlView isEqual:badDefense]){
        if (didBadDefense) {
            [UIView animateWithDuration:0.2 animations:^{
                badDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadDefense = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                badDefense.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                greatDefense.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadDefense = true;
            didGreatDefense = false;
        }
    }
    else if ([controlView isEqual:didntMove]){
        if (didDidntMove) {
            [UIView animateWithDuration:0.2 animations:^{
                didntMove.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didDidntMove = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                didntMove.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            }];
            didDidntMove = true;
        }
    }
    else if ([controlView isEqual:slowMovement]){
        if (didSlowMovement) {
            [UIView animateWithDuration:0.2 animations:^{
                slowMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didSlowMovement = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                slowMovement.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                fastMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didSlowMovement = true;
            didFastMovement = false;
        }
    }
    else if ([controlView isEqual:fastMovement]){
        if (didFastMovement) {
            [UIView animateWithDuration:0.2 animations:^{
                fastMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didFastMovement = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                fastMovement.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                slowMovement.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didFastMovement = true;
            didSlowMovement = false;
        }
    }
    else if ([controlView isEqual:brokeDownInMatch]){
        if (didBrokeDownInMatch) {
            [UIView animateWithDuration:0.2 animations:^{
                brokeDownInMatch.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBrokeDownInMatch = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                brokeDownInMatch.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            }];
            didBrokeDownInMatch = true;
        }
    }
    else if ([controlView isEqual:greatBallPickup]){
        if (didGreatBallPickup) {
            [UIView animateWithDuration:0.2 animations:^{
                greatBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatBallPickup = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatBallPickup.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                badBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatBallPickup = true;
            didBadBallPickup = false;
        }
    }
    else if ([controlView isEqual:badBallPickup]){
        if (didBadBallPickup) {
            [UIView animateWithDuration:0.2 animations:^{
                badBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadBallPickup = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                badBallPickup.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                greatBallPickup.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadBallPickup = true;
            didGreatBallPickup = false;
        }
    }
    else if ([controlView isEqual:greatCooperation]){
        if (didGreatCooperation) {
            [UIView animateWithDuration:0.2 animations:^{
                greatCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatCooperation = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatCooperation.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                badCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatCooperation = true;
            didBadCooperation = false;
        }
    }
    else if ([controlView isEqual:badCooperation]){
        if (didBadCooperation) {
            [UIView animateWithDuration:0.2 animations:^{
                badCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadCooperation = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                badCooperation.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                greatCooperation.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadCooperation = true;
            didGreatCooperation = false;
        }
    }
    else if ([controlView isEqual:greatHumanPlayer]){
        if (didGreatHumanPlayer) {
            [UIView animateWithDuration:0.2 animations:^{
                greatHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatHumanPlayer = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatHumanPlayer.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                badHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatHumanPlayer = true;
            didBadHumanPlayer = false;
        }
    }
    else if ([controlView isEqual:badHumanPlayer]){
        if (didBadHumanPlayer) {
            [UIView animateWithDuration:0.2 animations:^{
                badHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadHumanPlayer = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                badHumanPlayer.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                greatHumanPlayer.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadHumanPlayer = true;
            didGreatHumanPlayer = false;
        }
    }
    else if ([controlView isEqual:greatDriver]){
        if (didGreatDriver) {
            [UIView animateWithDuration:0.2 animations:^{
                greatDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatDriver = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatDriver.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                averageDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                badDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatDriver = true;
            didAverageDriver = false;
            didBadDriver = false;
        }
    }
    else if ([controlView isEqual:averageDriver]){
        if (didAverageDriver) {
            [UIView animateWithDuration:0.2 animations:^{
                averageDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didAverageDriver = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                averageDriver.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
                badDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didGreatDriver = false;
            didAverageDriver = true;
            didBadDriver = false;
        }
    }
    else if ([controlView isEqual:badDriver]){
        if (didBadDriver) {
            [UIView animateWithDuration:0.2 animations:^{
                badDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            didBadDriver = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                greatDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                averageDriver.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                badDriver.backgroundColor = [UIColor colorWithRed:0.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
            }];
            didGreatDriver = false;
            didAverageDriver = false;
            didBadDriver = true;
        }
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textField{
    if ([textField isEqual:notesTextField]) {
        if ([textField.text isEqualToString:@"Custom Notes"]) {
            textField.text = @"";
            textField.textColor = [UIColor blackColor];
        }
    }
    [textField becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textField{
    if ([textField isEqual:notesTextField]) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = @"Custom Notes";
            textField.textColor = [UIColor lightGrayColor];
        }
    }
    [textField resignFirstResponder];
}

-(void)coreDataSave{
    if ([notesTextField.text isEqualToString:@"Custom Notes"]) {notesTextField.text = @"";}
    notes = [[NSMutableString alloc] initWithString:@""];
    if (inRedZone) {
        [notes appendString:@"Red "];
    }
    if (inWhiteZone) {
        [notes appendString:@"White "];
    }
    if (inBlueZone) {
        [notes appendString:@"Blue "];
    }
    [notes appendString:@"{} "];
    
    NSMutableString *quickNotes = [[NSMutableString alloc] initWithString:@""];
    if (didGreatDefense) {
        [quickNotes appendString:@"Did Great Defense, "];
    }
    if (didBadDefense) {
        [quickNotes appendString:@"Did Bad Defense, "];
    }
    if (didDidntMove) {
        [quickNotes appendString:@"Didn't Move, "];
    }
    if (didSlowMovement) {
        [quickNotes appendString:@"Moved Slow, "];
    }
    if (didFastMovement) {
        [quickNotes appendString:@"Moved Fast, "];
    }
    if (didBrokeDownInMatch) {
        [quickNotes appendString:@"Broke Down in Match, "];
    }
    if (didGreatBallPickup) {
        [quickNotes appendString:@"Had Great Ball Pick Up Skills, "];
    }
    if (didBadBallPickup) {
        [quickNotes appendString:@"Had Bad Ball Pick Up Skills, "];
    }
    if (didGreatCooperation) {
        [quickNotes appendString:@"Great Cooperation, "];
    }
    if (didBadCooperation) {
        [quickNotes appendString:@"Bad Cooperation, "];
    }
    if (didGreatHumanPlayer) {
        [quickNotes appendString:@"Great Human Player, "];
    }
    if (didBadHumanPlayer) {
        [quickNotes appendString:@"Bad Human Player, "];
    }
    if (didGreatDriver) {
        [quickNotes appendString:@"Great Driver, "];
    }
    if (didAverageDriver) {
        [quickNotes appendString:@"Average Driver, "];
    }
    if (didBadDriver) {
        [quickNotes appendString:@"Bad Driver, "];
    }
    if (quickNotes.length > 0) {
        [quickNotes deleteCharactersInRange:NSMakeRange(quickNotes.length-2, 2)];
    }
    if (notesTextField.text.length > 0) {
        if (quickNotes.length == 0) {
            [notes appendString:notesTextField.text];
        }
        else{
            [notes appendString: quickNotes];
            [notes appendString: [[NSString alloc] initWithFormat:@"\n \n%@", notesTextField.text]];
        }
    }
    else{
        [notes appendString:quickNotes];
    }
    [UIView animateWithDuration:0.3 animations:^{
        notesScreen.center = CGPointMake(notesScreen.center.x, 1524);
    } completion:^(BOOL finished) {
        [notesScreen removeFromSuperview];
        [greyOut removeFromSuperview];
    }];
    [context performBlock:^{
        Regional *rgnl = [Regional createRegionalWithName:currentRegional inManagedObjectContext:context];
        
        Team *tm = [Team createTeamWithName:currentTeamNum inRegional:rgnl withManagedObjectContext:context];
        
        // Create a uniqueID for this match
        NSDate *now = [NSDate date];
        secs = [now timeIntervalSince1970];
        
        NSDictionary *matchDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:autoHighHotScore], @"autoHighHotScore",
                                   [NSNumber numberWithInteger:autoHighNotScore], @"autoHighNotScore",
                                   [NSNumber numberWithInteger:autoHighMissScore], @"autoHighMissScore",
                                   [NSNumber numberWithInteger:autoLowHotScore], @"autoLowHotScore",
                                   [NSNumber numberWithInteger:autoLowNotScore], @"autoLowNotScore",
                                   [NSNumber numberWithInteger:autoLowMissScore], @"autoLowMissScore",
                                   [NSNumber numberWithInteger:mobilityBonus], @"mobilityBonus",
                                   [NSNumber numberWithInteger:teleopHighMake], @"teleopHighMake",
                                   [NSNumber numberWithInteger:teleopHighMiss], @"teleopHighMiss",
                                   [NSNumber numberWithInteger:teleopLowMake], @"teleopLowMake",
                                   [NSNumber numberWithInteger:teleopLowMiss], @"teleopLowMiss",
                                   [NSNumber numberWithInteger:teleopOver], @"teleopOver",
                                   [NSNumber numberWithInteger:teleopCatch], @"teleopCatch",
                                   [NSNumber numberWithInteger:teleopPassed], @"teleopPassed",
                                   [NSNumber numberWithInteger:teleopReceived], @"teleopReceived",
                                   [NSNumber numberWithInteger:largePenaltyTally], @"penaltyLarge",
                                   [NSNumber numberWithInteger:smallPenaltyTally], @"penaltySmall",
                                   [NSString stringWithString:notes], @"notes",
                                   [NSString stringWithString:pos], @"red1Pos",
                                   [NSString stringWithString:scoutTeamNum], @"recordingTeam",
                                   [NSString stringWithString:initials], @"scoutInitials",
                                   [NSString stringWithString:currentMatchType], @"matchType",
                                   [NSString stringWithString:currentMatchNum], @"matchNum",
                                   [NSNumber numberWithInteger:secs], @"uniqueID", nil];
        
//        NSLog(@"%@", matchDict);
        
        Match *match = [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
        
        // If the match doesn't exist
        if ([match.uniqeID integerValue] == secs) {
            [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                if (success) {
                    [self saveSuccess];
                }
                else{
                    NSLog(@"Didn't save correctly");
                }
            }];
        }
        else{
            // Temporarily store the match and team that there was a duplicate of and call the AlertView
            duplicateMatch = match;
            teamWithDuplicate = tm;
            duplicateMatchDict = matchDict;
            [self overWriteAlert];
        }
    }];
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
    
    if (self.mySession != NULL) {
        // Sends data to connected peers
        [self setUpData];
        NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dictToSend];
        NSError *error;
        [self.mySession sendData:dataToSend toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
    }
    if (red1Pos == 0) {red1UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 1 : %@", currentMatchNum]; red1UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    else if (red1Pos == 1){red2UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 2 : %@", currentMatchNum]; red2UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    else if (red1Pos == 2){red3UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Red 3 : %@", currentMatchNum]; red3UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    else if (red1Pos == 3){blue1UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 1 : %@", currentMatchNum]; blue1UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    else if (red1Pos == 4){blue2UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 2 : %@", currentMatchNum]; blue2UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    else if (red1Pos == 5){blue3UpdaterLbl.text = [[NSString alloc] initWithFormat:@"Blue 3 : %@", currentMatchNum]; blue3UpdaterLbl.adjustsFontSizeToFitWidth = true;}
    
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
    
    teleopHighMake = 0;
    _teleopMakeHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMake];
    teleopHighMiss = 0;
    _teleopMissHighLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopHighMiss];
    teleopLowMake = 0;
    _teleopMakeLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMake];
    teleopLowMiss = 0;
    _teleopMissLowLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopLowMiss];
    teleopOver = 0;
    _teleopOverLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopOver];
    teleopCatch = 0;
    _teleopCatchLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopCatch];
    teleopPassed = 0;
    _teleopPassedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopPassed];
    teleopReceived = 0;
    _teleopReceivedLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopReceived];
    
    smallPenaltyTally = 0;
    _smallPenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)smallPenaltyTally];
    _smallPenaltyStepper.value = 0;
    largePenaltyTally = 0;
    _largePenaltyLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)largePenaltyTally];
    _largePenaltyStepper.value = 0;
    
    inRedZone = false;
    inWhiteZone = false;
    inBlueZone = false;
    didGreatDefense = false;
    didBadDefense = false;
    didDidntMove = false;
    didSlowMovement = false;
    didFastMovement = false;
    didBrokeDownInMatch = false;
    didGreatBallPickup = false;
    didBadBallPickup = false;
    didGreatCooperation = false;
    didBadCooperation = false;
    didGreatHumanPlayer = false;
    didBadHumanPlayer = false;
    didGreatDriver = false;
    didAverageDriver = false;
    didBadDriver = false;
    
    // Increment match number by 1 & Generate a random team number to simulate a loaded schedule if it's a qual match
    if ([currentMatchType isEqualToString:@"Q"]) {
        NSInteger matchNumTranslator = [currentMatchNum integerValue];
        matchNumTranslator++;
        currentMatchNum = [[NSString alloc] initWithFormat:@"%ld", (long)matchNumTranslator];
        currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
        [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
        
//        NSInteger randomTeamNum = arc4random() % 4000;
//        currentTeamNum = [[NSString alloc] initWithFormat:@"%ld", (long)randomTeamNum];
        if ([scheduleDictionary objectForKey:currentRegional]) {
            if ([[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum]) {
                currentTeamNum = [[[scheduleDictionary objectForKey:currentRegional] objectForKey:pos] objectForKey:currentMatchNum];
                currentTeamNumAtString = [[NSAttributedString alloc] initWithString:currentTeamNum];
                [_teamNumEdit setAttributedTitle:currentTeamNumAtString forState:UIControlStateNormal];
            }
            else{
                UIAlertView *invalidMatchNumberAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Match Number!"
                                                                                  message:@"You could have finished the last match for this regional, entered a bad match number, or there is some mistake with the schedule downloaded."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"I see."
                                                                        otherButtonTitles:nil];
                [invalidMatchNumberAlert show];
                currentTeamNum = @"";
            }
        }
        else{
            currentTeamNum = @"";
        }
        
        
        NSFetchRequest *roboPicRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
        NSPredicate *roboPicPredicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", currentTeamNum];
        roboPicRequest.predicate = roboPicPredicate;
        NSError *roboPicError = nil;
        NSArray *roboPics = [context executeFetchRequest:roboPicRequest error:&roboPicError];
        PitTeam *pt = [roboPics firstObject];
        _robotPic.alpha = 0;
        UIImage *image = [UIImage imageWithData:[pt valueForKey:@"image"]];
        _robotPic.image = image;
    }
    else{
        if ([currentMatchNum isEqualToString:@"Q1.1"]) {
            currentMatchNum = @"Q2.1";
        }
        else if ([currentMatchNum isEqualToString:@"Q2.1"]){
            currentMatchNum = @"Q3.1";
        }
        else if ([currentMatchNum isEqualToString:@"Q3.1"]){
            currentMatchNum = @"Q4.1";
        }
        else if ([currentMatchNum isEqualToString:@"Q4.1"]){
            currentMatchNum = @"Q1.2";
        }
        else if ([currentMatchNum isEqualToString:@"Q1.2"]){
            currentMatchNum = @"Q2.2";
        }
        else if ([currentMatchNum isEqualToString:@"Q2.2"]){
            currentMatchNum = @"Q3.2";
        }
        else if ([currentMatchNum isEqualToString:@"Q3.2"]){
            currentMatchNum = @"Q4.2";
        }
        else if ([currentMatchNum isEqualToString:@"Q4.2"]){
            currentMatchNum = @"Q1.3";
        }
        else if ([currentMatchNum isEqualToString:@"Q1.3"]){
            currentMatchNum = @"Q2.3";
        }
        else if ([currentMatchNum isEqualToString:@"Q2.3"]){
            currentMatchNum = @"Q3.3";
        }
        else if ([currentMatchNum isEqualToString:@"Q3.3"]){
            currentMatchNum = @"Q4.3";
        }
        else if ([currentMatchNum isEqualToString:@"Q4.3"]){
            currentMatchNum = @"S1.1";
        }
        else if ([currentMatchNum isEqualToString:@"S1.1"]){
            currentMatchNum = @"S2.1";
        }
        else if ([currentMatchNum isEqualToString:@"S2.1"]){
            currentMatchNum = @"S1.2";
        }
        else if ([currentMatchNum isEqualToString:@"S1.2"]){
            currentMatchNum = @"S2.2";
        }
        else if ([currentMatchNum isEqualToString:@"S2.2"]){
            currentMatchNum = @"S1.3";
        }
        else if ([currentMatchNum isEqualToString:@"S1.3"]){
            currentMatchNum = @"S2.3";
        }
        else if ([currentMatchNum isEqualToString:@"S2.3"]){
            currentMatchNum = @"F1.1";
        }
        else if ([currentMatchNum isEqualToString:@"F1.1"]){
            currentMatchNum = @"F1.2";
        }
        else if ([currentMatchNum isEqualToString:@"F1.2"]){
            currentMatchNum = @"F1.3";
        }
        else if ([currentMatchNum isEqualToString:@"F1.3"]){
            currentMatchNum = @"F1.4";
        }
        else if ([currentMatchNum isEqualToString:@"F1.4"]){
            currentMatchNum = @"";
        }
        
        _teamNumField.text = @"";
    }
    
    currentMatchNumAtString = [[NSAttributedString alloc] initWithString:currentMatchNum];
    [_matchNumEdit setAttributedTitle:currentMatchNumAtString forState:UIControlStateNormal];
    
    // Reset editability of match and team numbers
    if (_matchNumEdit.hidden) {
        _matchNumField.enabled = false;
        _matchNumField.hidden = true;
        _matchNumEdit.enabled = true;
        _matchNumEdit.hidden = false;
    }
    if (_teamNumEdit.hidden) {
        if ([currentMatchType isEqualToString:@"Q"]) {
            if (currentTeamNum.length > 0) {
                _teamNumField.enabled = false;
                _teamNumField.hidden = true;
                _teamNumEdit.enabled = true;
                _teamNumEdit.hidden = false;
            }
            else{
                _teamNumField.enabled = true;
                _teamNumField.hidden = false;
                _teamNumEdit.enabled = false;
                _teamNumEdit.hidden = true;
                _teamNumField.text = currentTeamNum;
            }
        }
    }
    
    if (currentMatchNum.length == 0) {
        _matchNumField.enabled = true;
        _matchNumField.hidden = false;
        _matchNumEdit.enabled = false;
        _matchNumEdit.hidden = true;
        
        _matchNumField.text = @"";
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^(void){
        _movementRobot.center = CGPointMake(_movementRobot.center.x, _movementLine.center.y + 50);
        _swipeUpArrow.alpha = 1;
        _robotPic.alpha = 1;
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
    [notesTextField resignFirstResponder];
}








@end
