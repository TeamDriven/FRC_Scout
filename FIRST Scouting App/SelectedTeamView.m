//
//  SelectedTeamView.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SelectedTeamView.h"
#import "Globals.h"
#import "MasterTeam.h"
#import "Regional.h"
#import "Team.h"
#import "Match.h"
#import "PitTeam.h"

@interface SelectedTeamView ()

@end

@implementation SelectedTeamView

NSString *teamNumber;
NSString *teamName;

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

MasterTeam *master;

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
    _teamNameLbl.adjustsFontSizeToFitWidth = YES;
    
    _header.title = teamNumber;
    _teamNameLbl.text = teamName;
    
    NSFetchRequest *masterTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"MasterTeam"];
    masterTeamRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"name = %@", teamNumber]];
    
    NSError *masterTeamError;
    NSArray *masterTeamArray = [context executeFetchRequest:masterTeamRequest error:&masterTeamError];
    
    master = [masterTeamArray firstObject];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
