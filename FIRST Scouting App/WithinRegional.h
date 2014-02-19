//
//  WithinRegional.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface WithinRegional : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *rankingsBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextMatchBtn;

@property (weak, nonatomic) IBOutlet UIButton *allianceSelectionBtn;

@property (weak, nonatomic) IBOutlet UIPickerView *regionalPicker;

extern NSString *regionalSelected;

@end
