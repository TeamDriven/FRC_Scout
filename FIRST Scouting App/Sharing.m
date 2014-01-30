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


@interface LocationsSecondViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITextFieldDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@property (nonatomic, strong) UIButton *browserButton;
@property (nonatomic, strong) UIButton *inviteMoreBtn;
@property (nonatomic, strong) UIButton *sendMessageBtn;
@property (nonatomic, strong) UIButton *cancelTransferBtn;
@property (nonatomic, strong) UISwitch *browserSwitch;
@property (nonatomic, strong) UISwitch *visibleSwitch;
@property (nonatomic, strong) UISwitch *overWriteSwitch;

@property (nonatomic,strong) UIActivityIndicatorView *loadingWheel;
@property (nonatomic, strong) UIProgressView *progressBar;

@end

static NSString * const kProgressCancelledKeyPath          = @"cancelled";
static NSString * const kProgressCompletedUnitCountKeyPath = @"completedUnitCount";

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
UISegmentedControl *positionSelector;
UITextField *teamNumberField;
UIButton *doneButton;

UILabel *overWriteLbl;
BOOL overWrite;

-(void)viewDidLoad{
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
    
    if (pos.length == 0 || pos == nil || scoutTeamNum.length == 0 || scoutTeamNum == nil) {
        grayOUT = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        grayOUT.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [grayOUT addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:grayOUT];
        
        miniSignIn = [[UIControl alloc]  initWithFrame:CGRectMake(184, 380, 400, 200)];
        miniSignIn.backgroundColor = [UIColor whiteColor];
        miniSignIn.layer.cornerRadius = 10;
        [miniSignIn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *whoaThereLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
        whoaThereLbl.text = @"Whoa there! Please Sign in!";
        whoaThereLbl.textAlignment = NSTextAlignmentCenter;
        whoaThereLbl.font = [UIFont systemFontOfSize:15];
        [miniSignIn addSubview:whoaThereLbl];
        
        positionSelector = [[UISegmentedControl alloc] initWithItems:@[@"Red 1", @"Red 2", @"Red 3", @"Blue 1", @"Blue 2", @"Blue 3"]];
        positionSelector.frame = CGRectMake(30, 50, 340, 30);
        [positionSelector addTarget:self action:@selector(positionChanged) forControlEvents:UIControlEventValueChanged];
        [miniSignIn addSubview:positionSelector];
        
        teamNumberField = [[UITextField alloc] initWithFrame:CGRectMake(140, 100, 120, 30)];
        teamNumberField.delegate = self;
        teamNumberField.placeholder = @"YOUR Team #";
        teamNumberField.font = [UIFont systemFontOfSize:14];
        [teamNumberField addTarget:self action:@selector(teamNumberEndedEditing) forControlEvents:UIControlEventEditingDidEnd];
        [teamNumberField addTarget:self action:@selector(numberChecker) forControlEvents:UIControlEventEditingChanged];
        teamNumberField.keyboardType = UIKeyboardTypeNumberPad;
        teamNumberField.borderStyle = UITextBorderStyleRoundedRect;
        teamNumberField.textAlignment = NSTextAlignmentCenter;
        [miniSignIn addSubview:teamNumberField];
        
        doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [doneButton addTarget:self action:@selector(closeMiniSignIn) forControlEvents:UIControlEventTouchUpInside];
        doneButton.frame = CGRectMake(165, 150, 70, 40);
        doneButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        doneButton.layer.cornerRadius = 5;
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        doneButton.enabled = false;
        [miniSignIn addSubview:doneButton];
        
        [grayOUT addSubview:miniSignIn];
        miniSignIn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 animations:^{
            miniSignIn.transform = CGAffineTransformIdentity;
        }];
    }
    else{
        [self setUpMultipeer];
    }
}



