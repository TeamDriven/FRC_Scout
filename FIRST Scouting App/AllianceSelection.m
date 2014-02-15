//
//  AllianceSelection.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "AllianceSelection.h"


@interface AllianceSelection ()

@end

@implementation AllianceSelection

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSString *regionalSelected;
Regional *regionalObject;

NSMutableArray *secondPickArray;

RegionalPoolCDTVC *regionalPoolCDTVC;

FirstPickListController *firstPickListController;
SecondPickListController *secondPickListController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _poolTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _poolTableView.layer.borderWidth = 1;
    _poolTableView.layer.cornerRadius = 5;
    _poolTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _firstPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _firstPickTableView.layer.borderWidth = 1;
    _firstPickTableView.layer.cornerRadius = 5;
    _firstPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    _secondPickTableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _secondPickTableView.layer.borderWidth = 1;
    _secondPickTableView.layer.cornerRadius = 5;
    _secondPickTableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
}



-(void)viewWillAppear:(BOOL)animated{
    regionalPoolCDTVC = [[RegionalPoolCDTVC alloc] init];
    [regionalPoolCDTVC setRegionalToDisplay:regionalSelected];
    [regionalPoolCDTVC setManagedObjectContext:context];
    _poolTableView.delegate = regionalPoolCDTVC;
    _poolTableView.dataSource = regionalPoolCDTVC;
    
    regionalPoolCDTVC.tableView = _poolTableView;
    
    [regionalPoolCDTVC performFetch];
    
    
    NSFetchRequest *regionalFetch = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    regionalFetch.predicate = [NSPredicate predicateWithFormat:@"name = %@", regionalSelected];
    
    NSError *regionalError;
    regionalObject = [[context executeFetchRequest:regionalFetch error:&regionalError] firstObject];
    
    NSArray *firstPickArray = [regionalObject.firstPickList array];
    NSArray *secondPickArray = [regionalObject.secondPickList array];
    
    firstPickListController = [[FirstPickListController alloc] init];
    [firstPickListController setFirstPickList:firstPickArray];
    _firstPickTableView.delegate = firstPickListController;
    _firstPickTableView.dataSource = firstPickListController;
    firstPickListController.tableView = _firstPickTableView;
    
    [regionalPoolCDTVC setFirstPickListController:firstPickListController];
    
    secondPickListController = [[SecondPickListController alloc] init];
    [secondPickListController setSecondPickList:secondPickArray];
    _secondPickTableView.delegate = secondPickListController;
    _secondPickTableView.dataSource = secondPickListController;
    secondPickListController.tableView = _secondPickTableView;
    
    [regionalPoolCDTVC setSecondPickListController:secondPickListController];
}

-(void)viewWillDisappear:(BOOL)animated{
    regionalObject.firstPickList = [NSOrderedSet orderedSetWithArray:firstPickListController.firstPickList];
    regionalObject.secondPickList = [NSOrderedSet orderedSetWithArray:secondPickListController.secondPickList];
    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Saved correctly on exit");
        }
        else{
            NSLog(@"Didn't save correctly");
        }
    }];
}


- (IBAction)reorderSecondPickList:(id)sender {
    if (_secondPickTableView.isEditing) {
        [_secondPickTableView setEditing:NO animated:YES];
    }
    else{
        [_secondPickTableView setEditing:YES animated:YES];
    }
}

- (IBAction)reorderFirstPickList:(id)sender {
    if (_firstPickTableView.isEditing) {
        [_firstPickTableView setEditing:NO animated:YES];
    }
    else{
        [_firstPickTableView setEditing:YES animated:YES];
    }
}

@end




