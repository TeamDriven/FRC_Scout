//
//  LocationsFirstViewController.h
//  FIRST Scouting App
//
//  Created by Eris on 11/3/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface LocationsFirstViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *highScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *midScoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *lowScoreLbl;

@property (weak, nonatomic) IBOutlet UITextField *matchNumField;
@property (weak, nonatomic) IBOutlet UITextField *teamNumField;

@property (weak, nonatomic) IBOutlet UIToolbar *header;



@end
