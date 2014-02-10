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
    matchRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"teamNum.name = %@", self.teamToDisplay]];
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
    autoStatBox.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:0.2];
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
    
    UIView *teleopStatBox = [[UIView alloc] initWithFrame:CGRectMake(40, 230, 470, 210)];
    teleopStatBox.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:0.2];
    teleopStatBox.layer.cornerRadius = 5;
    
    matchDetailView.frame = CGRectMake(selectedCellRect.origin.x + 364, selectedCellRect.origin.y + 30, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        matchDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [matchDetailView addSubview:closeButton];
        [matchDetailView addSubview:titleLbl];
        [matchDetailView addSubview:autoStatBox];
        [matchDetailView addSubview:teleopStatBox];
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
