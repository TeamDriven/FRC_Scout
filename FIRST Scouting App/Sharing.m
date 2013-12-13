//
//  LocationsSecondViewController.m
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Sharing.h"

@interface LocationsSecondViewController ()

@end

@implementation LocationsSecondViewController

NSArray *paths;
NSString *scoutingDirectory;
NSString *path;
NSMutableDictionary *dataDict;
NSMutableDictionary *receivedDataDict;


NSInteger overWrite;

NSString *key1;
NSString *key2;

NSString *pos;

NSData *dataToSend;
NSData *dataReceived;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", pos);
    
    [self setUpData];
    
    [_advertiseSwitcher setOn:false animated:YES];
    [_overWriteSwitch setOn:false animated:YES];
    
    
    //_sendMatchesBtn.enabled = false;
    //_sendMatchesBtn.alpha = 0.3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************************************************************************
********************    Reusable Methods    *****************************
************************************************************************/


-(void)setUpMultiPeer{
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:pos];
    
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"FIRST-SCOUT" session:self.mySession];
    
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"FIRST-SCOUT" discoveryInfo:nil session:self.mySession];
    
    self.browserVC.delegate = self;
    
    self.mySession.delegate = self;
    
    
}

-(void)setUpData{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    scoutingDirectory = [paths objectAtIndex:0];
    path = [scoutingDirectory stringByAppendingPathComponent:@"data.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"data" ofType:@"plist"] toPath:path error:nil];
    }
    
    dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
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
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Somebody Left!"
                                                       message: [[NSString alloc] initWithFormat:@"%@", [peerID displayName]]
                                                      delegate: nil
                                             cancelButtonTitle:@"Got it bro"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"DATA RECEIVED: %lu bytes!", (unsigned long)data.length);
    dataReceived = data;
    receivedDataDict = [[NSMutableDictionary alloc] init];
    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle: @"Hey!"
                                                   message: [[NSString alloc] initWithFormat:@"%@ is trying to send you data! Will you accept it?", [peerID displayName]]
                                                  delegate: self
                                         cancelButtonTitle:@"NEVER!!"
                                         otherButtonTitles:@"Yeah, I guess..." ,nil];
    [alert1 show];
    NSLog(@"Should Show Alert");
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
    
    dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
    NSError *error;
    NSArray *peerIDs = [self.sessionTwo connectedPeers];
    [self.sessionTwo sendData:dataToSend toPeers:peerIDs withMode:MCSessionSendDataReliable error:&error];
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
    if (buttonIndex == 1) {
        for (key1 in receivedDataDict) {
        if ([dataDict objectForKey:key1] == nil) {
            NSLog(@"Writing new folder");
            [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:key1];
        }
        for (key2 in [receivedDataDict objectForKey:key1]) {
            if ([[dataDict objectForKey:key1] objectForKey:key2] == nil) {
                NSLog(@"Writing a new file");
                [[dataDict objectForKey:key1] setObject:[[receivedDataDict objectForKey:key1] objectForKey:key2] forKey:key2];
            }
            else{
                if (overWrite == 1) {
                    [[dataDict objectForKey:key1] setObject:[[receivedDataDict objectForKey:key1] objectForKey:key2] forKey:key2];
                }
            }
        }
    }
    [dataDict writeToFile:path atomically:YES];
    NSLog(@"%@", dataDict);
    receivedDataDict = nil;
    [_overWriteSwitch setOn:false animated:YES];
    }
}




@end
