//
//  ViewTeams.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTeams : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
