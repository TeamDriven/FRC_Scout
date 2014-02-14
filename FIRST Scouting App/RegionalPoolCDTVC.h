//
//  RegionalPoolCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/11/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "FirstPickListController.h"
#import "SecondPickListController.h"

@interface RegionalPoolCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSString *regionalToDisplay;

@property (strong, nonatomic) FirstPickListController *firstPickListTableView;

@property (strong, nonatomic) SecondPickListController *secondPickListController;

@end
