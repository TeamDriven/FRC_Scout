//
//  FirstPickListCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/11/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Globals.h"
#import "AlliancePickListCell.h"
#import "Team.h"
#import "Regional.h"
#import "Match.h"
#import "PitTeam.h"

@interface FirstPickListCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *regionalToDisplay;

@property (strong, nonatomic) Regional *selectedRegional;

@end
