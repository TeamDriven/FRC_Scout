//
//  AllianceSelection.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "AllianceSelection.h"
#import "AlliancePickListCell.h"
#import "RegionalPoolCDTVC.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"

@interface AllianceSelection ()

@end

@implementation AllianceSelection

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSString *regionalSelected;
Regional *regionalObject;

NSMutableArray *firstPickArray;
NSMutableArray *secondPickArray;

RegionalPoolCDTVC *regionalPoolCDTVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _poolTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _poolTableView.layer.borderWidth = 1;
    _poolTableView.layer.cornerRadius = 5;
    _poolTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _firstPickTableView.delegate = self;
    _firstPickTableView.dataSource = self;
    _firstPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _firstPickTableView.layer.borderWidth = 1;
    _firstPickTableView.layer.cornerRadius = 5;
    _firstPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _secondPickTableView.delegate = self;
    _secondPickTableView.dataSource = self;
    _secondPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _secondPickTableView.layer.borderWidth = 1;
    _secondPickTableView.layer.cornerRadius = 5;
    _secondPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    secondPickArray = [[NSMutableArray alloc] initWithArray:@[@[@"1730", @"22", @"11"], @[@"1986", @"44", @"0"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    regionalPoolCDTVC = [[RegionalPoolCDTVC alloc] init];
    [regionalPoolCDTVC setRegionalToDisplay:regionalSelected];
    [regionalPoolCDTVC setManagedObjectContext:context];
    [regionalPoolCDTVC setBigView:self];
    _poolTableView.delegate = regionalPoolCDTVC;
    _poolTableView.dataSource = regionalPoolCDTVC;
    
    regionalPoolCDTVC.tableView = _poolTableView;
    
    [regionalPoolCDTVC performFetch];
    
    
    NSFetchRequest *regionalFetch = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    regionalFetch.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionalSelected];
    
    NSError *regionalError;
    regionalObject = [[context executeFetchRequest:regionalFetch error:&regionalError] firstObject];
    
    firstPickArray = [[NSMutableArray alloc] initWithArray:[regionalObject.firstPickList array]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_firstPickTableView]) {
        AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"secondPickCell"];
        Team *tm = [firstPickArray objectAtIndex:indexPath.row];
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
        
        return cell;
    }
    else if ([tableView isEqual:_secondPickTableView]){
        AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"secondPickCell"];
        cell.teamNum.text = [[secondPickArray objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.autoAvg.text = [[secondPickArray objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.teleopAvg.text = [[secondPickArray objectAtIndex:indexPath.row] objectAtIndex:2];
        return cell;
    }
    else{
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_firstPickTableView]) {
        if (indexPath.row > firstPickArray.count) {
            return UITableViewCellEditingStyleNone;
        }
        else{
            return UITableViewCellEditingStyleDelete;
        }
    }
    else if ([tableView isEqual:_secondPickTableView]){
        if (indexPath.row > secondPickArray.count) {
            return UITableViewCellEditingStyleNone;
        }
        else{
            return UITableViewCellEditingStyleDelete;
        }
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_firstPickTableView]) {
        return [firstPickArray count];
    }
    else if ([tableView isEqual:_secondPickTableView]){
        return [secondPickArray count];
    }
    else{
        return 0;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_firstPickTableView] || [tableView isEqual:_secondPickTableView]) {
        return YES;
    }
    else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    if ([tableView isEqual:_firstPickTableView]) {
        Team *tm = [firstPickArray objectAtIndex:sourceIndexPath.row];
        [firstPickArray removeObjectAtIndex:sourceIndexPath.row];
        [firstPickArray insertObject:tm atIndex:destinationIndexPath.row];
    }
    if ([tableView isEqual:_secondPickTableView]){
        NSArray *teamToMove = [secondPickArray objectAtIndex:sourceIndexPath.row];
        [secondPickArray removeObjectAtIndex:sourceIndexPath.row];
        [secondPickArray insertObject:teamToMove atIndex:destinationIndexPath.row];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_firstPickTableView] || [tableView isEqual:_secondPickTableView]) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([tableView isEqual:_firstPickTableView]) {
            [firstPickArray removeObjectAtIndex:indexPath.row];
        }
        else if ([tableView isEqual:_secondPickTableView]){
            [secondPickArray removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)insertTeamIntoFirstPickList:(Team *)team{
    [firstPickArray insertObject:team atIndex:[firstPickArray count]];
    
    [_firstPickTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[firstPickArray count] inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (IBAction)reorderSecondPickList:(id)sender {
    if (_secondPickTableView.isEditing) {
        [_secondPickTableView setEditing:NO animated:YES];
    }
    else{
        [_secondPickTableView setEditing:YES animated:YES];
    }
}

- (IBAction)reorderFirstPickList:(id)sender {
    if (_firstPickTableView.isEditing) {
        [_firstPickTableView setEditing:NO animated:YES];
    }
    else{
        [_firstPickTableView setEditing:YES animated:YES];
    }
}

@end




