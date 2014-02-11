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
                _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 47);
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
            red1PitRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNumber = %@", team.name]];
            
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
            _red1SearchBox.center = CGPointMake(_red1SearchBox.center.x, 47);
            _red1PitData.alpha = 0;
        } completion:^(BOOL finished) {
            _red1PitData.enabled = false;
        }];
    }
}
- (IBAction)red1PitData:(id)sender {
}

- (IBAction)red2FinishedEditing:(id)sender {
}
- (IBAction)red2PitData:(id)sender {
}

- (IBAction)red3FinishedEditing:(id)sender {
}
- (IBAction)red3PitData:(id)sender {
}

- (IBAction)blue1FinishedEditing:(id)sender {
}
- (IBAction)blue1PitData:(id)sender {
}

- (IBAction)blue2FinishedEditing:(id)sender {
}
- (IBAction)blue2PitData:(id)sender {
}

- (IBAction)blue3FinishedEditing:(id)sender {
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






















