//
//  PitCell.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/24/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *botImage;

@property (weak, nonatomic) IBOutlet UILabel *teamNumber;

@property (weak, nonatomic) IBOutlet UILabel *teamName;

@end
