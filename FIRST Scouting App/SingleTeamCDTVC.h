//
//  SingleTeamCDTVC.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface SingleTeamCDTVC : CoreDataTableViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak,nonatomic) UITextField *textField;

extern NSString *teamNumber;
extern NSString *teamName;

@end
