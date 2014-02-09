//
//  SelectedTeamView.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleTeamCDTVC.h"

@interface SelectedTeamView : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *header;

@property (weak, nonatomic) IBOutlet UILabel *teamNameLbl;

@property (weak, nonatomic) IBOutlet UIImageView *robotPic;

@property (weak, nonatomic) IBOutlet UIView *statBox;

@property (weak, nonatomic) IBOutlet UILabel *autoAvgLbl;
@property (weak, nonatomic) IBOutlet UILabel *teleopAvgLbl;
@property (weak, nonatomic) IBOutlet UILabel *passesAvgLbl;
@property (weak, nonatomic) IBOutlet UILabel *receivesAvgLbl;
@property (weak, nonatomic) IBOutlet UILabel *overTrussAvgLbl;
@property (weak, nonatomic) IBOutlet UILabel *catchesAvgLbl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;





@end
