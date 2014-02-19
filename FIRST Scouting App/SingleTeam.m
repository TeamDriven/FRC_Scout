//
//  SingleTeam.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SingleTeam.h"
#import "SingleTeamCDTVC.h"
#import "Globals.h"

@interface SingleTeam ()

@end

@implementation SingleTeam

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

SingleTeamCDTVC *cdtvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
}

-(void)viewWillAppear:(BOOL)animated{
    cdtvc = [[SingleTeamCDTVC alloc] init];
    [cdtvc setManagedObjectContext:context];
    [cdtvc setTextField:_searchBox];
    
    _tableView.delegate = cdtvc;
    _tableView.dataSource = cdtvc;
    
    cdtvc.tableView = _tableView;
    
    _searchBox.delegate = cdtvc;
    
    [cdtvc performFetch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)screenTapped:(id)sender {
    [_searchBox resignFirstResponder];
}


@end
