//
//  LocationsSecondViewController.m
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Sharing.h"
#import "Foundation/Foundation.h"
#import "CoreData/CoreData.h"
#import "Regional.h"
#import "Regional+Category.h"
#import "Team.h"
#import "Team+Category.h"
#import "Match.h"
#import "Match+Category.h"

@interface LocationsSecondViewController ()

@end

@implementation LocationsSecondViewController

NSArray *paths;
NSString *scoutingDirectory;
NSString *path;
NSMutableDictionary *dataDict;
NSMutableDictionary *receivedDataDict;
NSString *senderPeer;
MCPeerID *senderPeerID;

UIView *red1View;
UIView *greyOut;
UISegmentedControl *red1Selector;
UIButton *saveBtn;

NSInteger overWrite;

NSString *key1;
NSString *key2;
NSString *key3;

NSString *pos;

NSData *dataToSend;
NSData *dataReceived;

UIAlertView *receiveAlert;
UIAlertView *sendBackAlert;
bool sendAll;

NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;

NSArray *allData;
NSArray *receivedArray;

-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", pos);
    
    overWrite = 0;
    
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
    
    [_advertiseSwitcher setOn:false animated:YES];
    [_overWriteSwitch setOn:false animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (!pos && !red1View.superview) {
        CGRect greyOutRect = CGRectMake(0, 0, 768, 1024);
        greyOut = [[UIControl alloc] initWithFrame:greyOutRect];
        greyOut.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self.view addSubview:greyOut];
        
        CGRect red1Rect = CGRectMake(186, 450, 400, 170);
        red1View = [[UIView alloc] initWithFrame:red1Rect];
        red1View.layer.cornerRadius = 10;
        red1View.backgroundColor = [UIColor whiteColor];
        
        CGRect warningLblRect = CGRectMake(90, 20, 220, 30);
        UILabel *warningLbl = [[UILabel alloc] initWithFrame:warningLblRect];
        warningLbl.text = @"You are not signed in!";
        warningLbl.font = [UIFont systemFontOfSize:20];
        warningLbl.textAlignment = NSTextAlignmentCenter;
        [red1View addSubview:warningLbl];
        
        CGRect red1SelectorRect = CGRectMake(30, 70, 340, 30);
        red1Selector = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Red 1", @"Red 2", @"Red 3", @"Blue 1", @"Blue 2", @"Blue 3", nil]];
        [red1Selector addTarget:self action:@selector(enableSaveBtn) forControlEvents:UIControlEventValueChanged];
        red1Selector.frame = red1SelectorRect;
        [red1View addSubview:red1Selector];
        
        CGRect saveBtnRect = CGRectMake(175, 120, 50, 30);
        saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        saveBtn.frame = saveBtnRect;
        [saveBtn addTarget:self action:@selector(makeRed1ViewDisappear) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        saveBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [red1View addSubview:saveBtn];
        saveBtn.layer.cornerRadius = 5;
        saveBtn.enabled = false;
        saveBtn.alpha = 0.3;
        
        red1View.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [self.view addSubview:red1View];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             red1View.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished){
                         }];
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************************************************************************
********************    Reusable Methods    *****************************
************************************************************************/

-(void)enableSaveBtn{
    saveBtn.enabled = true;
    saveBtn.alpha = 1;
}

-(void)makeRed1ViewDisappear{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         red1View.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     }
                     completion:^(BOOL finished){
                         pos = [red1Selector titleForSegmentAtIndex:red1Selector.selectedSegmentIndex];
                         [red1View removeFromSuperview];
                         [greyOut removeFromSuperview];
                     }];
}

-(void)setUpMultiPeer{
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:pos];
    
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"FIRST-SCOUT" session:self.mySession];
    
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"FIRST-SCOUT" discoveryInfo:nil session:self.mySession];
    
    self.browserVC.delegate = self;
    
    self.mySession.delegate = self;
    
    
}

-(void)setUpData{
    allData = nil;
    dataToSend = nil;
    
//    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    scoutingDirectory = [paths objectAtIndex:0];
//    path = [scoutingDirectory stringByAppendingPathComponent:@"data.plist"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"] toPath:path error:nil];
//    }
//    
//    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    NSError *regionalError = nil;
    NSArray *regionals = [context executeFetchRequest:regionalRequest error:&regionalError];
    
    NSFetchRequest *teamRequest = [NSFetchRequest fetchRequestWithEntityName:@"Team"];
    NSError *teamError = nil;
    NSArray *teams = [context executeFetchRequest:teamRequest error:&teamError];
    
    
    NSFetchRequest *matchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    NSError *matchError = nil;
    NSArray *matches = [context executeFetchRequest:matchRequest error:&matchError];
    
    allData = [[NSArray alloc] initWithObjects:regionals, teams, matches, nil];
    
}

-(void)dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserVC{
    [self dismissBrowserVC];
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}


// SESSION //

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        NSLog(@"HOLY FRIGGIN CRAP YESSS!!!!");
        self.sessionTwo = session;
    }
    else if (state == MCSessionStateNotConnected){
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Somebody Left!"
                                                           message: [[NSString alloc] initWithFormat:@"%@", [peerID displayName]]
                                                          delegate: nil
                                                 cancelButtonTitle:@"Got it bro"
                                                 otherButtonTitles:nil];
            [alert show];
        });
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"DATA RECEIVED: %lu bytes!", (unsigned long)data.length);
    dataReceived = data;
    
    
    receivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    
