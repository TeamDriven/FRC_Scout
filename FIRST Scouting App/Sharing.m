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
#import "Regional.h"
#import "Regional+Category.h"
#import "Team.h"
#import "Team+Category.h"
#import "Match.h"
#import "Match+Category.h"


@interface LocationsSecondViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UIButton *sendMessageBtn;
//@property (nonatomic, strong) UITextField *chatBox;
//@property (nonatomic, strong) UITextView *textBox;

@end

@implementation LocationsSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, t ypically from a nib.
    [self setUpUI];
    [self setUpMultipeer];
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
    [self.view addSubview:self.browserButton];
    self.browserButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.browserButton addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendMessageBtn setTitle:@"Send" forState:UIControlStateNormal];
    self.sendMessageBtn.frame = CGRectMake(330, 400, 100, 50);
    [self.view addSubview:self.sendMessageBtn];
    self.sendMessageBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.sendMessageBtn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    
//    //  Setup TextBox
//    self.textBox = [[UITextView alloc] initWithFrame: CGRectMake(240, 350, 240, 270)];
//    self.textBox.editable = NO;
//    self.textBox.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview: self.textBox];
//    
//    //  Setup ChatBox
//    self.chatBox = [[UITextField alloc] initWithFrame: CGRectMake(240, 260, 240, 70)];
//    self.chatBox.backgroundColor = [UIColor lightGrayColor];
//    self.chatBox.returnKeyType = UIReturnKeySend;
//    self.chatBox.delegate = self;
//    [self.view addSubview:self.chatBox];
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
    NSError *error;
    [self.mySession sendData:[[NSData alloc] initWithData:[NSKeyedArchiver archivedDataWithRootObject:@"Please Work"]] toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
//    //  Retrieve text from chat box and clear chat box
//    NSString *message = self.chatBox.text;
//    self.chatBox.text = @"";
//    
//    //  Convert text to NSData
//    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //  Send data to connected peers
//    NSError *error;
//    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
//    
//    //  Append your own message to text box
//    [self receiveMessage: message fromPeer: self.myPeerID];
}

- (void) receiveMessage: (NSString *) message fromPeer: (MCPeerID *) peer{
//    //  Create the final text to append
//    NSString *finalText;
//    if (peer == self.myPeerID) {
//        finalText = [NSString stringWithFormat:@"\nme: %@ \n", message];
//    }
//    else{
//        finalText = [NSString stringWithFormat:@"\n%@: %@ \n", peer.displayName, message];
//    }
//    
//    //  Append text to text box
//    self.textBox.text = [self.textBox.text stringByAppendingString:finalText];
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

#pragma marks UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendText];
    return YES;
}

