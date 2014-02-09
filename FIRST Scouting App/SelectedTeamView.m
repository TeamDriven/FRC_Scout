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
#import "SelectedTeamCDTVC.h"

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

SelectedTeamCDTVC *cdtvc;

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
    _teamNameLbl.adjustsFontSizeToFitWidth = true;
    _teamNameLbl.layer.cornerRadius = 5;
    _statBox.layer.cornerRadius = 10;
    
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSFetchRequest *masterTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"MasterTeam"];
    masterTeamRequest.predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"name = %@", teamNumber]];
    
    NSError *masterTeamError;
    NSArray *masterTeamArray = [context executeFetchRequest:masterTeamRequest error:&masterTeamError];
    
    master = [masterTeamArray firstObject];
    
    PitTeam *pt = master.pitTeam;
    
    _robotPic.image = [UIImage imageWithData:pt.image];
    
    float autoTotal = 0;
    float teleopTotal = 0;
    float passTotal = 0;
    float receiveTotal = 0;
    float overTrussTotal = 0;
    float catchTotal = 0;
    float totalMatches = 0;
    
    for (Team *tm in master.teamsWithin) {
        for (Match *mtch in tm.matches) {
            autoTotal += [mtch.autoHighHotScore floatValue]*20;
            autoTotal += [mtch.autoHighNotScore floatValue]*15;
            autoTotal += [mtch.autoLowHotScore floatValue]*11;
            autoTotal += [mtch.autoLowNotScore floatValue]*6;
            autoTotal += [mtch.mobilityBonus floatValue]*5;
            teleopTotal += [mtch.teleopHighMake floatValue]*10;
            teleopTotal += [mtch.teleopLowMake floatValue];
            teleopTotal += [mtch.teleopCatch floatValue]*10;
            teleopTotal += [mtch.teleopOver floatValue]*10;
            passTotal += [mtch.teleopPassed floatValue];
            receiveTotal += [mtch.teleopReceived floatValue];
            overTrussTotal += [mtch.teleopOver floatValue];
            catchTotal += [mtch.teleopCatch floatValue];
            totalMatches++;
        }
    }
    
    float autoAvg = 0;
    float teleopAvg = 0;
    float passAvg = 0;
    float receiveAvg = 0;
    float overTrussAvg = 0;
    float catchAvg = 0;
    autoAvg = (float)autoTotal/(float)totalMatches;
    teleopAvg = (float)teleopTotal/(float)totalMatches;
    passAvg = (float)passTotal/(float)totalMatches;
    receiveAvg = (float)receiveTotal/(float)totalMatches;
    overTrussAvg = (float)overTrussTotal/(float)totalMatches;
    catchAvg = (float)catchTotal/(float)totalMatches;
    
    _autoAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", autoAvg];
    _teleopAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", teleopAvg];
    _passesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", passAvg];
    _receivesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", receiveAvg];
    _overTrussAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", overTrussAvg];
    _catchesAvgLbl.text = [[NSString alloc] initWithFormat:@"%.1f", catchAvg];
    
    cdtvc = [[SelectedTeamCDTVC alloc] init];
    [cdtvc setTeamToDisplay:teamNumber];
    [cdtvc setManagedObjectContext:context];
    
    _tableView.delegate = cdtvc;
    _tableView.dataSource = cdtvc;
    
    cdtvc.tableView = _tableView;
    
    [cdtvc performFetch];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





















