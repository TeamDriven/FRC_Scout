//
//  AllianceSelection.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "AllianceSelection.h"


@interface AllianceSelection ()

@end

@implementation AllianceSelection

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSString *regionalSelected;
Regional *regionalObject;

UIView *grieayOutView;
UIView *sortersView;

UIButton *autoHighHotAvg;
UIButton *autoHighMissAvg;
UIButton *autoHighNotAvg;
UIButton *autoHighMakesAvg;
UIButton *autoHighAttemptsAvg;
UIButton *autoHighHotPercentage;
UIButton *autoHighAccuracyPercentage;
UIButton *autoLowHotAvg;
UIButton *autoLowMissAvg;
UIButton *autoLowNotAvg;
UIButton *autoLowMakesAvg;
UIButton *autoLowAttemptsAvg;
UIButton *autoLowHotPercentage;
UIButton *autoLowAccuracyPercentage;
UIButton *autoAccuracyPercentage;
UIButton *mobilityBonusPercentage;
UIButton *autonomousAvg;

UIButton *teleopHighMakeAvg;
UIButton *teleopHighMissAvg;
UIButton *teleopHighAttemptsAvg;
UIButton *teleopHighAccuracyPercentage;
UIButton *teleopLowMakeAvg;
UIButton *teleopLowMissAvg;
UIButton *teleopLowAttemptsAvg;
UIButton *teleopLowAccuracyPercentage;
UIButton *teleopAccuracyPercentage;
UIButton *teleopCatchAvg;
UIButton *teleopOverAvg;
UIButton *teleopPassedAvg;
UIButton *teleopReceivedAvg;
UIButton *teleopPassReceiveRatio;
UIButton *teleopAvg;

UIButton *totalPointsAvg;

UIButton *smallPenaltyAvg;
UIButton *largePenaltyAvg;
UIButton *penaltyTotalAvg;

UIButton *offensiveZonePercentage;
UIButton *neutralZonePercentage;
UIButton *defensiveZonePercentage;

RegionalPoolCDTVC *regionalPoolCDTVC;

FirstPickListController *firstPickListController;
SecondPickListController *secondPickListController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _poolTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _poolTableView.layer.borderWidth = 1;
    _poolTableView.layer.cornerRadius = 5;
    _poolTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _firstPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _firstPickTableView.layer.borderWidth = 1;
    _firstPickTableView.layer.cornerRadius = 5;
    _firstPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _secondPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _secondPickTableView.layer.borderWidth = 1;
    _secondPickTableView.layer.cornerRadius = 5;
    _secondPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _sortDownArrow.alpha = 0.3;
    [_sortUpArrow setImage:[UIImage imageNamed:@"BlueSortArrowUp"] forState:UIControlStateNormal];
    
    _sortProperty.titleLabel.numberOfLines = 1;
    _sortProperty.titleLabel.adjustsFontSizeToFitWidth = YES;
    _sortProperty.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    _sortBox.backgroundColor = [UIColor whiteColor];
    _sortBox.layer.cornerRadius = 5;
    _sortBox.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _sortBox.layer.borderWidth = 1;
    
}

-(void)viewWillAppear:(BOOL)animated{
    regionalPoolCDTVC = [[RegionalPoolCDTVC alloc] init];
    [regionalPoolCDTVC setSortAttribute:@"totalPointsAvg"];
    [regionalPoolCDTVC setRegionalToDisplay:regionalSelected];
    [regionalPoolCDTVC setManagedObjectContext:context];
    _poolTableView.delegate = regionalPoolCDTVC;
    _poolTableView.dataSource = regionalPoolCDTVC;
    
    regionalPoolCDTVC.tableView = _poolTableView;
    
    [regionalPoolCDTVC performFetch];
    
    
    NSFetchRequest *regionalFetch = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    regionalFetch.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionalSelected];
    
    NSError *regionalError;
    regionalObject = [[context executeFetchRequest:regionalFetch error:&regionalError] firstObject];
    
    NSArray *firstPickArray = [regionalObject.firstPickList array];
    NSArray *secondPickArray = [regionalObject.secondPickList array];
    
    firstPickListController = [[FirstPickListController alloc] init];
    [firstPickListController setFirstPickList:firstPickArray];
    _firstPickTableView.delegate = firstPickListController;
    _firstPickTableView.dataSource = firstPickListController;
    firstPickListController.tableView = _firstPickTableView;
    
    [regionalPoolCDTVC setFirstPickListController:firstPickListController];
    
    secondPickListController = [[SecondPickListController alloc] init];
    [secondPickListController setSecondPickList:secondPickArray];
    _secondPickTableView.delegate = secondPickListController;
    _secondPickTableView.dataSource = secondPickListController;
    secondPickListController.tableView = _secondPickTableView;
    
    [regionalPoolCDTVC setSecondPickListController:secondPickListController];
}

