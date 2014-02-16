//
//  PoolMatchCell.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/15/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PoolMatchCell.h"

@implementation PoolMatchCell

UILabel *autonomousTotalLbl;
UILabel *teleopTotalLbl;
UILabel *passReceivesLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _matchNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 50, 20)];
        _matchNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20];
        _matchNumberLbl.adjustsFontSizeToFitWidth = true;
        [self.contentView addSubview:_matchNumberLbl];
        
        NSInteger valueDistanceX = 3;
        
        autonomousTotalLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 100, 20)];
        autonomousTotalLbl.text = @"Autonomous:";
        autonomousTotalLbl.font = [UIFont systemFontOfSize:14];
        [autonomousTotalLbl sizeToFit];
        autonomousTotalLbl.center = CGPointMake(autonomousTotalLbl.center.x, _matchNumberLbl.center.y);
        [self.contentView addSubview:autonomousTotalLbl];
        
        _autonomousValLbl = [[UILabel alloc] initWithFrame:CGRectMake(autonomousTotalLbl.frame.origin.x + autonomousTotalLbl.frame.size.width + valueDistanceX, autonomousTotalLbl.frame.origin.y, 20, 20)];
        _autonomousValLbl.font = [UIFont boldSystemFontOfSize:16];
        _autonomousValLbl.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_autonomousValLbl];
        
        teleopTotalLbl = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 80, 20)];
        teleopTotalLbl.text = @"Teleop:";
        teleopTotalLbl.font = [UIFont systemFontOfSize:14];
        [teleopTotalLbl sizeToFit];
        teleopTotalLbl.center = CGPointMake(teleopTotalLbl.center.x, _matchNumberLbl.center.y);
        [self.contentView addSubview:teleopTotalLbl];
        
        _teleopValLbl = [[UILabel alloc] initWithFrame:CGRectMake(teleopTotalLbl.frame.origin.x + teleopTotalLbl.frame.size.width + valueDistanceX, teleopTotalLbl.frame.origin.y, 20, 20)];
        _teleopValLbl.font = [UIFont boldSystemFontOfSize:16];
        _teleopValLbl.textColor = [UIColor brownColor];
        [self.contentView addSubview:_teleopValLbl];
        
        passReceivesLbl = [[UILabel alloc] initWithFrame:CGRectMake(285, 15, 130, 20)];
        passReceivesLbl.text = @"Passes/Receives:";
        passReceivesLbl.font = [UIFont systemFontOfSize:14];
        [passReceivesLbl sizeToFit];
        passReceivesLbl.center = CGPointMake(passReceivesLbl.center.x, _matchNumberLbl.center.y);
        [self.contentView addSubview:passReceivesLbl];
        
        _passesReceivesLbl = [[UILabel alloc] initWithFrame:CGRectMake(passReceivesLbl.frame.origin.x + passReceivesLbl.frame.size.width + valueDistanceX, passReceivesLbl.frame.origin.y, 20, 20)];
        _passesReceivesLbl.font = [UIFont boldSystemFontOfSize:16];
        _passesReceivesLbl.textColor = [UIColor brownColor];
        [self.contentView addSubview:_passesReceivesLbl];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