#pragma marks MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected!");
    }
    else{
        NSLog(@"Disconnected");
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    //  Decode data back to NSString
    NSString *message = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //  append message to text box:
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self receiveMessage:message fromPeer:peerID];
        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Hey!"
                                                               message:message
                                                              delegate:nil
                                                     cancelButtonTitle:@"Cool"
                                                     otherButtonTitles:nil];
        [messageAlert show];
    });
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
//
//// Core Data Filepath
//NSFileManager *FSAfileManager;
//NSURL *FSAdocumentsDirectory;
//NSString *FSAdocumentName;
//NSURL *FSApathurl;
//UIManagedDocument *FSAdocument;
//NSManagedObjectContext *context;
//
//-(void)viewDidLoad{
//    [super viewDidLoad];
//    
////    // *** Map to Core Data ***
////    FSAfileManager = [NSFileManager defaultManager];
////    FSAdocumentsDirectory = [[FSAfileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
////    FSAdocumentName = @"FSA";
////    FSApathurl = [FSAdocumentsDirectory URLByAppendingPathComponent:FSAdocumentName];
////    FSAdocument = [[UIManagedDocument alloc] initWithFileURL:FSApathurl];
////    context = FSAdocument.managedObjectContext;
////    
////    if ([[NSFileManager defaultManager] fileExistsAtPath:[FSApathurl path]]) {
////        [FSAdocument openWithCompletionHandler:^(BOOL success){
////            if (success) NSLog(@"Found the document!");
////            if (!success) NSLog(@"Couldn't find the document at path: %@", FSApathurl);
////        }];
////    }
////    else{
////        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
////            if (success) NSLog(@"Created the document!");
////            if (!success) NSLog(@"Couldn't create the document at path: %@", FSApathurl);
////        }];
////    }
////    // *** Done Mapping to Core Data **
//    
//    [_advertiseSwitcher setOn:false animated:YES];
//    
//    [self setUpMultipeer];
//}
//
//- (void) setUpMultipeer{
//    //  Setup peer ID
//    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
//    
//    //  Setup session
//    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
//    self.mySession.delegate = self;
//    
//    //  Setup BrowserViewController
//    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.mySession];
//    self.browserVC.delegate = self;
//    
//    //  Setup Advertiser
//    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.mySession];
//    
//}
//
//- (void) showBrowserVC{
//    [self presentViewController:self.browserVC animated:YES completion:nil];
//}
//
//- (IBAction)hostBtn:(id)sender {
//    [self showBrowserVC];
//}
//
//
//- (void) dismissBrowserVC{
//    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma marks MCBrowserViewControllerDelegate
//
//// Notifies the delegate, when the user taps the done button
//- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
//    [self dismissBrowserVC];
//}
//
//// Notifies delegate that the user taps the cancel button.
//- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
//    [self dismissBrowserVC];
//}
//- (IBAction)visibleSwitch:(id)sender {
//    if (_advertiseSwitcher.on) {
//        [self.advertiser start];
//    }
//}
//- (IBAction)sendMatchesBtn:(id)sender {
////    NSMutableDictionary *dictToSend = [[NSMutableDictionary alloc] init];
//    NSString *message = @"Please work";
////    NSFetchRequest *regionalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Regional"];
////    NSError *regionalError;
////    
////    NSArray *regionals = [context executeFetchRequest:regionalRequest error:&regionalError];
////    for (Regional *rgnl in regionals) {
////        [dictToSend setObject:[[NSMutableDictionary alloc] init] forKey:rgnl.name];
////        for (Team *tm in rgnl.teams) {
////            [[dictToSend objectForKey:rgnl.name] setObject:[[NSMutableDictionary alloc] init] forKey:tm.name];
////            for (Match *mtch in tm.matches) {
////                [[[dictToSend objectForKey:rgnl.name] objectForKey:tm.name]
////                 setObject:[[NSDictionary alloc]
////                            initWithObjectsAndKeys:
////                            [NSNumber numberWithInteger:[mtch.autoHighHotScore integerValue]], @"autoHighHotScore",
////                            [NSNumber numberWithInteger:[mtch.autoHighNotScore integerValue]], @"autoHighNotScore",
////                            [NSNumber numberWithInteger:[mtch.autoHighMissScore integerValue]], @"autoHighMissScore",
////                            [NSNumber numberWithInteger:[mtch.autoLowHotScore integerValue]], @"autoLowHotScore",
////                            [NSNumber numberWithInteger:[mtch.autoLowNotScore integerValue]], @"autoLowNotScore",
////                            [NSNumber numberWithInteger:[mtch.autoLowMissScore integerValue]], @"autoLowMissScore",
////                            [NSNumber numberWithInteger:[mtch.mobilityBonus integerValue]], @"mobilityBonus",
////                            [NSNumber numberWithInteger:[mtch.teleopHighMake integerValue]], @"teleopHighMake",
////                            [NSNumber numberWithInteger:[mtch.teleopHighMiss integerValue]], @"teleopHighMiss",
////                            [NSNumber numberWithInteger:[mtch.teleopLowMake integerValue]], @"teleopLowMake",
////                            [NSNumber numberWithInteger:[mtch.teleopLowMiss integerValue]], @"teleopLowMiss",
////                            [NSNumber numberWithInteger:[mtch.teleopOver integerValue]], @"teleopOver",
////                            [NSNumber numberWithInteger:[mtch.teleopPassed integerValue]], @"teleopPassed",
////                            [NSNumber numberWithInteger:[mtch.penaltyLarge integerValue]], @"penaltyLarge",
////                            [NSNumber numberWithInteger:[mtch.penaltySmall integerValue]], @"penaltySmall",
////                            [NSString stringWithString:mtch.notes], @"notes",
////                            [NSString stringWithString:mtch.red1Pos], @"red1Pos",
////                            [NSString stringWithString:mtch.recordingTeam], @"recordingTeam",
////                            [NSString stringWithString:mtch.scoutInitials], @"scoutInitials",
////                            [NSString stringWithString:mtch.matchType], @"matchType",
////                            [NSString stringWithString:mtch.matchNum], @"matchNum",
////                            [NSNumber numberWithInteger:[mtch.uniqeID integerValue]], @"uniqueID",nil] forKey:mtch.matchNum];
////            }
////        }
////    }
//    
//    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject:message];
//    
//    NSError *error;
//    [self.mySession sendData:dataToSend toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataReliable error:&error];
//}
//
//#pragma marks MCSessionDelegate
//// Remote peer changed state
//- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
//    if (state == MCSessionStateConnected) {
//        NSLog(@"Connected!");
//    }
//    else{
//        NSLog(@"Disconnected");
//    }
//}
//
//// Received data from remote peer
//- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
//    NSString *messageReceived = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"New Message!"
//                                                               message: messageReceived
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"Cool"
//                                                     otherButtonTitles:nil];
//        [messageAlert show];
//    });
//    
//    
////    NSDictionary *receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    
////    [context performBlock:^{
////        for (NSString *rgnl in receivedDataDict) {
////            Regional *regional = [Regional createRegionalWithName:rgnl inManagedObjectContext:context];
////            for (NSString *tm in [receivedDataDict objectForKey:rgnl]) {
////                Team *team = [Team createTeamWithName:tm inRegional:regional withManagedObjectContext:context];
////                for (NSString *mtch in [[receivedDataDict objectForKey:rgnl] objectForKey:tm]) {
////                    NSDictionary *matchDict = [[[receivedDataDict objectForKey:rgnl] objectForKey:tm] objectForKey:mtch];
////                    int uniqueID = [[matchDict objectForKey:@"uniqueID"] intValue];
////                    Match *match = [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
////                    if ([match.uniqeID intValue] != uniqueID) {
////                        [FSAdocument.managedObjectContext deleteObject:match];
////                        [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
////                    }
////                    [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
////                }
////            }
////        }
////    }];
//    
//}
//
//// Received a byte stream from remote peer
//- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
//    
//}
//
//// Start receiving a resource from remote peer
//- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
//    
//}
//
//// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
//- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
//    
//}
//
//
@end











