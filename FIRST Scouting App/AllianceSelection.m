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
    
    _sortProperty.titleLabel.numberOfLines = 1;
    _sortProperty.titleLabel.adjustsFontSizeToFitWidth = YES;
    _sortProperty.titleLabel.lineBreakMode = NSLineBreakByClipping;
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


- (IBAction)reorderSecondPickList:(id)sender {
    if (_secondPickTableView.isEditing) {
        [_secondPickTableView setEditing:NO animated:YES];
    }
    else{
        [_secondPickTableView setEditing:YES animated:YES];
    }
}

- (IBAction)reorderFirstPickList:(id)sender {
    if (_firstPickTableView.isEditing) {
        [_firstPickTableView setEditing:NO animated:YES];
    }
    else{
        [_firstPickTableView setEditing:YES animated:YES];
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
    
    UIView *autonomousBox = [[UIView alloc] initWithFrame:CGRectMake(15, 40, 210, 200)];
    autonomousBox.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:0.3];
    autonomousBox.layer.cornerRadius = 5;
    
//    autoHighHotAvg = [UIButton buttonWithType:UIButtonTypeSystem];
//    autoHighHotAvg.frame = CGRectMake(15, 30, <#CGFloat width#>, <#CGFloat height#>)
    
    UIView *teleopBox = [[UIView alloc] initWithFrame:CGRectMake(15, 260, 210, 320)];
    teleopBox.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:0.3];
    teleopBox.layer.cornerRadius = 5;
    
    
    
    sortersView.frame = CGRectMake(_sortProperty.center.x, _sortProperty.center.y, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        sortersView.frame = CGRectMake(159, 150, 450, 600);
    } completion:^(BOOL finished) {
        [sortersView addSubview:closeButton];
        [sortersView addSubview:autonomousBox];
        [sortersView addSubview:teleopBox];
    }];
}

-(void)closeSorterView{
    for (UIView *v in sortersView.subviews) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        sortersView.frame = CGRectMake(_sortProperty.center.x, _sortProperty.center.y, 1, 1);
    } completion:^(BOOL finished) {
        [sortersView removeFromSuperview];
        [grieayOutView removeFromSuperview];
    }];
}

- (IBAction)sortUp:(id)sender {
    _sortUpArrow.alpha = 1;
    _sortDownArrow.alpha = 0.3;
    [regionalPoolCDTVC sortOrderLargeFirst];
}

- (IBAction)sortDown:(id)sender {
    _sortUpArrow.alpha = 0.3;
    _sortDownArrow.alpha = 1;
    [regionalPoolCDTVC sortOrderSmallFirst];
}

-(void)sortAutoHighHotAvg{
    
}
-(void)sortAutoHighMissAvg{
    
}
-(void)sortAutoHighNotAvg{
    
}
-(void)sortAutoHighMakesAvg{
    
}
-(void)sortAutoHighAttemptsAvg{
    
}
-(void)sortAutoHighHotPercentage{
    
}
-(void)sortAutoHighAccuracyPercentage{
    
}
-(void)sortAutoLowHotAvg{
    
}
-(void)sortAutoLowMissAvg{
    
}
-(void)sortAutoLowNotAvg{
    
}
-(void)sortAutoLowMakesAvg{
    
}
-(void)sortAutoLowAttemptsAvg{
    
}
-(void)sortAutoLowHotPercentage{
    
}
-(void)sortAutoLowAccuracyPercentage{
    
}
-(void)sortAutoAccuracyPercentage{
    
}
-(void)sortMobilityBonusPercentage{
    
}
-(void)sortAutonomousAvg{
    
}

-(void)sortTeleopHighMakeAvg{
    
}
-(void)sortTeleopHighMissAvg{
    
}
-(void)sortTeleopHighAttemptsAvg{
    
}
-(void)sortTeleopHighAccuracyPercentage{
    
}
-(void)sortTeleopLowMakeAvg{
    
}
-(void)sortTeleopLowMissAvg{
    
}
-(void)sortTeleopLowAttemptsAvg{
    
}
-(void)sortTeleopLowAccuracyPercentage{
    
}
-(void)sortTeleopAccuracyPercentage{
    
}
-(void)sortTeleopCatchAvg{
    
}
-(void)sortTeleopOverAvg{
    
}
-(void)sortTeleopPassedAvg{
    
}
-(void)sortTeleopReceivedAvg{
    
}
-(void)sortTeleopPassReceiveRatio{
    
}
-(void)sortTeleopAvg{
    
}

-(void)sortsmallPenaltyAvg{
    
}
-(void)sortlargePenaltyAvg{
    
}
-(void)sortpenaltyTotalAvg{
    
}

-(void)sortoffensiveZonePercentage{
    
}
-(void)sortneutralZonePercentage{
    
}
-(void)sortdefensiveZonePercentage{
    
}

@end











