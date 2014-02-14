//
//  SecondPickListController.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/14/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlliancePickListCell.h"
#import "Team.h"
#import "Match.h"

@interface SecondPickListController : UITableViewController

@property (strong, nonatomic) NSArray *secondPickList;

-(void)insertNewTeamIntoSecondPickList:(Team *)team;

@end
