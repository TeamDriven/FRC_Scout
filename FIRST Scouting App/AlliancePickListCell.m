//
//  AlliancePickListCell.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/11/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "AlliancePickListCell.h"

@implementation AlliancePickListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
