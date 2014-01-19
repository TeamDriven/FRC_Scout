//
//  LocationsFirstViewController.h
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface LocationsFirstViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate, UITextFieldDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate>

// Multipeer Connectivity stuff
@property (nonatomic, strong) MCBrowserViewController *browserVCS;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiserS;
@property (nonatomic, strong) MCSession *browserSession;
@property (nonatomic, strong) MCSession *advertiserSession;
@property (nonatomic, strong) MCPeerID *myPeerIDS;

// User interaction on the match recording page
@property (weak, nonatomic) IBOutlet UITextField *matchNumField;
@property (weak, nonatomic) IBOutlet UITextField *teamNumField;
@property (weak, nonatomic) IBOutlet UIButton *matchNumEdit;
@property (weak, nonatomic) IBOutlet UIButton *teamNumEdit;
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;

// Labels for the selected name of the regional and initials of the scouter (updates after setUpView closes)
@property (weak, nonatomic) IBOutlet UILabel *regionalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *initialsLbl;

// Labels that switch on two finger swipe to indicate the two modes of the game
@property (weak, nonatomic) IBOutlet UILabel *autoTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopTrussLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopAssistsLbl;



// Autonomous labels that are updated when the scout changes the values in the respective areas
@property (weak, nonatomic) IBOutlet UILabel *autoHotHighLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoHotHighDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoNotHighLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoNotHighDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMissHighLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMissHighDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoHotLowLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoHotLowDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoNotLowLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoNotLowDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMissLowLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMissLowDispLbl;

// Autonomous buttons that let the user change the high/low values (orange)
@property (weak, nonatomic) IBOutlet UIButton *autoHotHighPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoHotHighMinus;
@property (weak, nonatomic) IBOutlet UIButton *autoNotHighPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoNotHighMinus;
@property (weak, nonatomic) IBOutlet UIButton *autoMissHighPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoMissHighMinus;
@property (weak, nonatomic) IBOutlet UIButton *autoHotLowPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoHotLowMinus;
@property (weak, nonatomic) IBOutlet UIButton *autoNotLowPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoNotLowMinus;
@property (weak, nonatomic) IBOutlet UIButton *autoMissLowPlus;
@property (weak, nonatomic) IBOutlet UIButton *autoMissLowMinus;

@property (weak, nonatomic) IBOutlet UIImageView *swipeUpArrow;
@property (weak, nonatomic) IBOutlet UIImageView *movementRobot;
@property (weak, nonatomic) IBOutlet UIView *movementLine;
@property (weak, nonatomic) IBOutlet UILabel *mobilityBonusLbl;



// Teleop labels that are updated when the scout changes the values in the respective areas
@property (weak, nonatomic) IBOutlet UILabel *teleopMakeHighLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMakeHighDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMissHighLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMissHighDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMakeLowLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMakeLowDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMissLowLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMissLowDispLbl;

@property (weak, nonatomic) IBOutlet UILabel *teleopOverLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopOverDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopCatchLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopCatchDispLbl;

@property (weak, nonatomic) IBOutlet UILabel *teleopPassedLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopPassedDispLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopReceivedLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopReceivedDispLbl;

// Teleop buttons that let the user change the high/low values (brown)
@property (weak, nonatomic) IBOutlet UIButton *teleopMakeHighPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMakeHighMinus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMissHighPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMissHighMinus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMakeLowPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMakeLowMinus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMissLowPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopMissLowMinus;

@property (weak, nonatomic) IBOutlet UIButton *teleopOverPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopOverMinus;
@property (weak, nonatomic) IBOutlet UIButton *teleopCatchPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopCatchMinus;

@property (weak, nonatomic) IBOutlet UIButton *teleopPassedPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopPassedMinus;
@property (weak, nonatomic) IBOutlet UIButton *teleopReceivedPlus;
@property (weak, nonatomic) IBOutlet UIButton *teleopReceivedMinus;


// Penalty items
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyLbl;
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyTitleLbl;
@property (weak, nonatomic) IBOutlet UIStepper *smallPenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyLbl;
@property (weak, nonatomic) IBOutlet UIStepper *largePenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyTitleLbl;



// Persistent save button
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end






