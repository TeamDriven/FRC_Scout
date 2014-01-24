//
//  RecordTeam.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "RecordTeam.h"
#import "PitTeam.h"
#import "PitTeam+Category.h"

@interface RecordTeam ()

@end

@implementation RecordTeam

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

// Robot Picture Stuff
UIControl *robotImageControl;
UIImageView *robotImage;
UIView *cameraPopup;
UIView *grayLayer;

// Drive Train
UIControl *sixEightWheelDrop;
BOOL isSixEightWheelDrop;
UIControl *fourWheelDrive;
BOOL isFourWheelDrive;
UIControl *mechanum;
BOOL isMechanum;
UIControl *swerveCrab;
BOOL isSwerveCrab;
UITextField *otherDriveTrain;
BOOL isOtherDriveTrain;
NSString *driveTrainString;

// Shooter
UIControl *shooterNone;
BOOL isShooterNone;
UIControl *shooterCatapult;
BOOL isShooterCatapult;
UIControl *shooterPuncher;
BOOL isShooterPuncher;
UITextField *otherShooter;
BOOL isOtherShooter;
NSString *shooterString;


// Preferred Goal
UIControl *preferredHigh;
BOOL isPreferredHigh;
UIControl *preferredLow;
BOOL isPreferredLow;
NSString *preferredGoalString;

// Goalie Arm
UIControl *goalieArmYes;
BOOL isGoalieArmYes;
UIControl *goalieArmNo;
BOOL isGoalieArmNo;
NSString *goalieArmString;


// Floor Collector
UIControl *floorCollectorYes;
BOOL isFloorCollectorYes;
UIControl *floorCollectorNo;
BOOL isFloorCollectorNo;
NSString *floorCollectorString;

// Autonomous
UIControl *autonomousYes;
BOOL isAutonomousYes;
UIControl *autonomousNo;
BOOL isAutonomousNo;
NSString *autonomousString;

// Auto Starting Position
UIControl *startLeft;
BOOL isStartLeft;
UIControl *startMiddle;
BOOL isStartMiddle;
UIControl *startRight;
BOOL isStartRight;
UIControl *startGoalie;
BOOL isStartGoalie;
NSString *autoStartingPositionString;

// Hot Goal Tracking
UIControl *hotGoalYes;
BOOL isHotGoalYes;
UIControl *hotGoalNo;
BOOL isHotGoalNo;
NSString *hotGoalTrackingString;

// Catching Mechanism
UIControl *catchingYes;
BOOL isCatchingYes;
UIControl *catchingNo;
BOOL isCatchingNo;
NSString *catchingMechanismString;

// Bumper Quality
UIControl *bumperOne;
BOOL isBumperOne;
UIControl *bumperThree;
BOOL isBumperThree;
UIControl *bumperFive;
BOOL isBumperFive;
NSString *bumperQualityString;

// Core Data Helpers
NSArray *stringsArray;
BOOL isSomethingSelectedInEveryRow;
NSInteger secs;
PitTeam *duplicatePitTeam;
NSDictionary *duplicatePitTeamDict;
UIAlertView *overWriteAlert;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
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
    
    UILabel *robotImageLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 75, 125, 15)];
    robotImageLbl.text = @"Tap to Change";
    robotImageLbl.textAlignment = NSTextAlignmentCenter;
    robotImageLbl.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:robotImageLbl];
    
    robotImageControl = [[UIControl alloc] initWithFrame:CGRectMake(40, 90, 125, 125)];
    [robotImageControl addTarget:self action:@selector(getAnImage) forControlEvents:UIControlEventTouchUpInside];
    robotImageControl.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    robotImageControl.layer.borderWidth = 1;
    UILabel *addPicLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 105)];
    addPicLbl.text = @"+";
    addPicLbl.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    addPicLbl.textAlignment = NSTextAlignmentCenter;
    addPicLbl.font = [UIFont boldSystemFontOfSize:100];
    [robotImageControl addSubview:addPicLbl];
    robotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    [robotImageControl addSubview:robotImage];
    
    [self.view addSubview:robotImageControl];
    
    _teamNumberField.delegate = self;
    _teamNameField.delegate = self;
    
    [self driveTrainRowSetUp];
    [self shooterRowSetUp];
    [self preferredGoalRowSetUp];
    [self goalieArmRowSetUp];
    [self floorCollectorRowSetUp];
    [self autonomousRowSetUp];
    [self autoStartingPositionRowSetUp];
    [self hotGoalTrackingRowSetUp];
    [self catchingMechanismRowSetUp];
    [self bumperQualityRowSetUp];
    
    _additionalNotesTxtField.layer.cornerRadius = 10;
    _additionalNotesTxtField.layer.borderColor = [[UIColor colorWithWhite:0.7 alpha:1.0] CGColor];
    _additionalNotesTxtField.layer.borderWidth = 1;
    _additionalNotesTxtField.font = [UIFont systemFontOfSize:14];
    _additionalNotesTxtField.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _additionalNotesTxtField.text = @"Additional Notes";
    _additionalNotesTxtField.delegate = self;
    
    _saveBtn.layer.cornerRadius = 10;
    
    [self.view bringSubviewToFront:_additionalNotesTxtField];
    [self.view bringSubviewToFront:robotImageControl];
    
    driveTrainString = @"";
    shooterString = @"";
    preferredGoalString = @"";
    goalieArmString = @"";
    floorCollectorString = @"";
    autonomousString = @"";
    autoStartingPositionString = @"";
    hotGoalTrackingString = @"";
    catchingMechanismString = @"";
    bumperQualityString = @"";
}

