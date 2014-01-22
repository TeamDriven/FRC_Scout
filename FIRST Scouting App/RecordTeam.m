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
UIControl *fourWheelDrive;
UIControl *mechanum;
UIControl *swerveCrab;

// Shooter
UIControl *shooterYes;
UIControl *shooterNo;

// Preferred Goal
UIControl *preferredHigh;
UIControl *preferredLow;

// Goalie Arm
UIControl *goalieArmYes;
UIControl *goalieArmNo;

// Floor Collector
UIControl *floorCollectorYes;
UIControl *floorCollectorNo;

// Autonomous
UIControl *autonomousYes;
UIControl *autonomousNo;

// Auto Starting Position
UIControl *startLeft;
UIControl *startMiddle;
UIControl *startRight;
UIControl *startGoalie;

// Hot Goal Tracking
UIControl *hotGoalYes;
UIControl *hotGoalNo;

// Catching Mechanism
UIControl *catchingYes;
UIControl *catchingNo;

// Bumper Quality
UIControl *bumperOne;
UIControl *bumperThree;
UIControl *bumperFive;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
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
    
    
    
    
    _customNotes.backgroundColor = [UIColor whiteColor];
    _customNotes.layer.cornerRadius = 10;
    _customNotes.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
    _customNotes.layer.borderWidth = 1;
    _customNotes.text = @"Custom Notes";
    _customNotes.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    _saveBtn.layer.cornerRadius = 10;
    
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

@end
