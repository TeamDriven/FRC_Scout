//
//  MatchCell.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 12/13/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *matchNumLbl;

@property (weak, nonatomic) IBOutlet UILabel *autoTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *autoTotalNum;

@property (weak, nonatomic) IBOutlet UILabel *teleopTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopTotalNum;

@property (weak, nonatomic) IBOutlet UILabel *endgameTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *endgameTotalNum;


@end
