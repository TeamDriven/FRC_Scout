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

@interface LocationsFirstViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (strong, nonatomic) MCSession *session;

// User interaction on the match recording page
@property (weak, nonatomic) IBOutlet UITextField *matchNumField;
@property (weak, nonatomic) IBOutlet UITextField *teamNumField;
@property (weak, nonatomic) IBOutlet UIButton *matchNumEdit;
@property (weak, nonatomic) IBOutlet UIButton *teamNumEdit;

// Labels for the selected name of the regional and initials of the scouter (updates after setUpView closes)
@property (weak, nonatomic) IBOutlet UILabel *regionalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *initialsLbl;

// Labels that switch on two finger swipe to indicate the two modes of the game
@property (weak, nonatomic) IBOutlet UILabel *autoTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopTitleLbl;

// Labels that are updated when the scout changes the values in the respective areas
@property (weak, nonatomic) IBOutlet UILabel *teleopHighScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoHighScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMidScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMidScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopLowScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoLowScoreLbl;

// Penalty items
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyLbl;
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyTitleLbl;
@property (weak, nonatomic) IBOutlet UIStepper *smallPenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyLbl;
@property (weak, nonatomic) IBOutlet UIStepper *largePenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyTitleLbl;

// Autonomous buttons that let the user change the high/mid/low values (orange)
@property (weak, nonatomic) IBOutlet UIButton *autoHighMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoHighPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoMidMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoMidPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLowMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLowPlusBtn;

// Teleoperated buttons that let the user change the high/mid/low values (gray and black)
@property (weak, nonatomic) IBOutlet UIButton *teleopHighMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopHighPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopMidMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopMidPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopLowMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopLowPlusBtn;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
