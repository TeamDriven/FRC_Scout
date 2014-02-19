//
//  FirstPickListController.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/14/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "FirstPickListController.h"
#import "Regional.h"
#import "Globals.h"
#import "PoolTeamMatchesCDTVC.h"
#import "Team.h"
#import "Team+Category.h"
#import "MasterTeam.h"
#import "PitTeam.h"


@implementation FirstPickListController

NSMutableArray *firstPickListMutable;

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

// TeamDetailView
UIView *greayOutView;
UIView *listSelectorView;
UIButton *closeButton;
UIButton *pitDataBtn;
UILabel *tableViewLbl;
UITableView *matchesTableView;
PoolTeamMatchesCDTVC *teamMatchesCDTVC;
CGRect selectedCellRect;
UILabel *titleLbl;
UIView *averagesBox;
UIImageView *robotPic;

Team *teamSelected;

// PitData View
UIControl *grayOutview;
UIView *pitDetailView;
UIControl *imageControl;
UIImageView *robotImage;
BOOL isImageLarge;

-(void)setFirstPickList:(NSArray *)firstPickList{
    _firstPickList = firstPickList;
    
    firstPickListMutable = [[NSMutableArray alloc] initWithArray:_firstPickList];
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
    return [firstPickListMutable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlliancePickListCell *cell = (AlliancePickListCell *)[tableView dequeueReusableCellWithIdentifier:@"firstPickCell"];
    
    Team *tm = [firstPickListMutable objectAtIndex:indexPath.row];
    
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
    cell.autoAvg.adjustsFontSizeToFitWidth = true;
    cell.teleopAvg.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    cell.teleopAvg.adjustsFontSizeToFitWidth = true;
    
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
        Team *teamRemoved = [firstPickListMutable objectAtIndex:indexPath.row];
        
        [firstPickListMutable removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.firstPickList = firstPickListMutable;
        
        if ([firstPickListMutable count] == 0) {
            [self.tableView setEditing:NO];
        }
        
        teamRemoved.regionalIn.firstPickList = [NSOrderedSet orderedSetWithArray:self.firstPickList];
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Saved Correctly After Delete");
            }
            else{
                NSLog(@"Didn't Save Correctly After Delete");
            }
        }];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    Team *teamSelected = [firstPickListMutable objectAtIndex:fromIndexPath.row];
    [firstPickListMutable removeObjectAtIndex:fromIndexPath.row];
    [firstPickListMutable insertObject:teamSelected atIndex:toIndexPath.row];
    self.firstPickList = firstPickListMutable;
    
    teamSelected.regionalIn.firstPickList = [NSOrderedSet orderedSetWithArray:self.firstPickList];
    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved Correctly After Move");
        }
        else{
            NSLog(@"Didn't save after move");
        }
    }];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

