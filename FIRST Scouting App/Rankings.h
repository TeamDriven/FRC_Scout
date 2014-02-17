//
//  Rankings.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rankings : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *sortUpButton;
@property (weak, nonatomic) IBOutlet UIButton *sortDownBtn;

@property (weak, nonatomic) IBOutlet UITableView *rankingsTableView;


@end
