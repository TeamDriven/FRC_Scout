//
//  RecordTeam.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "RecordTeam.h"

@interface RecordTeam ()

@end

@implementation RecordTeam

UIControl *robotImageControl;
UIImageView *robotImage;
UIView *cameraPopup;
UIView *grayLayer;

// Drive Train
UIControl *sixEightWheelDrop;
BOOL isSixEightWheelDrop;
UIControl *fourWheelDrive;
BOOL isFourWheelDrive;
UIControl *mechanum;
BOOL isMechanum;
UIControl *swerveCrab;
BOOL isSwerveCrab;
UITextField *customDriveTrain;
BOOL isCustomDriveTrain;

// Shooter
UIControl *shooterYes;
BOOL isShooterYes;
UIControl *shooterNo;
BOOL isShooterNo;

// Preferred Goal
UIControl *preferredHigh;
BOOL isPreferredHigh;
UIControl *preferredLow;
BOOL isPreferredLow;

// Goalie Arm
UIControl *goalieArmYes;
BOOL isGoalieArmYes;
UIControl *goalieArmNo;
BOOL isGoalieArmNo;

// Floor Collector
UIControl *floorCollectorYes;
BOOL isFloorCollectorYes;
UIControl *floorCollectorNo;
BOOL isFloorCollectorNo;

// Autonomous
UIControl *autonomousYes;
BOOL isAutonomousYes;
UIControl *autonomousNo;
BOOL isAutonomousNo;

// Auto Starting Position
UIControl *startLeft;
BOOL isStartLeft;
UIControl *startMiddle;
BOOL isStartMiddle;
UIControl *startRight;
BOOL isStartRight;
UIControl *startGoalie;
BOOL isStartGoalie;

// Hot Goal Tracking
UIControl *hotGoalYes;
BOOL isHotGoalYes;
UIControl *hotGoalNo;
BOOL isHotGoalNo;

// Catching Mechanism
UIControl *catchingYes;
BOOL isCatchingYes;
UIControl *catchingNo;
BOOL isCatchingNo;

