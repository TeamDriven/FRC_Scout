//
//  RecordTeam.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTeam : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teamNumberField;

@property (weak, nonatomic) IBOutlet UITextView *customNotes;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
