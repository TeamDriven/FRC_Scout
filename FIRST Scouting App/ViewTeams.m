//
//  ViewTeams.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "ViewTeams.h"
#import "Globals.h"
#import "ViewTeamsCDTVC.h"
#import "Globals.h"

@interface ViewTeams ()

@end

@implementation ViewTeams

NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;
ViewTeamsCDTVC *cdtvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
}

-(void)viewWillAppear:(BOOL)animated{
    cdtvc = [[ViewTeamsCDTVC alloc] init];
    [cdtvc setManagedObjectContext:context];
    [cdtvc setTextField:_teamSearch];
    
    _teamSearch.delegate = cdtvc;
    
    _tableView.delegate = cdtvc;
    _tableView.dataSource = cdtvc;
    
    cdtvc.tableView = _tableView;
    
    [cdtvc performFetch];
}



- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath{
    // here you are supposed call appropriate UITableView methods to update rows!
    // but don’t worry, we’re going to make it easy on you ...
}


- (IBAction)screenTapped:(id)sender {
    [_teamSearch resignFirstResponder];
}

@end