// Bumper Quality
UIControl *bumperOne;
BOOL isBumperOne;
UIControl *bumperThree;
BOOL isBumperThree;
UIControl *bumperFive;
BOOL isBumperFive;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UILabel *robotImageLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 75, 125, 15)];
    robotImageLbl.text = @"Tap to Change";
    robotImageLbl.textAlignment = NSTextAlignmentCenter;
    robotImageLbl.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:robotImageLbl];
    
    robotImageControl = [[UIControl alloc] initWithFrame:CGRectMake(40, 90, 125, 125)];
    [robotImageControl addTarget:self action:@selector(getAnImage) forControlEvents:UIControlEventTouchUpInside];
    UILabel *addPicLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    addPicLbl.text = @"Add Image";
    addPicLbl.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    addPicLbl.textAlignment = NSTextAlignmentCenter;
    addPicLbl.font = [UIFont systemFontOfSize:13];
    addPicLbl.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    addPicLbl.layer.borderWidth = 1;
    [robotImageControl addSubview:addPicLbl];
    robotImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    [robotImageControl addSubview:robotImage];
    
    [self.view addSubview:robotImageControl];
    
    
    sixEightWheelDrop = [[UIControl alloc] initWithFrame:CGRectMake(230, 245, 110, 30)];
    [sixEightWheelDrop addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    sixEightWheelDrop.layer.cornerRadius = 5;
    UILabel *sixEightWheelDropLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 30)];
    sixEightWheelDropLbl.text = @"6 or 8 Wheel Drop";
    sixEightWheelDropLbl.textColor = [UIColor whiteColor];
    sixEightWheelDropLbl.textAlignment = NSTextAlignmentCenter;
    sixEightWheelDropLbl.font = [UIFont systemFontOfSize:12];
    sixEightWheelDropLbl.backgroundColor = [UIColor clearColor];
    [sixEightWheelDrop addSubview:sixEightWheelDropLbl];
    [self.view addSubview:sixEightWheelDrop];
    
    fourWheelDrive = [[UIControl alloc] initWithFrame:CGRectMake(350, 245, 85, 30)];
    [fourWheelDrive addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    fourWheelDrive.layer.cornerRadius = 5;
    UILabel *fourWheelDriveLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
    fourWheelDriveLbl.text = @"4 Wheel Drive";
    fourWheelDriveLbl.textColor = [UIColor whiteColor];
    fourWheelDriveLbl.textAlignment = NSTextAlignmentCenter;
    fourWheelDriveLbl.font = [UIFont systemFontOfSize:12];
    fourWheelDriveLbl.backgroundColor = [UIColor clearColor];
    [fourWheelDrive addSubview:fourWheelDriveLbl];
    [self.view addSubview:fourWheelDrive];
    
    mechanum = [[UIControl alloc] initWithFrame:CGRectMake(445, 245, 70, 30)];
    [mechanum addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    mechanum.layer.cornerRadius = 5;
    UILabel *mechanumLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    mechanumLbl.text = @"Mechanum";
    mechanumLbl.textColor = [UIColor whiteColor];
    mechanumLbl.textAlignment = NSTextAlignmentCenter;
    mechanumLbl.font = [UIFont systemFontOfSize:12];
    mechanumLbl.backgroundColor = [UIColor clearColor];
    [mechanum addSubview:mechanumLbl];
    [self.view addSubview:mechanum];
    
    swerveCrab = [[UIControl alloc] initWithFrame:CGRectMake(525, 245, 80, 30)];
    [swerveCrab addTarget:self action:@selector(driveTrainSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    swerveCrab.layer.cornerRadius = 5;
    UILabel *swerveCrabLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    swerveCrabLbl.text = @"Swerve/Crab";
    swerveCrabLbl.textColor = [UIColor whiteColor];
    swerveCrabLbl.textAlignment = NSTextAlignmentCenter;
    swerveCrabLbl.font = [UIFont systemFontOfSize:12];
    swerveCrabLbl.backgroundColor = [UIColor clearColor];
    [swerveCrab addSubview:swerveCrabLbl];
    [self.view addSubview:swerveCrab];
    
    customDriveTrain = [[UITextField alloc] initWithFrame:CGRectMake(615, 245, 110, 30)];
    customDriveTrain.borderStyle = UITextBorderStyleRoundedRect;
    customDriveTrain.placeholder = @"Other Drive Train";
    customDriveTrain.font = [UIFont systemFontOfSize:12];
    customDriveTrain.textAlignment = NSTextAlignmentCenter;
    customDriveTrain.returnKeyType = UIReturnKeyDone;
    customDriveTrain.delegate = self;
    [customDriveTrain addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:customDriveTrain];
    
    shooterYes = [[UIControl alloc] initWithFrame:CGRectMake(230, 295, 80, 30)];
    [shooterYes addTarget:self action:@selector(shooterSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    shooterYes.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    shooterYes.layer.cornerRadius = 5;
    UILabel *shooterYesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    shooterYesLbl.text = @"Yes";
    shooterYesLbl.textColor = [UIColor whiteColor];
    shooterYesLbl.textAlignment = NSTextAlignmentCenter;
    shooterYesLbl.font = [UIFont systemFontOfSize:12];
    shooterYesLbl.backgroundColor = [UIColor clearColor];
    [shooterYes addSubview:shooterYesLbl];
    [self.view addSubview:shooterYes];
    
    shooterNo = [[UIControl alloc] initWithFrame:CGRectMake(320, 295, 80, 30)];
    [shooterNo addTarget:self action:@selector(shooterSelectionTapped:) forControlEvents:UIControlEventTouchUpInside];
    shooterNo.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
    shooterNo.layer.cornerRadius = 5;
    UILabel *shooterNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    shooterNoLbl.text = @"No";
    shooterNoLbl.textColor = [UIColor whiteColor];
    shooterNoLbl.textAlignment = NSTextAlignmentCenter;
    shooterNoLbl.font = [UIFont systemFontOfSize:12];
    shooterNoLbl.backgroundColor = [UIColor clearColor];
    [shooterNo addSubview:shooterNoLbl];
    [self.view addSubview:shooterNo];
    
    _additionalNotesTxtField.layer.cornerRadius = 10;
    _additionalNotesTxtField.layer.borderColor = [[UIColor colorWithWhite:0.7 alpha:1.0] CGColor];
    _additionalNotesTxtField.layer.borderWidth = 1;
    _additionalNotesTxtField.font = [UIFont systemFontOfSize:14];
    _additionalNotesTxtField.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    _additionalNotesTxtField.text = @"Additional Notes";
    _additionalNotesTxtField.delegate = self;
    
    _saveBtn.layer.cornerRadius = 10;
    
    [self.view bringSubviewToFront:_additionalNotesTxtField];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAnImage{
    grayLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayLayer.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:grayLayer];
    
    cameraPopup = [[UIView alloc] initWithFrame:CGRectMake(209, 824, 350, 280)];
    cameraPopup.backgroundColor = [UIColor whiteColor];
    cameraPopup.layer.cornerRadius = 15;
    
    UIButton *useCameraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    useCameraBtn.frame = CGRectMake(30, 20, 290, 40);
    [useCameraBtn addTarget:self action:@selector(useCamera) forControlEvents:UIControlEventTouchUpInside];
    [useCameraBtn setTitle:@"Use Camera" forState:UIControlStateNormal];
    [useCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [useCameraBtn setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1]];
    useCameraBtn.layer.cornerRadius = 10;
    [cameraPopup addSubview:useCameraBtn];
    
    UIButton *usePhotoReelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    usePhotoReelBtn.frame = CGRectMake(30, 80, 290, 40);
    [usePhotoReelBtn addTarget:self action:@selector(usePhotoReel) forControlEvents:UIControlEventTouchUpInside];
    [usePhotoReelBtn setTitle:@"Use Photo Reel" forState:UIControlStateNormal];
    [usePhotoReelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [usePhotoReelBtn setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1]];
    usePhotoReelBtn.layer.cornerRadius = 10;
    [cameraPopup addSubview:usePhotoReelBtn];
    
    UIButton *cameraCancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cameraCancelButton.frame = CGRectMake(30, 140, 290, 40);
    [cameraCancelButton addTarget:self action:@selector(cancelCameraPopUp) forControlEvents:UIControlEventTouchUpInside];
    [cameraCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cameraCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraCancelButton setBackgroundColor:[UIColor redColor]];
    cameraCancelButton.layer.cornerRadius = 10;
    [cameraPopup addSubview:cameraCancelButton];
    
    [grayLayer addSubview:cameraPopup];
    
    cameraPopup.center = CGPointMake(384, 1164);
    [UIView animateWithDuration:0.2 animations:^{
        cameraPopup.center = CGPointMake(384, 904);
    }];
    
}
-(void)useCamera{
    [UIView animateWithDuration:0.1 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        
        [imagePicker setAllowsEditing:YES];
        
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
    
    
//    CGRect f = imagePicker.view.bounds;
//    f.size.height -= imagePicker.navigationBar.bounds.size.height;
//    UIGraphicsBeginImageContext(f.size);
//    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
//    UIRectFillUsingBlendMode(CGRectMake(0, 125, f.size.width, 3), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(0, 893, f.size.width, 3), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(0, 128, 3, 766), kCGBlendModeNormal);
//    UIRectFillUsingBlendMode(CGRectMake(765, 128, 3, 766), kCGBlendModeNormal);
//    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
//    overlayIV.image = overlayImage;
//    overlayIV.alpha = 0.7f;
//    [imagePicker setCameraOverlayView:overlayIV];
    
    
}
-(void)usePhotoReel{
    [UIView animateWithDuration:0.1 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        
        [imagePicker setAllowsEditing:YES];
        
        [self presentViewController:imagePicker animated:YES completion:^{}];
    }];
    
}
-(void)cancelCameraPopUp{
    [UIView animateWithDuration:0.2 animations:^{
        cameraPopup.center = CGPointMake(cameraPopup.center.x, 1164);
    } completion:^(BOOL finished) {
        [cameraPopup removeFromSuperview];
        [grayLayer removeFromSuperview];
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.0);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.0];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    robotImage.frame = CGRectMake(0, 0, 700, 700);
    robotImage.image = image;
    robotImage.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        robotImage.frame = CGRectMake(0, 0, 125, 125);
    } completion:^(BOOL finished) {
//        UIGraphicsBeginImageContext(CGSizeMake(320, 320));
//        [image drawInRect:CGRectMake(0,0,320,320)];
//        UIImage* saveImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        robotImage.image = saveImage;
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)driveTrainSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:sixEightWheelDrop]) {
        if (isSixEightWheelDrop) {
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSixEightWheelDrop = true;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = false;
            isCustomDriveTrain = false;
        }
    }
    else if ([controller isEqual:fourWheelDrive]){
        if (isFourWheelDrive) {
            [UIView animateWithDuration:0.2 animations:^{
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isFourWheelDrive = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = true;
            isMechanum = false;
            isSwerveCrab = false;
            isCustomDriveTrain = false;
        }
    }
    else if ([controller isEqual:mechanum]){
        if (isMechanum) {
            [UIView animateWithDuration:0.2 animations:^{
                mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isMechanum = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = true;
            isSwerveCrab = false;
            isCustomDriveTrain = false;
        }
    }
    else if ([controller isEqual:swerveCrab]){
        if (isSwerveCrab) {
            [UIView animateWithDuration:0.2 animations:^{
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSwerveCrab = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = true;
            isCustomDriveTrain = false;
        }
    }
}

-(void)shooterSelectionTapped:(UIControl *)controller{
    if ([controller isEqual:shooterYes]) {
        if (isShooterYes) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterYes.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isShooterYes = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                shooterNo.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                shooterYes.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isShooterYes = true;
            isShooterNo = false;
        }
    }
    else if ([controller isEqual:shooterNo]){
        if (isShooterNo) {
            [UIView animateWithDuration:0.2 animations:^{
                shooterNo.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isShooterNo = false;
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                shooterYes.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                shooterNo.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
            }];
            isShooterYes = false;
            isShooterNo = true;
        }
    }
}



-(void)textFieldDidChange:(UITextField *)textField{
    if ([textField isEqual:customDriveTrain]) {
        if (customDriveTrain.text.length > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                sixEightWheelDrop.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                fourWheelDrive.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                mechanum.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
                swerveCrab.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            }];
            isSixEightWheelDrop = false;
            isFourWheelDrive = false;
            isMechanum = false;
            isSwerveCrab = false;
            isCustomDriveTrain = true;
        }
        else{
            isCustomDriveTrain = false;
        }
    }
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView isEqual:_additionalNotesTxtField]) {
        if ([_additionalNotesTxtField.text isEqualToString:@"Additional Notes"]) {
            _additionalNotesTxtField.text = @"";
            _additionalNotesTxtField.textColor = [UIColor blackColor];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _additionalNotesTxtField.center = CGPointMake(_additionalNotesTxtField.center.x, 700);
        } completion:^(BOOL finished) {}];
        
        
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView isEqual:_additionalNotesTxtField]) {
        if ([_additionalNotesTxtField.text isEqualToString:@""]) {
            _additionalNotesTxtField.text = @"Additional Notes";
            _additionalNotesTxtField.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _additionalNotesTxtField.center = CGPointMake(_additionalNotesTxtField.center.x, 800);
        } completion:^(BOOL finished) {}];
    }
}
- (IBAction)screenTapped:(id)sender {
    [_teamNumberField resignFirstResponder];
    [_additionalNotesTxtField resignFirstResponder];
    [customDriveTrain resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


@end












