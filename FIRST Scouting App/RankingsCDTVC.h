//
//  RankingsCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/16/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "RankingsCell.h"
#import "Team.h"
#import "Team+Category.h"
#import "Regional.h"
#import "PoolTeamMatchesCDTVC.h"
#import "MasterTeam.h"
#import "PitTeam.h"


@interface RankingsCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *regionalSelected;

@property (strong, nonatomic) NSString *sortString;

-(void)sortOrderLargeFirst;

-(void)sortOrderSmallFirst;

@end