-(void)driveTrainRowSetUp{
    sixEightWheelDrop = [[UIControl alloc] initWithFrame:CGRectMake(210, 245, 115, 30)];
    [sixEightWheelDrop addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    sixEightWheelDrop.layer.cornerRadius = 5;
    sixEightWheelDrop.center = CGPointMake(sixEightWheelDrop.center.x, _driveTrainLbl.center.y);
    UILabel *sixEightWheelDropLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 115, 30)];
    sixEightWheelDropLbl.text = @"6 or 8 Wheel Drop";
    sixEightWheelDropLbl.textColor = [UIColor whiteColor];
    sixEightWheelDropLbl.textAlignment = NSTextAlignmentCenter;
    sixEightWheelDropLbl.font = [UIFont boldSystemFontOfSize:12];
    sixEightWheelDropLbl.backgroundColor = [UIColor clearColor];
    [sixEightWheelDrop addSubview:sixEightWheelDropLbl];
    [self.view addSubview:sixEightWheelDrop];
    
    fourWheelDrive = [[UIControl alloc] initWithFrame:CGRectMake(335, 245, 90, 30)];
    [fourWheelDrive addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    fourWheelDrive.layer.cornerRadius = 5;
    fourWheelDrive.center = CGPointMake(fourWheelDrive.center.x, _driveTrainLbl.center.y);
    UILabel *fourWheelDriveLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    fourWheelDriveLbl.text = @"4 Wheel Drive";
    fourWheelDriveLbl.textColor = [UIColor whiteColor];
    fourWheelDriveLbl.textAlignment = NSTextAlignmentCenter;
    fourWheelDriveLbl.font = [UIFont boldSystemFontOfSize:12];
    fourWheelDriveLbl.backgroundColor = [UIColor clearColor];
    [fourWheelDrive addSubview:fourWheelDriveLbl];
    [self.view addSubview:fourWheelDrive];
    
    mechanum = [[UIControl alloc] initWithFrame:CGRectMake(435, 245, 75, 30)];
    [mechanum addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    mechanum.layer.cornerRadius = 5;
    mechanum.center = CGPointMake(mechanum.center.x, _driveTrainLbl.center.y);
    UILabel *mechanumLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    mechanumLbl.text = @"Mechanum";
    mechanumLbl.textColor = [UIColor whiteColor];
    mechanumLbl.textAlignment = NSTextAlignmentCenter;
    mechanumLbl.font = [UIFont boldSystemFontOfSize:12];
    mechanumLbl.backgroundColor = [UIColor clearColor];
    [mechanum addSubview:mechanumLbl];
    [self.view addSubview:mechanum];
    
    swerveCrab = [[UIControl alloc] initWithFrame:CGRectMake(520, 245, 85, 30)];
    [swerveCrab addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    swerveCrab.layer.cornerRadius = 5;
    swerveCrab.center = CGPointMake(swerveCrab.center.x, _driveTrainLbl.center.y);
    UILabel *swerveCrabLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    swerveCrabLbl.text = @"Swerve/Crab";
    swerveCrabLbl.textColor = [UIColor whiteColor];
    swerveCrabLbl.textAlignment = NSTextAlignmentCenter;
    swerveCrabLbl.font = [UIFont boldSystemFontOfSize:12];
    swerveCrabLbl.backgroundColor = [UIColor clearColor];
    [swerveCrab addSubview:swerveCrabLbl];
    [self.view addSubview:swerveCrab];
    
    otherDriveTrain = [[UITextField alloc] initWithFrame:CGRectMake(615, 245, 110, 30)];
    otherDriveTrain.center = CGPointMake(otherDriveTrain.center.x, _driveTrainLbl.center.y);
    otherDriveTrain.borderStyle = UITextBorderStyleRoundedRect;
    otherDriveTrain.placeholder = @"Other Drive Train";
    otherDriveTrain.font = [UIFont systemFontOfSize:12];
    otherDriveTrain.textAlignment = NSTextAlignmentCenter;
    otherDriveTrain.returnKeyType = UIReturnKeyDone;
    otherDriveTrain.delegate = self;
    [otherDriveTrain addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:otherDriveTrain];
}
-(void)shooterRowSetUp{
    shooterNone = [[UIControl alloc] initWithFrame:CGRectMake(210, 295, 55, 30)];
    shooterNone.center = CGPointMake(shooterNone.center.x, _shooterLbl.center.y);
    [shooterNone addTarget:self action:@selector(shooterSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    shooterNone.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    shooterNone.layer.cornerRadius = 5;
    UILabel *shooterNoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    shooterNoneLbl.text = @"None";
    shooterNoneLbl.textColor = [UIColor whiteColor];
    shooterNoneLbl.textAlignment = NSTextAlignmentCenter;
    shooterNoneLbl.font = [UIFont boldSystemFontOfSize:12];
    shooterNoneLbl.backgroundColor = [UIColor clearColor];
    [shooterNone addSubview:shooterNoneLbl];
    [self.view addSubview:shooterNone];
    
    shooterCatapult = [[UIControl alloc] initWithFrame:CGRectMake(275, 295, 80, 30)];
    shooterCatapult.center = CGPointMake(shooterCatapult.center.x, _shooterLbl.center.y);
    [shooterCatapult addTarget:self action:@selector(shooterSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    shooterCatapult.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    shooterCatapult.layer.cornerRadius = 5;
    UILabel *shooterCatapultLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    shooterCatapultLbl.text = @"Catapult";
    shooterCatapultLbl.textColor = [UIColor whiteColor];
    shooterCatapultLbl.textAlignment = NSTextAlignmentCenter;
    shooterCatapultLbl.font = [UIFont boldSystemFontOfSize:12];
    shooterCatapultLbl.backgroundColor = [UIColor clearColor];
    [shooterCatapult addSubview:shooterCatapultLbl];
    [self.view addSubview:shooterCatapult];
    
    shooterPuncher = [[UIControl alloc] initWithFrame:CGRectMake(365, 295, 80, 30)];
    shooterPuncher.center = CGPointMake(shooterPuncher.center.x, _shooterLbl.center.y);
    [shooterPuncher addTarget:self action:@selector(shooterSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    shooterPuncher.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    shooterPuncher.layer.cornerRadius = 5;
    UILabel *shooterPuncherLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    shooterPuncherLbl.text = @"Puncher";
    shooterPuncherLbl.textColor = [UIColor whiteColor];
    shooterPuncherLbl.textAlignment = NSTextAlignmentCenter;
    shooterPuncherLbl.font = [UIFont boldSystemFontOfSize:12];
    shooterPuncherLbl.backgroundColor = [UIColor clearColor];
    [shooterPuncher addSubview:shooterPuncherLbl];
    [self.view addSubview:shooterPuncher];
    
    otherShooter = [[UITextField alloc] initWithFrame:CGRectMake(455, 295, 100, 30)];
    otherShooter.center = CGPointMake(otherShooter.center.x, _shooterLbl.center.y);
    otherShooter.borderStyle = UITextBorderStyleRoundedRect;
    otherShooter.placeholder = @"Other Shooter";
    otherShooter.font = [UIFont systemFontOfSize:12];
    otherShooter.textAlignment = NSTextAlignmentCenter;
    otherShooter.returnKeyType = UIReturnKeyDone;
    otherShooter.delegate = self;
    [otherShooter addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:otherShooter];
}
-(void)preferredGoalRowSetUp{
    preferredHigh = [[UIControl alloc] initWithFrame:CGRectMake(210, 345, 80, 30)];
    preferredHigh.center = CGPointMake(preferredHigh.center.x, _preferredGoalLbl.center.y);
    [preferredHigh addTarget:self action:@selector(preferredGoalSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    preferredHigh.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    preferredHigh.layer.cornerRadius = 5;
    UILabel *preferredHighLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    preferredHighLbl.text = @"High";
    preferredHighLbl.textColor = [UIColor whiteColor];
    preferredHighLbl.textAlignment = NSTextAlignmentCenter;
    preferredHighLbl.font = [UIFont boldSystemFontOfSize:12];
    preferredHighLbl.backgroundColor = [UIColor clearColor];
    [preferredHigh addSubview:preferredHighLbl];
    [self.view addSubview:preferredHigh];
    
    preferredLow = [[UIControl alloc] initWithFrame:CGRectMake(300, 345, 80, 30)];
    preferredLow.center = CGPointMake(preferredLow.center.x, _preferredGoalLbl.center.y);
    [preferredLow addTarget:self action:@selector(preferredGoalSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    preferredLow.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    preferredLow.layer.cornerRadius = 5;
    UILabel *preferredLowLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    preferredLowLbl.text = @"Low";
    preferredLowLbl.textColor = [UIColor whiteColor];
    preferredLowLbl.textAlignment = NSTextAlignmentCenter;
    preferredLowLbl.font = [UIFont boldSystemFontOfSize:12];
    preferredLowLbl.backgroundColor = [UIColor clearColor];
    [preferredLow addSubview:preferredLowLbl];
    [self.view addSubview:preferredLow];
}
-(void)goalieArmRowSetUp{
    goalieArmYes = [[UIControl alloc] initWithFrame:CGRectMake(210, 395, 80, 30)];
    goalieArmYes.center = CGPointMake(goalieArmYes.center.x, _goalieArmLbl.center.y);
    [goalieArmYes addTarget:self action:@selector(goalieArmSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    goalieArmYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    goalieArmYes.layer.cornerRadius = 5;
    UILabel *goalieArmYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    goalieArmYesLbl.text = @"Yes";
    goalieArmYesLbl.textColor = [UIColor whiteColor];
    goalieArmYesLbl.textAlignment = NSTextAlignmentCenter;
    goalieArmYesLbl.font = [UIFont boldSystemFontOfSize:12];
    goalieArmYesLbl.backgroundColor = [UIColor clearColor];
    [goalieArmYes addSubview:goalieArmYesLbl];
    [self.view addSubview:goalieArmYes];
    
    goalieArmNo = [[UIControl alloc] initWithFrame:CGRectMake(300, 395, 80, 30)];
    goalieArmNo.center = CGPointMake(goalieArmNo.center.x, _goalieArmLbl.center.y);
    [goalieArmNo addTarget:self action:@selector(goalieArmSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    goalieArmNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    goalieArmNo.layer.cornerRadius = 5;
    UILabel *goalieArmNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    goalieArmNoLbl.text = @"No";
    goalieArmNoLbl.textColor = [UIColor whiteColor];
    goalieArmNoLbl.textAlignment = NSTextAlignmentCenter;
    goalieArmNoLbl.font = [UIFont boldSystemFontOfSize:12];
    goalieArmNoLbl.backgroundColor = [UIColor clearColor];
    [goalieArmNo addSubview:goalieArmNoLbl];
    [self.view addSubview:goalieArmNo];
}
-(void)floorCollectorRowSetUp{
    floorCollectorYes = [[UIControl alloc] initWithFrame:CGRectMake(210, 446, 80, 30)];
    floorCollectorYes.center = CGPointMake(floorCollectorYes.center.x, _floorCollectorLbl.center.y);
    [floorCollectorYes addTarget:self action:@selector(floorCollectorSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    floorCollectorYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    floorCollectorYes.layer.cornerRadius = 5;
    UILabel *floorCollectorYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    floorCollectorYesLbl.text = @"Yes";
    floorCollectorYesLbl.textColor = [UIColor whiteColor];
    floorCollectorYesLbl.textAlignment = NSTextAlignmentCenter;
    floorCollectorYesLbl.font = [UIFont boldSystemFontOfSize:12];
    floorCollectorYesLbl.backgroundColor = [UIColor clearColor];
    [floorCollectorYes addSubview:floorCollectorYesLbl];
    [self.view addSubview:floorCollectorYes];
    
    floorCollectorNo = [[UIControl alloc] initWithFrame:CGRectMake(300, 446, 80, 30)];
    floorCollectorNo.center = CGPointMake(floorCollectorNo.center.x, _floorCollectorLbl.center.y);
    [floorCollectorNo addTarget:self action:@selector(floorCollectorSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    floorCollectorNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    floorCollectorNo.layer.cornerRadius = 5;
    UILabel *floorCollectorNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    floorCollectorNoLbl.text = @"No";
    floorCollectorNoLbl.textColor = [UIColor whiteColor];
    floorCollectorNoLbl.textAlignment = NSTextAlignmentCenter;
    floorCollectorNoLbl.font = [UIFont boldSystemFontOfSize:12];
    floorCollectorNoLbl.backgroundColor = [UIColor clearColor];
    [floorCollectorNo addSubview:floorCollectorNoLbl];
    [self.view addSubview:floorCollectorNo];
}
-(void)autonomousRowSetUp{
    autonomousYes = [[UIControl alloc] initWithFrame:CGRectMake(210, 496, 80, 30)];
    autonomousYes.center = CGPointMake(autonomousYes.center.x, _autonomousLbl.center.y);
    [autonomousYes addTarget:self action:@selector(autonomousSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    autonomousYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    autonomousYes.layer.cornerRadius = 5;
    UILabel *autonomousYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    autonomousYesLbl.text = @"Yes";
    autonomousYesLbl.textColor = [UIColor whiteColor];
    autonomousYesLbl.textAlignment = NSTextAlignmentCenter;
    autonomousYesLbl.font = [UIFont boldSystemFontOfSize:12];
    autonomousYesLbl.backgroundColor = [UIColor clearColor];
    [autonomousYes addSubview:autonomousYesLbl];
    [self.view addSubview:autonomousYes];
    
    autonomousNo = [[UIControl alloc] initWithFrame:CGRectMake(300, 496, 80, 30)];
    autonomousNo.center = CGPointMake(autonomousNo.center.x, _autonomousLbl.center.y);
    [autonomousNo addTarget:self action:@selector(autonomousSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    autonomousNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    autonomousNo.layer.cornerRadius = 5;
    UILabel *autonomousNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    autonomousNoLbl.text = @"No";
    autonomousNoLbl.textColor = [UIColor whiteColor];
    autonomousNoLbl.textAlignment = NSTextAlignmentCenter;
    autonomousNoLbl.font = [UIFont boldSystemFontOfSize:12];
    autonomousNoLbl.backgroundColor = [UIColor clearColor];
    [autonomousNo addSubview:autonomousNoLbl];
    [self.view addSubview:autonomousNo];
}
-(void)autoStartingPositionRowSetUp{
    startLeft = [[UIControl alloc] initWithFrame:CGRectMake(210, 496, 70, 30)];
    startLeft.center = CGPointMake(startLeft.center.x, _autoStartingPositionLbl.center.y);
    [startLeft addTarget:self action:@selector(autoStartingPositionSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    startLeft.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    startLeft.layer.cornerRadius = 5;
    UILabel *startLeftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    startLeftLbl.text = @"Left";
    startLeftLbl.textColor = [UIColor whiteColor];
    startLeftLbl.textAlignment = NSTextAlignmentCenter;
    startLeftLbl.font = [UIFont boldSystemFontOfSize:12];
    startLeftLbl.backgroundColor = [UIColor clearColor];
    [startLeft addSubview:startLeftLbl];
    [self.view addSubview:startLeft];
    
    startMiddle = [[UIControl alloc] initWithFrame:CGRectMake(290, 496, 70, 30)];
    startMiddle.center = CGPointMake(startMiddle.center.x, _autoStartingPositionLbl.center.y);
    [startMiddle addTarget:self action:@selector(autoStartingPositionSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    startMiddle.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    startMiddle.layer.cornerRadius = 5;
    UILabel *startMiddleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    startMiddleLbl.text = @"Middle";
    startMiddleLbl.textColor = [UIColor whiteColor];
    startMiddleLbl.textAlignment = NSTextAlignmentCenter;
    startMiddleLbl.font = [UIFont boldSystemFontOfSize:12];
    startMiddleLbl.backgroundColor = [UIColor clearColor];
    [startMiddle addSubview:startMiddleLbl];
    [self.view addSubview:startMiddle];
    
    startRight = [[UIControl alloc] initWithFrame:CGRectMake(370, 496, 70, 30)];
    startRight.center = CGPointMake(startRight.center.x, _autoStartingPositionLbl.center.y);
    [startRight addTarget:self action:@selector(autoStartingPositionSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    startRight.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    startRight.layer.cornerRadius = 5;
    UILabel *startRightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    startRightLbl.text = @"Right";
    startRightLbl.textColor = [UIColor whiteColor];
    startRightLbl.textAlignment = NSTextAlignmentCenter;
    startRightLbl.font = [UIFont boldSystemFontOfSize:12];
    startRightLbl.backgroundColor = [UIColor clearColor];
    [startRight addSubview:startRightLbl];
    [self.view addSubview:startRight];
    
    startGoalie = [[UIControl alloc] initWithFrame:CGRectMake(450, 496, 70, 30)];
    startGoalie.center = CGPointMake(startGoalie.center.x, _autoStartingPositionLbl.center.y);
    [startGoalie addTarget:self action:@selector(autoStartingPositionSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    startGoalie.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    startGoalie.layer.cornerRadius = 5;
    UILabel *startGoalieLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    startGoalieLbl.text = @"Goalie";
    startGoalieLbl.textColor = [UIColor whiteColor];
    startGoalieLbl.textAlignment = NSTextAlignmentCenter;
    startGoalieLbl.font = [UIFont boldSystemFontOfSize:12];
    startGoalieLbl.backgroundColor = [UIColor clearColor];
    [startGoalie addSubview:startGoalieLbl];
    [self.view addSubview:startGoalie];
}
-(void)hotGoalTrackingRowSetUp{
    hotGoalYes = [[UIControl alloc] initWithFrame:CGRectMake(210, 496, 80, 30)];
    hotGoalYes.center = CGPointMake(hotGoalYes.center.x, _hotGoalTrackingLbl.center.y);
    [hotGoalYes addTarget:self action:@selector(hotGoalTrackingSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    hotGoalYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    hotGoalYes.layer.cornerRadius = 5;
    UILabel *hotGoalYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    hotGoalYesLbl.text = @"Yes";
    hotGoalYesLbl.textColor = [UIColor whiteColor];
    hotGoalYesLbl.textAlignment = NSTextAlignmentCenter;
    hotGoalYesLbl.font = [UIFont boldSystemFontOfSize:12];
    hotGoalYesLbl.backgroundColor = [UIColor clearColor];
    [hotGoalYes addSubview:hotGoalYesLbl];
    [self.view addSubview:hotGoalYes];
    
    hotGoalNo = [[UIControl alloc] initWithFrame:CGRectMake(300, 496, 80, 30)];
    hotGoalNo.center = CGPointMake(hotGoalNo.center.x, _hotGoalTrackingLbl.center.y);
    [hotGoalNo addTarget:self action:@selector(hotGoalTrackingSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    hotGoalNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    hotGoalNo.layer.cornerRadius = 5;
    UILabel *hotGoalNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    hotGoalNoLbl.text = @"No";
    hotGoalNoLbl.textColor = [UIColor whiteColor];
    hotGoalNoLbl.textAlignment = NSTextAlignmentCenter;
    hotGoalNoLbl.font = [UIFont boldSystemFontOfSize:12];
    hotGoalNoLbl.backgroundColor = [UIColor clearColor];
    [hotGoalNo addSubview:hotGoalNoLbl];
    [self.view addSubview:hotGoalNo];
}
-(void)catchingMechanismRowSetUp{
    catchingYes = [[UIControl alloc] initWithFrame:CGRectMake(210, 496, 80, 30)];
    catchingYes.center = CGPointMake(catchingYes.center.x, _catchingMechanismLbl.center.y);
    [catchingYes addTarget:self action:@selector(catchingMechanismSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    catchingYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    catchingYes.layer.cornerRadius = 5;
    UILabel *catchingYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    catchingYesLbl.text = @"Yes";
    catchingYesLbl.textColor = [UIColor whiteColor];
    catchingYesLbl.textAlignment = NSTextAlignmentCenter;
    catchingYesLbl.font = [UIFont boldSystemFontOfSize:12];
    catchingYesLbl.backgroundColor = [UIColor clearColor];
    [catchingYes addSubview:catchingYesLbl];
    [self.view addSubview:catchingYes];
    
    catchingNo = [[UIControl alloc] initWithFrame:CGRectMake(300, 496, 80, 30)];
    catchingNo.center = CGPointMake(catchingNo.center.x, _catchingMechanismLbl.center.y);
    [catchingNo addTarget:self action:@selector(catchingMechanismSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    catchingNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    catchingNo.layer.cornerRadius = 5;
    UILabel *catchingNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    catchingNoLbl.text = @"No";
    catchingNoLbl.textColor = [UIColor whiteColor];
    catchingNoLbl.textAlignment = NSTextAlignmentCenter;
    catchingNoLbl.font = [UIFont boldSystemFontOfSize:12];
    catchingNoLbl.backgroundColor = [UIColor clearColor];
    [catchingNo addSubview:catchingNoLbl];
    [self.view addSubview:catchingNo];
}
-(void)bumperQualityRowSetUp{
    bumperOne = [[UIControl alloc] initWithFrame:CGRectMake(210, 496, 70, 30)];
    bumperOne.center = CGPointMake(bumperOne.center.x, _bumperQualityLbl.center.y);
    [bumperOne addTarget:self action:@selector(bumperQualitySelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    bumperOne.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    bumperOne.layer.cornerRadius = 5;
    UILabel *bumperOneLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    bumperOneLbl.text = @"One";
    bumperOneLbl.textColor = [UIColor whiteColor];
    bumperOneLbl.textAlignment = NSTextAlignmentCenter;
    bumperOneLbl.font = [UIFont boldSystemFontOfSize:12];
    bumperOneLbl.backgroundColor = [UIColor clearColor];
    [bumperOne addSubview:bumperOneLbl];
    [self.view addSubview:bumperOne];
    
    bumperThree = [[UIControl alloc] initWithFrame:CGRectMake(290, 496, 70, 30)];
    bumperThree.center = CGPointMake(bumperThree.center.x, _bumperQualityLbl.center.y);
    [bumperThree addTarget:self action:@selector(bumperQualitySelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    bumperThree.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    bumperThree.layer.cornerRadius = 5;
    UILabel *bumperThreeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    bumperThreeLbl.text = @"Three";
    bumperThreeLbl.textColor = [UIColor whiteColor];
    bumperThreeLbl.textAlignment = NSTextAlignmentCenter;
    bumperThreeLbl.font = [UIFont boldSystemFontOfSize:12];
    bumperThreeLbl.backgroundColor = [UIColor clearColor];
    [bumperThree addSubview:bumperThreeLbl];
    [self.view addSubview:bumperThree];
    
    bumperFive = [[UIControl alloc] initWithFrame:CGRectMake(370, 496, 70, 30)];
    bumperFive.center = CGPointMake(bumperFive.center.x, _bumperQualityLbl.center.y);
    [bumperFive addTarget:self action:@selector(bumperQualitySelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    bumperFive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
    bumperFive.layer.cornerRadius = 5;
    UILabel *bumperFiveLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    bumperFiveLbl.text = @"Five";
    bumperFiveLbl.textColor = [UIColor whiteColor];
    bumperFiveLbl.textAlignment = NSTextAlignmentCenter;
    bumperFiveLbl.font = [UIFont boldSystemFontOfSize:12];
    bumperFiveLbl.backgroundColor = [UIColor clearColor];
    [bumperFive addSubview:bumperFiveLbl];
    [self.view addSubview:bumperFive];
}

- (IBAction)numberValidator:(id)sender {
    NSMutableString *txt1 = [[NSMutableString alloc] initWithString:_teamNumberField.text];
    for (unsigned int i = 0; i < [txt1 length]; i++) {
        NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt1 characterAtIndex:i]];
        if ([character isEqualToString:@" "]){
            [txt1 deleteCharactersInRange:NSMakeRange(i, 1)];
            _teamNumberField.text = [[NSString alloc] initWithString:txt1];
        }
        else if ([character integerValue] == 0 && ![character isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Numbers only please!"
                                                           message: @"Please only enter numbers in the \"Team Number\" text field"
                                                          delegate: nil
                                                 cancelButtonTitle:@"Sorry..."
                                                 otherButtonTitles:nil];
            [alert show];
            [txt1 deleteCharactersInRange:NSMakeRange(i, 1)];
            _teamNumberField.text = [[NSString alloc] initWithString:txt1];
        }
    }
}

-(void)getAnImage{
    grayLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayLayer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:grayLayer];
    
    cameraPopup = [[UIView alloc] initWithFrame:CGRectMake(209, 824, 350, 330)];
    cameraPopup.backgroundColor = [UIColor whiteColor];
    cameraPopup.layer.cornerRadius = 15;
    
    UIButton *useCameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    useCameraBtn.frame = CGRectMake(30, 20, 290, 40);
    [useCameraBtn addTarget:self action:@selector(useCamera) forControlEvents:UIControlEventTouchUpInside];
    [useCameraBtn setTitle:@"Use Camera" forState:UIControlStateNormal];
    [useCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useCameraBtn setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1]];
    useCameraBtn.layer.cornerRadius = 10;
    [cameraPopup addSubview:useCameraBtn];
    
    UIButton *usePhotoReelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    usePhotoReelBtn.frame = CGRectMake(30, 80, 290, 40);
    [usePhotoReelBtn addTarget:self action:@selector(usePhotoReel) forControlEvents:UIControlEventTouchUpInside];
    [usePhotoReelBtn setTitle:@"Use Photo Reel" forState:UIControlStateNormal];
    [usePhotoReelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [usePhotoReelBtn setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1]];
    usePhotoReelBtn.layer.cornerRadius = 10;
    [cameraPopup addSubview:usePhotoReelBtn];
    
    UIButton *deletePhotoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deletePhotoBtn.frame = CGRectMake(30, 140, 290, 40);
    [deletePhotoBtn addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchUpInside];
    [deletePhotoBtn setTitle:@"Delete Photo" forState:UIControlStateNormal];
    [deletePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deletePhotoBtn setBackgroundColor:[UIColor redColor]];
    deletePhotoBtn.layer.cornerRadius = 10;
    [cameraPopup addSubview:deletePhotoBtn];
    
    UIButton *cameraCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cameraCancelButton.frame = CGRectMake(30, 200, 290, 40);
    [cameraCancelButton addTarget:self action:@selector(cancelCameraPopUp) forControlEvents:UIControlEventTouchUpInside];
    [cameraCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cameraCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraCancelButton setBackgroundColor:[UIColor redColor]];
    cameraCancelButton.layer.cornerRadius = 10;
    [cameraPopup addSubview:cameraCancelButton];
    
    [grayLayer addSubview:cameraPopup];
    
    cameraPopup.center = CGPointMake(384, 1164);
    [UIView animateWithDuration:0.2 animations:^{
        cameraPopup.center = CGPointMake(384, 860);
    }];
    
}
-(void)useCamera{
    [UIView animateWithDuration:0.1 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        
        [imagePicker setAllowsEditing:YES];
        
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
    
    
//    CGRect f = imagePicker.view.bounds;
//    f.size.height -= imagePicker.navigationBar.bounds.size.height;
//    UIGraphicsBeginImageContext(f.size);
//    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
//    UIRectFillUsingBlendMode(CGRectMake(0, 125, f.size.width, 3), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(0, 893, f.size.width, 3), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(0, 128, 3, 766), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(765, 128, 3, 766), kCGBlendModeNormal);
//    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
//    overlayIV.image = overlayImage;
//    overlayIV.alpha = 0.7f;
//    [imagePicker setCameraOverlayView:overlayIV];
    
    
}
-(void)usePhotoReel{
    [UIView animateWithDuration:0.1 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        
        [imagePicker setAllowsEditing:YES];
        
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
}
-(void)deletePhoto{
    [UIView animateWithDuration:0.3 animations:^{
        robotImage.alpha = 0;
        robotImageControl.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    } completion:^(BOOL finished) {
        robotImage.image = nil;
        robotImage.alpha = 1;
        [self cancelCameraPopUp];
    }];
}
-(void)cancelCameraPopUp{
    [UIView animateWithDuration:0.2 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    robotImageControl.layer.borderColor = [[UIColor clearColor] CGColor];
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.0);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.0];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    robotImage.frame = CGRectMake(0, 0, 700, 700);
    robotImage.image = image;
    robotImage.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        robotImage.frame = CGRectMake(0, 0, 125, 125);
    } completion:^(BOOL finished) {}];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)driveTrainSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:sixEightWheelDrop]) {
        if (isSixEightWheelDrop) {
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            driveTrainString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSixEightWheelDrop = true;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = false;
            isOtherDriveTrain = false;
            otherDriveTrain.text = @"";
            if (otherDriveTrain.isFirstResponder) {[otherDriveTrain resignFirstResponder];}
            driveTrainString = @"6 or 8 Wheel Drop";
        }
    }
    else if ([controller isEqual:fourWheelDrive]){
        if (isFourWheelDrive) {
            [UIView animateWithDuration:0.2 animations:^{
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isFourWheelDrive = false;
            driveTrainString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = true;
            isMechanum = false;
            isSwerveCrab = false;
            isOtherDriveTrain = false;
            otherDriveTrain.text = @"";
            if (otherDriveTrain.isFirstResponder) {[otherDriveTrain resignFirstResponder];}
            driveTrainString = @"Four Wheel Drive";
        }
    }
    else if ([controller isEqual:mechanum]){
        if (isMechanum) {
            [UIView animateWithDuration:0.2 animations:^{
                mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isMechanum = false;
            driveTrainString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = true;
            isSwerveCrab = false;
            isOtherDriveTrain = false;
            otherDriveTrain.text = @"";
            if (otherDriveTrain.isFirstResponder) {[otherDriveTrain resignFirstResponder];}
            driveTrainString = @"Mechanum";
        }
    }
    else if ([controller isEqual:swerveCrab]){
        if (isSwerveCrab) {
            [UIView animateWithDuration:0.2 animations:^{
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSwerveCrab = false;
            driveTrainString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = true;
            isOtherDriveTrain = false;
            otherDriveTrain.text = @"";
            if (otherDriveTrain.isFirstResponder) {[otherDriveTrain resignFirstResponder];}
            driveTrainString = @"Swerve/Crab";
        }
    }
}
-(void)shooterSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:shooterNone]){
        if (isShooterNone) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterNone.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterNone = false;
            shooterString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                shooterNone.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                shooterCatapult.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterPuncher.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterNone = true;
            isShooterCatapult = false;
            isShooterPuncher = false;
            isOtherShooter = false;
            otherShooter.text = @"";
            if (otherShooter.isFirstResponder) {[otherShooter resignFirstResponder];}
            shooterString = @"None";
        }
    }
    else if ([controller isEqual:shooterCatapult]) {
        if (isShooterCatapult) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterCatapult.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterCatapult = false;
            shooterString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                shooterNone.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterCatapult.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                shooterPuncher.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterNone = false;
            isShooterCatapult = true;
            isShooterPuncher = false;
            isOtherShooter = false;
            otherShooter.text = @"";
            if (otherShooter.isFirstResponder) {[otherShooter resignFirstResponder];}
            shooterString = @"Catapult";
        }
    }
    else if ([controller isEqual:shooterPuncher]) {
        if (isShooterPuncher) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterPuncher.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterPuncher = false;
            shooterString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                shooterNone.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterCatapult.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterPuncher.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isShooterNone = false;
            isShooterCatapult = false;
            isShooterPuncher = true;
            isOtherShooter = false;
            otherShooter.text = @"";
            if (otherShooter.isFirstResponder) {[otherShooter resignFirstResponder];}
            shooterString = @"Puncher";
        }
    }
}
-(void)preferredGoalSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:preferredHigh]){
        if (isPreferredHigh) {
            [UIView animateWithDuration:0.2 animations:^{
                preferredHigh.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isPreferredHigh = false;
            preferredGoalString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                preferredHigh.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                preferredLow.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isPreferredHigh = true;
            isPreferredLow = false;
            preferredGoalString = @"High";
        }
    }
    else if ([controller isEqual:preferredLow]){
        if (isPreferredLow) {
            [UIView animateWithDuration:0.2 animations:^{
                preferredLow.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isPreferredLow = false;
            preferredGoalString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                preferredHigh.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                preferredLow.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isPreferredHigh = false;
            isPreferredLow = true;
            preferredGoalString = @"Low";
        }
    }
}
-(void)goalieArmSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:goalieArmYes]){
        if (isGoalieArmYes) {
            [UIView animateWithDuration:0.2 animations:^{
                goalieArmYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isGoalieArmYes = false;
            goalieArmString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                goalieArmYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                goalieArmNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isGoalieArmYes = true;
            isGoalieArmNo = false;
            goalieArmString = @"Yes";
        }
    }
    else if ([controller isEqual:goalieArmNo]){
        if (isGoalieArmNo) {
            [UIView animateWithDuration:0.2 animations:^{
                goalieArmNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isGoalieArmNo = false;
            goalieArmString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                goalieArmYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                goalieArmNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isGoalieArmYes = false;
            isGoalieArmNo = true;
            goalieArmString = @"No";
        }
    }
}
-(void)floorCollectorSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:floorCollectorYes]){
        if (isFloorCollectorYes) {
            [UIView animateWithDuration:0.2 animations:^{
                floorCollectorYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isFloorCollectorYes = false;
            floorCollectorString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                floorCollectorYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                floorCollectorNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isFloorCollectorYes = true;
            isFloorCollectorNo = false;
            floorCollectorString = @"Yes";
        }
    }
    else if ([controller isEqual:floorCollectorNo]){
        if (isFloorCollectorNo) {
            [UIView animateWithDuration:0.2 animations:^{
                floorCollectorNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isFloorCollectorNo = false;
            floorCollectorString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                floorCollectorYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                floorCollectorNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isFloorCollectorYes = false;
            isFloorCollectorNo = true;
            floorCollectorString = @"No";
        }
    }
}
-(void)autonomousSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:autonomousYes]){
        if (isAutonomousYes) {
            [UIView animateWithDuration:0.2 animations:^{
                autonomousYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isAutonomousYes= false;
            autonomousString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                autonomousYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                autonomousNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isAutonomousYes = true;
            isAutonomousNo = false;
            autonomousString = @"Yes";
        }
    }
    else if ([controller isEqual:autonomousNo]){
        if (isAutonomousNo) {
            [UIView animateWithDuration:0.2 animations:^{
                autonomousNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isAutonomousNo = false;
            autonomousString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                autonomousYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                autonomousNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isAutonomousYes = false;
            isAutonomousNo = true;
            autonomousString = @"No";
        }
    }
}
-(void)autoStartingPositionSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:startLeft]){
        if (isStartLeft) {
            [UIView animateWithDuration:0.2 animations:^{
                startLeft.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartLeft = false;
            autoStartingPositionString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                startLeft.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                startMiddle.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startRight.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startGoalie.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartLeft = true;
            isStartMiddle = false;
            isStartRight = false;
            isStartGoalie = false;
            autoStartingPositionString = @"Left";
        }
    }
    else if ([controller isEqual:startMiddle]) {
        if (isStartMiddle) {
            [UIView animateWithDuration:0.2 animations:^{
                startMiddle.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartMiddle = false;
            autoStartingPositionString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                startLeft.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startMiddle.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                startRight.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startGoalie.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartLeft = false;
            isStartMiddle = true;
            isStartRight = false;
            isStartGoalie = false;
            autoStartingPositionString = @"Middle";
        }
    }
    else if ([controller isEqual:startRight]) {
        if (isStartRight) {
            [UIView animateWithDuration:0.2 animations:^{
                startRight.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartRight = false;
            autoStartingPositionString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                startLeft.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startMiddle.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startRight.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                startGoalie.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartLeft = false;
            isStartMiddle = false;
            isStartRight = true;
            isStartGoalie = false;
            autoStartingPositionString = @"Right";
        }
    }
    else if ([controller isEqual:startGoalie]) {
        if (isStartGoalie) {
            [UIView animateWithDuration:0.2 animations:^{
                startGoalie.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isStartGoalie = false;
            autoStartingPositionString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                startLeft.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startMiddle.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startRight.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                startGoalie.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isStartLeft = false;
            isStartMiddle = false;
            isStartRight = false;
            isStartGoalie = true;
            autoStartingPositionString = @"Goalie";
        }
    }
}
-(void)hotGoalTrackingSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:hotGoalYes]){
        if (isHotGoalYes) {
            [UIView animateWithDuration:0.2 animations:^{
                hotGoalYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isHotGoalYes = false;
            hotGoalTrackingString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                hotGoalYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                hotGoalNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isHotGoalYes = true;
            isHotGoalNo = false;
            hotGoalTrackingString = @"Yes";
        }
    }
    else if ([controller isEqual:hotGoalNo]){
        if (isHotGoalNo) {
            [UIView animateWithDuration:0.2 animations:^{
                hotGoalNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isHotGoalNo = false;
            hotGoalTrackingString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                hotGoalYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                hotGoalNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isHotGoalYes = false;
            isHotGoalNo = true;
            hotGoalTrackingString = @"No";
        }
    }
}
-(void)catchingMechanismSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:catchingYes]){
        if (isCatchingYes) {
            [UIView animateWithDuration:0.2 animations:^{
                catchingYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isCatchingYes = false;
            catchingMechanismString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                catchingYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                catchingNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isCatchingYes = true;
            isCatchingNo = false;
            catchingMechanismString = @"Yes";
        }
    }
    else if ([controller isEqual:catchingNo]){
        if (isCatchingNo) {
            [UIView animateWithDuration:0.2 animations:^{
                catchingNo.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isCatchingNo = false;
            catchingMechanismString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                catchingYes.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                catchingNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isCatchingYes = false;
            isCatchingNo = true;
            catchingMechanismString = @"No";
        }
    }
}
-(void)bumperQualitySelectionTapped:(UIControl *)controller{
    if ([controller isEqual:bumperOne]){
        if (isBumperOne) {
            [UIView animateWithDuration:0.2 animations:^{
                bumperOne.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isBumperOne = false;
            bumperQualityString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                bumperOne.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                bumperThree.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                bumperFive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isBumperOne = true;
            isBumperThree = false;
            isBumperFive = false;
            bumperQualityString = @"One";
        }
    }
    else if ([controller isEqual:bumperThree]){
        if (isBumperThree) {
            [UIView animateWithDuration:0.2 animations:^{
                bumperThree.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isBumperThree = false;
            bumperQualityString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                bumperOne.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                bumperThree.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                bumperFive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isBumperOne = false;
            isBumperThree = true;
            isBumperFive = false;
            bumperQualityString = @"Three";
        }
    }
    else if ([controller isEqual:bumperFive]){
        if (isBumperFive) {
            [UIView animateWithDuration:0.2 animations:^{
                bumperFive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isBumperFive = false;
            bumperQualityString = @"";
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                bumperOne.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                bumperThree.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                bumperFive.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isBumperOne = false;
            isBumperThree = false;
            isBumperFive = true;
            bumperQualityString = @"Five";
        }
    }
}


-(void)textFieldDidChange:(UITextField *)textField{
    if ([textField isEqual:otherDriveTrain]) {
        if (otherDriveTrain.text.length > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = false;
            isOtherDriveTrain = true;
            driveTrainString = otherDriveTrain.text;
        }
        else{
            isOtherDriveTrain = false;
            driveTrainString = @"";
        }
    }
    else if ([textField isEqual:otherShooter]){
        if (otherShooter.text.length > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterNone.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterCatapult.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
                shooterPuncher.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }];
            isShooterNone = false;
            isShooterCatapult = false;
            isShooterPuncher = false;
            shooterString = otherShooter.text;
        }
        else{
            isOtherShooter = false;
            shooterString = @"";
        }
    }
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView isEqual:_additionalNotesTxtField]) {
        if ([_additionalNotesTxtField.text isEqualToString:@"Additional Notes"]) {
            _additionalNotesTxtField.text = @"";
            _additionalNotesTxtField.textColor = [UIColor blackColor];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _additionalNotesTxtField.center = CGPointMake(_additionalNotesTxtField.center.x, 700);
        } completion:^(BOOL finished) {}];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView isEqual:_additionalNotesTxtField]) {
        if ([_additionalNotesTxtField.text isEqualToString:@""]) {
            _additionalNotesTxtField.text = @"Additional Notes";
            _additionalNotesTxtField.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _additionalNotesTxtField.center = CGPointMake(_additionalNotesTxtField.center.x, 810);
        } completion:^(BOOL finished) {}];
    }
}

- (IBAction)screenTapped:(id)sender {
    [_teamNumberField resignFirstResponder];
    [_teamNameField resignFirstResponder];
    [_additionalNotesTxtField resignFirstResponder];
    [otherDriveTrain resignFirstResponder];
    [otherShooter resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


-(IBAction)saveSheetBtn:(id)sender {
    
    [self somethingSelectedInEveryRowValidator];
    
    if (!isSomethingSelectedInEveryRow) {
        UIAlertView *somethingNotSelectedAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!" message:@"Not every row has something selected in it! Please fix this!" delegate:nil cancelButtonTitle:@"Will do" otherButtonTitles:nil];
        [somethingNotSelectedAlert show];
    }
    else if (_teamNumberField.text.length == 0) {
        UIAlertView *noTeamNumAlert = [[UIAlertView alloc] initWithTitle:@"Bad Scout! No!" message:@"Please enter a team number in the top center text field. Thanks! (You're really not a bad scout, I just needed to get your attention)" delegate:nil cancelButtonTitle:@"Whoops!" otherButtonTitles:nil];
        [noTeamNumAlert show];
    }
    else{
        NSData *imageData;
        if ([_additionalNotesTxtField.text isEqualToString: @"Additional Notes"] && _additionalNotesTxtField.backgroundColor == [UIColor colorWithWhite:0.9 alpha:1.0]) {
            _additionalNotesTxtField.text = @"";
        }
        if (robotImage.image) {
            UIGraphicsBeginImageContext(CGSizeMake(320, 320));
            [robotImage.image drawInRect:CGRectMake(0,0,320,320)];
            UIImage* saveImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            robotImage.image = saveImage;
            
            imageData = UIImagePNGRepresentation(robotImage.image);
        }
        
        [context performBlock:^{
            NSDate *now = [NSDate date];
            secs = [now timeIntervalSince1970];
            
            NSDictionary *pitTeamDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithString:driveTrainString], @"driveTrain",
                                         [NSString stringWithString:shooterString], @"shooter",
                                         [NSString stringWithString:preferredGoalString], @"preferredGoal",
                                         [NSString stringWithString:goalieArmString], @"goalieArm",
                                         [NSString stringWithString:floorCollectorString], @"floorCollector",
                                         [NSString stringWithString:autonomousString], @"autonomous",
                                         [NSString stringWithString:autoStartingPositionString], @"autoStartingPosition",
                                         [NSString stringWithString:hotGoalTrackingString], @"hotGoalTracking",
                                         [NSString stringWithString:catchingMechanismString], @"catchingMechanism",
                                         [NSString stringWithString:bumperQualityString], @"bumperQuality",
                                         [NSData dataWithData:imageData], @"image",
                                         [NSString stringWithString:_teamNumberField.text], @"teamNumber",
                                         [NSString stringWithString:_teamNameField.text], @"teamName",
                                         [NSString stringWithString:_additionalNotesTxtField.text], @"notes",
                                         [NSNumber numberWithInteger:secs], @"uniqueID", nil];
            
            PitTeam *pt = [PitTeam createPitTeamWithDictionary:pitTeamDict inManagedObjectContext:context];
            
            // If the match doesn't exist
            if ([pt.uniqueID integerValue] == secs) {
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
                duplicatePitTeam = pt;
                duplicatePitTeamDict = pitTeamDict;
                [self overWriteAlert];
            }
        }];
    }
}

-(void)overWriteAlert{
    overWriteAlert = [[UIAlertView alloc] initWithTitle:@"There's a Conflict!" message:@"There is already a team saved for that team number. Do you want to overwrite it?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [overWriteAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:overWriteAlert]) {
        if (buttonIndex == 1) {
            [self overWritePitTeam];
        }
    }
}

-(void)overWritePitTeam{
    [context performBlock:^{
        [FSAdocument.managedObjectContext deleteObject:duplicatePitTeam];
        [PitTeam createPitTeamWithDictionary:duplicatePitTeamDict inManagedObjectContext:context];
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if (success) {
                [self saveSuccess];
            }
            else{
                NSLog(@"Didn't overwrite correctly");
            }
        }];
    }];
}

-(void)somethingSelectedInEveryRowValidator{
    stringsArray = @[driveTrainString, shooterString, preferredGoalString, goalieArmString, floorCollectorString, autonomousString, autoStartingPositionString, hotGoalTrackingString, catchingMechanismString, bumperQualityString];
    isSomethingSelectedInEveryRow = true;
    for (NSString *s in stringsArray) {
        if ([s isEqualToString:@""]) {
            isSomethingSelectedInEveryRow = false;
            break;
        }
    }
}

-(void)saveSuccess{
    UIAlertView *saveSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You saved the team into storage!" delegate:nil cancelButtonTitle:@"Fantastic" otherButtonTitles: nil];
    [saveSuccessAlert show];
    [UIView animateWithDuration:0.2 animations:^{
        for (UIControl *c in [self.view subviews]) {
            if ([c.backgroundColor isEqual:[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]]) {
                c.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.8];
            }
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            robotImage.alpha = 0;
            robotImageControl.layer.borderColor = [[UIColor clearColor] CGColor];
        } completion:^(BOOL finished) {
            robotImage.image = nil;
            robotImage.alpha = 1;
        }];
    }];
    _teamNumberField.text = @"";
    _teamNameField.text = @"";
    otherDriveTrain.text = @"";
    otherShooter.text = @"";
    _additionalNotesTxtField.text = @"Additional Notes";
    _additionalNotesTxtField.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    isSixEightWheelDrop = false;
    isFourWheelDrive = false;
    isMechanum = false;
    isSwerveCrab = false;
    isOtherDriveTrain = false;
    
    isShooterNone = false;
    isShooterCatapult = false;
    isShooterPuncher = false;
    isOtherShooter = false;
    
    isPreferredHigh = false;
    isPreferredLow = false;
    
    isGoalieArmYes = false;
    isGoalieArmNo = false;
    
    isFloorCollectorYes = false;
    isFloorCollectorNo = false;
    
    isAutonomousYes = false;
    isAutonomousNo = false;
    
    isStartLeft = false;
    isStartMiddle = false;
    isStartRight = false;
    isStartGoalie = false;
    
    isHotGoalYes = false;
    isHotGoalNo = false;
    
    isCatchingYes = false;
    isCatchingNo = false;
    
    isBumperOne = false;
    isBumperThree = false;
    isBumperFive = false;
    
    for (__strong NSString *s in stringsArray) {
        s = @"";
    }
    
    duplicatePitTeam = nil;
    duplicatePitTeamDict = nil;
}


@end