-(void)viewWillDisappear:(BOOL)animated{
    regionalObject.firstPickList = [NSOrderedSet orderedSetWithArray:firstPickListController.firstPickList];
    regionalObject.secondPickList = [NSOrderedSet orderedSetWithArray:secondPickListController.secondPickList];
    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved correctly on exit");
        }
        else{
            NSLog(@"Didn't save correctly");
        }
    }];
}


- (IBAction)reorderFirstPickList:(id)sender {
    if ([_firstPickTableView numberOfRowsInSection:0] > 0) {
        if (_firstPickTableView.isEditing) {
            [_firstPickTableView setEditing:NO animated:YES];
        }
        else{
            [_firstPickTableView setEditing:YES animated:YES];
        }
    }
}

- (IBAction)reorderSecondPickList:(id)sender {
    if ([_secondPickTableView numberOfRowsInSection:0] > 0) {
        if (_secondPickTableView.isEditing) {
            [_secondPickTableView setEditing:NO animated:YES];
        }
        else{
            [_secondPickTableView setEditing:YES animated:YES];
        }
    }
}

- (IBAction)sortChange:(id)sender {
    grieayOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grieayOutView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:grieayOutView];
    
    sortersView = [[UIView alloc] initWithFrame:CGRectMake(159, 150, 450, 600)];
    sortersView.backgroundColor = [UIColor whiteColor];
    sortersView.layer.cornerRadius = 10;
    [grieayOutView addSubview:sortersView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(390, 0, 55, 30);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeSorterView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    UILabel *sortersViewTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 20)];
    sortersViewTitleLbl.text = @"Select a Sorter";
    sortersViewTitleLbl.font = [UIFont boldSystemFontOfSize:17];
    sortersViewTitleLbl.textAlignment = NSTextAlignmentCenter;
    
    UIView *autonomousBox = [[UIView alloc] initWithFrame:CGRectMake(15, 40, 420, 200)];
    autonomousBox.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:0.3];
    autonomousBox.layer.cornerRadius = 5;
    
    UILabel *autonomousBoxTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 100, 15)];
    autonomousBoxTitleLbl.text = @"Autonomous";
    autonomousBoxTitleLbl.textAlignment = NSTextAlignmentCenter;
    autonomousBoxTitleLbl.font = [UIFont systemFontOfSize:13];
    [autonomousBox addSubview:autonomousBoxTitleLbl];
    
    NSInteger buttonSeparationX = 10;
    NSInteger buttonSeparationY = 5;
    
    autoHighHotAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighHotAvg.frame = CGRectMake(10, 20, 90, 30);
    [autoHighHotAvg setTitle:@"High Hot Avg" forState:UIControlStateNormal];
    autoHighHotAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighHotAvg addTarget:self action:@selector(sortAutoHighHotAvg) forControlEvents:UIControlEventTouchUpInside];
    autoHighHotAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighHotAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighHotAvg];
    
    autoHighMissAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighMissAvg.frame = CGRectMake(autoHighHotAvg.frame.origin.x + autoHighHotAvg.frame.size.width +buttonSeparationX, autoHighHotAvg.frame.origin.y, 90, 30);
    [autoHighMissAvg setTitle:@"High Miss Avg" forState:UIControlStateNormal];
    autoHighMissAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighMissAvg addTarget:self action:@selector(sortAutoHighMissAvg) forControlEvents:UIControlEventTouchUpInside];
    autoHighMissAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighMissAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighMissAvg];
    
    autoHighNotAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighNotAvg.frame = CGRectMake(autoHighMissAvg.frame.origin.x + autoHighMissAvg.frame.size.width +buttonSeparationX, autoHighHotAvg.frame.origin.y, 90, 30);
    [autoHighNotAvg setTitle:@"High Not Avg" forState:UIControlStateNormal];
    autoHighNotAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighNotAvg addTarget:self action:@selector(sortAutoHighNotAvg) forControlEvents:UIControlEventTouchUpInside];
    autoHighNotAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighNotAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighNotAvg];
    
    autoHighMakesAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighMakesAvg.frame = CGRectMake(autoHighNotAvg.frame.origin.x + autoHighNotAvg.frame.size.width +buttonSeparationX, autoHighHotAvg.frame.origin.y, 100, 30);
    [autoHighMakesAvg setTitle:@"High Makes Avg" forState:UIControlStateNormal];
    autoHighMakesAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighMakesAvg addTarget:self action:@selector(sortAutoHighMakesAvg) forControlEvents:UIControlEventTouchUpInside];
    autoHighMakesAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [autonomousBox addSubview:autoHighMakesAvg];
    
    autoHighAttemptsAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighAttemptsAvg.frame = CGRectMake(15, autoHighHotAvg.frame.origin.y + autoHighHotAvg.frame.size.height + buttonSeparationY, 120, 30);
    [autoHighAttemptsAvg setTitle:@"High Attempts Avg" forState:UIControlStateNormal];
    autoHighAttemptsAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighAttemptsAvg addTarget:self action:@selector(sortAutoHighAttemptsAvg) forControlEvents:UIControlEventTouchUpInside];
    autoHighAttemptsAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighAttemptsAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighAttemptsAvg];
    
    autoHighHotPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighHotPercentage.frame = CGRectMake(autoHighAttemptsAvg.frame.origin.x + autoHighAttemptsAvg.frame.size.width +buttonSeparationX, autoHighAttemptsAvg.frame.origin.y, 105, 30);
    [autoHighHotPercentage setTitle:@"High Hot Percent" forState:UIControlStateNormal];
    autoHighHotPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighHotPercentage addTarget:self action:@selector(sortAutoHighHotPercentage) forControlEvents:UIControlEventTouchUpInside];
    autoHighHotPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighHotPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighHotPercentage];
    
    autoHighAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    autoHighAccuracyPercentage.frame = CGRectMake(autoHighHotPercentage.frame.origin.x + autoHighHotPercentage.frame.size.width +buttonSeparationX, autoHighAttemptsAvg.frame.origin.y, 145, 30);
    [autoHighAccuracyPercentage setTitle:@"High Accuracy Percent" forState:UIControlStateNormal];
    autoHighAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoHighAccuracyPercentage addTarget:self action:@selector(sortAutoHighAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    autoHighAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoHighAccuracyPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoHighAccuracyPercentage];
    
    autoLowHotAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowHotAvg.frame = CGRectMake(10, autoHighAttemptsAvg.frame.origin.y + autoHighAttemptsAvg.frame.size.height + buttonSeparationY, 90, 30);
    [autoLowHotAvg setTitle:@"Low Hot Avg" forState:UIControlStateNormal];
    autoLowHotAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowHotAvg addTarget:self action:@selector(sortAutoLowHotAvg) forControlEvents:UIControlEventTouchUpInside];
    autoLowHotAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowHotAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowHotAvg];
    
    autoLowMissAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowMissAvg.frame = CGRectMake(autoLowHotAvg.frame.origin.x + autoLowHotAvg.frame.size.width +buttonSeparationX, autoLowHotAvg.frame.origin.y, 90, 30);
    [autoLowMissAvg setTitle:@"Low Miss Avg" forState:UIControlStateNormal];
    autoLowMissAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowMissAvg addTarget:self action:@selector(sortAutoLowMissAvg) forControlEvents:UIControlEventTouchUpInside];
    autoLowMissAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowMissAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowMissAvg];
    
    autoLowNotAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowNotAvg.frame = CGRectMake(autoLowMissAvg.frame.origin.x + autoLowMissAvg.frame.size.width +buttonSeparationX, autoLowHotAvg.frame.origin.y, 90, 30);
    [autoLowNotAvg setTitle:@"Low Not Avg" forState:UIControlStateNormal];
    autoLowNotAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowNotAvg addTarget:self action:@selector(sortAutoLowNotAvg) forControlEvents:UIControlEventTouchUpInside];
    autoLowNotAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowNotAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowNotAvg];
    
    autoLowMakesAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowMakesAvg.frame = CGRectMake(autoLowNotAvg.frame.origin.x + autoLowNotAvg.frame.size.width +buttonSeparationX, autoLowHotAvg.frame.origin.y, 100, 30);
    [autoLowMakesAvg setTitle:@"Low Makes Avg" forState:UIControlStateNormal];
    autoLowMakesAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowMakesAvg addTarget:self action:@selector(sortAutoLowMakesAvg) forControlEvents:UIControlEventTouchUpInside];
    autoLowMakesAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowMakesAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowMakesAvg];
    
    autoLowAttemptsAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowAttemptsAvg.frame = CGRectMake(15, autoLowHotAvg.frame.origin.y + autoLowHotAvg.frame.size.height + buttonSeparationY, 120, 30);
    [autoLowAttemptsAvg setTitle:@"Low Attempts Avg" forState:UIControlStateNormal];
    autoLowAttemptsAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowAttemptsAvg addTarget:self action:@selector(sortAutoLowAttemptsAvg) forControlEvents:UIControlEventTouchUpInside];
    autoLowAttemptsAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowAttemptsAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowAttemptsAvg];
    
    autoLowHotPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowHotPercentage.frame = CGRectMake(autoLowAttemptsAvg.frame.origin.x + autoLowAttemptsAvg.frame.size.width +buttonSeparationX, autoLowAttemptsAvg.frame.origin.y, 105, 30);
    [autoLowHotPercentage setTitle:@"Low Hot Percent" forState:UIControlStateNormal];
    autoLowHotPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowHotPercentage addTarget:self action:@selector(sortAutoLowHotPercentage) forControlEvents:UIControlEventTouchUpInside];
    autoLowHotPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowHotPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowHotPercentage];
    
    autoLowAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    autoLowAccuracyPercentage.frame = CGRectMake(autoLowHotPercentage.frame.origin.x + autoLowHotPercentage.frame.size.width +buttonSeparationX, autoLowAttemptsAvg.frame.origin.y, 145, 30);
    [autoLowAccuracyPercentage setTitle:@"Low Accuracy Percent" forState:UIControlStateNormal];
    autoLowAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoLowAccuracyPercentage addTarget:self action:@selector(sortAutoLowAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    autoLowAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoLowAccuracyPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoLowAccuracyPercentage];
    
    autoAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    autoAccuracyPercentage.frame = CGRectMake(10, autoLowAccuracyPercentage.frame.origin.y + autoLowAccuracyPercentage.frame.size.height + buttonSeparationY, 140, 30);
    [autoAccuracyPercentage setTitle:@"Accuracy Percentage" forState:UIControlStateNormal];
    autoAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [autoAccuracyPercentage addTarget:self action:@selector(sortAutoAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    autoAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autoAccuracyPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:autoAccuracyPercentage];
    
    mobilityBonusPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    mobilityBonusPercentage.frame = CGRectMake(autoAccuracyPercentage.frame.origin.x + autoAccuracyPercentage.frame.size.width + buttonSeparationX, autoAccuracyPercentage.frame.origin.y, 180, 30);
    [mobilityBonusPercentage setTitle:@"Mobility Success Percentage" forState:UIControlStateNormal];
    mobilityBonusPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [mobilityBonusPercentage addTarget:self action:@selector(sortMobilityBonusPercentage) forControlEvents:UIControlEventTouchUpInside];
    mobilityBonusPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    mobilityBonusPercentage.layer.cornerRadius = 5;
    [autonomousBox addSubview:mobilityBonusPercentage];
    
    autonomousAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    autonomousAvg.frame = CGRectMake(mobilityBonusPercentage.frame.origin.x + mobilityBonusPercentage.frame.size.width +buttonSeparationX, mobilityBonusPercentage.frame.origin.y, 60, 30);
    [autonomousAvg setTitle:@"Total Avg" forState:UIControlStateNormal];
    autonomousAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [autonomousAvg addTarget:self action:@selector(sortAutonomousAvg) forControlEvents:UIControlEventTouchUpInside];
    autonomousAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    autonomousAvg.layer.cornerRadius = 5;
    [autonomousBox addSubview:autonomousAvg];
    
    UIView *teleopBox = [[UIView alloc] initWithFrame:CGRectMake(15, 260, 420, 200)];
    teleopBox.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:0.3];
    teleopBox.layer.cornerRadius = 5;
    
    UILabel *teleopBoxTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 100, 15)];
    teleopBoxTitleLbl.text = @"Teleop";
    teleopBoxTitleLbl.textAlignment = NSTextAlignmentCenter;
    teleopBoxTitleLbl.font = [UIFont systemFontOfSize:13];
    [teleopBox addSubview:teleopBoxTitleLbl];
    
    teleopHighMakeAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopHighMakeAvg.frame = CGRectMake(40, 20, 100, 30);
    [teleopHighMakeAvg setTitle:@"High Make Avg" forState:UIControlStateNormal];
    teleopHighMakeAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopHighMakeAvg addTarget:self action:@selector(sortTeleopHighMakeAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopHighMakeAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopHighMakeAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopHighMakeAvg];
    
    teleopHighMissAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopHighMissAvg.frame = CGRectMake(teleopHighMakeAvg.frame.origin.x + teleopHighMakeAvg.frame.size.width +buttonSeparationX, teleopHighMakeAvg.frame.origin.y, 100, 30);
    [teleopHighMissAvg setTitle:@"High Miss Avg" forState:UIControlStateNormal];
    teleopHighMissAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopHighMissAvg addTarget:self action:@selector(sortTeleopHighMissAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopHighMissAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopHighMissAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopHighMissAvg];
    
    teleopHighAttemptsAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopHighAttemptsAvg.frame = CGRectMake(teleopHighMissAvg.frame.origin.x + teleopHighMissAvg.frame.size.width +buttonSeparationX, teleopHighMakeAvg.frame.origin.y, 120, 30);
    [teleopHighAttemptsAvg setTitle:@"High Attempts Avg" forState:UIControlStateNormal];
    teleopHighAttemptsAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopHighAttemptsAvg addTarget:self action:@selector(sortTeleopHighAttemptsAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopHighAttemptsAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopHighAttemptsAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopHighAttemptsAvg];
    
    teleopHighAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopHighAccuracyPercentage.frame = CGRectMake(25, teleopHighMakeAvg.frame.origin.y + teleopHighMakeAvg.frame.size.height + buttonSeparationY, 150, 30);
    [teleopHighAccuracyPercentage setTitle:@"High Accuracy Percent" forState:UIControlStateNormal];
    teleopHighAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopHighAccuracyPercentage addTarget:self action:@selector(sortTeleopHighAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    teleopHighAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopHighAccuracyPercentage.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopHighAccuracyPercentage];
    
    teleopLowMakeAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopLowMakeAvg.frame = CGRectMake(teleopHighAccuracyPercentage.frame.origin.x + teleopHighAccuracyPercentage.frame.size.width + buttonSeparationX, teleopHighAccuracyPercentage.frame.origin.y, 100, 30);
    [teleopLowMakeAvg setTitle:@"Low Make Avg" forState:UIControlStateNormal];
    teleopLowMakeAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopLowMakeAvg addTarget:self action:@selector(sortTeleopLowMakeAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopLowMakeAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopLowMakeAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopLowMakeAvg];
    
    teleopLowMissAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopLowMissAvg.frame = CGRectMake(teleopLowMakeAvg.frame.origin.x + teleopLowMakeAvg.frame.size.width + buttonSeparationX, teleopHighAccuracyPercentage.frame.origin.y, 100, 30);
    [teleopLowMissAvg setTitle:@"Low Miss Avg" forState:UIControlStateNormal];
    teleopLowMissAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopLowMissAvg addTarget:self action:@selector(sortTeleopLowMissAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopLowMissAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopLowMissAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopLowMissAvg];
    
    teleopLowAttemptsAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopLowAttemptsAvg.frame = CGRectMake(70, teleopHighAccuracyPercentage.frame.origin.y + teleopHighAccuracyPercentage.frame.size.height + buttonSeparationY, 120, 30);
    [teleopLowAttemptsAvg setTitle:@"Low Attempts Avg" forState:UIControlStateNormal];
    teleopLowAttemptsAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopLowAttemptsAvg addTarget:self action:@selector(sortTeleopLowAttemptsAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopLowAttemptsAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopLowAttemptsAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopLowAttemptsAvg];
    
    teleopLowAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopLowAccuracyPercentage.frame = CGRectMake(teleopLowAttemptsAvg.frame.origin.x + teleopLowAttemptsAvg.frame.size.width + buttonSeparationX, teleopLowAttemptsAvg.frame.origin.y, 150, 30);
    [teleopLowAccuracyPercentage setTitle:@"Low Accuracy Percent" forState:UIControlStateNormal];
    teleopLowAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopLowAccuracyPercentage addTarget:self action:@selector(sortTeleopLowAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    teleopLowAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopLowAccuracyPercentage.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopLowAccuracyPercentage];
    
    teleopAccuracyPercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopAccuracyPercentage.frame = CGRectMake(40, teleopLowAttemptsAvg.frame.origin.y + teleopLowAttemptsAvg.frame.size.height + buttonSeparationY, 150, 30);
    [teleopAccuracyPercentage setTitle:@"Total Accuracy Percent" forState:UIControlStateNormal];
    teleopAccuracyPercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopAccuracyPercentage addTarget:self action:@selector(sortTeleopAccuracyPercentage) forControlEvents:UIControlEventTouchUpInside];
    teleopAccuracyPercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopAccuracyPercentage.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopAccuracyPercentage];
    
    teleopCatchAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopCatchAvg.frame = CGRectMake(teleopAccuracyPercentage.frame.origin.x + teleopAccuracyPercentage.frame.size.width + buttonSeparationX, teleopAccuracyPercentage.frame.origin.y, 70, 30);
    [teleopCatchAvg setTitle:@"Catch Avg" forState:UIControlStateNormal];
    teleopCatchAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopCatchAvg addTarget:self action:@selector(sortTeleopCatchAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopCatchAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopCatchAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopCatchAvg];
    
    teleopOverAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopOverAvg.frame = CGRectMake(teleopCatchAvg.frame.origin.x + teleopCatchAvg.frame.size.width + buttonSeparationX, teleopAccuracyPercentage.frame.origin.y, 100, 30);
    [teleopOverAvg setTitle:@"Over Truss Avg" forState:UIControlStateNormal];
    teleopOverAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopOverAvg addTarget:self action:@selector(sortTeleopOverAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopOverAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopOverAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopOverAvg];
    
    teleopPassedAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopPassedAvg.frame = CGRectMake(20, teleopAccuracyPercentage.frame.origin.y + teleopAccuracyPercentage.frame.size.height + buttonSeparationY, 70, 30);
    [teleopPassedAvg setTitle:@"Pass Avg" forState:UIControlStateNormal];
    teleopPassedAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopPassedAvg addTarget:self action:@selector(sortTeleopPassedAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopPassedAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopPassedAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopPassedAvg];
    
    teleopReceivedAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopReceivedAvg.frame = CGRectMake(teleopPassedAvg.frame.origin.x + teleopPassedAvg.frame.size.width + buttonSeparationX, teleopPassedAvg.frame.origin.y, 90, 30);
    [teleopReceivedAvg setTitle:@"Receive Avg" forState:UIControlStateNormal];
    teleopReceivedAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopReceivedAvg addTarget:self action:@selector(sortTeleopReceivedAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopReceivedAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopReceivedAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopReceivedAvg];
    
    teleopPassReceiveRatio = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopPassReceiveRatio.frame = CGRectMake(teleopReceivedAvg.frame.origin.x + teleopReceivedAvg.frame.size.width + buttonSeparationX, teleopPassedAvg.frame.origin.y, 120, 30);
    [teleopPassReceiveRatio setTitle:@"Pass/Receive Ratio" forState:UIControlStateNormal];
    teleopPassReceiveRatio.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopPassReceiveRatio addTarget:self action:@selector(sortTeleopPassReceiveRatio) forControlEvents:UIControlEventTouchUpInside];
    teleopPassReceiveRatio.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopPassReceiveRatio.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopPassReceiveRatio];
    
    teleopAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    teleopAvg.frame = CGRectMake(teleopPassReceiveRatio.frame.origin.x + teleopPassReceiveRatio.frame.size.width + buttonSeparationX, teleopPassedAvg.frame.origin.y, 70, 30);
    [teleopAvg setTitle:@"Total Avg" forState:UIControlStateNormal];
    teleopAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [teleopAvg addTarget:self action:@selector(sortTeleopAvg) forControlEvents:UIControlEventTouchUpInside];
    teleopAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    teleopAvg.layer.cornerRadius = 5;
    [teleopBox addSubview:teleopAvg];
    
    UILabel *otherLbl = [[UILabel alloc] initWithFrame:CGRectMake(175, 470, 100, 15)];
    otherLbl.text = @"Other";
    otherLbl.font = [UIFont systemFontOfSize:13];
    otherLbl.textAlignment = NSTextAlignmentCenter;
    
    smallPenaltyAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    smallPenaltyAvg.frame = CGRectMake(40, 485, 120, 30);
    [smallPenaltyAvg setTitle:@"Small Penalty Avg" forState:UIControlStateNormal];
    smallPenaltyAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [smallPenaltyAvg addTarget:self action:@selector(sortSmallPenaltyAvg) forControlEvents:UIControlEventTouchUpInside];
    smallPenaltyAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    smallPenaltyAvg.layer.cornerRadius = 5;
    
    largePenaltyAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    largePenaltyAvg.frame = CGRectMake(smallPenaltyAvg.frame.origin.x + smallPenaltyAvg.frame.size.width + buttonSeparationX, smallPenaltyAvg.frame.origin.y, 120, 30);
    [largePenaltyAvg setTitle:@"Large Penalty Avg" forState:UIControlStateNormal];
    largePenaltyAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [largePenaltyAvg addTarget:self action:@selector(sortLargePenaltyAvg) forControlEvents:UIControlEventTouchUpInside];
    largePenaltyAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    largePenaltyAvg.layer.cornerRadius = 5;
    
    penaltyTotalAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    penaltyTotalAvg.frame = CGRectMake(largePenaltyAvg.frame.origin.x + largePenaltyAvg.frame.size.width + buttonSeparationX, smallPenaltyAvg.frame.origin.y, 110, 30);
    [penaltyTotalAvg setTitle:@"Total Penalty Avg" forState:UIControlStateNormal];
    penaltyTotalAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [penaltyTotalAvg addTarget:self action:@selector(sortPenaltyTotalAvg) forControlEvents:UIControlEventTouchUpInside];
    penaltyTotalAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    penaltyTotalAvg.layer.cornerRadius = 5;
    
    offensiveZonePercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    offensiveZonePercentage.frame = CGRectMake(25, smallPenaltyAvg.frame.origin.y + smallPenaltyAvg.frame.size.height + buttonSeparationY, 130, 30);
    [offensiveZonePercentage setTitle:@"Offensive Tendency" forState:UIControlStateNormal];
    offensiveZonePercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [offensiveZonePercentage addTarget:self action:@selector(sortOffensiveZonePercentage) forControlEvents:UIControlEventTouchUpInside];
    offensiveZonePercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    offensiveZonePercentage.layer.cornerRadius = 5;
    
    neutralZonePercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    neutralZonePercentage.frame = CGRectMake(offensiveZonePercentage.frame.origin.x + offensiveZonePercentage.frame.size.width + buttonSeparationX, offensiveZonePercentage.frame.origin.y, 120, 30);
    [neutralZonePercentage setTitle:@"Neutral Tendency" forState:UIControlStateNormal];
    neutralZonePercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [neutralZonePercentage addTarget:self action:@selector(sortNeutralZonePercentage) forControlEvents:UIControlEventTouchUpInside];
    neutralZonePercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    neutralZonePercentage.layer.cornerRadius = 5;
    
    defensiveZonePercentage = [UIButton buttonWithType:UIButtonTypeSystem];
    defensiveZonePercentage.frame = CGRectMake(neutralZonePercentage.frame.origin.x + neutralZonePercentage.frame.size.width + buttonSeparationX, offensiveZonePercentage.frame.origin.y, 130, 30);
    [defensiveZonePercentage setTitle:@"Defensive Tendency" forState:UIControlStateNormal];
    defensiveZonePercentage.titleLabel.font = [UIFont systemFontOfSize:13];
    [defensiveZonePercentage addTarget:self action:@selector(sortDefensiveZonePercentage) forControlEvents:UIControlEventTouchUpInside];
    defensiveZonePercentage.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    defensiveZonePercentage.layer.cornerRadius = 5;
    
    totalPointsAvg = [UIButton buttonWithType:UIButtonTypeSystem];
    totalPointsAvg.frame = CGRectMake(160, offensiveZonePercentage.frame.origin.y + offensiveZonePercentage.frame.size.height + buttonSeparationY, 130, 30);
    [totalPointsAvg setTitle:@"Total Points Avg" forState:UIControlStateNormal];
    totalPointsAvg.titleLabel.font = [UIFont systemFontOfSize:13];
    [totalPointsAvg addTarget:self action:@selector(sortTotalPointsAvg) forControlEvents:UIControlEventTouchUpInside];
    totalPointsAvg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    totalPointsAvg.layer.cornerRadius = 5;
    
    sortersView.frame = CGRectMake(628, 101, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        sortersView.frame = CGRectMake(159, 150, 450, 600);
    } completion:^(BOOL finished) {
        [sortersView addSubview:closeButton];
        [sortersView addSubview:sortersViewTitleLbl];
        [sortersView addSubview:autonomousBox];
        [sortersView addSubview:teleopBox];
        [sortersView addSubview:otherLbl];
        [sortersView addSubview:smallPenaltyAvg];
        [sortersView addSubview:largePenaltyAvg];
        [sortersView addSubview:penaltyTotalAvg];
        [sortersView addSubview:offensiveZonePercentage];
        [sortersView addSubview:neutralZonePercentage];
        [sortersView addSubview:defensiveZonePercentage];
        [sortersView addSubview:totalPointsAvg];
    }];
}