//    receivedDataDict = [[NSMutableDictionary alloc] init];
//    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    
    senderPeer = [peerID displayName];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        receiveAlert = [[UIAlertView alloc]initWithTitle: @"Hey!"
                                                       message: [[NSString alloc] initWithFormat:@"%@ is trying to send you data! Do you accept?", senderPeer]
                                                      delegate: self
                                             cancelButtonTitle:@"Nuh Uh!!"
                                             otherButtonTitles:@"Ok, I guess.",nil];
        [receiveAlert show];
    });
}


/************************************************************************
 ****************    Actions and Other Code    **************************
 ************************************************************************/

- (IBAction)browseGO:(id)sender {
    [self setUpMultiPeer];
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (IBAction)advertiseSwitch:(id)sender {
    if (_advertiseSwitcher.on) {
        [self setUpMultiPeer];
        [self.advertiser start];
    }
    else{
        [self.advertiser stop];
    }
}

- (IBAction)sendMatches:(id)sender {
    [self setUpData];
    
    dataToSend = [NSKeyedArchiver archivedDataWithRootObject:allData];
    NSError *error;
    NSArray *peerIDs;
    
    peerIDs = [self.sessionTwo connectedPeers];
    
    
    [self.sessionTwo sendData:dataToSend toPeers:peerIDs withMode:MCSessionSendDataReliable error:&error];
    
    sendAll = true;
}

- (IBAction)switchOverwrite:(id)sender {
    if (_overWriteSwitch.on) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"WARNING"
                                                       message: @"By flipping this switch into the ON position, you are telling this app that any time someone sends you a match that you already have, their match will overwrite yours. If you DO NOT want this feature, flip the switch back off."
                                                      delegate: nil
                                             cancelButtonTitle:@"Aye aye, Cap'n"
                                             otherButtonTitles:nil];
        [alert show];
        overWrite = 1;
    }
    else{
        overWrite = 0;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:receiveAlert] && buttonIndex == 1) {
        NSLog(@"Made it do receiveAlert button 1 pressed");
//        [context performBlock:^{
//            for (Regional *r in [receivedArray objectAtIndex:0]) {
//                NSLog(@"Regional %d", [[receivedArray objectAtIndex:0] indexOfObject:r]);
//                Regional *rgnl = [Regional createRegionalWithName:r.name inManagedObjectContext:context];
//                for (Team *t in [receivedArray objectAtIndex:1]) {
//                    NSLog(@"Team %d", [[receivedArray objectAtIndex:1] indexOfObject:t]);
//                    Team *tm = [Team createTeamWithName:t.name inRegional:rgnl withManagedObjectContext:context];
//                    for (Match *m in [receivedArray objectAtIndex:2]) {
//                        NSLog(@"Match %d", [[receivedArray objectAtIndex:2] indexOfObject:m]);
//                        NSDictionary *matchDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                   [NSNumber numberWithInteger:[m.teleHighScore integerValue]], @"teleHighScore",
//                                                   [NSNumber numberWithInteger:[m.autoHighScore integerValue]], @"autoHighScore",
//                                                   [NSNumber numberWithInteger:[m.teleMidScore integerValue]], @"teleMidScore",
//                                                   [NSNumber numberWithInteger:[m.autoMidScore integerValue]], @"autoMidScore",
//                                                   [NSNumber numberWithInteger:[m.teleLowScore integerValue]], @"teleLowScore",
//                                                   [NSNumber numberWithInteger:[m.autoLowScore integerValue]], @"autoLowScore",
//                                                   //[NSNumber numberWithInteger:endGame], @"endGame",
//                                                   [NSNumber numberWithInteger:[m.penaltyLarge integerValue]], @"penaltyLarge",
//                                                   [NSNumber numberWithInteger:[m.penaltySmall integerValue]], @"penaltySmall",
//                                                   [NSString stringWithString:m.red1Pos], @"red1Pos",
//                                                   [NSString stringWithString:m.recordingTeam], @"recordingTeam",
//                                                   [NSString stringWithString:m.scoutInitials], @"scoutInitials",
//                                                   [NSString stringWithString:m.matchType], @"matchType",
//                                                   [NSString stringWithString:m.matchNum], @"matchNum",
//                                                   [NSNumber numberWithInteger:[m.uniqeID integerValue]], @"uniqueID", nil];
//                        
//                        
//                        Match *mch = [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
//                        
//                        if ([mch.uniqeID integerValue] != [[matchDict objectForKey:@"uniqueID"] integerValue]) {
//                            if (overWrite == 1) {
//                                [FSAdocument.managedObjectContext deleteObject:mch];
//                                [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
//                            }
//                        }
//                    }
//                }
//            }
//            
//            [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
//                if (success) {
//                    for (Regional *rnl in [receivedArray objectAtIndex:0]) {
//                        NSLog(@"Successfully Transferred Regional: %@", rnl.name);
//                    }
//                }
//                else{
//                    NSLog(@"Didn't transfer regionals correctly.");
//                }
//            }];
//        
//            sendBackAlert = [[UIAlertView alloc] initWithTitle:@"Successfully Transferred!"
//                                                       message:@"Would you like to send your data to connected peers?"
//                                                      delegate:self
//                                             cancelButtonTitle:@"Nope!"
//                                             otherButtonTitles:@"Go for it", nil];
//            
//        }];
    }
    else if ([alertView isEqual:sendBackAlert] == 1){
        [self sendMatches:self];
    }
}



@end
