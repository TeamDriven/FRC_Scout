//
//  LocationsSecondViewController.m
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Sharing.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Foundation/Foundation.h"
#import "CoreData/CoreData.h"
#import "Globals.h"
#import "Regional.h"
#import "Regional+Category.h"
#import "Team.h"
#import "Team+Category.h"
#import "Match.h"
#import "Match+Category.h"
#import "PitTeam.h"
#import "PitTeam+Category.h"


@interface LocationsSecondViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UIButton *sendMessageBtn;

@end

@implementation LocationsSecondViewController

// Core Data Filepath
NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSString *pos;

UIControl *miniSignIn;
UIControl *grayOUT;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, t ypically from a nib.
    
    // *** Map to Core Data ***
    FSAfileManager = [NSFileManager defaultManager];
    FSAdocumentsDirectory = [[FSAfileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    FSAdocumentName = @"FSA";
    FSApathurl = [FSAdocumentsDirectory URLByAppendingPathComponent:FSAdocumentName];
    FSAdocument = [[UIManagedDocument alloc] initWithFileURL:FSApathurl];
    context = FSAdocument.managedObjectContext;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FSApathurl path]]) {
        [FSAdocument openWithCompletionHandler:^(BOOL success){
            if (success) NSLog(@"Found the document!");
            if (!success) NSLog(@"Couldn't find the document at path: %@", FSApathurl);
        }];
    }
    else{
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) NSLog(@"Created the document!");
            if (!success) NSLog(@"Couldn't create the document at path: %@", FSApathurl);
        }];
    }
    // *** Done Mapping to Core Data **

    [self setUpUI];
    [self setUpMultipeer];
    
    if (pos.length == 0 || pos == nil) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpUI{
    //  Setup the browse button
    self.browserButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.browserButton setTitle:@"Browse" forState:UIControlStateNormal];
    self.browserButton.frame = CGRectMake(330, 220, 100, 50);
    self.browserButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.browserButton.layer.cornerRadius = 5;
    [self.browserButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.browserButton];

    
    self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendMessageBtn setTitle:@"Send" forState:UIControlStateNormal];
    self.sendMessageBtn.frame = CGRectMake(330, 400, 100, 50);
    self.sendMessageBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.sendMessageBtn.layer.cornerRadius = 5;
    [self.sendMessageBtn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendMessageBtn];

}

- (void) setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.mySession.delegate = self;
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"FRCSCOUT" session:self.mySession];
    self.browserVC.delegate = self;
    
    //  Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"FRCSCOUT" discoveryInfo:nil session:self.mySession];
    [self.advertiser start];
}