-(void)closeSorterView{
    for (UIView *v in sortersView.subviews) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        sortersView.frame = CGRectMake(628, 101, 1, 1);
    } completion:^(BOOL finished) {
        [sortersView removeFromSuperview];
        [grieayOutView removeFromSuperview];
    }];
}

- (IBAction)sortUp:(id)sender {
    _sortUpArrow.alpha = 1;
    [_sortUpArrow setImage:[UIImage imageNamed:@"BlueSortArrowUp"] forState:UIControlStateNormal];
    _sortDownArrow.alpha = 0.3;
    [_sortDownArrow setImage:[UIImage imageNamed:@"BlackSortArrowDown"] forState:UIControlStateNormal];
    [regionalPoolCDTVC sortOrderLargeFirst];
}

- (IBAction)sortDown:(id)sender {
    _sortUpArrow.alpha = 0.3;
    [_sortUpArrow setImage:[UIImage imageNamed:@"BlackSortArrowUp"] forState:UIControlStateNormal];
    _sortDownArrow.alpha = 1;
    [_sortDownArrow setImage:[UIImage imageNamed:@"BlueSortArrowDown"] forState:UIControlStateNormal];
    [regionalPoolCDTVC sortOrderSmallFirst];
}

-(void)sortAutoHighHotAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoHighHotAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Hot Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighMissAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoHighMissAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Miss Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighNotAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoHighNotAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Not Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighMakesAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoHighMakesAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Makes Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighAttemptsAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoHighAttemptsAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Attempts Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighHotPercentage{
    [regionalPoolCDTVC setSortAttribute:@"autoHighHotPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Hot Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoHighAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"autoHighAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto High Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowHotAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoLowHotAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Hot Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowMissAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoLowMissAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Miss Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowNotAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoLowNotAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Not Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowMakesAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoLowMakesAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Makes Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowAttemptsAvg{
    [regionalPoolCDTVC setSortAttribute:@"autoLowAttemptsAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Attempts Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowHotPercentage{
    [regionalPoolCDTVC setSortAttribute:@"autoLowHotPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Hot Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoLowAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"autoLowAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Low Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutoAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"autoAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortMobilityBonusPercentage{
    [regionalPoolCDTVC setSortAttribute:@"mobilityBonusPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Mobility Success Percentage" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortAutonomousAvg{
    [regionalPoolCDTVC setSortAttribute:@"autonomousAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Auto Total Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}

-(void)sortTeleopHighMakeAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopHighMakeAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop High Make Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopHighMissAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopHighMissAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop High Miss Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopHighAttemptsAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopHighAttemptsAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop High Attempts" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopHighAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"teleopHighAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop High Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopLowMakeAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopLowMakeAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Low Make Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopLowMissAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopLowMissAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Low Miss Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopLowAttemptsAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopLowAttemptsAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Low Attempts Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopLowAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"teleopLowAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Low Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopAccuracyPercentage{
    [regionalPoolCDTVC setSortAttribute:@"teleopAccuracyPercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Accuracy Percent" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopCatchAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopCatchAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Catch Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopOverAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopOverAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Over Truss Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopPassedAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopPassedAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Passes Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopReceivedAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopReceivedAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Receives Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopPassReceiveRatio{
    [regionalPoolCDTVC setSortAttribute:@"teleopPassReceiveRatio"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Pass Receive Ratio" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortTeleopAvg{
    [regionalPoolCDTVC setSortAttribute:@"teleopAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Teleop Total Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}

-(void)sortTotalPointsAvg{
    [regionalPoolCDTVC setSortAttribute:@"totalPointsAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Total Points Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}

-(void)sortSmallPenaltyAvg{
    [regionalPoolCDTVC setSortAttribute:@"smallPenaltyAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Small Penalty Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortLargePenaltyAvg{
    [regionalPoolCDTVC setSortAttribute:@"largePenaltyAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Large Penalty Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortPenaltyTotalAvg{
    [regionalPoolCDTVC setSortAttribute:@"penaltyTotalAvg"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Total Penalty Avg" forState:UIControlStateNormal];
    [self closeSorterView];
}

-(void)sortOffensiveZonePercentage{
    [regionalPoolCDTVC setSortAttribute:@"offensiveZonePercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Offensive Zone Tendency" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortNeutralZonePercentage{
    [regionalPoolCDTVC setSortAttribute:@"neutralZonePercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Neutral Zone Tendency" forState:UIControlStateNormal];
    [self closeSorterView];
}
-(void)sortDefensiveZonePercentage{
    [regionalPoolCDTVC setSortAttribute:@"defensiveZonePercentage"];
    [self sortUp:self];
    [_sortProperty setTitle:@"Defensive Zone Tendency" forState:UIControlStateNormal];
    [self closeSorterView];
}

@end











