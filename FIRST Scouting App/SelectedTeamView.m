//
//  SelectedTeamView.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SelectedTeamView.h"
#import "Globals.h"
#import "MasterTeam.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"
#import "PitTeam.h"
#import "SelectedTeamCDTVC.h"

@interface SelectedTeamView ()

@end

@implementation SelectedTeamView

NSString *teamNumber;
NSString *teamName;

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

MasterTeam *master;

SelectedTeamCDTVC *cdtvc;

// Pit Scouting info display
UIControl *grayOutview;
UIView *pitDetailView;
UIControl *imageControl;
UIImageView *robotImage;
BOOL isImageLarge;

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
    _teamNameLbl.adjustsFontSizeToFitWidth = YES;
    
    _header.title = teamNumber;
    _teamNameLbl.text = teamName;
    _teamNameLbl.adjustsFontSizeToFitWidth = true;
    _teamNameLbl.layer.cornerRadius = 5;
    _statBox.layer.cornerRadius = 10;
    
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _pitScoutingInfoBtn.layer.cornerRadius = 5;
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSFetchRequest *masterTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"MasterTeam"];
    masterTeamRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"name = %@", teamNumber]];
    
    NSError *masterTeamError;
    NSArray *masterTeamArray = [context executeFetchRequest:masterTeamRequest error:&masterTeamError];
    
    master = [masterTeamArray firstObject];
    
    PitTeam *pt = master.pitTeam;
    
    _robotPic.image = [UIImage imageWithData:pt.image];
    
    if (!pt) {
        _pitScoutingInfoBtn.enabled = false;
        _pitScoutingInfoBtn.hidden = true;
    }
    
    if (_robotPic.image == nil) {
        _robotPic.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        UILabel *noPicLbl = [[UILabel alloc] initWithFrame:CGRectMake(_robotPic.center.x - 100, _robotPic.center.y - 15, _robotPic.frame.size.width, 30)];
        noPicLbl.textAlignment = NSTextAlignmentCenter;
        noPicLbl.text = @"No Picture";
        noPicLbl.font = [UIFont boldSystemFontOfSize:20];
        [self.view addSubview:noPicLbl];
    }
    
    float autoTotal = 0;
    float teleopTotal = 0;
    float passTotal = 0;
    float receiveTotal = 0;
    float overTrussTotal = 0;
    float catchTotal = 0;
    float totalMatches = 0;
    
    float offensiveZoneCount = 0;
    float neutralZoneCount = 0;
    float defensiveZoneCount = 0;
    
    for (Team *tm in master.teamsWithin) {
        for (Match *mtch in tm.matches) {
            autoTotal += [mtch.autoHighHotScore floatValue]*20;
            autoTotal += [mtch.autoHighNotScore floatValue]*15;
            autoTotal += [mtch.autoLowHotScore floatValue]*11;
            autoTotal += [mtch.autoLowNotScore floatValue]*6;
            autoTotal += [mtch.mobilityBonus floatValue]*5;
            teleopTotal += [mtch.teleopHighMake floatValue]*10;
            teleopTotal += [mtch.teleopLowMake floatValue];
            teleopTotal += [mtch.teleopCatch floatValue]*10;
            teleopTotal += [mtch.teleopOver floatValue]*10;
            passTotal += [mtch.teleopPassed floatValue];
            receiveTotal += [mtch.teleopReceived floatValue];
            overTrussTotal += [mtch.teleopOver floatValue];
            catchTotal += [mtch.teleopCatch floatValue];
            
            NSString *zoneString = [[mtch.notes componentsSeparatedByString:@"{}"] firstObject];
            if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralZoneCount ++;}
            
            if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                    defensiveZoneCount++;
                }
                if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                    offensiveZoneCount++;
                }
            }
            else{
                if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                    defensiveZoneCount++;
                }
                if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                    offensiveZoneCount++;
                }
            }
            
            totalMatches++;
        }
    }
    
    float autoAvg = 0;
    float teleopAvg = 0;
    float passAvg = 0;
    float receiveAvg = 0;
    float overTrussAvg = 0;
    float catchAvg = 0;
    float offensiveZoneTendency = 0;
    float neutralZoneTendency = 0;
    float defensiveZoneTendency = 0;
    autoAvg = (float)autoTotal/(float)totalMatches;
    teleopAvg = (float)teleopTotal/(float)totalMatches;
    passAvg = (float)passTotal/(float)totalMatches;
    receiveAvg = (float)receiveTotal/(float)totalMatches;
    overTrussAvg = (float)overTrussTotal/(float)totalMatches;
    catchAvg = (float)catchTotal/(float)totalMatches;
    offensiveZoneTendency = (float)offensiveZoneCount/(float)totalMatches;
    neutralZoneTendency = (float)neutralZoneCount/(float)totalMatches;
    defensiveZoneTendency = (float)defensiveZoneCount/(float)totalMatches;
    
    _autoAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    _teleopAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    _passesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", passAvg];
    _receivesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", receiveAvg];
    _overTrussAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", overTrussAvg];
    _catchesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", catchAvg];
    _offensivePercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", offensiveZoneTendency*100];
    _neutralPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", neutralZoneTendency*100];
    _defensivePercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", defensiveZoneTendency*100];
    
    cdtvc = [[SelectedTeamCDTVC alloc] init];
    [cdtvc setTeamToDisplay:teamNumber];
    [cdtvc setManagedObjectContext:context];
    
    _tableView.delegate = cdtvc;
    _tableView.dataSource = cdtvc;
    
    cdtvc.tableView = _tableView;
    
    [cdtvc performFetch];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pitScoutingInfoPressed:(id)sender {
    PitTeam *ptSelected = master.pitTeam;
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [grayOutview addTarget:self action:@selector(grayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:grayOutview];
    
    pitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    pitDetailView.layer.cornerRadius = 10;
    pitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:pitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    imageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [imageControl addTarget:self action:@selector(enlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[ptSelected valueForKey:@"image"]];
    robotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    robotImage.image = image;
    [imageControl addSubview:robotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.driveTrain];
    driveTrainLbl.adjustsFontSizeToFitWidth = true;
    driveTrainLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    driveTrainLbl.layer.cornerRadius = 5;
    driveTrainLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *shooterHeader = [[UILabel alloc] initWithFrame:CGRectMake(270, 225, 80, 25)];
    shooterHeader.text = @"Shooter";
    shooterHeader.font = [UIFont boldSystemFontOfSize:15];
    shooterHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *shooterLbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 250, 140, 25)];
    shooterLbl.textAlignment = NSTextAlignmentCenter;
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.shooter];
    shooterLbl.adjustsFontSizeToFitWidth = true;
    shooterLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    shooterLbl.layer.cornerRadius = 5;
    shooterLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *preferredGoalHeader = [[UILabel alloc] initWithFrame:CGRectMake(400, 225, 120, 25)];
    preferredGoalHeader.text = @"Preferred Goal";
    preferredGoalHeader.font = [UIFont boldSystemFontOfSize:15];
    preferredGoalHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *preferredGoalLbl = [[UILabel alloc] initWithFrame:CGRectMake(400, 250, 120, 25)];
    preferredGoalLbl.textAlignment = NSTextAlignmentCenter;
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.preferredGoal];
    preferredGoalLbl.adjustsFontSizeToFitWidth = true;
    preferredGoalLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    preferredGoalLbl.layer.cornerRadius = 5;
    preferredGoalLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *goalieArmHeader = [[UILabel alloc] initWithFrame:CGRectMake(40, 290, 80, 25)];
    goalieArmHeader.text = @"Goalie Arm";
    goalieArmHeader.font = [UIFont boldSystemFontOfSize:15];
    goalieArmHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *goalieArmLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 315, 100, 25)];
    goalieArmLbl.textAlignment = NSTextAlignmentCenter;
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.goalieArm];
    goalieArmLbl.adjustsFontSizeToFitWidth = true;
    goalieArmLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    goalieArmLbl.layer.cornerRadius = 5;
    goalieArmLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *floorCollectorHeader = [[UILabel alloc] initWithFrame:CGRectMake(150, 290, 110, 25)];
    floorCollectorHeader.text = @"Floor Collector";
    floorCollectorHeader.font = [UIFont boldSystemFontOfSize:15];
    floorCollectorHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *floorCollectorLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 315, 110, 25)];
    floorCollectorLbl.textAlignment = NSTextAlignmentCenter;
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.floorCollector];
    floorCollectorLbl.adjustsFontSizeToFitWidth = true;
    floorCollectorLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    floorCollectorLbl.layer.cornerRadius = 5;
    floorCollectorLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *autonomousHeader = [[UILabel alloc] initWithFrame:CGRectMake(280, 290, 90, 25)];
    autonomousHeader.text = @"Autonomous";
    autonomousHeader.font = [UIFont boldSystemFontOfSize:15];
    autonomousHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *autonomousLbl = [[UILabel alloc] initWithFrame:CGRectMake(280, 315, 90, 25)];
    autonomousLbl.textAlignment = NSTextAlignmentCenter;
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.autonomous];
    autonomousLbl.adjustsFontSizeToFitWidth = true;
    autonomousLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    autonomousLbl.layer.cornerRadius = 5;
    autonomousLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *startingPositionHeader = [[UILabel alloc] initWithFrame:CGRectMake(390, 290, 130, 25)];
    startingPositionHeader.text = @"Starting Position";
    startingPositionHeader.font = [UIFont boldSystemFontOfSize:15];
    startingPositionHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *startingPositionLbl = [[UILabel alloc] initWithFrame:CGRectMake(390, 315, 130, 25)];
    startingPositionLbl.textAlignment = NSTextAlignmentCenter;
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.autoStartingPosition];
    startingPositionLbl.adjustsFontSizeToFitWidth = true;
    startingPositionLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    startingPositionLbl.layer.cornerRadius = 5;
    startingPositionLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *hotGoalTrackingHeader = [[UILabel alloc] initWithFrame:CGRectMake(30, 355, 150, 25)];
    hotGoalTrackingHeader.text = @"Hot Goal Tracking";
    hotGoalTrackingHeader.font = [UIFont boldSystemFontOfSize:15];
    hotGoalTrackingHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *hotGoalTrackingLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 380, 150, 25)];
    hotGoalTrackingLbl.textAlignment = NSTextAlignmentCenter;
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.hotGoalTracking];
    hotGoalTrackingLbl.adjustsFontSizeToFitWidth = true;
    hotGoalTrackingLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    hotGoalTrackingLbl.layer.cornerRadius = 5;
    hotGoalTrackingLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *catchingMechanismHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 355, 160, 25)];
    catchingMechanismHeader.text = @"Catching Mechanism";
    catchingMechanismHeader.font = [UIFont boldSystemFontOfSize:15];
    catchingMechanismHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *catchingMechanismLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 380, 160, 25)];
    catchingMechanismLbl.textAlignment = NSTextAlignmentCenter;
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.catchingMechanism];
    catchingMechanismLbl.adjustsFontSizeToFitWidth = true;
    catchingMechanismLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    catchingMechanismLbl.layer.cornerRadius = 5;
    catchingMechanismLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *bumperQualityHeader = [[UILabel alloc] initWithFrame:CGRectMake(380, 355, 140, 25)];
    bumperQualityHeader.text = @"Bumper Quality";
    bumperQualityHeader.font = [UIFont boldSystemFontOfSize:15];
    bumperQualityHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *bumperQualityLbl = [[UILabel alloc] initWithFrame:CGRectMake(380, 380, 140, 25)];
    bumperQualityLbl.textAlignment = NSTextAlignmentCenter;
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.notes];
    if (notesView.text.length == 0) {
        notesView.text = @"No Notes";
        notesView.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
    notesView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    notesView.layer.borderWidth = 1;
    notesView.layer.cornerRadius = 5;
    notesView.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    notesView.textAlignment = NSTextAlignmentCenter;
    notesView.editable = false;
    notesView.selectable = false;
    
    
    pitDetailView.frame = CGRectMake(_pitScoutingInfoBtn.center.x, _pitScoutingInfoBtn.center.y, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [pitDetailView addSubview:closeButton];
        [pitDetailView addSubview:teamNumberLbl];
        [pitDetailView addSubview:teamNameLbl];
        [pitDetailView addSubview:imageControl];
        [pitDetailView addSubview:driveTrainHeader];
        [pitDetailView addSubview:driveTrainLbl];
        [pitDetailView addSubview:shooterHeader];
        [pitDetailView addSubview:shooterLbl];
        [pitDetailView addSubview:preferredGoalHeader];
        [pitDetailView addSubview:preferredGoalLbl];
        [pitDetailView addSubview:goalieArmHeader];
        [pitDetailView addSubview:goalieArmLbl];
        [pitDetailView addSubview:floorCollectorHeader];
        [pitDetailView addSubview:floorCollectorLbl];
        [pitDetailView addSubview:autonomousHeader];
        [pitDetailView addSubview:autonomousLbl];
        [pitDetailView addSubview:startingPositionHeader];
        [pitDetailView addSubview:startingPositionLbl];
        [pitDetailView addSubview:hotGoalTrackingHeader];
        [pitDetailView addSubview:hotGoalTrackingLbl];
        [pitDetailView addSubview:catchingMechanismHeader];
        [pitDetailView addSubview:catchingMechanismLbl];
        [pitDetailView addSubview:bumperQualityHeader];
        [pitDetailView addSubview:bumperQualityLbl];
        [pitDetailView addSubview:notesHeader];
        [pitDetailView addSubview:notesView];
        [pitDetailView bringSubviewToFront:imageControl];
    }];
}

-(void)enlargePicture{
    if (!isImageLarge) {
        if (robotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                imageControl.frame = CGRectMake(-25, 0, 600, 600);
                robotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            isImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            imageControl.frame = CGRectMake(10, 10, 200, 200);
            robotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        isImageLarge = false;
    }
}
-(void)grayOutShrinkPic{
    if (isImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            imageControl.frame = CGRectMake(10, 10, 200, 200);
            robotImage.frame = CGRectMake(0, 0, 200, 200);
            isImageLarge = false;
        }];
    }
}

-(void)closeDetailView{
    for (UIView *v in [pitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(_pitScoutingInfoBtn.center.x, _pitScoutingInfoBtn.center.y, 1, 1);
    } completion:^(BOOL finished) {
        [pitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
        self.tableView.userInteractionEnabled = true;
    }];
}

@end





















