//
//  RegionalPoolCDTVC.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/11/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "RegionalPoolCDTVC.h"
#import "Globals.h"
#import "AllianceSelectionPoolCell.h"
#import "Team.h"
#import "Regional.h"
#import "Match.h"
#import "PitTeam.h"

@implementation RegionalPoolCDTVC

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *poolRequest = [[NSFetchRequest alloc] initWithEntityName:@"Team"];
    poolRequest.predicate = [NSPredicate predicateWithFormat:@"regionalIn.name = %@", _regionalToDisplay];
    poolRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:poolRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)setRegionalToDisplay:(NSString *)regionalToDisplay{
    _regionalToDisplay = regionalToDisplay;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AllianceSelectionPoolCell *cell = (AllianceSelectionPoolCell *)[tableView dequeueReusableCellWithIdentifier:@"poolCell"];
    
    Team *tm = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.teamNumLbl.text = tm.name;
    
    float autoTotal = 0;
    float teleopTotal = 0;
    float totalMatches = 0;
    float totalPasses = 0;
    float totalReceives = 0;
    float totalOvers = 0;
    float totalCatches = 0;
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
        totalPasses += [mtch.teleopPassed floatValue];
        totalReceives += [mtch.teleopReceived floatValue];
        totalOvers += [mtch.teleopOver floatValue];
        totalCatches += [mtch.teleopCatch floatValue];
        totalMatches++;
    }
    
    
    float autoAvg = 0;
    float teleopAvg = 0;
    float passAvg = 0;
    float receiveAvg = 0;
    float overAvg = 0;
    float catchAvg = 0;
    autoAvg = (float)autoTotal/(float)totalMatches;
    teleopAvg = (float)teleopTotal/(float)totalMatches;
    passAvg = (float)totalPasses/(float)totalMatches;
    receiveAvg = (float)totalReceives/(float)totalMatches;
    overAvg = (float)totalOvers/(float)totalMatches;
    catchAvg = (float)totalCatches/(float)totalMatches;
    
    cell.autoAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    cell.teleopAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    cell.passesReceivesLbl.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f", passAvg, receiveAvg];
    cell.overTrussLbl.text = [[NSString alloc] initWithFormat:@"%.1f", overAvg];
    cell.trussCatchLbl.text = [[NSString alloc] initWithFormat:@"%.1f", catchAvg];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Team *teamSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
//    if (!teamSelected.firstPickListRegional) {
//        [self.managedObjectContext performBlock:^{
//            
//            [teamSelected.regionalIn insertObject:teamSelected inFirstPickListAtIndex:[teamSelected.regionalIn.firstPickList count]];
//            
//            NSLog(@"Inserted team %@ in First Pick List at Index: %ld", teamSelected.name, (long)[teamSelected.regionalIn.firstPickList count]);
//            
//            [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
//        }];
//        
//    }
    

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}











@end












