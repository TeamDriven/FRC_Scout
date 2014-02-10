//
//  SingleTeamMatchCell.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/9/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTeamMatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *autoLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoAccuracyLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopAccuracyLbl;
@property (weak, nonatomic) IBOutlet UILabel *passReceiveLbl;

@end
