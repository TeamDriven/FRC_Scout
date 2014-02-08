//
//  SingleTeamCDTVC.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SingleTeamCDTVC.h"
#import "SingleTeamCell.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"
#import "PitTeam.h"

@implementation SingleTeamCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *teamRequest = [[NSFetchRequest alloc] initWithEntityName:@"Team"];
    teamRequest.predicate = nil;
    teamRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:teamRequest
                                     managedObjectContext:managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleTeamCell *cell = (SingleTeamCell *)[tableView dequeueReusableCellWithIdentifier:@"singleTeamCell"];
    
    Team *tm = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSFetchRequest *pitTeamRequest = [[NSFetchRequest alloc] initWithEntityName:@"PitTeam"];
    pitTeamRequest.predicate = [NSPredicate predicateWithFormat:@"teamNumber = %@", [tm valueForKey:@"teamNumber"]];
    NSError *pitTeamError;
    NSArray *pitTeamArray = [self.managedObjectContext executeFetchRequest:pitTeamRequest error:&pitTeamError];
    PitTeam *pt = [pitTeamArray firstObject];
    
    cell.robotImage.image = [UIImage imageWithData:[pt valueForKey:@"image"]];
    
    cell.teamNumberLbl.text = tm.name;
    cell.teamNameLbl.text = pt.teamName;
    
    NSArray *matches = [tm.matches allObjects];
    
    float autoTotal = 0;
    float teleopTotal = 0;
    for (Match *mtch in matches) {
        autoTotal += [mtch.autoHighHotScore floatValue]*20;
        autoTotal += [mtch.autoHighNotScore floatValue]*15;
        autoTotal += [mtch.autoLowHotScore floatValue]*11;
        autoTotal += [mtch.autoLowNotScore floatValue]*6;
        autoTotal += [mtch.mobilityBonus floatValue]*5;
        teleopTotal += [mtch.teleopHighMake floatValue]*10;
        teleopTotal += [mtch.teleopLowMake floatValue];
        teleopTotal += [mtch.teleopCatch floatValue]*10;
        teleopTotal += [mtch.teleopOver floatValue]*10;
    }
    float autoAvg = 0;
    float teleopAvg = 0;
    autoAvg = (float)autoTotal/(float)[matches count];
    teleopAvg = (float)teleopTotal/(float)[matches count];
    
    cell.autoAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    cell.teleopAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    
    
    return cell;
}

@end







