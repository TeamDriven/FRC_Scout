//
//  PeerCell.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "PeerCell.h"

@implementation PeerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.peerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 40)];
        self.peerNameLbl.textAlignment = NSTextAlignmentLeft;
        self.peerNameLbl.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.peerNameLbl];
        
        self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressBar.frame = CGRectMake(220, 34, 130, 1);
        self.progressBar.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        self.progressBar.alpha = 0;
        [self addSubview:self.progressBar];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