-(void)insertNewTeamIntoFirstPickList:(Team *)team{
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[firstPickListMutable count] inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    
    [firstPickListMutable insertObject:team atIndex:[firstPickListMutable count]];
    
    [self.tableView endUpdates];
    
    self.firstPickList = firstPickListMutable;
    
    team.regionalIn.firstPickList = [NSOrderedSet orderedSetWithArray:self.firstPickList];
    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved Correctly After Insertion");
        }
        else{
            NSLog(@"Didn't save after insertion");
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    teamSelected = [firstPickListMutable objectAtIndex:indexPath.row];
    selectedCellRect = [self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPath] toView:[[self.tableView superview] superview]];
    
    
    greayOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    greayOutView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [[[self.view superview] superview] addSubview:greayOutView];
    
    listSelectorView = [[UIView alloc] initWithFrame:CGRectMake(84, 175, 600, 600)];
    listSelectorView.backgroundColor = [UIColor whiteColor];
    listSelectorView.layer.cornerRadius = 10;
    [greayOutView addSubview:listSelectorView];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(545, 0, 50, 30);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeListSelectorView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(250, 15, 100, 30)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:24];
    titleLbl.text = teamSelected.name;
    
    averagesBox = [[UIView alloc] initWithFrame:CGRectMake(355, 50, 180, 160)];
    averagesBox.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    averagesBox.layer.cornerRadius = 10;
    
    UILabel *averagesBoxTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 7, 100, 18)];
    averagesBoxTitleLbl.text = @"Averages";
    averagesBoxTitleLbl.font = [UIFont boldSystemFontOfSize:16];
    averagesBoxTitleLbl.adjustsFontSizeToFitWidth = true;
    averagesBoxTitleLbl.textAlignment = NSTextAlignmentCenter;
    [averagesBox addSubview:averagesBoxTitleLbl];
    
    NSInteger valueDistanceX = 3;
    NSInteger valueDistanceY = 1;
    
    UILabel *autonomousAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 80, 15)];
    autonomousAvgLbl.text = @"Autonomous:";
    autonomousAvgLbl.font = [UIFont systemFontOfSize:14];
    [autonomousAvgLbl sizeToFit];
    [averagesBox addSubview:autonomousAvgLbl];
    
    UILabel *autonomousAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.size.width + autonomousAvgLbl.frame.origin.x + valueDistanceX, autonomousAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    autonomousAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.autonomousAvgCalculated];
    autonomousAvgValue.font = [UIFont boldSystemFontOfSize:16];
    autonomousAvgValue.textColor = [UIColor orangeColor];
    [autonomousAvgValue sizeToFit];
    [averagesBox addSubview:autonomousAvgValue];
    
    
    NSInteger distanceFromPrevious = 20;
    
    UILabel *teleopAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.origin.x, autonomousAvgLbl.frame.origin.y + distanceFromPrevious, 80, 15)];
    teleopAvgLbl.text = @"Teleop:";
    teleopAvgLbl.font = [UIFont systemFontOfSize:14];
    [teleopAvgLbl sizeToFit];
    [averagesBox addSubview:teleopAvgLbl];
    
    UILabel *teleopAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(teleopAvgLbl.frame.size.width + teleopAvgLbl.frame.origin.x + valueDistanceX, teleopAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    teleopAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.teleopAvgCalculated];
    teleopAvgValue.font = [UIFont boldSystemFontOfSize:16];
    teleopAvgValue.textColor = [UIColor brownColor];
    [teleopAvgValue sizeToFit];
    [averagesBox addSubview:teleopAvgValue];
    
    
    UILabel *passesAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.origin.x, teleopAvgLbl.frame.origin.y + distanceFromPrevious, 80, 15)];
    passesAvgLbl.text = @"Passes:";
    passesAvgLbl.font = [UIFont systemFontOfSize:14];
    [passesAvgLbl sizeToFit];
    [averagesBox addSubview:passesAvgLbl];
    
    UILabel *passesAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(passesAvgLbl.frame.size.width + passesAvgLbl.frame.origin.x + valueDistanceX, passesAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    passesAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.teleopPassedAvgCalculated];
    passesAvgValue.font = [UIFont boldSystemFontOfSize:16];
    passesAvgValue.textColor = [UIColor brownColor];
    [passesAvgValue sizeToFit];
    [averagesBox addSubview:passesAvgValue];
    
    
    UILabel *receivesAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.origin.x, passesAvgLbl.frame.origin.y + distanceFromPrevious, 80, 15)];
    receivesAvgLbl.text = @"Receives:";
    receivesAvgLbl.font = [UIFont systemFontOfSize:14];
    [receivesAvgLbl sizeToFit];
    [averagesBox addSubview:receivesAvgLbl];
    
    UILabel *receivesAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(receivesAvgLbl.frame.size.width + receivesAvgLbl.frame.origin.x + valueDistanceX, receivesAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    receivesAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.teleopReceivedAvgCalculated];
    receivesAvgValue.font = [UIFont boldSystemFontOfSize:16];
    receivesAvgValue.textColor = [UIColor brownColor];
    [receivesAvgValue sizeToFit];
    [averagesBox addSubview:receivesAvgValue];
    
    
    UILabel *overTrussAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.origin.x, receivesAvgLbl.frame.origin.y + distanceFromPrevious, 80, 15)];
    overTrussAvgLbl.text = @"Over Truss:";
    overTrussAvgLbl.font = [UIFont systemFontOfSize:14];
    [overTrussAvgLbl sizeToFit];
    [averagesBox addSubview:overTrussAvgLbl];
    
    UILabel *overTrussAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(overTrussAvgLbl.frame.size.width + overTrussAvgLbl.frame.origin.x + valueDistanceX, overTrussAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    overTrussAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.teleopOverAvgCalculated];
    overTrussAvgValue.font = [UIFont boldSystemFontOfSize:16];
    overTrussAvgValue.textColor = [UIColor brownColor];
    [overTrussAvgValue sizeToFit];
    [averagesBox addSubview:overTrussAvgValue];
    
    
    UILabel *trussCatchesAvgLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousAvgLbl.frame.origin.x, overTrussAvgLbl.frame.origin.y + distanceFromPrevious, 80, 15)];
    trussCatchesAvgLbl.text = @"Truss Catches:";
    trussCatchesAvgLbl.font = [UIFont systemFontOfSize:14];
    [trussCatchesAvgLbl sizeToFit];
    [averagesBox addSubview:trussCatchesAvgLbl];
    
    UILabel *trussCatchAvgValue = [[UILabel alloc] initWithFrame:CGRectMake(trussCatchesAvgLbl.frame.size.width + trussCatchesAvgLbl.frame.origin.x + valueDistanceX, trussCatchesAvgLbl.frame.origin.y - valueDistanceY, 10, 15)];
    trussCatchAvgValue.text = [[NSString alloc] initWithFormat:@"%.1f", teamSelected.teleopCatchAvgCalculated];
    trussCatchAvgValue.font = [UIFont boldSystemFontOfSize:16];
    trussCatchAvgValue.textColor = [UIColor brownColor];
    [trussCatchAvgValue sizeToFit];
    [averagesBox addSubview:trussCatchAvgValue];
    
    pitDataBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pitDataBtn.frame = CGRectMake(110, 215, 100, 20);
    pitDataBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    pitDataBtn.layer.cornerRadius = 5;
    [pitDataBtn setTitle:@"Pit Data" forState:UIControlStateNormal];
    pitDataBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [pitDataBtn addTarget:self action:@selector(openPitData) forControlEvents:UIControlEventTouchUpInside];
    pitDataBtn.enabled = true;
    pitDataBtn.hidden = false;
    
    robotPic = [[UIImageView alloc] initWithFrame:CGRectMake(80, 50, 160, 160)];
    robotPic.image = [UIImage imageWithData:teamSelected.master.pitTeam.image];
    if (robotPic.image == nil) {
        robotPic.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        UILabel *noImageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 160, 40)];
        noImageLbl.textAlignment = NSTextAlignmentCenter;
        noImageLbl.text = @"No Image";
        noImageLbl.font = [UIFont boldSystemFontOfSize:20];
        [robotPic addSubview:noImageLbl];
        pitDataBtn.enabled = false;
        pitDataBtn.hidden = true;
    }
    
    
    
    tableViewLbl = [[UILabel alloc] initWithFrame:CGRectMake(250, 230, 100, 15)];
    tableViewLbl.text = @"Matches";
    tableViewLbl.font = [UIFont boldSystemFontOfSize:17];
    tableViewLbl.textAlignment = NSTextAlignmentCenter;
    
    matchesTableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 250, 480, 295) style:UITableViewStylePlain];
    matchesTableView.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1.0] CGColor];
    matchesTableView.layer.borderWidth = 1;
    matchesTableView.layer.cornerRadius = 5;
    matchesTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    teamMatchesCDTVC = [[PoolTeamMatchesCDTVC alloc] init];
    [teamMatchesCDTVC.tableView registerClass:[PoolMatchCell class] forCellReuseIdentifier:@"poolMatchCell"];
    [teamMatchesCDTVC setTeamSelected:teamSelected];
    [teamMatchesCDTVC setManagedObjectContext:self.managedObjectContext];
    
    matchesTableView.delegate = teamMatchesCDTVC;
    matchesTableView.dataSource = teamMatchesCDTVC;
    
    teamMatchesCDTVC.tableView = matchesTableView;
    
    listSelectorView.frame = CGRectMake(selectedCellRect.origin.x + selectedCellRect.size.width/2, selectedCellRect.origin.y + selectedCellRect.size.height/2, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        listSelectorView.frame = CGRectMake(84, 175, 600, 600);
    } completion:^(BOOL finished) {
        [listSelectorView addSubview:closeButton];
        [listSelectorView addSubview:titleLbl];
        [listSelectorView addSubview:averagesBox];
        [listSelectorView addSubview:robotPic];
        [listSelectorView addSubview:pitDataBtn];
        [listSelectorView addSubview:tableViewLbl];
        [listSelectorView addSubview:matchesTableView];
    }];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)closeListSelectorView{
    [closeButton removeFromSuperview];
    [titleLbl removeFromSuperview];
    [averagesBox removeFromSuperview];
    [robotPic removeFromSuperview];
    [pitDataBtn removeFromSuperview];
    [tableViewLbl removeFromSuperview];
    [matchesTableView removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        listSelectorView.frame = CGRectMake(selectedCellRect.origin.x + selectedCellRect.size.width/2, selectedCellRect.origin.y + selectedCellRect.size.height/2, 1, 1);
    } completion:^(BOOL finished) {
        [listSelectorView removeFromSuperview];
        [greayOutView removeFromSuperview];
        teamSelected = nil;
    }];
}

