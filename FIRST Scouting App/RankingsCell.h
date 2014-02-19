//
//  RankingsCell.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/16/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rankLbl;

@property (weak, nonatomic) IBOutlet UILabel *teamNumLbl;

@property (weak, nonatomic) IBOutlet UILabel *autoAvgLbl;

@property (weak, nonatomic) IBOutlet UILabel *teleopAvgLbl;

@property (weak, nonatomic) IBOutlet UILabel *passesReceivesLbl;

@property (weak, nonatomic) IBOutlet UILabel *trussCatchLbl;

@property (weak, nonatomic) IBOutlet UILabel *overTrussLbl;


@end
