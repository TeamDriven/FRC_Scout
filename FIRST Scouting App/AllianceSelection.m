//
//  AllianceSelection.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "AllianceSelection.h"
#import "AlliancePickListCell.h"

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

NSMutableArray *firstPickArray;
NSMutableArray *secondPickArray;

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
    
    _poolTableView.delegate = self;
    _poolTableView.dataSource = self;
    
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
    
    firstPickArray = [[NSMutableArray alloc] initWithArray:@[@[@"1730", @"43", @"58"], @[@"1986", @"22", @"44"], @[@"1987", @"33", @"45"]]];
    secondPickArray = [[NSMutableArray alloc] initWithArray:@[@[@"1008", @"11", @"22"], @[@"1234", @"33", @"44"], @[@"148", @"55", @"66"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
//    [_firstPickTableView setEditing:YES animated:YES];
//    
//    [_secondPickTableView setEditing:YES animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_firstPickTableView]) {
        AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"firstPickCell"];
        cell.teamNum.text = [[firstPickArray objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.autoAvg.text = [[firstPickArray objectAtIndex:indexPath.row] objectAtIndex:1];
        cell.teleopAvg.text = [[firstPickArray objectAtIndex:indexPath.row] objectAtIndex:2];
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
        NSArray *teamToMove = [firstPickArray objectAtIndex:sourceIndexPath.row];
        [firstPickArray removeObjectAtIndex:sourceIndexPath.row];
        [firstPickArray insertObject:teamToMove atIndex:destinationIndexPath.row];
    }
    else if ([tableView isEqual:_secondPickTableView]){
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

- (IBAction)reorderFirstPickList:(id)sender {
    if (_firstPickTableView.isEditing) {
        [_firstPickTableView setEditing:NO animated:YES];
    }
    else{
        [_firstPickTableView setEditing:YES animated:YES];
    }
}
- (IBAction)reorderSecondPickList:(id)sender {
    if (_secondPickTableView.isEditing) {
        [_secondPickTableView setEditing:NO animated:YES];
    }
    else{
        [_secondPickTableView setEditing:YES animated:YES];
    }
}


@end




