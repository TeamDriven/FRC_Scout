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
@property (weak, nonatomic) IBOutlet UILabel *movementBonusLbl;

// Penalty items
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyLbl;
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyTitleLbl;
@property (weak, nonatomic) IBOutlet UIStepper *smallPenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyLbl;
@property (weak, nonatomic) IBOutlet UIStepper *largePenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyTitleLbl;
// Teleoperated buttons that let the user change the high/mid/low values (gray and black)


@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
