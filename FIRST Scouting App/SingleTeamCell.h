//
//  SingleTeamCell.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *robotImage;

@property (weak, nonatomic) IBOutlet UILabel *teamNumberLbl;

@property (weak, nonatomic) IBOutlet UILabel *teamNameLbl;

@property (weak, nonatomic) IBOutlet UILabel *autoAvgLbl;

@property (weak, nonatomic) IBOutlet UILabel *teleopAvgLbl;


@end