- (void) showBrowserVC{
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendText{
    NSMutableDictionary *dictToSend = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *regionalsDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *pitTeamsDict = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    NSError *regionalError;
    
    NSArray *regionals = [context executeFetchRequest:regionalRequest error:&regionalError];
    for (Regional *rgnl in regionals) {
        [regionalsDict setObject:[[NSMutableDictionary alloc] init] forKey:rgnl.name];
        for (Team *tm in rgnl.teams) {
            [[regionalsDict objectForKey:rgnl.name] setObject:[[NSMutableDictionary alloc] init] forKey:tm.name];
            for (Match *mtch in tm.matches) {
                [[[regionalsDict objectForKey:rgnl.name] objectForKey:tm.name]
                 setObject:[[NSDictionary alloc]
                            initWithObjectsAndKeys:
                            [NSNumber numberWithInteger:[mtch.autoHighHotScore integerValue]], @"autoHighHotScore",
                            [NSNumber numberWithInteger:[mtch.autoHighNotScore integerValue]], @"autoHighNotScore",
                            [NSNumber numberWithInteger:[mtch.autoHighMissScore integerValue]], @"autoHighMissScore",
                            [NSNumber numberWithInteger:[mtch.autoLowHotScore integerValue]], @"autoLowHotScore",
                            [NSNumber numberWithInteger:[mtch.autoLowNotScore integerValue]], @"autoLowNotScore",
                            [NSNumber numberWithInteger:[mtch.autoLowMissScore integerValue]], @"autoLowMissScore",
                            [NSNumber numberWithInteger:[mtch.mobilityBonus integerValue]], @"mobilityBonus",
                            [NSNumber numberWithInteger:[mtch.teleopHighMake integerValue]], @"teleopHighMake",
                            [NSNumber numberWithInteger:[mtch.teleopHighMiss integerValue]], @"teleopHighMiss",
                            [NSNumber numberWithInteger:[mtch.teleopLowMake integerValue]], @"teleopLowMake",
                            [NSNumber numberWithInteger:[mtch.teleopLowMiss integerValue]], @"teleopLowMiss",
                            [NSNumber numberWithInteger:[mtch.teleopOver integerValue]], @"teleopOver",
                            [NSNumber numberWithInteger:[mtch.teleopPassed integerValue]], @"teleopPassed",
                            [NSNumber numberWithInteger:[mtch.penaltyLarge integerValue]], @"penaltyLarge",
                            [NSNumber numberWithInteger:[mtch.penaltySmall integerValue]], @"penaltySmall",
                            [NSString stringWithString:mtch.notes], @"notes",
                            [NSString stringWithString:mtch.red1Pos], @"red1Pos",
                            [NSString stringWithString:mtch.recordingTeam], @"recordingTeam",
                            [NSString stringWithString:mtch.scoutInitials], @"scoutInitials",
                            [NSString stringWithString:mtch.matchType], @"matchType",
                            [NSString stringWithString:mtch.matchNum], @"matchNum",
                            [NSNumber numberWithInteger:[mtch.uniqeID integerValue]], @"uniqueID",nil] forKey:mtch.matchNum];
            }
        }
    }
    
    NSFetchRequest *pitTeamsRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
    NSError *pitTeamError;
    NSArray *pitTeams = [context executeFetchRequest:pitTeamsRequest error:&pitTeamError];
    for (PitTeam *pt in pitTeams) {
        [pitTeamsDict setObject:[[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithString:pt.driveTrain], @"driveTrain",
                                 [NSString stringWithString:pt.shooter], @"shooter",
                                 [NSString stringWithString:pt.preferredGoal], @"preferredGoal",
                                 [NSString stringWithString:pt.goalieArm], @"goalieArm",
                                 [NSString stringWithString:pt.floorCollector], @"floorCollector",
                                 [NSString stringWithString:pt.autonomous], @"autonomous",
                                 [NSString stringWithString:pt.autoStartingPosition], @"autoStartingPosition",
                                 [NSString stringWithString:pt.hotGoalTracking], @"hotGoalTracking",
                                 [NSString stringWithString:pt.catchingMechanism], @"catchingMechanism",
                                 [NSString stringWithString:pt.bumperQuality], @"bumperQuality",
                                 [NSData dataWithData:pt.image], @"image",
                                 [NSString stringWithString:pt.teamNumber], @"teamNumber",
                                 [NSString stringWithString:pt.teamName], @"teamName",
                                 [NSString stringWithString:pt.notes], @"notes",
                                 [NSNumber numberWithInteger:[pt.uniqueID integerValue]], @"uniqueID", nil] forKey:pt.teamNumber];
    }
    
    [dictToSend setObject:regionalsDict forKey:@"Regionals"];
    [dictToSend setObject:pitTeamsDict forKey:@"PitTeams"];
    
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dictToSend];
    
    NSError *error;
    [self.mySession sendData:dataToSend toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected!");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *connectedAlert = [[UIAlertView alloc] initWithTitle:@"Wohoo!"
                                                                     message:[[NSString alloc] initWithFormat:@"You connected with %@", peerID.displayName]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Awesometastic"
                                                           otherButtonTitles:nil];
            [connectedAlert show];
        });
    }
    else{
        NSLog(@"Disconnected");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *disConnectedAlert = [[UIAlertView alloc] initWithTitle:@"Oh No!"
                                                                     message:[[NSString alloc] initWithFormat:@"You disconnected from %@", peerID.displayName]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Dang it!"
                                                           otherButtonTitles:nil];
            [disConnectedAlert show];
        });
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Hey!"
                                                               message:@"You Got Mail!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Cool"
                                                     otherButtonTitles:nil];
        [messageAlert show];
    });
    
    NSDictionary *receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [context performBlock:^{
        NSDictionary *regionalsDict = [receivedDataDict objectForKey:@"Regionals"];
        for (NSString *rgnl in regionalsDict) {
            Regional *regional = [Regional createRegionalWithName:rgnl inManagedObjectContext:context];
            for (NSString *tm in [regionalsDict objectForKey:rgnl]) {
                Team *team = [Team createTeamWithName:tm inRegional:regional withManagedObjectContext:context];
                for (NSString *mtch in [[receivedDataDict objectForKey:rgnl] objectForKey:tm]) {
                    NSDictionary *matchDict = [[[regionalsDict objectForKey:rgnl] objectForKey:tm] objectForKey:mtch];
                    int uniqueID = [[matchDict objectForKey:@"uniqueID"] intValue];
                    Match *match = [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                    if ([match.uniqeID intValue] != uniqueID) {
                        [FSAdocument.managedObjectContext deleteObject:match];
                        [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                    }
                    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
                }
            }
        }
        NSDictionary *pitTeamsDict = [receivedDataDict objectForKey:@"PitTeams"];
        for (NSString *pt in pitTeamsDict) {
            int uniqueID = [[[pitTeamsDict objectForKey:pt] objectForKey:@"uniqueID"] intValue];
            PitTeam *pitTeam = [PitTeam createPitTeamWithDictionary:[pitTeamsDict objectForKey:pt] inManagedObjectContext:context];
            
            if (uniqueID != [pitTeam.uniqueID intValue]) {
                [FSAdocument.managedObjectContext deleteObject:pitTeam];
                [PitTeam createPitTeamWithDictionary:[pitTeamsDict objectForKey:pt] inManagedObjectContext:context];
            }
            [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
        }
    }];

}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

@end











