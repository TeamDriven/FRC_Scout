//
//  SelectedTeamCDTVC.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/9/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SelectedTeamCDTVC.h"
#import "SingleTeamMatchCell.h"
#import "MasterTeam.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"
#import "PitTeam.h"

@implementation SelectedTeamCDTVC

UIView *greyOutView;
UIView *matchDetailView;

CGRect selectedCellRect;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *matchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    matchRequest.predicate = [NSPredicate predicateWithFormat:@"teamNum.name = %@", self.teamToDisplay];
    matchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"teamNum.regionalIn.name" ascending:YES selector:@selector(localizedStandardCompare:)], [[NSSortDescriptor alloc] initWithKey:@"matchNum" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:matchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:@"teamNum.regionalIn.name"
                                     cacheName:nil];
}

-(void)setTeamToDisplay:(NSString *)teamToDisplay{
    _teamToDisplay = teamToDisplay;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleTeamMatchCell *cell = (SingleTeamMatchCell *)[tableView dequeueReusableCellWithIdentifier:@"singleTeamCell"];
    
    Match *mtch = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([mtch.matchType isEqualToString:@"Q"]) {
        cell.titleLbl.text = [[NSString alloc] initWithFormat:@"%@ - Q", mtch.matchNum];
    }
    else{
        cell.titleLbl.text = mtch.matchNum;
    }
    
    
    
    NSInteger autoTotal = 0;
    autoTotal += [mtch.autoHighHotScore integerValue]*20;
    autoTotal += [mtch.autoHighNotScore integerValue]*15;
    autoTotal += [mtch.autoLowHotScore integerValue]*11;
    autoTotal += [mtch.autoLowNotScore integerValue]*6;
    autoTotal += [mtch.mobilityBonus integerValue]*5;
    
    NSInteger teleopTotal = 0;
    teleopTotal += [mtch.teleopHighMake integerValue]*10;
    teleopTotal += [mtch.teleopLowMake integerValue];
    teleopTotal += [mtch.teleopOver integerValue]*10;
    teleopTotal += [mtch.teleopCatch integerValue]*10;
    
    float autoShotsMade = 0;
    autoShotsMade += [mtch.autoHighHotScore floatValue];
    autoShotsMade += [mtch.autoHighNotScore floatValue];
    autoShotsMade += [mtch.autoLowHotScore floatValue];
    autoShotsMade += [mtch.autoLowNotScore floatValue];
    
    float autoShotsMissed = 0;
    autoShotsMissed += [mtch.autoHighMissScore floatValue];
    autoShotsMissed += [mtch.autoLowMissScore floatValue];
    
    if (autoShotsMissed > 0) {
        cell.autoAccuracyLbl.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)(autoShotsMade/(autoShotsMissed+autoShotsMade)*100)];
    }
    else{
        if (autoShotsMade > 0) {
            cell.autoAccuracyLbl.text = @"100%";
        }
        else{
            cell.autoAccuracyLbl.text = @"0%";
        }
    }
    
    float teleopShotsMade = 0;
    teleopShotsMade += [mtch.teleopHighMake floatValue];
    teleopShotsMade += [mtch.teleopLowMake floatValue];
    
    float teleopShotsMissed = 0;
    teleopShotsMissed += [mtch.teleopHighMiss floatValue];
    teleopShotsMissed += [mtch.teleopLowMiss floatValue];
    
    if (teleopShotsMissed > 0) {
        cell.teleopAccuracyLbl.text = [[NSString alloc] initWithFormat:@"%.0f%%", (float)(teleopShotsMade/(teleopShotsMissed+teleopShotsMade)*100)];
    }
    else{
        if (teleopShotsMade > 0) {
            cell.teleopAccuracyLbl.text = @"100%";
        }
        else{
            cell.teleopAccuracyLbl.text = @"0%";
        }
    }
    
    cell.autoLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoTotal];
    cell.teleopLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopTotal];
    cell.passReceiveLbl.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (long)[mtch.teleopPassed integerValue], (long)[mtch.teleopReceived integerValue]];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.userInteractionEnabled = false;
    Match *matchSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    selectedCellRect = [self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPath] toView:[[self.tableView superview] superview]];
    
    greyOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    greyOutView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [[[self.tableView superview] superview] addSubview:greyOutView];
    
    matchDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    matchDetailView.layer.cornerRadius = 10;
    matchDetailView.backgroundColor = [UIColor whiteColor];
    [greyOutView addSubview:matchDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 15, 400, 30)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20];
    if ([matchSelected.matchType isEqualToString:@"Q"]) {
        titleLbl.text = [[NSString alloc] initWithFormat:@"Qualification Match %@", matchSelected.matchNum];
    }
    else{
        titleLbl.text = matchSelected.matchNum;
    }
    
    UIView *autoStatBox = [[UIView alloc] initWithFrame:CGRectMake(40, 60, 470, 150)];
    autoStatBox.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:0.3];
    autoStatBox.layer.cornerRadius = 5;
    
    UILabel *autoTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 90, 20)];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    autoTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:@"Autonomous"
                                                             attributes:underlineAttribute];
    autoTitleLbl.textAlignment = NSTextAlignmentCenter;
    autoTitleLbl.font = [UIFont systemFontOfSize:14];
    [autoStatBox addSubview:autoTitleLbl];
    
    UILabel *autoHighHotLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 92, 25)];
    autoHighHotLbl.font = [UIFont systemFontOfSize:17];
    autoHighHotLbl.text = @"High Hot:";
    [autoStatBox addSubview:autoHighHotLbl];
    
    UILabel *autoHighHotCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(106, 30, 30, 25)];
    autoHighHotCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoHighHotScore];
    autoHighHotCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoHighHotCountLbl];
    
    UILabel *autoHighNotLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 57, 92, 25)];
    autoHighNotLbl.font = [UIFont systemFontOfSize:17];
    autoHighNotLbl.text = @"High Not:";
    [autoStatBox addSubview:autoHighNotLbl];
    
    UILabel *autoHighNotCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(106, 57, 30, 25)];
    autoHighNotCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoHighNotScore];
    autoHighNotCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoHighNotCountLbl];
    
    UILabel *autoHighMissedLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 84, 115, 25)];
    autoHighMissedLbl.font = [UIFont systemFontOfSize:17];
    autoHighMissedLbl.text = @"High Missed:";
    [autoStatBox addSubview:autoHighMissedLbl];
    
    UILabel *autoHighMissedCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(133, 84, 30, 25)];
    autoHighMissedCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoHighMissScore];
    autoHighMissedCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoHighMissedCountLbl];
    
    UILabel *autoLowHotLbl = [[UILabel alloc] initWithFrame:CGRectMake(315, 30, 92, 25)];
    autoLowHotLbl.font = [UIFont systemFontOfSize:17];
    autoLowHotLbl.text = @"Low Hot:";
    [autoStatBox addSubview:autoLowHotLbl];
    
    UILabel *autoLowHotCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(388, 30, 30, 25)];
    autoLowHotCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoLowHotScore];
    autoLowHotCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoLowHotCountLbl];
    
    UILabel *autoLowNotLbl = [[UILabel alloc] initWithFrame:CGRectMake(315, 57, 92, 25)];
    autoLowNotLbl.font = [UIFont systemFontOfSize:17];
    autoLowNotLbl.text = @"Low Not:";
    [autoStatBox addSubview:autoLowNotLbl];
    
    UILabel *autoLowNotCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(388, 57, 30, 25)];
    autoLowNotCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoLowNotScore];
    autoLowNotCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoLowNotCountLbl];
    
    UILabel *autoLowMissedLbl = [[UILabel alloc] initWithFrame:CGRectMake(315, 84, 115, 25)];
    autoLowMissedLbl.font = [UIFont systemFontOfSize:17];
    autoLowMissedLbl.text = @"Low Missed:";
    [autoStatBox addSubview:autoLowMissedLbl];
    
    UILabel *autoLowMissedCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(414, 84, 30, 25)];
    autoLowMissedCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.autoLowMissScore];
    autoLowMissedCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:autoLowMissedCountLbl];
    
    UILabel *mobilityBonusLbl = [[UILabel alloc] initWithFrame:CGRectMake(148, 114, 120, 25)];
    mobilityBonusLbl.text = @"Mobility Bonus:";
    mobilityBonusLbl.font = [UIFont systemFontOfSize:17];
    [autoStatBox addSubview:mobilityBonusLbl];
    
    UILabel *mobilityBonusValue = [[UILabel alloc] initWithFrame:CGRectMake(273, 114, 40, 25)];
    if ([matchSelected.mobilityBonus integerValue] == 1) {
        mobilityBonusValue.backgroundColor = [UIColor greenColor];
        mobilityBonusValue.textColor = [UIColor whiteColor];
        mobilityBonusValue.text = @"Yes";
    }
    else{
        mobilityBonusValue.backgroundColor = [UIColor redColor];
        mobilityBonusValue.textColor = [UIColor whiteColor];
        mobilityBonusValue.text = @"No";
    }
    mobilityBonusValue.textAlignment = NSTextAlignmentCenter;
    mobilityBonusValue.layer.cornerRadius = 5;
    mobilityBonusValue.font = [UIFont boldSystemFontOfSize:19];
    [autoStatBox addSubview:mobilityBonusValue];
    
    UIView *teleopStatBox = [[UIView alloc] initWithFrame:CGRectMake(40, 225, 470, 210)];
    teleopStatBox.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:0.3];
    teleopStatBox.layer.cornerRadius = 5;
    
    UILabel *teleopTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 90, 20)];
    teleopTitleLbl.attributedText = [[NSAttributedString alloc] initWithString:@"Teleop"
                                                                    attributes:underlineAttribute];
    teleopTitleLbl.textAlignment = NSTextAlignmentCenter;
    teleopTitleLbl.font = [UIFont systemFontOfSize:14];
    [teleopStatBox addSubview:teleopTitleLbl];
    
    UILabel *teleopHighMadeLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 92, 25)];
    teleopHighMadeLbl.font = [UIFont systemFontOfSize:17];
    teleopHighMadeLbl.text = @"High Made:";
    [teleopHighMadeLbl sizeToFit];
    [teleopStatBox addSubview:teleopHighMadeLbl];
    
    UILabel *teleopHighMadeCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopHighMadeLbl.center.x + teleopHighMadeLbl.frame.size.width/2 + 2, 30, 30, 25)];
    teleopHighMadeCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopHighMake];
    teleopHighMadeCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopHighMadeCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopHighMadeCountLbl];
    
    UILabel *teleopHighMissedLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, 104, 25)];
    teleopHighMissedLbl.font = [UIFont systemFontOfSize:17];
    teleopHighMissedLbl.text = @"High Missed:";
    [teleopHighMissedLbl sizeToFit];
    [teleopStatBox addSubview:teleopHighMissedLbl];
    
    UILabel *teleopHighMissedCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopHighMissedLbl.center.x + teleopHighMissedLbl.frame.size.width/2 + 2, 59, 30, 25)];
    teleopHighMissedCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopHighMiss];
    teleopHighMissedCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopHighMissedCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopHighMissedCountLbl];
    
    UILabel *teleopOverLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 104, 25)];
    teleopOverLbl.font = [UIFont systemFontOfSize:17];
    teleopOverLbl.text = @"Over Truss:";
    [teleopOverLbl sizeToFit];
    [teleopStatBox addSubview:teleopOverLbl];
    
    UILabel *teleopOverCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopOverLbl.center.x + teleopOverLbl.frame.size.width/2 + 2, 99, 30, 25)];
    teleopOverCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopOver];
    teleopOverCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopOverCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopOverCountLbl];
    
    UILabel *teleopCatchLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 130, 104, 25)];
    teleopCatchLbl.font = [UIFont systemFontOfSize:17];
    teleopCatchLbl.text = @"Truss Catch:";
    [teleopCatchLbl sizeToFit];
    [teleopStatBox addSubview:teleopCatchLbl];
    
    UILabel *teleopCatchCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopCatchLbl.center.x + teleopCatchLbl.frame.size.width/2 + 2, 129, 30, 25)];
    teleopCatchCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopCatch];
    teleopCatchCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopCatchCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopCatchCountLbl];
    
    UILabel *teleopLowMadeLbl = [[UILabel alloc] initWithFrame:CGRectMake(295, 30, 92, 25)];
    teleopLowMadeLbl.font = [UIFont systemFontOfSize:17];
    teleopLowMadeLbl.text = @"Low Made:";
    [teleopLowMadeLbl sizeToFit];
    [teleopStatBox addSubview:teleopLowMadeLbl];
    
    UILabel *teleopLowMadeCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopLowMadeLbl.center.x + teleopLowMadeLbl.frame.size.width/2 + 2, 30, 30, 25)];
    teleopLowMadeCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopLowMake];
    teleopLowMadeCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopLowMadeCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopLowMadeCountLbl];
    
    UILabel *teleopLowMissedLbl = [[UILabel alloc] initWithFrame:CGRectMake(295, 60, 104, 25)];
    teleopLowMissedLbl.font = [UIFont systemFontOfSize:17];
    teleopLowMissedLbl.text = @"Low Missed:";
    [teleopLowMissedLbl sizeToFit];
    [teleopStatBox addSubview:teleopLowMissedLbl];
    
    UILabel *teleopLowMissedCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopLowMissedLbl.center.x + teleopLowMissedLbl.frame.size.width/2 + 2, 59, 30, 25)];
    teleopLowMissedCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopLowMiss];
    teleopLowMissedCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopLowMissedCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopLowMissedCountLbl];
    
    UILabel *teleopPassLbl = [[UILabel alloc] initWithFrame:CGRectMake(295, 100, 104, 25)];
    teleopPassLbl.font = [UIFont systemFontOfSize:17];
    teleopPassLbl.text = @"Pass Count:";
    [teleopPassLbl sizeToFit];
    [teleopStatBox addSubview:teleopPassLbl];
    
    UILabel *teleopPassCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopPassLbl.center.x + teleopPassLbl.frame.size.width/2 + 2, 99, 30, 25)];
    teleopPassCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopPassed];
    teleopPassCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopPassCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopPassCountLbl];
    
    UILabel *teleopReceivedLbl = [[UILabel alloc] initWithFrame:CGRectMake(295, 130, 104, 25)];
    teleopReceivedLbl.font = [UIFont systemFontOfSize:17];
    teleopReceivedLbl.text = @"Received Count:";
    [teleopReceivedLbl sizeToFit];
    [teleopStatBox addSubview:teleopReceivedLbl];
    
    UILabel *teleopReceivedCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopReceivedLbl.center.x + teleopReceivedLbl.frame.size.width/2 + 2, 129, 30, 25)];
    teleopReceivedCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.teleopReceived];
    teleopReceivedCountLbl.font = [UIFont boldSystemFontOfSize:19];
    [teleopReceivedCountLbl sizeToFit];
    [teleopStatBox addSubview:teleopReceivedCountLbl];
    
    UILabel *smallPenaltyLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 104, 25)];
    smallPenaltyLbl.font = [UIFont systemFontOfSize:17];
    smallPenaltyLbl.text = @"Small Penalties:";
    [smallPenaltyLbl sizeToFit];
    [teleopStatBox addSubview:smallPenaltyLbl];
    
    UILabel *smallPenaltyCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(smallPenaltyLbl.center.x + smallPenaltyLbl.frame.size.width/2 + 2, 169, 30, 25)];
    smallPenaltyCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.penaltySmall];
    smallPenaltyCountLbl.font = [UIFont boldSystemFontOfSize:19];
    smallPenaltyCountLbl.textColor = [UIColor redColor];
    [smallPenaltyCountLbl sizeToFit];
    [teleopStatBox addSubview:smallPenaltyCountLbl];
    
    UILabel *largePenaltyLbl = [[UILabel alloc] initWithFrame:CGRectMake(295, 170, 104, 25)];
    largePenaltyLbl.font = [UIFont systemFontOfSize:17];
    largePenaltyLbl.text = @"Large Penalties:";
    [largePenaltyLbl sizeToFit];
    [teleopStatBox addSubview:largePenaltyLbl];
    
    UILabel *largePenaltyCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(largePenaltyLbl.center.x + largePenaltyLbl.frame.size.width/2 + 2, 169, 30, 25)];
    largePenaltyCountLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.penaltyLarge];
    largePenaltyCountLbl.font = [UIFont boldSystemFontOfSize:19];
    largePenaltyCountLbl.textColor = [UIColor redColor];
    [largePenaltyCountLbl sizeToFit];
    [teleopStatBox addSubview:largePenaltyCountLbl];
    
    NSArray *splitNotes = [matchSelected.notes componentsSeparatedByString:@"{}"];
    
    UILabel *notesLbl = [[UILabel alloc] initWithFrame:CGRectMake(140, 443, 70, 15)];
    notesLbl.text = @"Notes";
    notesLbl.textAlignment = NSTextAlignmentCenter;
    notesLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    notesLbl.font = [UIFont systemFontOfSize:14];
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(50, 460, 250, 75)];
    notesView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    notesView.layer.borderWidth = 1;
    notesView.layer.cornerRadius = 5;
    notesView.textAlignment = NSTextAlignmentCenter;
    notesView.text = [[NSString alloc] initWithFormat:@"%@", [splitNotes lastObject]];
    
    UILabel *allianceInLbl = [[UILabel alloc] initWithFrame:CGRectMake(350, 455, 90, 20)];
    allianceInLbl.text = @"Alliance In: ";
    allianceInLbl.font = [UIFont systemFontOfSize:16];
    [allianceInLbl sizeToFit];
    
    UILabel *allianceInValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(allianceInLbl.frame.origin.x + allianceInLbl.frame.size.width + 2, allianceInLbl.frame.origin.y, 30, 20)];
    NSString *allianceString = @"";
    if ([[matchSelected.red1Pos substringToIndex:1] isEqualToString:@"R"]) {
        allianceString = @"Red";
        allianceInValueLbl.textColor = [UIColor redColor];
    }
    else{
        allianceString = @"Blue";
        allianceInValueLbl.textColor = [UIColor blueColor];
    }
    allianceInValueLbl.font = [UIFont boldSystemFontOfSize:17];
    allianceInValueLbl.text = allianceString;
    [allianceInValueLbl sizeToFit];
    
    UILabel *zonesHungOutInLbl = [[UILabel alloc] initWithFrame:CGRectMake(330, 485, 165, 17)];
    zonesHungOutInLbl.textAlignment = NSTextAlignmentCenter;
    zonesHungOutInLbl.text = @"Zones Hung Out In";
    zonesHungOutInLbl.font = [UIFont systemFontOfSize:14];
    
    NSInteger redZoneX = 330;
    
    UIView *redZone = [[UIView alloc] initWithFrame:CGRectMake(redZoneX, 505, 55, 30)];
    redZone.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3];
    UILabel *redZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    redZoneLabel.textAlignment = NSTextAlignmentCenter;
    redZoneLabel.textColor = [UIColor whiteColor];
    redZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    redZoneLabel.text = @"Red";
    [redZone addSubview:redZoneLabel];
    if ([[splitNotes firstObject] rangeOfString:@"Red"].location != NSNotFound) {
        redZone.backgroundColor = [UIColor redColor];
    }
    
    redZoneX+=55;
    UIView *whiteZone = [[UIView alloc] initWithFrame:CGRectMake(redZoneX, 505, 55, 30)];
    whiteZone.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    UILabel *whiteZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    whiteZoneLabel.textAlignment = NSTextAlignmentCenter;
    whiteZoneLabel.textColor = [UIColor whiteColor];
    whiteZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    whiteZoneLabel.text = @"White";
    [whiteZone addSubview:whiteZoneLabel];
    if ([[splitNotes firstObject] rangeOfString:@"White"].location != NSNotFound) {
        whiteZone.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    }
    
    redZoneX+=55;
    UIView *blueZone = [[UIView alloc] initWithFrame:CGRectMake(redZoneX, 505, 55, 30)];
    blueZone.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.3];
    UILabel *blueZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    blueZoneLabel.textAlignment = NSTextAlignmentCenter;
    blueZoneLabel.textColor = [UIColor whiteColor];
    blueZoneLabel.font = [UIFont boldSystemFontOfSize:16];
    blueZoneLabel.text = @"Blue";
    [blueZone addSubview:blueZoneLabel];
    if ([[splitNotes firstObject] rangeOfString:@"Blue"].location != NSNotFound) {
        blueZone.backgroundColor = [UIColor blueColor];
    }
    
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
    
    UILabel *whoRecordedLbl = [[UILabel alloc] initWithFrame:CGRectMake(140, 570, 104, 25)];
    whoRecordedLbl.font = [UIFont systemFontOfSize:17];
    whoRecordedLbl.text = @"Recorded by";
    [whoRecordedLbl sizeToFit];
    
    UILabel *whoRecordedValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(whoRecordedLbl.center.x + whoRecordedLbl.frame.size.width/2 + 3, whoRecordedLbl.frame.origin.y-1, 30, 25)];
    whoRecordedValueLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.scoutInitials];
    whoRecordedValueLbl.font = [UIFont boldSystemFontOfSize:19];
    [whoRecordedValueLbl sizeToFit];
    
    UILabel *teamRecordedLbl = [[UILabel alloc] initWithFrame:CGRectMake(whoRecordedValueLbl.center.x + whoRecordedValueLbl.frame.size.width/2 + 4, whoRecordedValueLbl.frame.origin.y + 1, 104, 25)];
    teamRecordedLbl.font = [UIFont systemFontOfSize:17];
    teamRecordedLbl.text = @"from team ";
    [teamRecordedLbl sizeToFit];
    
    UILabel *teamRecordedValueLbl = [[UILabel alloc] initWithFrame:CGRectMake(teamRecordedLbl.center.x + teamRecordedLbl.frame.size.width/2 + 2, teamRecordedLbl.frame.origin.y-1, 30, 25)];
    teamRecordedValueLbl.text = [[NSString alloc] initWithFormat:@"%@", matchSelected.recordingTeam];
    teamRecordedValueLbl.font = [UIFont boldSystemFontOfSize:19];
    [teamRecordedValueLbl sizeToFit];
    
    matchDetailView.frame = CGRectMake(selectedCellRect.origin.x + 364, selectedCellRect.origin.y + 30, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        matchDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [matchDetailView addSubview:closeButton];
        [matchDetailView addSubview:titleLbl];
        [matchDetailView addSubview:autoStatBox];
        [matchDetailView addSubview:teleopStatBox];
        [matchDetailView addSubview:notesLbl];
        [matchDetailView addSubview:notesView];
        [matchDetailView addSubview:allianceInLbl];
        [matchDetailView addSubview:allianceInValueLbl];
        [matchDetailView addSubview:zonesHungOutInLbl];
        [matchDetailView addSubview:redZone];
        [matchDetailView addSubview:whiteZone];
        [matchDetailView addSubview:blueZone];
        [matchDetailView addSubview:whoRecordedLbl];
        [matchDetailView addSubview:whoRecordedValueLbl];
        [matchDetailView addSubview:teamRecordedLbl];
        [matchDetailView addSubview:teamRecordedValueLbl];
        
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)closeDetailView{
    for (UIView *v in [matchDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        matchDetailView.frame = CGRectMake(selectedCellRect.origin.x + 364, selectedCellRect.origin.y + 30, 1, 1);
    } completion:^(BOOL finished) {
        [matchDetailView removeFromSuperview];
        [greyOutView removeFromSuperview];
        self.tableView.userInteractionEnabled = true;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self closeDetailView];
}

@end
