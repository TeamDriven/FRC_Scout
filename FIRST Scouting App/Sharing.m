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

UIView *red1View;
UIView *greyOut;
UISegmentedControl *red1Selector;
UIButton *saveBtn;

UIView *headsUpView;

NSInteger overWrite;

NSString *key1;
NSString *key2;
NSString *key3;

NSString *pos;

NSData *dataToSend;
NSData *dataReceived;



- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", pos);
    
    [self setUpData];
    
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

- (void)didReceiveMemoryWarning
{
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
    NSLog(@"Initializing ReceivedDataDict");
    receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    NSLog(@"ReceivedDataDict is Unarchived");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Hey!"
                                                   message: [[NSString alloc] initWithFormat:@"%@ is trying to send you data! Do you accept?", [peerID displayName]]
                                                  delegate: self
                                         cancelButtonTitle:@"Nuh Uh!!"
                                         otherButtonTitles:@"Ok, I guess.",nil];
    [alert show];
    
//    [self.view addSubview:greyOut];
//    
//    CGRect headsUpViewRect = CGRectMake(236, 400, 300, 200);
//    headsUpView = [[UIView alloc] initWithFrame:headsUpViewRect];
//    headsUpView.backgroundColor = [UIColor whiteColor];
//    headsUpView.layer.cornerRadius = 10;
//    
//    CGRect headsUpTitleLblRect = CGRectMake(20, 20, 260, 30);
//    UILabel *headsUpTitleLbl = [[UILabel alloc] initWithFrame:headsUpTitleLblRect];
//    headsUpTitleLbl.text = [[NSString alloc] initWithFormat:@"%@ is trying to send you matches!", [peerID displayName]];
//    headsUpTitleLbl.font = [UIFont systemFontOfSize:15];
//    headsUpTitleLbl.textAlignment = NSTextAlignmentCenter;
//    [headsUpView addSubview:headsUpTitleLbl];
//    
//    CGRect headsUpSubTitleLblRect = CGRectMake(50, 60, 200, 30);
//    UILabel *headsUpSubTitleLbl = [[UILabel alloc] initWithFrame:headsUpSubTitleLblRect];
//    headsUpSubTitleLbl.text = @"Do you accept their gift?";
//    headsUpSubTitleLbl.font = [UIFont systemFontOfSize:10];
//    headsUpSubTitleLbl.textAlignment = NSTextAlignmentCenter;
//    [headsUpView addSubview:headsUpSubTitleLbl];
//    
//    CGRect confirmBtnRect = CGRectMake(200, 120, 80, 50);
//    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [confirmBtn addTarget:self action:@selector(headsUpViewClickedButtonAtIndex1) forControlEvents:UIControlEventTouchUpInside];
//    confirmBtn.frame = confirmBtnRect;
//    [confirmBtn setTitle:@"Of Course!" forState:UIControlStateNormal];
//    confirmBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//    [headsUpView addSubview:confirmBtn];
//    confirmBtn.layer.cornerRadius = 5;
//    
//    CGRect cancelBtnRect = CGRectMake(20, 120, 80, 50);
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [cancelBtn addTarget:self action:@selector(cancelHeadsUpView) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.frame = cancelBtnRect;
//    [cancelBtn setTitle:@"Nuh Uh!!" forState:UIControlStateNormal];
//    cancelBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//    [headsUpView addSubview:cancelBtn];
//    cancelBtn.layer.cornerRadius = 5;
//    
//    headsUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
//    [self.view addSubview:headsUpView];
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         headsUpView.transform = CGAffineTransformIdentity;
//                     }
//                     completion:^(BOOL finished){
//                     }];
    
    NSLog(@"Should Show Alert");
}

-(void)cancelHeadsUpView{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         headsUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     }
                     completion:^(BOOL finished){
                         [headsUpView removeFromSuperview];
                         [greyOut removeFromSuperview];
                     }];
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

-(void)headsUpViewClickedButtonAtIndex1{
    for (key1 in receivedDataDict) {
    if (![dataDict objectForKey:key1]) {
        NSLog(@"Writing new red/blue folder");
        [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:key1];
    }
    for (key2 in [receivedDataDict objectForKey:key1]) {
        if (![[dataDict objectForKey:key1] objectForKey:key2]) {
            NSLog(@"Writing a new regional");
            [[dataDict objectForKey:key1] setObject:[[receivedDataDict objectForKey:key1] objectForKey:key2] forKey:key2];
        }
        for (key3 in [[receivedDataDict objectForKey:key1] objectForKey:key2]) {
            if (![[[dataDict objectForKey:key1] objectForKey:key2] objectForKey:key3]) {
                NSLog(@"Writing a new match");
                [[[dataDict objectForKey:key1] objectForKey:key2] setObject:[[[receivedDataDict objectForKey:key1] objectForKey:key2] objectForKey:key3] forKey:key3];
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
    [self cancelHeadsUpView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        for (key1 in receivedDataDict) {
            if (![dataDict objectForKey:key1]) {
                NSLog(@"Writing new red/blue folder");
                [dataDict setObject:[[NSMutableDictionary alloc] init] forKey:key1];
            }
            for (key2 in [receivedDataDict objectForKey:key1]) {
                if (![[dataDict objectForKey:key1] objectForKey:key2]) {
                    NSLog(@"Writing a new regional");
                    [[dataDict objectForKey:key1] setObject:[[receivedDataDict objectForKey:key1] objectForKey:key2] forKey:key2];
                }
                for (key3 in [[receivedDataDict objectForKey:key1] objectForKey:key2]) {
                    if (![[[dataDict objectForKey:key1] objectForKey:key2] objectForKey:key3]) {
                        NSLog(@"Writing a new match");
                        [[[dataDict objectForKey:key1] objectForKey:key2] setObject:[[[receivedDataDict objectForKey:key1] objectForKey:key2] objectForKey:key3] forKey:key3];
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
        if (headsUpView.superview) {
            [self cancelHeadsUpView];
        }
        
    }
}



@end