-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard{
    [teamNumberField resignFirstResponder];
}
-(void)positionChanged{
    pos = [positionSelector titleForSegmentAtIndex:positionSelector.selectedSegmentIndex];
    NSLog(@"Position: %@", pos);
    if (teamNumberField.text.length > 0 && pos.length > 0) {
        doneButton.enabled = true;
    }
    else{
        doneButton.enabled = false;
    }
}
-(void)numberChecker{
    NSMutableString *txt1 = [[NSMutableString alloc] initWithString:teamNumberField.text];
    for (unsigned int i = 0; i < [txt1 length]; i++) {
        NSString *character = [[NSString alloc] initWithFormat:@"%C", [txt1 characterAtIndex:i]];
        if ([character isEqualToString:@" "]){
            [txt1 deleteCharactersInRange:NSMakeRange(i, 1)];
            teamNumberField.text = [[NSString alloc] initWithString:txt1];
        }
        else if ([character integerValue] == 0 && ![character isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Numbers only please!"
                                                           message: @"Please only enter numbers in the \"Team Number\" text field"
                                                          delegate: nil
                                                 cancelButtonTitle:@"Sorry..."
                                                 otherButtonTitles:nil];
            [alert show];
            [txt1 deleteCharactersInRange:NSMakeRange(i, 1)];
            teamNumberField.text = [[NSString alloc] initWithString:txt1];
        }
    }
    if (teamNumberField.text.length > 4) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:teamNumberField.text];
        [text deleteCharactersInRange:NSMakeRange(text.length -1, 1)];
        teamNumberField.text = text;
    }
    if (teamNumberField.text.length == 0) {
        doneButton.enabled = false;
    }
    else if(teamNumberField.text.length > 0){
        doneButton.enabled = true;
    }
}
-(void)teamNumberEndedEditing{
    scoutTeamNum = teamNumberField.text;
    if (teamNumberField.text.length > 0 && pos.length > 0) {
        doneButton.enabled = true;
    }
    else{
        doneButton.enabled = false;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)closeMiniSignIn{
    [teamNumberField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        miniSignIn.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [miniSignIn removeFromSuperview];
        [grayOUT removeFromSuperview];
        [self setUpMultipeer];
    }];
}

-(void)setUpUI{
    UILabel *browserSwitchLbl = [[UILabel alloc] initWithFrame:CGRectMake(234, 100, 100, 20)];
    browserSwitchLbl.text = @"Host";
    browserSwitchLbl.font = [UIFont systemFontOfSize:16];
    browserSwitchLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:browserSwitchLbl];
    
    self.browserSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(259, 120, 49, 31)];
    [self.browserSwitch addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.browserSwitch];
    
    self.inviteMoreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.inviteMoreBtn.frame = CGRectMake(244, 160, 80, 30);
    [self.inviteMoreBtn addTarget:self action:@selector(showBrowserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteMoreBtn setTitle:@"Invite More" forState:UIControlStateNormal];
    self.inviteMoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.inviteMoreBtn];
    self.inviteMoreBtn.enabled = false;
    self.inviteMoreBtn.alpha = 0;
    
    UILabel *visibleSwitchLbl = [[UILabel alloc] initWithFrame:CGRectMake(434, 100, 100, 20)];
    visibleSwitchLbl.text = @"Visible";
    visibleSwitchLbl.font = [UIFont systemFontOfSize:16];
    visibleSwitchLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:visibleSwitchLbl];
    
    self.visibleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(459, 120, 49, 31)];
    [self.visibleSwitch addTarget:self action:@selector(visibleSwitchChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.visibleSwitch];
    [self.visibleSwitch setOn:true animated:YES];

    self.sendMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendMessageBtn setTitle:@"Send" forState:UIControlStateNormal];
    self.sendMessageBtn.frame = CGRectMake(330, 250, 100, 50);
    self.sendMessageBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.sendMessageBtn.layer.cornerRadius = 5;
    [self.sendMessageBtn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendMessageBtn];
    self.sendMessageBtn.enabled = false;
    self.sendMessageBtn.alpha = 0;
    
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressBar.frame = CGRectMake(309, 310, 150, 2);
    [self.view addSubview:self.progressBar];
    self.progressBar.alpha = 0;
    
    overWriteLbl = [[UILabel alloc] initWithFrame:CGRectMake(324, 320, 120, 20)];
    overWriteLbl.text = @"Allow Overwriting";
    overWriteLbl.textAlignment = NSTextAlignmentCenter;
    overWriteLbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:overWriteLbl];
    overWriteLbl.alpha = 0;
    
    self.overWriteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(359, 340, 49, 31)];
    [self.overWriteSwitch addTarget:self action:@selector(overWriteOption) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.overWriteSwitch];
    self.overWriteSwitch.hidden = true;
    self.overWriteSwitch.enabled = false;

}

