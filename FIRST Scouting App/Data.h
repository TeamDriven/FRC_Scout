//
//  Data.h
//  FIRST Scouting App
//
//  Created by Eris on 11/5/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface Data : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teamSearchField;

@property (weak, nonatomic) IBOutlet UISwitch *redSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *orangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *yellowSwitch;

@property (weak, nonatomic) IBOutlet UIView *switchBackgroundView;


@end
