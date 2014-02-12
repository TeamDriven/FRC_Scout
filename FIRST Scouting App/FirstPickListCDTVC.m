//
//  FirstPickListCDTVC.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/11/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "FirstPickListCDTVC.h"
#import "AlliancePickListCell.h"
#import "Team.h"
#import "Regional.h"
#import "Match.h"
#import "PitTeam.h"

@implementation FirstPickListCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *firstPickListRequest = [[NSFetchRequest alloc] initWithEntityName:@"Team"];
    firstPickListRequest.predicate = [NSPredicate predicateWithFormat:@"firstPickListRegional.name = %@", _regionalToDisplay];
    firstPickListRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:firstPickListRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)setRegionalToDisplay:(NSString *)regionalToDisplay{
    _regionalToDisplay = regionalToDisplay;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"firstPickCell"];
    
    Team *tm = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.teamNum.text = tm.name;
    
    float autoTotal = 0;
    float teleopTotal = 0;
    float totalMatches = 0;
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
        totalMatches++;
    }
    
    
    float autoAvg = 0;
    float teleopAvg = 0;
    autoAvg = (float)autoTotal/(float)totalMatches;
    teleopAvg = (float)teleopTotal/(float)totalMatches;
    
    cell.autoAvg.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    cell.teleopAvg.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
     return cell;
}

@end