-(void)setUpMultipeer{
    //  Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[[NSString alloc] initWithFormat:@"%@ - %@", pos, scoutTeamNum]];
    
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

-(void)visibleSwitchChanged{
    if (self.visibleSwitch.on) {
        [self setUpMultipeer];
    }
    else{
        [self.mySession disconnect];
        [self.advertiser stop];
    }
}

-(void)showBrowserVC{
    if (self.browserSwitch.on) {
        [self presentViewController:self.browserVC animated:YES completion:nil];
        self.inviteMoreBtn.enabled = true;
        self.inviteMoreBtn.alpha = 1;
    }
    else{
        self.inviteMoreBtn.enabled = false;
        self.inviteMoreBtn.alpha = 0;
    }
}

-(void)dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendText{
    self.sendMessageBtn.enabled = false;
    
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
    
    NSData *dataWithDictToSend = [NSKeyedArchiver archivedDataWithRootObject:dictToSend];
    
    
    NSURL *tempDataURL = [FSAdocumentsDirectory URLByAppendingPathComponent:@"tempData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[tempDataURL path]]) {
        NSError *deleteError;
        if (![[NSFileManager defaultManager] removeItemAtURL:tempDataURL error:&deleteError]) {
            NSLog(@"Delete Error: %@", deleteError);
        }
    }
    
    [dataWithDictToSend writeToURL:tempDataURL atomically:YES];
    
    NSProgress *progress = [self.mySession sendResourceAtURL:tempDataURL withName:@"temporaryData" toPeer:[[self.mySession connectedPeers] objectAtIndex:0] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"[Error] %@", error);
        }
        else{
            NSLog(@"Send Success!");
        }
    }];
    [progress addObserver:self forKeyPath:kProgressCancelledKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [progress addObserver:self forKeyPath:kProgressCompletedUnitCountKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    self.progressBar.alpha = 1;
    self.progressBar.progress = progress.fractionCompleted;
}

-(void)overWriteOption{
    if (self.overWriteSwitch.on) {
        overWrite = true;
        UIAlertView *overWriteCaution = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                              message:@"By setting this mode ON, you are allowing any and all data sent to you to overwrite your data if there happens to be any duplicates. Turn the switch back off if you do not want this feature." delegate:nil cancelButtonTitle:@"Got it, Cap'n" otherButtonTitles: nil];
        [overWriteCaution show];
    }
    else{
        overWrite = false;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = object;
        
//        if (((int)progress.fractionCompleted % (int)[NSNumber numberWithFloat:0.01]) == 0) {
//            NSLog(@"PROGRESS: %f", progress.fractionCompleted);
//        }
        if ([keyPath isEqualToString:kProgressCancelledKeyPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.progressBar.alpha = 0;
                } completion:^(BOOL finished) {
                    self.progressBar.progress = 0.0;
                }];
            });
        }
        else if ([keyPath isEqualToString:kProgressCompletedUnitCountKeyPath]){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBar.progress = progress.fractionCompleted;
            });
        
            if (progress.completedUnitCount == progress.totalUnitCount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2 animations:^{
                        self.progressBar.alpha = 0;
                    } completion:^(BOOL finished) {
                        self.progressBar.progress = 0.0;
                    }];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[[FSAdocumentsDirectory URLByAppendingPathComponent:@"tempData"] path]]) {
                        NSError *deleteSentDataError;
                        if (![[NSFileManager defaultManager] removeItemAtURL:[FSAdocumentsDirectory URLByAppendingPathComponent:@"tempData"] error:&deleteSentDataError]) {
                            NSLog(@"Delete Sent Data Error: %@", deleteSentDataError);
                        }
                    }
                    self.sendMessageBtn.enabled = true;
                });
            }
        }
    }
}

