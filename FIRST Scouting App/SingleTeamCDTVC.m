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
#import "MasterTeam.h"

@implementation SingleTeamCDTVC

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    
    
    NSFetchRequest *teamRequest = [[NSFetchRequest alloc] initWithEntityName:@"MasterTeam"];
    teamRequest.predicate = [NSPredicate predicateWithFormat:@"teamsWithin.@count > 0"];
    teamRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:teamRequest
                                     managedObjectContext:managedObjectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
}

-(void)setTextField:(UITextField *)textField{
    _textField = textField;
    
    [_textField addTarget:self action:@selector(searching) forControlEvents:UIControlEventEditingChanged];
}

-(void)searching{
    NSFetchRequest *numberRequest = [[NSFetchRequest alloc] initWithEntityName:@"MasterTeam"];
    if (_textField.text.length == 0){
        numberRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
        [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:numberRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
    }
    else{
        numberRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@", _textField.text];
        numberRequest.predicate = predicate;
        [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:numberRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
    }
    [self performFetch];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleTeamCell *cell = (SingleTeamCell *)[tableView dequeueReusableCellWithIdentifier:@"singleTeamCell"];
    
    MasterTeam *mt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.robotImage.image = [UIImage imageWithData:mt.pitTeam.image];
    
    cell.teamNumberLbl.text = mt.name;
    cell.teamNameLbl.text = mt.pitTeam.teamName;
    
    float autoTotal = 0;
    float teleopTotal = 0;
    float totalMatches = 0;
    for (Team *tm in mt.teamsWithin) {
        NSArray *matches = [tm.matches allObjects];
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
            totalMatches++;
        }
    }
    
    
    float autoAvg = 0;
    float teleopAvg = 0;
    autoAvg = (float)autoTotal/(float)totalMatches;
    teleopAvg = (float)teleopTotal/(float)totalMatches;
    
    cell.autoAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    cell.teleopAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_textField resignFirstResponder];
    
    SingleTeamCell *selectedCell = (SingleTeamCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    teamNumber = selectedCell.teamNumberLbl.text;
    teamName = selectedCell.teamNameLbl.text;
}

@end







