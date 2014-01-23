//
//  RecordTeam.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTeam : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teamNumberField;
@property (weak, nonatomic) IBOutlet UITextField *teamNameField;

@property (weak, nonatomic) IBOutlet UITextView *additionalNotesTxtField;

@property (weak, nonatomic) IBOutlet UILabel *driveTrainLbl;
@property (weak, nonatomic) IBOutlet UILabel *shooterLbl;
@property (weak, nonatomic) IBOutlet UILabel *preferredGoalLbl;
@property (weak, nonatomic) IBOutlet UILabel *goalieArmLbl;
@property (weak, nonatomic) IBOutlet UILabel *floorCollectorLbl;
@property (weak, nonatomic) IBOutlet UILabel *autonomousLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoStartingPositionLbl;
@property (weak, nonatomic) IBOutlet UILabel *hotGoalTrackingLbl;
@property (weak, nonatomic) IBOutlet UILabel *catchingMechanismLbl;
@property (weak, nonatomic) IBOutlet UILabel *bumperQualityLbl;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
