//
//  PoolTeamMatchesCDTVC.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/15/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PoolTeamMatchesCDTVC.h"


@implementation PoolTeamMatchesCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *matchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Match"];
    matchRequest.predicate = [NSPredicate predicateWithFormat:@"teamNum.name = %@", _teamSelected.name];
    matchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"matchNum" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:matchRequest
                                     managedObjectContext:self.managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PoolMatchCell *cell = (PoolMatchCell *)[tableView dequeueReusableCellWithIdentifier:@"poolMatchCell"];
    
    if (cell == nil) {
        cell = [[PoolMatchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"poolMatchCell"];
    }
    
    Match *mtch = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.matchNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", mtch.matchNum];
    
    NSInteger autoTotal = 0;
    autoTotal += [mtch.autoHighHotScore integerValue]*20;
    autoTotal += [mtch.autoHighNotScore integerValue]*15;
    autoTotal += [mtch.autoLowHotScore integerValue]*11;
    autoTotal += [mtch.autoLowNotScore integerValue]*6;
    autoTotal += [mtch.mobilityBonus integerValue]*5;
    
    cell.autonomousValLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)autoTotal];
    [cell.autonomousValLbl sizeToFit];
    
    NSInteger teleopTotal = 0;
    teleopTotal += [mtch.teleopHighMake integerValue]*10;
    teleopTotal += [mtch.teleopLowMake integerValue];
    teleopTotal += [mtch.teleopOver integerValue]*10;
    teleopTotal += [mtch.teleopCatch integerValue]*10;
    
    cell.teleopValLbl.text = [[NSString alloc] initWithFormat:@"%ld", (long)teleopTotal];
    [cell.teleopValLbl sizeToFit];
    
    cell.passesReceivesLbl.text = [[NSString alloc] initWithFormat:@"%ld/%ld", (long)[mtch.teleopPassed integerValue], (long)[mtch.teleopCatch integerValue]];
    [cell.passesReceivesLbl sizeToFit];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}





@end














