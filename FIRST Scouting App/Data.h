//
//  Data.h
//  FIRST Scouting App
//
//  Created by Eris on 11/5/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "MatchCell.h"

@interface Data : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *teamSearchField;

@property (weak, nonatomic) IBOutlet UISwitch *redSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *orangeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *yellowSwitch;

@property (weak, nonatomic) IBOutlet UIView *switchBackgroundView;

@property (weak, nonatomic) IBOutlet UITableView *matchTableView;

@property (weak, nonatomic) IBOutlet UILabel *autoAvgNum;
@property (weak, nonatomic) IBOutlet UILabel *teleopAvgNum;
@property (weak, nonatomic) IBOutlet UILabel *endgameAvgNum;

@end
