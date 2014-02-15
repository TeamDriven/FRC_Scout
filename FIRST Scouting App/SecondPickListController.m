//
//  SecondPickListController.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/14/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SecondPickListController.h"

@interface SecondPickListController ()

@end

@implementation SecondPickListController

NSMutableArray *secondPickListMutable;

-(void)setSecondPickList:(NSArray *)secondPickList{
    _secondPickList = secondPickList;
    
    secondPickListMutable = [[NSMutableArray alloc] initWithArray:_secondPickList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [secondPickListMutable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"secondPickCell"];
    
    Team *tm = [secondPickListMutable objectAtIndex:indexPath.row];
    
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [secondPickListMutable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.secondPickList = secondPickListMutable;
        
        if ([secondPickListMutable count] == 0) {
            [self.tableView setEditing:NO];
        }
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    Team *teamSelected = [secondPickListMutable objectAtIndex:fromIndexPath.row];
    [secondPickListMutable removeObjectAtIndex:fromIndexPath.row];
    [secondPickListMutable insertObject:teamSelected atIndex:toIndexPath.row];
    self.secondPickList = secondPickListMutable;
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(void)insertNewTeamIntoSecondPickList:(Team *)team{
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[secondPickListMutable count] inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    
    [secondPickListMutable insertObject:team atIndex:[secondPickListMutable count]];
    
    [self.tableView endUpdates];
    
    self.secondPickList = secondPickListMutable;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end