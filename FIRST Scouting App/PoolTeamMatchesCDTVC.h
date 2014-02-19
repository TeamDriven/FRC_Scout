//
//  PoolTeamMatchesCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/15/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "PoolMatchCell.h"
#import "Team.h"
#import "Team+Category.h"
#import "Match.h"

@interface PoolTeamMatchesCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Team *teamSelected;

@end