-(void)openPitData{
    PitTeam *ptSelected = teamSelected.master.pitTeam;
    
    grayOutview = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [grayOutview addTarget:self action:@selector(grayOutShrinkPic) forControlEvents:UIControlEventTouchUpInside];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [[[self.view superview] superview] addSubview:grayOutview];
    
    pitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    pitDetailView.layer.cornerRadius = 10;
    pitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:pitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 5, 60, 35);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    imageControl = [[UIControl alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    [imageControl addTarget:self action:@selector(enlargePicture) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [UIImage imageWithData:[ptSelected valueForKey:@"image"]];
    robotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    robotImage.image = image;
    [imageControl addSubview:robotImage];
    
    UILabel *driveTrainHeader = [[UILabel alloc] initWithFrame:CGRectMake(65, 225, 120, 25)];
    driveTrainHeader.text = @"Drive Train";
    driveTrainHeader.font = [UIFont boldSystemFontOfSize:15];
    driveTrainHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 190, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.driveTrain];
    driveTrainLbl.adjustsFontSizeToFitWidth = true;
    driveTrainLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    driveTrainLbl.layer.cornerRadius = 5;
    driveTrainLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *shooterHeader = [[UILabel alloc] initWithFrame:CGRectMake(270, 225, 80, 25)];
    shooterHeader.text = @"Shooter";
    shooterHeader.font = [UIFont boldSystemFontOfSize:15];
    shooterHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *shooterLbl = [[UILabel alloc] initWithFrame:CGRectMake(240, 250, 140, 25)];
    shooterLbl.textAlignment = NSTextAlignmentCenter;
    shooterLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.shooter];
    shooterLbl.adjustsFontSizeToFitWidth = true;
    shooterLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    shooterLbl.layer.cornerRadius = 5;
    shooterLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *preferredGoalHeader = [[UILabel alloc] initWithFrame:CGRectMake(400, 225, 120, 25)];
    preferredGoalHeader.text = @"Preferred Goal";
    preferredGoalHeader.font = [UIFont boldSystemFontOfSize:15];
    preferredGoalHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *preferredGoalLbl = [[UILabel alloc] initWithFrame:CGRectMake(400, 250, 120, 25)];
    preferredGoalLbl.textAlignment = NSTextAlignmentCenter;
    preferredGoalLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.preferredGoal];
    preferredGoalLbl.adjustsFontSizeToFitWidth = true;
    preferredGoalLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    preferredGoalLbl.layer.cornerRadius = 5;
    preferredGoalLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *goalieArmHeader = [[UILabel alloc] initWithFrame:CGRectMake(40, 290, 80, 25)];
    goalieArmHeader.text = @"Goalie Arm";
    goalieArmHeader.font = [UIFont boldSystemFontOfSize:15];
    goalieArmHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *goalieArmLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 315, 100, 25)];
    goalieArmLbl.textAlignment = NSTextAlignmentCenter;
    goalieArmLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.goalieArm];
    goalieArmLbl.adjustsFontSizeToFitWidth = true;
    goalieArmLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    goalieArmLbl.layer.cornerRadius = 5;
    goalieArmLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *floorCollectorHeader = [[UILabel alloc] initWithFrame:CGRectMake(150, 290, 110, 25)];
    floorCollectorHeader.text = @"Floor Collector";
    floorCollectorHeader.font = [UIFont boldSystemFontOfSize:15];
    floorCollectorHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *floorCollectorLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 315, 110, 25)];
    floorCollectorLbl.textAlignment = NSTextAlignmentCenter;
    floorCollectorLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.floorCollector];
    floorCollectorLbl.adjustsFontSizeToFitWidth = true;
    floorCollectorLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    floorCollectorLbl.layer.cornerRadius = 5;
    floorCollectorLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *autonomousHeader = [[UILabel alloc] initWithFrame:CGRectMake(280, 290, 90, 25)];
    autonomousHeader.text = @"Autonomous";
    autonomousHeader.font = [UIFont boldSystemFontOfSize:15];
    autonomousHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *autonomousLbl = [[UILabel alloc] initWithFrame:CGRectMake(280, 315, 90, 25)];
    autonomousLbl.textAlignment = NSTextAlignmentCenter;
    autonomousLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.autonomous];
    autonomousLbl.adjustsFontSizeToFitWidth = true;
    autonomousLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    autonomousLbl.layer.cornerRadius = 5;
    autonomousLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *startingPositionHeader = [[UILabel alloc] initWithFrame:CGRectMake(390, 290, 130, 25)];
    startingPositionHeader.text = @"Starting Position";
    startingPositionHeader.font = [UIFont boldSystemFontOfSize:15];
    startingPositionHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *startingPositionLbl = [[UILabel alloc] initWithFrame:CGRectMake(390, 315, 130, 25)];
    startingPositionLbl.textAlignment = NSTextAlignmentCenter;
    startingPositionLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.autoStartingPosition];
    startingPositionLbl.adjustsFontSizeToFitWidth = true;
    startingPositionLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    startingPositionLbl.layer.cornerRadius = 5;
    startingPositionLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *hotGoalTrackingHeader = [[UILabel alloc] initWithFrame:CGRectMake(30, 355, 150, 25)];
    hotGoalTrackingHeader.text = @"Hot Goal Tracking";
    hotGoalTrackingHeader.font = [UIFont boldSystemFontOfSize:15];
    hotGoalTrackingHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *hotGoalTrackingLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 380, 150, 25)];
    hotGoalTrackingLbl.textAlignment = NSTextAlignmentCenter;
    hotGoalTrackingLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.hotGoalTracking];
    hotGoalTrackingLbl.adjustsFontSizeToFitWidth = true;
    hotGoalTrackingLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    hotGoalTrackingLbl.layer.cornerRadius = 5;
    hotGoalTrackingLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *catchingMechanismHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 355, 160, 25)];
    catchingMechanismHeader.text = @"Catching Mechanism";
    catchingMechanismHeader.font = [UIFont boldSystemFontOfSize:15];
    catchingMechanismHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *catchingMechanismLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 380, 160, 25)];
    catchingMechanismLbl.textAlignment = NSTextAlignmentCenter;
    catchingMechanismLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.catchingMechanism];
    catchingMechanismLbl.adjustsFontSizeToFitWidth = true;
    catchingMechanismLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    catchingMechanismLbl.layer.cornerRadius = 5;
    catchingMechanismLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *bumperQualityHeader = [[UILabel alloc] initWithFrame:CGRectMake(380, 355, 140, 25)];
    bumperQualityHeader.text = @"Bumper Quality";
    bumperQualityHeader.font = [UIFont boldSystemFontOfSize:15];
    bumperQualityHeader.textAlignment = NSTextAlignmentCenter;
    
    UILabel *bumperQualityLbl = [[UILabel alloc] initWithFrame:CGRectMake(380, 380, 140, 25)];
    bumperQualityLbl.textAlignment = NSTextAlignmentCenter;
    bumperQualityLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.bumperQuality];
    bumperQualityLbl.adjustsFontSizeToFitWidth = true;
    bumperQualityLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    bumperQualityLbl.layer.cornerRadius = 5;
    bumperQualityLbl.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
    
    UILabel *notesHeader = [[UILabel alloc] initWithFrame:CGRectMake(200, 420, 150, 25)];
    notesHeader.text = @"Additional Notes";
    notesHeader.font = [UIFont boldSystemFontOfSize:15];
    notesHeader.textAlignment = NSTextAlignmentCenter;
    
    UITextView *notesView = [[UITextView alloc] initWithFrame:CGRectMake(100, 445, 350, 125)];
    notesView.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.notes];
    if (notesView.text.length == 0) {
        notesView.text = @"No Notes";
        notesView.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
    notesView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    notesView.layer.borderWidth = 1;
    notesView.layer.cornerRadius = 5;
    notesView.font = [UIFont fontWithName:@"Heiti SC" size:16.0f];
    notesView.textAlignment = NSTextAlignmentCenter;
    notesView.editable = false;
    notesView.selectable = false;
    
    
    pitDetailView.frame = CGRectMake(254, 400, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [pitDetailView addSubview:closeButton];
        [pitDetailView addSubview:teamNumberLbl];
        [pitDetailView addSubview:teamNameLbl];
        [pitDetailView addSubview:imageControl];
        [pitDetailView addSubview:driveTrainHeader];
        [pitDetailView addSubview:driveTrainLbl];
        [pitDetailView addSubview:shooterHeader];
        [pitDetailView addSubview:shooterLbl];
        [pitDetailView addSubview:preferredGoalHeader];
        [pitDetailView addSubview:preferredGoalLbl];
        [pitDetailView addSubview:goalieArmHeader];
        [pitDetailView addSubview:goalieArmLbl];
        [pitDetailView addSubview:floorCollectorHeader];
        [pitDetailView addSubview:floorCollectorLbl];
        [pitDetailView addSubview:autonomousHeader];
        [pitDetailView addSubview:autonomousLbl];
        [pitDetailView addSubview:startingPositionHeader];
        [pitDetailView addSubview:startingPositionLbl];
        [pitDetailView addSubview:hotGoalTrackingHeader];
        [pitDetailView addSubview:hotGoalTrackingLbl];
        [pitDetailView addSubview:catchingMechanismHeader];
        [pitDetailView addSubview:catchingMechanismLbl];
        [pitDetailView addSubview:bumperQualityHeader];
        [pitDetailView addSubview:bumperQualityLbl];
        [pitDetailView addSubview:notesHeader];
        [pitDetailView addSubview:notesView];
        [pitDetailView bringSubviewToFront:imageControl];
    }];
}

-(void)enlargePicture{
    if (!isImageLarge) {
        if (robotImage.image) {
            [UIView animateWithDuration:0.3 animations:^{
                imageControl.frame = CGRectMake(-25, 0, 600, 600);
                robotImage.frame = CGRectMake(0, 0, 600, 600);
            }];
            isImageLarge = true;
        }
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            imageControl.frame = CGRectMake(10, 10, 200, 200);
            robotImage.frame = CGRectMake(0, 0, 200, 200);
        }];
        isImageLarge = false;
    }
}

-(void)grayOutShrinkPic{
    if (isImageLarge) {
        [UIView animateWithDuration:0.3 animations:^{
            imageControl.frame = CGRectMake(10, 10, 200, 200);
            robotImage.frame = CGRectMake(0, 0, 200, 200);
            isImageLarge = false;
        }];
    }
}

-(void)closeDetailView{
    for (UIView *v in [pitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(254, 400, 1, 1);
    } completion:^(BOOL finished) {
        [pitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
        self.tableView.userInteractionEnabled = true;
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self closeListSelectorView];
}


@end
