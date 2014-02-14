//
//  FirstPickListController.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/14/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlliancePickListCell.h"
#import "Team.h"
#import "Match.h"

@interface FirstPickListController : UITableViewController

@property (strong, nonatomic) NSArray *firstPickList;

-(void)insertNewTeamIntoFirstPickList:(Team *)team;

@end
