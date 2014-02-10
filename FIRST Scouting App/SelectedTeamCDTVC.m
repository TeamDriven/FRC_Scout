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

@end