#pragma marks MCBrowserViewControllerDelegate

// Notifies the delegate, when the user taps the done button
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
    
}

// Notifies delegate that the user taps the cancel button.
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate
// Remote peer changed state
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state == MCSessionStateConnected) {
        NSLog(@"Connected!");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *connectedAlert = [[UIAlertView alloc] initWithTitle:@"Wohoo!"
                                                                     message:[[NSString alloc] initWithFormat:@"You connected with %@", peerID.displayName]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Awesometastic"
                                                           otherButtonTitles:nil];
            [connectedAlert show];
            [UIView animateWithDuration:0.2 animations:^{
                self.sendMessageBtn.alpha = 1;
                self.overWriteSwitch.alpha = 1;
                overWriteLbl.alpha = 1;
            } completion:^(BOOL finished) {
                self.sendMessageBtn.enabled = true;
                self.overWriteSwitch.hidden = false;
                self.overWriteSwitch.enabled = true;
//                [self.overWriteSwitch setOn:false animated:YES];
            }];
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
            if ([[self.mySession connectedPeers] count] == 0) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.sendMessageBtn.alpha = 0;
                    overWriteLbl.alpha = 0;
                } completion:^(BOOL finished) {
                    self.sendMessageBtn.enabled = false;
                    self.overWriteSwitch.hidden = true;
                    self.overWriteSwitch.enabled = false;
                }];
            };
        });
    }
}

// Received data from remote peer
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSLog(@"Did receive data of %lu bytes", (unsigned long)data.length);
}

// Received a byte stream from remote peer
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

// Start receiving a resource from remote peer
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    NSProgress *progres = progress;
    [progres addObserver:self forKeyPath:kProgressCancelledKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [progres addObserver:self forKeyPath:kProgressCompletedUnitCountKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.progressBar.alpha = 1;
        }];
        self.sendMessageBtn.enabled = false;
    });
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    NSURL *receivedTempDataURL = [FSAdocumentsDirectory URLByAppendingPathComponent:@"receivedTempData"];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSString alloc] initWithString:[receivedTempDataURL path]]]) {
        NSError *errorA;
        [[NSFileManager defaultManager] removeItemAtPath:[receivedTempDataURL path] error:&errorA];
        if (errorA) {
            NSLog(@"Removing Error: %@", errorA);
        }
    }
    else{
        [[NSFileManager defaultManager] createFileAtPath:[receivedTempDataURL path] contents:nil attributes:nil];
    }
    
    NSLog(@"HOLY CRAP IT FINISHED!!");
    
    NSError *error2 = nil;
    if (![[NSFileManager defaultManager] moveItemAtURL:localURL
                                                 toURL:receivedTempDataURL
                                                 error:&error2]) {
        NSLog(@"[Error] %@", error2);
    }
    else{
        NSLog(@"Saved successfully!!!");
    }
    
    [self updateCoreDataFromTransferredFileFromPeer:peerID];
}

