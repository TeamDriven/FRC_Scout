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
#import "AlliancePickListCell.h"
#import "Team.h"
#import "Team+Category.h"
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

UIView *greayOutView;
UIView *listSelectorView;
UIButton *firstListBtn;
UIButton *secondListBtn;

Team *teamSelected;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *poolRequest = [[NSFetchRequest alloc] initWithEntityName:@"Team"];
    poolRequest.predicate = [NSPredicate predicateWithFormat:@"regionalIn.name = %@", _regionalToDisplay];
    poolRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:poolRequest
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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
    teamSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    greayOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    greayOutView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [[[self.view superview] superview] addSubview:greayOutView];
    
    listSelectorView = [[UIView alloc] initWithFrame:CGRectMake(234, 400, 300, 75)];
    listSelectorView.backgroundColor = [UIColor whiteColor];
    listSelectorView.layer.cornerRadius = 10;
    [greayOutView addSubview:listSelectorView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(255, 0, 40, 20);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeListSelectorView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:11];
    
    firstListBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    firstListBtn.frame = CGRectMake(10, 25, 135, 35);
    [firstListBtn setTitle:@"Add to First Pick List" forState:UIControlStateNormal];
    [firstListBtn addTarget:self action:@selector(addToFirstPickList) forControlEvents:UIControlEventTouchUpInside];
    firstListBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    firstListBtn.layer.cornerRadius = 5;
    firstListBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    if ([self.firstPickListController.firstPickList containsObject:teamSelected]) {
        firstListBtn.enabled = false;
    }
    else{
        firstListBtn.enabled = true;
    }
    
    secondListBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    secondListBtn.frame = CGRectMake(155, 25, 135, 35);
    [secondListBtn setTitle:@"Add to Second Pick List" forState:UIControlStateNormal];
    [secondListBtn addTarget:self action:@selector(addToSecondPickList) forControlEvents:UIControlEventTouchUpInside];
    secondListBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    secondListBtn.layer.cornerRadius = 5;
    secondListBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    if ([self.secondPickListController.secondPickList containsObject:teamSelected]) {
        secondListBtn.enabled = false;
    }
    else{
        secondListBtn.enabled = true;
    }
    
    listSelectorView.transform = CGAffineTransformMakeScale(.01, .01);
    [UIView animateWithDuration:0.2 animations:^{
        listSelectorView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [listSelectorView addSubview:closeButton];
        [listSelectorView addSubview:firstListBtn];
        [listSelectorView addSubview:secondListBtn];
    }];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)closeListSelectorView{
    [UIView animateWithDuration:0.2 animations:^{
        listSelectorView.transform = CGAffineTransformMakeScale(.01, .01);
    } completion:^(BOOL finished) {
        [listSelectorView removeFromSuperview];
        [greayOutView removeFromSuperview];
        teamSelected = nil;
    }];
}

-(void)addToFirstPickList{
    if (![self.firstPickListController.firstPickList containsObject:teamSelected]) {
        [self.firstPickListController insertNewTeamIntoFirstPickList:teamSelected];
        firstListBtn.enabled = false;
    }
}

-(void)addToSecondPickList{
    if (![self.secondPickListController.secondPickList containsObject:teamSelected]) {
        [self.secondPickListController insertNewTeamIntoSecondPickList:teamSelected];
        secondListBtn.enabled = false;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self closeListSelectorView];
}








@end












