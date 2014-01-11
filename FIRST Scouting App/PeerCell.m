//
//  PeerCell.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 1/6/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PeerCell.h"

@implementation PeerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.peerLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 80, 20)];
        self.peerLbl.textAlignment = NSTextAlignmentCenter;
        self.peerLbl.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.peerLbl];
        
        self.connectedLbl = [[UILabel alloc] initWithFrame:CGRectMake(220, 28, 140, 20)];
        self.connectedLbl.textAlignment = NSTextAlignmentRight;
        self.connectedLbl.font = [UIFont boldSystemFontOfSize:18];
        self.connectedLbl.text = @"Connected!";
        self.connectedLbl.alpha = 0;
        self.connectedLbl.textColor = [UIColor greenColor];
        [self addSubview:self.connectedLbl];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