-(void)updateCoreDataFromTransferredFileFromPeer:(MCPeerID *)peer{
    NSURL *receivedDataURL = [FSAdocumentsDirectory URLByAppendingPathComponent:@"receivedTempData"];
    NSData *dataReceived = [[NSData alloc] initWithContentsOfURL:receivedDataURL];
    NSDictionary *receivedDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataReceived];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingWheel.alpha = 1;
        [self.loadingWheel startAnimating];
        self.sendMessageBtn.enabled = false;
    });
    
    __block NSInteger matchesReceived = 0;
    __block NSInteger pitTeamsReceived = 0;
    
    [context performBlock:^{
        NSDictionary *regionalsDict = [receivedDataDict objectForKey:@"Regionals"];
        for (NSString *rgnl in regionalsDict) {
            Regional *regional = [Regional createRegionalWithName:rgnl inManagedObjectContext:context];
            for (NSString *tm in [regionalsDict objectForKey:rgnl]) {
                Team *team = [Team createTeamWithName:tm inRegional:regional withManagedObjectContext:context];
                for (NSString *mtch in [[regionalsDict objectForKey:rgnl] objectForKey:tm]) {
                    NSDictionary *matchDict = [[[regionalsDict objectForKey:rgnl] objectForKey:tm] objectForKey:mtch];
                    NSFetchRequest *matchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
                    NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"(matchNum = %@) AND (teamNum.name = %@)", [matchDict objectForKey:@"matchNum"], tm];
                    matchRequest.predicate = matchPredicate;
                    NSError *matchError;
                    NSArray *matches = [context executeFetchRequest:matchRequest error:&matchError];
                    if ([matches count] == 0){
                        matchesReceived++;
                    }
                    int uniqueID = [[matchDict objectForKey:@"uniqueID"] intValue];
                    Match *match = [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                    if ([match.uniqeID intValue] != uniqueID && overWrite == true) {
                        [FSAdocument.managedObjectContext deleteObject:match];
                        [Match createMatchWithDictionary:matchDict inTeam:team withManagedObjectContext:context];
                        NSLog(@"Deleted and recreated a match");
                        matchesReceived++;
                    }
                }
            }
        }
        NSDictionary *pitTeamsDict = [receivedDataDict objectForKey:@"PitTeams"];
        for (NSString *pt in pitTeamsDict) {
            NSFetchRequest *pitTeamRequest = [NSFetchRequest fetchRequestWithEntityName:@"PitTeam"];
            NSPredicate *pitTeamPredicate = [NSPredicate predicateWithFormat:@"(teamNumber = %@)", pt];
            pitTeamRequest.predicate = pitTeamPredicate;
            NSError *pitTeamError;
            NSArray *pitTeams = [context executeFetchRequest:pitTeamRequest error:&pitTeamError];
            if ([pitTeams count] == 0){
                pitTeamsReceived++;
            }
            int uniqueID = [[[pitTeamsDict objectForKey:pt] objectForKey:@"uniqueID"] intValue];
            PitTeam *pitTeam = [PitTeam createPitTeamWithDictionary:[pitTeamsDict objectForKey:pt] inManagedObjectContext:context];
            if (uniqueID != [pitTeam.uniqueID intValue] && overWrite == true) {
                [FSAdocument.managedObjectContext deleteObject:pitTeam];
                [PitTeam createPitTeamWithDictionary:[pitTeamsDict objectForKey:pt] inManagedObjectContext:context];
                NSLog(@"Deleted and recreated a pit scouted team");
                pitTeamsReceived++;
            }
        }
        
        [FSAdocument saveToURL:FSApathurl forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"You Got Mail!"
                                                                   message:[[NSString alloc] initWithFormat:@"%@ sent you: \n %ld New Matches and \n %ld New Pit Scouted Teams!", peer.displayName, (long)matchesReceived, (long)pitTeamsReceived]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Cool"
                                                         otherButtonTitles:nil];
            [messageAlert show];
            [self.loadingWheel stopAnimating];
            self.loadingWheel.alpha = 0;
            self.sendMessageBtn.enabled = true;
        });
        
        NSError *deleteError;
        if (![[NSFileManager defaultManager] removeItemAtURL:receivedDataURL error:&deleteError]) {
            NSLog(@"Error: %@", deleteError);
        }
        else{
            NSLog(@"Deleted received data properly!");
        }
        
    }];

}

@end











