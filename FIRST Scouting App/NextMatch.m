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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)red1FinishedEditing:(id)sender {
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
            
            _red1AutoHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoHighMakes/(float)matchesCount, (float)autoHighAttempts/(float)matchesCount];
            _red1AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _red1AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _red1AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
            _red1MobilityPercentage.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)mobilityBonus/(float)matchesCount*100];
            _red1TeleopHighMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopHighMakes/(float)matchesCount, (float)teleopHighAttempts/(float)matchesCount];
            _red1TeleopLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)teleopLowMakes/(float)matchesCount, (float)teleopLowAttempts/(float)matchesCount];
            _red1TrussShot.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussShot/(float)matchesCount];
            _red1TrussCatch.text = [[NSString alloc] initWithFormat:@"%.1f", (float)trussCatch/(float)matchesCount];
            _red1Passes.text = [[NSString alloc] initWithFormat:@"%.1f", (float)passes/(float)matchesCount];
            _red1Receives.text = [[NSString alloc] initWithFormat:@"%.1f", (float)receives/(float)matchesCount];
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
            } completion:^(BOOL finished) {
                _red1PitData.enabled = true;
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
}

- (IBAction)red2FinishedEditing:(id)sender {
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
            _red2AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _red2AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _red2AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
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
                }
            } completion:^(BOOL finished) {
                _red2PitData.enabled = true;
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
}

- (IBAction)red3FinishedEditing:(id)sender {
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
            _red3AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _red3AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _red3AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
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
            } completion:^(BOOL finished) {
                _red3PitData.enabled = true;
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
}

- (IBAction)blue1FinishedEditing:(id)sender {
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
            _blue1AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _blue1AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _blue1AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
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
            } completion:^(BOOL finished) {
                _blue1PitData.enabled = true;
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
}

- (IBAction)blue2FinishedEditing:(id)sender {
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
            _blue2AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _blue2AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _blue2AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
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
            } completion:^(BOOL finished) {
                _blue2PitData.enabled = true;
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
}

- (IBAction)blue3FinishedEditing:(id)sender {
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
            _blue3AutoHighHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoHighHot/(float)autoHighMakes*100];
            _blue3AutoLowMakes.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", (float)autoLowMakes/(float)matchesCount, (float)autoLowAttempts/(float)matchesCount];
            _blue3AutoLowHot.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)autoLowHot/(float)autoLowMakes*100];
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
            } completion:^(BOOL finished) {
                _blue3PitData.enabled = true;
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




@end






















