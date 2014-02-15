//
//  NextMatch.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "NextMatch.h"
#import "CoreData/CoreData.h"
#import "WithinRegional.h"
#import "Globals.h"
#import "Team.h"
#import "Team+Category.h"
#import "PitTeam.h"
#import "Match.h"

@interface NextMatch ()

@end

@implementation NextMatch

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;


NSString *regionalSelected;

NSArray *red1Labels;
NSArray *red2Labels;
NSArray *red3Labels;
NSArray *blue1Labels;
NSArray *blue2Labels;
NSArray *blue3Labels;

PitTeam *red1PitTeam;
PitTeam *red2PitTeam;
PitTeam *red3PitTeam;
PitTeam *blue1PitTeam;
PitTeam *blue2PitTeam;
PitTeam *blue3PitTeam;

UIControl *grayOutview;

UIView *red1PitDetailView;
UIControl *red1ImageControl;
UIImageView *red1RobotImage;
BOOL red1IsImageLarge;

UIView *red2PitDetailView;
UIControl *red2ImageControl;
UIImageView *red2RobotImage;
BOOL red2IsImageLarge;

UIView *red3PitDetailView;
UIControl *red3ImageControl;
UIImageView *red3RobotImage;
BOOL red3IsImageLarge;

UIView *blue1PitDetailView;
UIControl *blue1ImageControl;
UIImageView *blue1RobotImage;
BOOL blue1IsImageLarge;

UIView *blue2PitDetailView;
UIControl *blue2ImageControl;
UIImageView *blue2RobotImage;
BOOL blue2IsImageLarge;

