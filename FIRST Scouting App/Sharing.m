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
UIView *greyOutView;
UISegmentedControl *red1Selector;
UIButton *saveBtn;

NSInteger overWrite;
NSTimer *sendMatchesDelay;

NSString *pos;

NSData *dataToSend;
NSData *dataReceived;
bool sentOnce;

UIAlertView *receiveAlert;
UIAlertView *sendBackAlert;

NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;


-(void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Position: %@", pos);
    
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
    
    sentOnce = false;
}

-(void)viewDidAppear:(BOOL)animated{
    if (!pos && !red1View.superview) {
        CGRect greyOutViewRect = CGRectMake(0, 0, 768, 1024);
        greyOutView = [[UIControl alloc] initWithFrame:greyOutViewRect];
        greyOutView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        [self.view addSubview:greyOutView];
        
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
                         [greyOutView removeFromSuperview];
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
    
    dataDict = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
    NSError *regionalError = nil;
    NSArray *regionals = [context executeFetchRequest:regionalRequest error:&regionalError];
    
    for (int r = 0; r < [regionals count]; r++) {
        NSArray *teams = [NSArray arrayWithArray:[[[regionals objectAtIndex:r] teams] allObjects]];
        NSString *regionalTitle = [[NSString alloc] initWithFormat:@"%@", [[regionals objectAtIndex:r] name]];
        [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:regionalTitle];
        for (int t = 0; t < [teams count]; t++) {
            NSArray *matches = [NSArray arrayWithArray:[[[teams objectAtIndex:t] matches] allObjects]];
            NSString *teamTitle = [[NSString alloc] initWithFormat:@"%@", [[teams objectAtIndex:t] name]];
            [[dataDict objectForKey:regionalTitle] setObject:[[NSMutableDictionary alloc] init] forKey:teamTitle];
            for (Match *m in matches) {
                NSString *matchNum = [[NSString alloc] initWithFormat:@"%@", m.matchNum];
                NSDictionary *matchDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           [NSNumber numberWithInteger:[m.teleHighScore integerValue]], @"teleHighScore",
                                           [NSNumber numberWithInteger:[m.autoHighScore integerValue]], @"autoHighScore",
                                           [NSNumber numberWithInteger:[m.teleMidScore integerValue]], @"teleMidScore",
                                           [NSNumber numberWithInteger:[m.autoMidScore integerValue]], @"autoMidScore",
                                           [NSNumber numberWithInteger:[m.teleLowScore integerValue]], @"teleLowScore",
                                           [NSNumber numberWithInteger:[m.autoLowScore integerValue]], @"autoLowScore",
                                           //[NSNumber numberWithInteger:[m.endGame integerValue]], @"endGame",
                                           [NSNumber numberWithInteger:[m.penaltyLarge integerValue]], @"penaltyLarge",
                                           [NSNumber numberWithInteger:[m.penaltySmall integerValue]], @"penaltySmall",
                                           [NSString stringWithString:m.red1Pos], @"red1Pos",
                                           [NSString stringWithString:m.recordingTeam], @"recordingTeam",
                                           [NSString stringWithString:m.matchType], @"matchType",
                                           [NSString stringWithString:m.matchNum], @"matchNum",
                                           [NSNumber numberWithInteger:[m.uniqeID integerValue]], @"uniqueID", nil];
                [[[dataDict objectForKey:regionalTitle] objectForKey:teamTitle] setObject:matchDict forKey:matchNum];
            }
        }
    }
    NSLog(@"%@", dataDict);
    
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
    
    receivedDataDict = [[NSMutableDictionary alloc] init];
    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    
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

-(IBAction)browseGO:(id)sender {
    
    [self setUpMultiPeer];
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

-(IBAction)advertiseSwitch:(id)sender {
    if (_advertiseSwitcher.on) {
        [self setUpMultiPeer];
        [self.advertiser start];
    }
    else{
        [self.advertiser stop];
    }
}

-(IBAction)sendMatches:(id)sender {
    [self setUpData];
    
    dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
    NSError *error;
    NSArray *peerIDs;
    
    peerIDs = [self.sessionTwo connectedPeers];
    
    
    [self.sessionTwo sendData:dataToSend toPeers:peerIDs withMode:MCSessionSendDataReliable error:&error];
    
    _sendMatchesBtn.enabled = false;
    _sendMatchesBtn.alpha = 0.5;
    
    sendMatchesDelay = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reEnableSendMatchesBtn) userInfo:nil repeats:NO];
    
    sentOnce = true;
}
-(void)reEnableSendMatchesBtn{
    _sendMatchesBtn.enabled = true;
    _sendMatchesBtn.alpha = 1.0;
    sentOnce = false;
    [sendMatchesDelay invalidate];
    sendMatchesDelay = nil;
}

-(IBAction)switchOverwrite:(id)sender {
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
        [self dataDictToCoreData];
    }
    else if ([alertView isEqual:sendBackAlert] && buttonIndex == 1){
        [self sendMatches:self];
    }
}

-(void)dataDictToCoreData{
    [context performBlock:^{
        for (NSString *r in receivedDataDict) {
            Regional *rgnl = [Regional createRegionalWithName:r inManagedObjectContext:context];
            for (NSString *t in [receivedDataDict objectForKey:r]) {
                Team *tm = [Team createTeamWithName:t inRegional:rgnl withManagedObjectContext:context];
                for (NSString *m in [[receivedDataDict objectForKey:r] objectForKey:t]) {
                    NSDictionary *matchDict = [[[receivedDataDict objectForKey:r] objectForKey:t] objectForKey:m];
                    NSNumber *uniqueID = [NSNumber numberWithInteger:[[matchDict objectForKey:@"uniqueID"] integerValue]];
                    Match *mtch = [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
                    
                    if ([mtch.uniqeID integerValue] == [uniqueID integerValue]) {
                        NSLog(@"No conflicts!");
                    }
                    else{
                        if (overWrite == 1) {
                            [FSAdocument.managedObjectContext deleteObject:mtch];
                            NSLog(@"Deleted the saved match");
                            [Match createMatchWithDictionary:matchDict inTeam:tm withManagedObjectContext:context];
                        }
                    }
                }
            }
        }
        
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
            if (success) {
                NSLog(@"Saved transferred data");
            }
            else{
                NSLog(@"Didn't transfer regionals correctly.");
            }
        }];
        
        receivedDataDict = nil;
        [self sendBackDataAlert];
    }];
}

-(void)sendBackDataAlert{
    if (!sentOnce) {
        sendBackAlert = [[UIAlertView alloc] initWithTitle:@"Successfully Transferred!"
                                               message:@"Would you like to send your data to connected peers?"
                                              delegate:self
                                     cancelButtonTitle:@"Nope!"
                                     otherButtonTitles:@"Go for it", nil];
        [sendBackAlert show];
    }
    else{
        sendBackAlert = [[UIAlertView alloc] initWithTitle:@"Successfully Transferred!"
                                                   message:@"Give yourself a pat on the back for both of us."
                                                  delegate:self
                                         cancelButtonTitle:@"K."
                                         otherButtonTitles:nil];
        [sendBackAlert show];
    }
    
}












@end