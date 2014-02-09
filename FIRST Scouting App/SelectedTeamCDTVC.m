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
    
    cell.titleLbl.text = mtch.matchNum;
    
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
