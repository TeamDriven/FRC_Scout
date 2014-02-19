//
//  ViewTeamsCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/9/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface ViewTeamsCDTVC : CoreDataTableViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) UITextField *textField;

@end
