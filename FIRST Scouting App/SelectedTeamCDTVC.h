//
//  SelectedTeamCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/9/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface SelectedTeamCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *teamToDisplay;

@end
