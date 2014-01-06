//
//  LocationsFirstViewController.h
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface LocationsFirstViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *matchNumField;
@property (weak, nonatomic) IBOutlet UITextField *teamNumField;
@property (weak, nonatomic) IBOutlet UIButton *matchNumEdit;
@property (weak, nonatomic) IBOutlet UIButton *teamNumEdit;

@property (weak, nonatomic) IBOutlet UILabel *regionalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *initialsLbl;

@property (weak, nonatomic) IBOutlet UILabel *autoTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopTitleLbl;

@property (weak, nonatomic) IBOutlet UILabel *teleopHighScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoHighScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopMidScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoMidScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopLowScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoLowScoreLbl;

@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyLbl;
@property (weak, nonatomic) IBOutlet UILabel *smallPenaltyTitleLbl;
@property (weak, nonatomic) IBOutlet UIStepper *smallPenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyLbl;
@property (weak, nonatomic) IBOutlet UIStepper *largePenaltyStepper;
@property (weak, nonatomic) IBOutlet UILabel *largePenaltyTitleLbl;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIButton *autoHighMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoHighPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoMidMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoMidPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLowMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoLowPlusBtn;

@property (weak, nonatomic) IBOutlet UIButton *teleopHighMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopHighPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopMidMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopMidPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopLowMinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *teleopLowPlusBtn;



@end