UIView *blue3PitDetailView;
UIControl *blue3ImageControl;
UIImageView *blue3RobotImage;
BOOL blue3IsImageLarge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _red1SearchBox.delegate = self;
    _red2SearchBox.delegate = self;
    _red3SearchBox.delegate = self;
    _blue1SearchBox.delegate = self;
    _blue2SearchBox.delegate = self;
    _blue3SearchBox.delegate = self;
    _red1PitData.alpha = 0;
    _red1PitData.enabled = false;
    _red2PitData.alpha = 0;
    _red2PitData.enabled = false;
    _red3PitData.alpha = 0;
    _red3PitData.enabled = false;
    _blue1PitData.alpha = 0;
    _blue1PitData.enabled = false;
    _blue2PitData.alpha = 0;
    _blue2PitData.enabled = false;
    _blue3PitData.alpha = 0;
    _blue3PitData.enabled = false;
    
    red1Labels = @[_red1AutoHighMakes, _red1AutoHighHot, _red1AutoLowMakes, _red1AutoLowHot, _red1MobilityPercentage, _red1TeleopHighMakes, _red1TeleopLowMakes, _red1TrussShot, _red1TrussCatch, _red1Passes, _red1Receives, _red1SmallPenalty, _red1LargePenalty, _red1Offensive, _red1Neutral, _red1Defensive];
    for (UILabel *lbl in red1Labels) {
        lbl.alpha = 0;
    }
    
    red2Labels = @[_red2AutoHighMakes, _red2AutoHighHot, _red2AutoLowMakes, _red2AutoLowHot, _red2MobilityPercentage, _red2TeleopHighMakes, _red2TeleopLowMakes, _red2TrussShot, _red2TrussCatch, _red2Passes, _red2Receives, _red2SmallPenalty, _red2LargePenalty, _red2Offensive, _red2Neutral, _red2Defensive];
    for (UILabel *lbl in red2Labels) {
        lbl.alpha = 0;
    }
    
    red3Labels = @[_red3AutoHighMakes, _red3AutoHighHot, _red3AutoLowMakes, _red3AutoLowHot, _red3MobilityPercentage, _red3TeleopHighMakes, _red3TeleopLowMakes, _red3TrussShot, _red3TrussCatch, _red3Passes, _red3Receives, _red3SmallPenalty, _red3LargePenalty, _red3Offensive, _red3Neutral, _red3Defensive];
    for (UILabel *lbl in red3Labels) {
        lbl.alpha = 0;
    }
    
    blue1Labels = @[_blue1AutoHighMakes, _blue1AutoHighHot, _blue1AutoLowMakes, _blue1AutoLowHot, _blue1MobilityPercentage, _blue1TeleopHighMakes, _blue1TeleopLowMakes, _blue1TrussShot, _blue1TrussCatch, _blue1Passes, _blue1Receives, _blue1SmallPenalty, _blue1LargePenalty, _blue1Offensive, _blue1Neutral, _blue1Defensive];
    for (UILabel *lbl in blue1Labels) {
        lbl.alpha = 0;
    }
    
    blue2Labels = @[_blue2AutoHighMakes, _blue2AutoHighHot, _blue2AutoLowMakes, _blue2AutoLowHot, _blue2MobilityPercentage, _blue2TeleopHighMakes, _blue2TeleopLowMakes, _blue2TrussShot, _blue2TrussCatch, _blue2Passes, _blue2Receives, _blue2SmallPenalty, _blue2LargePenalty, _blue2Offensive, _blue2Neutral, _blue2Defensive];
    for (UILabel *lbl in blue2Labels) {
        lbl.alpha = 0;
    }
    
    blue3Labels = @[_blue3AutoHighMakes, _blue3AutoHighHot, _blue3AutoLowMakes, _blue3AutoLowHot, _blue3MobilityPercentage, _blue3TeleopHighMakes, _blue3TeleopLowMakes, _blue3TrussShot, _blue3TrussCatch, _blue3Passes, _blue3Receives, _blue3SmallPenalty, _blue3LargePenalty, _blue3Offensive, _blue3Neutral, _blue3Defensive];
    for (UILabel *lbl in blue3Labels) {
        lbl.alpha = 0;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    for (UILabel *lbl in red1Labels) {
        lbl.alpha = 0;
    }
    for (UILabel *lbl in red2Labels) {
        lbl.alpha = 0;
    }
    for (UILabel *lbl in red3Labels) {
        lbl.alpha = 0;
    }
    for (UILabel *lbl in blue1Labels) {
        lbl.alpha = 0;
    }
    for (UILabel *lbl in blue2Labels) {
        lbl.alpha = 0;
    }
    for (UILabel *lbl in blue3Labels) {
        lbl.alpha = 0;
    }
    
    _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 44);
    _red1SearchBox.text = @"";
    _red1PitData.enabled = false;
    _red1PitData.alpha = 0;
    
    _red2SearchBox.center = CGPointMake(_red2SearchBox.center.x, 44);
    _red2SearchBox.text = @"";
    _red2PitData.enabled = false;
    _red2PitData.alpha = 0;
    
    _red3SearchBox.center = CGPointMake(_red3SearchBox.center.x, 44);
    _red3SearchBox.text = @"";
    _red3PitData.enabled = false;
    _red3PitData.alpha = 0;
    
    _blue1SearchBox.center = CGPointMake(_blue1SearchBox.center.x, 44);
    _blue1SearchBox.text = @"";
    _blue1PitData.enabled = false;
    _blue1PitData.alpha = 0;
    
    _blue2SearchBox.center = CGPointMake(_blue2SearchBox.center.x, 44);
    _blue2SearchBox.text = @"";
    _blue2PitData.enabled = false;
    _blue2PitData.alpha = 0;
    
    _blue3SearchBox.center = CGPointMake(_blue3SearchBox.center.x, 44);
    _blue3SearchBox.text = @"";
    _blue3PitData.enabled = false;
    _blue3PitData.alpha = 0;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)red1FinishedEditing:(id)sender {
    red1PitTeam = nil;
    if (_red1SearchBox.text.length > 0) {
        NSFetchRequest *red1TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        red1TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _red1SearchBox.text, regionalSelected];
        
        NSError *red1TeamError;
        NSArray *red1TeamArray = [context executeFetchRequest:red1TeamRequest error:&red1TeamError];
        
        if (red1TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red1Labels) {
                    lbl.alpha = 0;
                }
                _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 44);
                _red1PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _red1PitData.enabled = false;
            }];
        }
        else{
            Team *team = [red1TeamArray firstObject];
            
            
//            float autoHighMakes = 0;
//            float autoHighAttempts = 0;
//            float autoHighHot = 0;
//            float autoLowMakes = 0;
//            float autoLowAttempts = 0;
//            float autoLowHot = 0;
//            float mobilityBonus = 0;
//            float teleopHighMakes = 0;
//            float teleopHighAttempts = 0;
//            float teleopLowMakes = 0;
//            float teleopLowAttempts = 0;
//            float trussShot = 0;
//            float trussCatch = 0;
//            float passes = 0;
//            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
//                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
//                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
//                autoHighHot += [mtch.autoHighHotScore floatValue];
//                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
//                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
//                autoLowHot += [mtch.autoLowHotScore floatValue];
//                mobilityBonus += [mtch.mobilityBonus floatValue];
//                teleopHighMakes += [mtch.teleopHighMake floatValue];
//                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
//                teleopLowMakes += [mtch.teleopLowMake floatValue];
//                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
//                trussShot += [mtch.teleopOver floatValue];
//                trussCatch += [mtch.teleopCatch floatValue];
//                passes += [mtch.teleopPassed floatValue];
//                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
//            _red1AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
//            if (autoHighMakes == 0) {_red1AutoHighHot.text = @"0%";}
//            else{_red1AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
//            _red1AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
//            if (autoLowMakes == 0) {_red1AutoLowHot.text = @"0%";}
//            else{_red1AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
//            _red1MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
//            _red1TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
//            _red1TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
//            _red1TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
//            _red1TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
//            _red1Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
//            _red1Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _red1AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", team.autoHigh]
            _red1SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _red1LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _red1Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _red1Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _red1Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *red1PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            red1PitRequest.predicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", team.name];
            
            NSError *red1PitError;
            NSArray *red1PitTeamArray = [context executeFetchRequest:red1PitRequest error:&red1PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red1Labels) {
                    lbl.alpha = 1;
                }
                if (red1PitTeamArray.count > 0) {
                    red1PitTeam = [red1PitTeamArray firstObject];
                    _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 37);
                    _red1PitData.alpha = 1;
                }
                else{
                    red1PitTeam = nil;
                    _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 44);
                    _red1PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (red1PitTeam) {
                    _red1PitData.enabled = true;
                }
                else{
                    _red1PitData.enabled = false;
                }
            }];
            
            
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in red1Labels) {
                lbl.alpha = 0;
            }
            _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 44);
            _red1PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _red1PitData.enabled = false;
        }];
    }
}
- (IBAction)red1PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(red1GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    red1PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    red1PitDetailView.layer.cornerRadius = 10;
    red1PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:red1PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(red1CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    red1ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [red1ImageControl addTarget:self action:@selector(red1EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[red1PitTeam valueForKey:@"image"]];
    red1RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    red1RobotImage.image = image;
    [red1ImageControl addSubview:red1RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", red1PitTeam.notes];
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
    
    
    red1PitDetailView.frame = CGRectMake(145, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        red1PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [red1PitDetailView addSubview:closeButton];
        [red1PitDetailView addSubview:teamNumberLbl];
        [red1PitDetailView addSubview:teamNameLbl];
        [red1PitDetailView addSubview:red1ImageControl];
        [red1PitDetailView addSubview:driveTrainHeader];
        [red1PitDetailView addSubview:driveTrainLbl];
        [red1PitDetailView addSubview:shooterHeader];
        [red1PitDetailView addSubview:shooterLbl];
        [red1PitDetailView addSubview:preferredGoalHeader];
        [red1PitDetailView addSubview:preferredGoalLbl];
        [red1PitDetailView addSubview:goalieArmHeader];
        [red1PitDetailView addSubview:goalieArmLbl];
        [red1PitDetailView addSubview:floorCollectorHeader];
        [red1PitDetailView addSubview:floorCollectorLbl];
        [red1PitDetailView addSubview:autonomousHeader];
        [red1PitDetailView addSubview:autonomousLbl];
        [red1PitDetailView addSubview:startingPositionHeader];
        [red1PitDetailView addSubview:startingPositionLbl];
        [red1PitDetailView addSubview:hotGoalTrackingHeader];
        [red1PitDetailView addSubview:hotGoalTrackingLbl];
        [red1PitDetailView addSubview:catchingMechanismHeader];
        [red1PitDetailView addSubview:catchingMechanismLbl];
        [red1PitDetailView addSubview:bumperQualityHeader];
        [red1PitDetailView addSubview:bumperQualityLbl];
        [red1PitDetailView addSubview:notesHeader];
        [red1PitDetailView addSubview:notesView];
        [red1PitDetailView bringSubviewToFront:red1ImageControl];
    }];
}
-(void)red1EnlargePicture{
    if (!red1IsImageLarge) {
        if (red1RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                red1ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                red1RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            red1IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            red1ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red1RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        red1IsImageLarge = false;
    }
}
-(void)red1GrayOutShrinkPic{
    if (red1IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            red1ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red1RobotImage.frame = CGRectMake(0, 0, 200, 200);
            red1IsImageLarge = false;
        }];
    }
}
-(void)red1CloseDetailView{
    for (UIView *v in [red1PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        red1PitDetailView.frame = CGRectMake(145, 126, 1, 1);
    } completion:^(BOOL finished) {
        [red1PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)red2FinishedEditing:(id)sender {
    red2PitTeam = nil;
    if (_red2SearchBox.text.length > 0) {
        NSFetchRequest *red2TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        red2TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _red2SearchBox.text, regionalSelected];
        
        NSError *red2TeamError;
        NSArray *red2TeamArray = [context executeFetchRequest:red2TeamRequest error:&red2TeamError];
        
        if (red2TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red2Labels) {
                    lbl.alpha = 0;
                }
                _red2SearchBox.center = CGPointMake(_red2SearchBox.center.x, 44);
                _red2PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _red2PitData.enabled = false;
            }];
        }
        else{
            Team *team = [red2TeamArray firstObject];
            
            
            float autoHighMakes = 0;
            float autoHighAttempts = 0;
            float autoHighHot = 0;
            float autoLowMakes = 0;
            float autoLowAttempts = 0;
            float autoLowHot = 0;
            float mobilityBonus = 0;
            float teleopHighMakes = 0;
            float teleopHighAttempts = 0;
            float teleopLowMakes = 0;
            float teleopLowAttempts = 0;
            float trussShot = 0;
            float trussCatch = 0;
            float passes = 0;
            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
                autoHighHot += [mtch.autoHighHotScore floatValue];
                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
                autoLowHot += [mtch.autoLowHotScore floatValue];
                mobilityBonus += [mtch.mobilityBonus floatValue];
                teleopHighMakes += [mtch.teleopHighMake floatValue];
                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
                teleopLowMakes += [mtch.teleopLowMake floatValue];
                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
                trussShot += [mtch.teleopOver floatValue];
                trussCatch += [mtch.teleopCatch floatValue];
                passes += [mtch.teleopPassed floatValue];
                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
            _red2AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            if (autoHighMakes == 0) {_red2AutoHighHot.text = @"0%";}
            else{_red2AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
            _red2AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            if (autoLowMakes == 0) {_red2AutoLowHot.text = @"0%";}
            else{_red2AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
            _red2MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _red2TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _red2TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _red2TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _red2TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _red2Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _red2Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _red2SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _red2LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _red2Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _red2Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _red2Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *red2PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            red2PitRequest.predicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", team.name];
            
            NSError *red2PitError;
            NSArray *red2PitTeamArray = [context executeFetchRequest:red2PitRequest error:&red2PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red2Labels) {
                    lbl.alpha = 1;
                }
                if (red2PitTeamArray.count > 0) {
                    red2PitTeam = [red2PitTeamArray firstObject];
                    _red2SearchBox.center = CGPointMake(_red2SearchBox.center.x, 37);
                    _red2PitData.alpha = 1;
                }else{
                    red2PitTeam = nil;
                    _red2SearchBox.center = CGPointMake(_red2SearchBox.center.x, 44);
                    _red2PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (red2PitTeam) {
                    _red2PitData.enabled = true;
                }
                else{
                    _red2PitData.enabled = false;
                }
            }];
            
            
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in red2Labels) {
                lbl.alpha = 0;
            }
            _red2SearchBox.center = CGPointMake(_red2SearchBox.center.x, 44);
            _red2PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _red2PitData.enabled = false;
        }];
    }
}
- (IBAction)red2PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(red2GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    red2PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    red2PitDetailView.layer.cornerRadius = 10;
    red2PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:red2PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(red2CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    red2ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [red2ImageControl addTarget:self action:@selector(red2EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[red2PitTeam valueForKey:@"image"]];
    red2RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    red2RobotImage.image = image;
    [red2ImageControl addSubview:red2RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", red2PitTeam.notes];
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
    
    
    red2PitDetailView.frame = CGRectMake(259, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        red2PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [red2PitDetailView addSubview:closeButton];
        [red2PitDetailView addSubview:teamNumberLbl];
        [red2PitDetailView addSubview:teamNameLbl];
        [red2PitDetailView addSubview:red2ImageControl];
        [red2PitDetailView addSubview:driveTrainHeader];
        [red2PitDetailView addSubview:driveTrainLbl];
        [red2PitDetailView addSubview:shooterHeader];
        [red2PitDetailView addSubview:shooterLbl];
        [red2PitDetailView addSubview:preferredGoalHeader];
        [red2PitDetailView addSubview:preferredGoalLbl];
        [red2PitDetailView addSubview:goalieArmHeader];
        [red2PitDetailView addSubview:goalieArmLbl];
        [red2PitDetailView addSubview:floorCollectorHeader];
        [red2PitDetailView addSubview:floorCollectorLbl];
        [red2PitDetailView addSubview:autonomousHeader];
        [red2PitDetailView addSubview:autonomousLbl];
        [red2PitDetailView addSubview:startingPositionHeader];
        [red2PitDetailView addSubview:startingPositionLbl];
        [red2PitDetailView addSubview:hotGoalTrackingHeader];
        [red2PitDetailView addSubview:hotGoalTrackingLbl];
        [red2PitDetailView addSubview:catchingMechanismHeader];
        [red2PitDetailView addSubview:catchingMechanismLbl];
        [red2PitDetailView addSubview:bumperQualityHeader];
        [red2PitDetailView addSubview:bumperQualityLbl];
        [red2PitDetailView addSubview:notesHeader];
        [red2PitDetailView addSubview:notesView];
        [red2PitDetailView bringSubviewToFront:red2ImageControl];
    }];
}
-(void)red2EnlargePicture{
    if (!red2IsImageLarge) {
        if (red2RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                red2ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                red2RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            red2IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            red2ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red2RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        red2IsImageLarge = false;
    }
}
-(void)red2GrayOutShrinkPic{
    if (red2IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            red2ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red2RobotImage.frame = CGRectMake(0, 0, 200, 200);
            red2IsImageLarge = false;
        }];
    }
}
-(void)red2CloseDetailView{
    for (UIView *v in [red2PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        red2PitDetailView.frame = CGRectMake(259, 126, 1, 1);
    } completion:^(BOOL finished) {
        [red2PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)red3FinishedEditing:(id)sender {
    red3PitTeam = nil;
    if (_red3SearchBox.text.length > 0) {
        NSFetchRequest *red3TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        red3TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _red3SearchBox.text, regionalSelected];
        
        NSError *red3TeamError;
        NSArray *red3TeamArray = [context executeFetchRequest:red3TeamRequest error:&red3TeamError];
        
        if (red3TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red3Labels) {
                    lbl.alpha = 0;
                }
                _red3SearchBox.center = CGPointMake(_red3SearchBox.center.x, 44);
                _red3PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _red3PitData.enabled = false;
            }];
        }
        else{
            Team *team = [red3TeamArray firstObject];
            
            
            float autoHighMakes = 0;
            float autoHighAttempts = 0;
            float autoHighHot = 0;
            float autoLowMakes = 0;
            float autoLowAttempts = 0;
            float autoLowHot = 0;
            float mobilityBonus = 0;
            float teleopHighMakes = 0;
            float teleopHighAttempts = 0;
            float teleopLowMakes = 0;
            float teleopLowAttempts = 0;
            float trussShot = 0;
            float trussCatch = 0;
            float passes = 0;
            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
                autoHighHot += [mtch.autoHighHotScore floatValue];
                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
                autoLowHot += [mtch.autoLowHotScore floatValue];
                mobilityBonus += [mtch.mobilityBonus floatValue];
                teleopHighMakes += [mtch.teleopHighMake floatValue];
                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
                teleopLowMakes += [mtch.teleopLowMake floatValue];
                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
                trussShot += [mtch.teleopOver floatValue];
                trussCatch += [mtch.teleopCatch floatValue];
                passes += [mtch.teleopPassed floatValue];
                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
            _red3AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            if (autoHighMakes == 0) {_red3AutoHighHot.text = @"0%";}
            else{_red3AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
            _red3AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            if (autoLowMakes == 0) {_red3AutoLowHot.text = @"0%";}
            else{_red3AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
            _red3MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _red3TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _red3TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _red3TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _red3TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _red3Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _red3Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _red3SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _red3LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _red3Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _red3Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _red3Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *red3PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            red3PitRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNumber = %@", team.name]];
            
            NSError *red3PitError;
            NSArray *red3PitTeamArray = [context executeFetchRequest:red3PitRequest error:&red3PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in red3Labels) {
                    lbl.alpha = 1;
                }
                if (red3PitTeamArray.count > 0) {
                    red3PitTeam = [red3PitTeamArray firstObject];
                    _red3SearchBox.center = CGPointMake(_red3SearchBox.center.x, 37);
                    _red3PitData.alpha = 1;
                }
                else{
                    red3PitTeam = nil;
                    _red3SearchBox.center = CGPointMake(_red3SearchBox.center.x, 44);
                    _red3PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (red3PitTeam) {
                    _red3PitData.enabled = true;
                }
                else{
                    _red3PitData.enabled = false;
                }
            }];
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in red3Labels) {
                lbl.alpha = 0;
            }
            _red3SearchBox.center = CGPointMake(_red3SearchBox.center.x, 44);
            _red3PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _red3PitData.enabled = false;
        }];
    }
}
- (IBAction)red3PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(red3GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    red3PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    red3PitDetailView.layer.cornerRadius = 10;
    red3PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:red3PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(red3CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    red3ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [red3ImageControl addTarget:self action:@selector(red3EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[red3PitTeam valueForKey:@"image"]];
    red3RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    red3RobotImage.image = image;
    [red3ImageControl addSubview:red3RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", red3PitTeam.notes];
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
    
    
    red3PitDetailView.frame = CGRectMake(374, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        red3PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [red3PitDetailView addSubview:closeButton];
        [red3PitDetailView addSubview:teamNumberLbl];
        [red3PitDetailView addSubview:teamNameLbl];
        [red3PitDetailView addSubview:red3ImageControl];
        [red3PitDetailView addSubview:driveTrainHeader];
        [red3PitDetailView addSubview:driveTrainLbl];
        [red3PitDetailView addSubview:shooterHeader];
        [red3PitDetailView addSubview:shooterLbl];
        [red3PitDetailView addSubview:preferredGoalHeader];
        [red3PitDetailView addSubview:preferredGoalLbl];
        [red3PitDetailView addSubview:goalieArmHeader];
        [red3PitDetailView addSubview:goalieArmLbl];
        [red3PitDetailView addSubview:floorCollectorHeader];
        [red3PitDetailView addSubview:floorCollectorLbl];
        [red3PitDetailView addSubview:autonomousHeader];
        [red3PitDetailView addSubview:autonomousLbl];
        [red3PitDetailView addSubview:startingPositionHeader];
        [red3PitDetailView addSubview:startingPositionLbl];
        [red3PitDetailView addSubview:hotGoalTrackingHeader];
        [red3PitDetailView addSubview:hotGoalTrackingLbl];
        [red3PitDetailView addSubview:catchingMechanismHeader];
        [red3PitDetailView addSubview:catchingMechanismLbl];
        [red3PitDetailView addSubview:bumperQualityHeader];
        [red3PitDetailView addSubview:bumperQualityLbl];
        [red3PitDetailView addSubview:notesHeader];
        [red3PitDetailView addSubview:notesView];
        [red3PitDetailView bringSubviewToFront:red3ImageControl];
    }];
}
-(void)red3EnlargePicture{
    if (!red3IsImageLarge) {
        if (red3RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                red3ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                red3RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            red3IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            red3ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red3RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        red3IsImageLarge = false;
    }
}
-(void)red3GrayOutShrinkPic{
    if (red3IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            red3ImageControl.frame = CGRectMake(10, 10, 200, 200);
            red3RobotImage.frame = CGRectMake(0, 0, 200, 200);
            red3IsImageLarge = false;
        }];
    }
}
-(void)red3CloseDetailView{
    for (UIView *v in [red3PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        red3PitDetailView.frame = CGRectMake(374, 126, 1, 1);
    } completion:^(BOOL finished) {
        [red3PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)blue1FinishedEditing:(id)sender {
    blue1PitTeam = nil;
    if (_blue1SearchBox.text.length > 0) {
        NSFetchRequest *blue1TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        blue1TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _blue1SearchBox.text, regionalSelected];
        
        NSError *blue1TeamError;
        NSArray *blue1TeamArray = [context executeFetchRequest:blue1TeamRequest error:&blue1TeamError];
        
        if (blue1TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue1Labels) {
                    lbl.alpha = 0;
                }
                _blue1SearchBox.center = CGPointMake(_blue1SearchBox.center.x, 44);
                _blue1PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _blue1PitData.enabled = false;
            }];
        }
        else{
            Team *team = [blue1TeamArray firstObject];
            
            
            float autoHighMakes = 0;
            float autoHighAttempts = 0;
            float autoHighHot = 0;
            float autoLowMakes = 0;
            float autoLowAttempts = 0;
            float autoLowHot = 0;
            float mobilityBonus = 0;
            float teleopHighMakes = 0;
            float teleopHighAttempts = 0;
            float teleopLowMakes = 0;
            float teleopLowAttempts = 0;
            float trussShot = 0;
            float trussCatch = 0;
            float passes = 0;
            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
                autoHighHot += [mtch.autoHighHotScore floatValue];
                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
                autoLowHot += [mtch.autoLowHotScore floatValue];
                mobilityBonus += [mtch.mobilityBonus floatValue];
                teleopHighMakes += [mtch.teleopHighMake floatValue];
                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
                teleopLowMakes += [mtch.teleopLowMake floatValue];
                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
                trussShot += [mtch.teleopOver floatValue];
                trussCatch += [mtch.teleopCatch floatValue];
                passes += [mtch.teleopPassed floatValue];
                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
            _blue1AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            if (autoHighMakes == 0) {_blue1AutoHighHot.text = @"0%";}
            else{_blue1AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
            _blue1AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            if (autoLowMakes == 0) {_blue1AutoLowHot.text = @"0%";}
            else{_blue1AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
            _blue1MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _blue1TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _blue1TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _blue1TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _blue1TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _blue1Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _blue1Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _blue1SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _blue1LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _blue1Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _blue1Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _blue1Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *blue1PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            blue1PitRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNumber = %@", team.name]];
            
            NSError *blue1PitError;
            NSArray *blue1PitTeamArray = [context executeFetchRequest:blue1PitRequest error:&blue1PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue1Labels) {
                    lbl.alpha = 1;
                }
                if (blue1PitTeamArray.count > 0) {
                    blue1PitTeam = [blue1PitTeamArray firstObject];
                    _blue1SearchBox.center = CGPointMake(_blue1SearchBox.center.x, 37);
                    _blue1PitData.alpha = 1;
                }
                else{
                    blue1PitTeam = nil;
                    _blue1SearchBox.center = CGPointMake(_blue1SearchBox.center.x, 44);
                    _blue1PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (blue1PitTeam) {
                    _blue1PitData.enabled = true;
                }
                else{
                    _blue1PitData.enabled = false;
                }
            }];
            
            
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in blue1Labels) {
                lbl.alpha = 0;
            }
            _blue1SearchBox.center = CGPointMake(_blue1SearchBox.center.x, 44);
            _blue1PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _blue1PitData.enabled = false;
        }];
    }
}
- (IBAction)blue1PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(blue1GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    blue1PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    blue1PitDetailView.layer.cornerRadius = 10;
    blue1PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:blue1PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(blue1CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    blue1ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [blue1ImageControl addTarget:self action:@selector(blue1EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[blue1PitTeam valueForKey:@"image"]];
    blue1RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    blue1RobotImage.image = image;
    [blue1ImageControl addSubview:blue1RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", blue1PitTeam.notes];
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
    
    
    blue1PitDetailView.frame = CGRectMake(484, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        blue1PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [blue1PitDetailView addSubview:closeButton];
        [blue1PitDetailView addSubview:teamNumberLbl];
        [blue1PitDetailView addSubview:teamNameLbl];
        [blue1PitDetailView addSubview:blue1ImageControl];
        [blue1PitDetailView addSubview:driveTrainHeader];
        [blue1PitDetailView addSubview:driveTrainLbl];
        [blue1PitDetailView addSubview:shooterHeader];
        [blue1PitDetailView addSubview:shooterLbl];
        [blue1PitDetailView addSubview:preferredGoalHeader];
        [blue1PitDetailView addSubview:preferredGoalLbl];
        [blue1PitDetailView addSubview:goalieArmHeader];
        [blue1PitDetailView addSubview:goalieArmLbl];
        [blue1PitDetailView addSubview:floorCollectorHeader];
        [blue1PitDetailView addSubview:floorCollectorLbl];
        [blue1PitDetailView addSubview:autonomousHeader];
        [blue1PitDetailView addSubview:autonomousLbl];
        [blue1PitDetailView addSubview:startingPositionHeader];
        [blue1PitDetailView addSubview:startingPositionLbl];
        [blue1PitDetailView addSubview:hotGoalTrackingHeader];
        [blue1PitDetailView addSubview:hotGoalTrackingLbl];
        [blue1PitDetailView addSubview:catchingMechanismHeader];
        [blue1PitDetailView addSubview:catchingMechanismLbl];
        [blue1PitDetailView addSubview:bumperQualityHeader];
        [blue1PitDetailView addSubview:bumperQualityLbl];
        [blue1PitDetailView addSubview:notesHeader];
        [blue1PitDetailView addSubview:notesView];
        [blue1PitDetailView bringSubviewToFront:blue1ImageControl];
    }];
}
-(void)blue1EnlargePicture{
    if (!blue1IsImageLarge) {
        if (blue1RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                blue1ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                blue1RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            blue1IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            blue1ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue1RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        blue1IsImageLarge = false;
    }
}
-(void)blue1GrayOutShrinkPic{
    if (blue1IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            blue1ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue1RobotImage.frame = CGRectMake(0, 0, 200, 200);
            blue1IsImageLarge = false;
        }];
    }
}
-(void)blue1CloseDetailView{
    for (UIView *v in [blue1PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        blue1PitDetailView.frame = CGRectMake(484, 126, 1, 1);
    } completion:^(BOOL finished) {
        [blue1PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)blue2FinishedEditing:(id)sender {
    blue2PitTeam = nil;
    if (_blue2SearchBox.text.length > 0) {
        NSFetchRequest *blue2TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        blue2TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _blue2SearchBox.text, regionalSelected];
        
        NSError *blue2TeamError;
        NSArray *blue2TeamArray = [context executeFetchRequest:blue2TeamRequest error:&blue2TeamError];
        
        if (blue2TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue2Labels) {
                    lbl.alpha = 0;
                }
                _blue2SearchBox.center = CGPointMake(_blue2SearchBox.center.x, 44);
                _blue2PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _blue2PitData.enabled = false;
            }];
        }
        else{
            Team *team = [blue2TeamArray firstObject];
            
            
            float autoHighMakes = 0;
            float autoHighAttempts = 0;
            float autoHighHot = 0;
            float autoLowMakes = 0;
            float autoLowAttempts = 0;
            float autoLowHot = 0;
            float mobilityBonus = 0;
            float teleopHighMakes = 0;
            float teleopHighAttempts = 0;
            float teleopLowMakes = 0;
            float teleopLowAttempts = 0;
            float trussShot = 0;
            float trussCatch = 0;
            float passes = 0;
            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
                autoHighHot += [mtch.autoHighHotScore floatValue];
                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
                autoLowHot += [mtch.autoLowHotScore floatValue];
                mobilityBonus += [mtch.mobilityBonus floatValue];
                teleopHighMakes += [mtch.teleopHighMake floatValue];
                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
                teleopLowMakes += [mtch.teleopLowMake floatValue];
                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
                trussShot += [mtch.teleopOver floatValue];
                trussCatch += [mtch.teleopCatch floatValue];
                passes += [mtch.teleopPassed floatValue];
                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
            _blue2AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            if (autoHighMakes == 0) {_blue2AutoHighHot.text = @"0%";}
            else{_blue2AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
            _blue2AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            if (autoLowMakes == 0) {_blue2AutoLowHot.text = @"0%";}
            else{_blue2AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
            _blue2MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _blue2TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _blue2TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _blue2TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _blue2TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _blue2Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _blue2Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _blue2SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _blue2LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _blue2Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _blue2Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _blue2Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *blue2PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            blue2PitRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNumber = %@", team.name]];
            
            NSError *blue2PitError;
            NSArray *blue2PitTeamArray = [context executeFetchRequest:blue2PitRequest error:&blue2PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue2Labels) {
                    lbl.alpha = 1;
                }
                if (blue2PitTeamArray.count > 0) {
                    blue2PitTeam = [blue2PitTeamArray firstObject];
                    _blue2SearchBox.center = CGPointMake(_blue2SearchBox.center.x, 37);
                    _blue2PitData.alpha = 1;
                }
                else{
                    blue2PitTeam = nil;
                    _blue2SearchBox.center = CGPointMake(_blue2SearchBox.center.x, 44);
                    _blue2PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (blue2PitTeam) {
                    _blue2PitData.enabled = true;
                }
                else{
                    _blue2PitData.enabled = false;
                }
            }];
            
            
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in blue2Labels) {
                lbl.alpha = 0;
            }
            _blue2SearchBox.center = CGPointMake(_blue2SearchBox.center.x, 44);
            _blue2PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _blue2PitData.enabled = false;
        }];
    }
}
- (IBAction)blue2PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(blue2GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    blue2PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    blue2PitDetailView.layer.cornerRadius = 10;
    blue2PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:blue2PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(blue2CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    blue2ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [blue2ImageControl addTarget:self action:@selector(blue2EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[blue2PitTeam valueForKey:@"image"]];
    blue2RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    blue2RobotImage.image = image;
    [blue2ImageControl addSubview:blue2RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", blue2PitTeam.notes];
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
    
    
    blue2PitDetailView.frame = CGRectMake(598, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        blue2PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [blue2PitDetailView addSubview:closeButton];
        [blue2PitDetailView addSubview:teamNumberLbl];
        [blue2PitDetailView addSubview:teamNameLbl];
        [blue2PitDetailView addSubview:blue2ImageControl];
        [blue2PitDetailView addSubview:driveTrainHeader];
        [blue2PitDetailView addSubview:driveTrainLbl];
        [blue2PitDetailView addSubview:shooterHeader];
        [blue2PitDetailView addSubview:shooterLbl];
        [blue2PitDetailView addSubview:preferredGoalHeader];
        [blue2PitDetailView addSubview:preferredGoalLbl];
        [blue2PitDetailView addSubview:goalieArmHeader];
        [blue2PitDetailView addSubview:goalieArmLbl];
        [blue2PitDetailView addSubview:floorCollectorHeader];
        [blue2PitDetailView addSubview:floorCollectorLbl];
        [blue2PitDetailView addSubview:autonomousHeader];
        [blue2PitDetailView addSubview:autonomousLbl];
        [blue2PitDetailView addSubview:startingPositionHeader];
        [blue2PitDetailView addSubview:startingPositionLbl];
        [blue2PitDetailView addSubview:hotGoalTrackingHeader];
        [blue2PitDetailView addSubview:hotGoalTrackingLbl];
        [blue2PitDetailView addSubview:catchingMechanismHeader];
        [blue2PitDetailView addSubview:catchingMechanismLbl];
        [blue2PitDetailView addSubview:bumperQualityHeader];
        [blue2PitDetailView addSubview:bumperQualityLbl];
        [blue2PitDetailView addSubview:notesHeader];
        [blue2PitDetailView addSubview:notesView];
        [blue2PitDetailView bringSubviewToFront:blue2ImageControl];
    }];
}
-(void)blue2EnlargePicture{
    if (!blue2IsImageLarge) {
        if (blue2RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                blue2ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                blue2RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            blue2IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            blue2ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue2RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        blue2IsImageLarge = false;
    }
}
-(void)blue2GrayOutShrinkPic{
    if (blue2IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            blue2ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue2RobotImage.frame = CGRectMake(0, 0, 200, 200);
            blue2IsImageLarge = false;
        }];
    }
}
-(void)blue2CloseDetailView{
    for (UIView *v in [blue2PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        blue2PitDetailView.frame = CGRectMake(598, 126, 1, 1);
    } completion:^(BOOL finished) {
        [blue2PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)blue3FinishedEditing:(id)sender {
    blue3PitTeam = nil;
    if (_blue3SearchBox.text.length > 0) {
        NSFetchRequest *blue3TeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
        blue3TeamRequest.predicate = [NSPredicate predicateWithFormat:@"(name = %@) AND (regionalIn.name = %@)", _blue3SearchBox.text, regionalSelected];
        
        NSError *blue3TeamError;
        NSArray *blue3TeamArray = [context executeFetchRequest:blue3TeamRequest error:&blue3TeamError];
        
        if (blue3TeamArray.count == 0) {
            UIAlertView *noTeamAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                  message:@"That team doesn't have any matches recorded in this regional!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Darn"
                                                        otherButtonTitles:nil];
            [noTeamAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue3Labels) {
                    lbl.alpha = 0;
                }
                _blue3SearchBox.center = CGPointMake(_blue3SearchBox.center.x, 44);
                _blue3PitData.alpha = 0;
            } completion:^(BOOL finished) {
                _blue3PitData.enabled = false;
            }];
        }
        else{
            Team *team = [blue3TeamArray firstObject];
            
            
            float autoHighMakes = 0;
            float autoHighAttempts = 0;
            float autoHighHot = 0;
            float autoLowMakes = 0;
            float autoLowAttempts = 0;
            float autoLowHot = 0;
            float mobilityBonus = 0;
            float teleopHighMakes = 0;
            float teleopHighAttempts = 0;
            float teleopLowMakes = 0;
            float teleopLowAttempts = 0;
            float trussShot = 0;
            float trussCatch = 0;
            float passes = 0;
            float receives = 0;
            float smallPenalties = 0;
            float largePenalties = 0;
            float offensiveCount = 0;
            float neutralCount = 0;
            float defensiveCount = 0;
            float matchesCount = 0;
            
            for (Match *mtch in team.matches) {
                autoHighMakes += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue];
                autoHighAttempts += [mtch.autoHighHotScore floatValue] + [mtch.autoHighNotScore floatValue] + [mtch.autoHighMissScore floatValue];
                autoHighHot += [mtch.autoHighHotScore floatValue];
                autoLowMakes += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue];
                autoLowAttempts += [mtch.autoLowHotScore floatValue] + [mtch.autoLowNotScore floatValue] + [mtch.autoLowMissScore floatValue];
                autoLowHot += [mtch.autoLowHotScore floatValue];
                mobilityBonus += [mtch.mobilityBonus floatValue];
                teleopHighMakes += [mtch.teleopHighMake floatValue];
                teleopHighAttempts += [mtch.teleopHighMake floatValue] + [mtch.teleopHighMiss floatValue];
                teleopLowMakes += [mtch.teleopLowMake floatValue];
                teleopLowAttempts += [mtch.teleopLowMake floatValue] + [mtch.teleopLowMiss floatValue];
                trussShot += [mtch.teleopOver floatValue];
                trussCatch += [mtch.teleopCatch floatValue];
                passes += [mtch.teleopPassed floatValue];
                receives += [mtch.teleopReceived floatValue];
                smallPenalties += [mtch.penaltySmall floatValue];
                largePenalties += [mtch.penaltyLarge floatValue];
                
                NSString *zoneString = [[mtch.notes componentsSeparatedByString:@":"] firstObject];
                if ([zoneString rangeOfString:@"White"].location != NSNotFound) {neutralCount ++;}
                
                if ([[mtch.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                else{
                    if ([zoneString rangeOfString:@"Blue"].location != NSNotFound) {
                        defensiveCount++;
                    }
                    if ([zoneString rangeOfString:@"Red"].location != NSNotFound) {
                        offensiveCount++;
                    }
                }
                
                matchesCount ++;
            }
            
            _blue3AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            if (autoHighMakes == 0) {_blue3AutoHighHot.text = @"0%";}
            else{_blue3AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];}
            _blue3AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            if (autoLowMakes == 0) {_blue3AutoLowHot.text = @"0%";}
            else{_blue3AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];}
            _blue3MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _blue3TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _blue3TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _blue3TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _blue3TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _blue3Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _blue3Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
            _blue3SmallPenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)smallPenalties/(float)matchesCount];
            _blue3LargePenalty.text = [[NSString alloc] initWithFormat:@"%.1f", (float)largePenalties/(float)matchesCount];
            _blue3Offensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)offensiveCount/(float)matchesCount*100];
            _blue3Neutral.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)neutralCount/(float)matchesCount*100];
            _blue3Defensive.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)defensiveCount/(float)matchesCount*100];
            
            NSFetchRequest *blue3PitRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            blue3PitRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNumber = %@", team.name]];
            
            NSError *blue3PitError;
            NSArray *blue3PitTeamArray = [context executeFetchRequest:blue3PitRequest error:&blue3PitError];
            
            [UIView animateWithDuration:0.2 animations:^{
                for (UILabel *lbl in blue3Labels) {
                    lbl.alpha = 1;
                }
                if (blue3PitTeamArray.count > 0) {
                    blue3PitTeam = [blue3PitTeamArray firstObject];
                    _blue3SearchBox.center = CGPointMake(_blue3SearchBox.center.x, 37);
                    _blue3PitData.alpha = 1;
                }
                else{
                    blue3PitTeam = nil;
                    _blue3SearchBox.center = CGPointMake(_blue3SearchBox.center.x, 44);
                    _blue3PitData.alpha = 0;
                }
            } completion:^(BOOL finished) {
                if (blue3PitTeam) {
                    _blue3PitData.enabled = true;
                }
                else{
                    _blue3PitData.enabled = false;
                }
            }];
            
            
        }
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            for (UILabel *lbl in blue3Labels) {
                lbl.alpha = 0;
            }
            _blue3SearchBox.center = CGPointMake(_blue3SearchBox.center.x, 44);
            _blue3PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _blue3PitData.enabled = false;
        }];
    }
}
- (IBAction)blue3PitData:(id)sender {
    [self screenTapped];
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [grayOutview addTarget:self action:@selector(blue3GrayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:grayOutview];
    
    blue3PitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    blue3PitDetailView.layer.cornerRadius = 10;
    blue3PitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:blue3PitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(blue3CloseDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    blue3ImageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [blue3ImageControl addTarget:self action:@selector(blue3EnlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[blue3PitTeam valueForKey:@"image"]];
    blue3RobotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    blue3RobotImage.image = image;
    [blue3ImageControl addSubview:blue3RobotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.driveTrain];
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
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.shooter];
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
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.preferredGoal];
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
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.goalieArm];
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
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.floorCollector];
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
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.autonomous];
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
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.autoStartingPosition];
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
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.hotGoalTracking];
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
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.catchingMechanism];
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
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", blue3PitTeam.notes];
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
    
    
    blue3PitDetailView.frame = CGRectMake(712, 126, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        blue3PitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [blue3PitDetailView addSubview:closeButton];
        [blue3PitDetailView addSubview:teamNumberLbl];
        [blue3PitDetailView addSubview:teamNameLbl];
        [blue3PitDetailView addSubview:blue3ImageControl];
        [blue3PitDetailView addSubview:driveTrainHeader];
        [blue3PitDetailView addSubview:driveTrainLbl];
        [blue3PitDetailView addSubview:shooterHeader];
        [blue3PitDetailView addSubview:shooterLbl];
        [blue3PitDetailView addSubview:preferredGoalHeader];
        [blue3PitDetailView addSubview:preferredGoalLbl];
        [blue3PitDetailView addSubview:goalieArmHeader];
        [blue3PitDetailView addSubview:goalieArmLbl];
        [blue3PitDetailView addSubview:floorCollectorHeader];
        [blue3PitDetailView addSubview:floorCollectorLbl];
        [blue3PitDetailView addSubview:autonomousHeader];
        [blue3PitDetailView addSubview:autonomousLbl];
        [blue3PitDetailView addSubview:startingPositionHeader];
        [blue3PitDetailView addSubview:startingPositionLbl];
        [blue3PitDetailView addSubview:hotGoalTrackingHeader];
        [blue3PitDetailView addSubview:hotGoalTrackingLbl];
        [blue3PitDetailView addSubview:catchingMechanismHeader];
        [blue3PitDetailView addSubview:catchingMechanismLbl];
        [blue3PitDetailView addSubview:bumperQualityHeader];
        [blue3PitDetailView addSubview:bumperQualityLbl];
        [blue3PitDetailView addSubview:notesHeader];
        [blue3PitDetailView addSubview:notesView];
        [blue3PitDetailView bringSubviewToFront:blue3ImageControl];
    }];
}
-(void)blue3EnlargePicture{
    if (!blue3IsImageLarge) {
        if (blue3RobotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                blue3ImageControl.frame = CGRectMake(-25, 0, 600, 600);
                blue3RobotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            blue3IsImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            blue3ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue3RobotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        blue3IsImageLarge = false;
    }
}
-(void)blue3GrayOutShrinkPic{
    if (blue3IsImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            blue3ImageControl.frame = CGRectMake(10, 10, 200, 200);
            blue3RobotImage.frame = CGRectMake(0, 0, 200, 200);
            blue3IsImageLarge = false;
        }];
    }
}
-(void)blue3CloseDetailView{
    for (UIView *v in [blue3PitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        blue3PitDetailView.frame = CGRectMake(712, 126, 1, 1);
    } completion:^(BOOL finished) {
        [blue3PitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)baseScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)redScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)blueScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe1Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe2Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe3Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe4Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe5Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe6Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe7Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
-(void)screenTapped{
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}




@end






















