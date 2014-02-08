//
//  SingleTeamCell.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "SingleTeamCell.h"

@implementation SingleTeamCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _teamNameLbl.adjustsFontSizeToFitWidth = true;
        _autoAvgLbl.adjustsFontSizeToFitWidth = true;
        _teleopAvgLbl.adjustsFontSizeToFitWidth = true;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
