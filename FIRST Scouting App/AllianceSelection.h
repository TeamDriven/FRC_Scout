//
//  AllianceSelection.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface AllianceSelection : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *poolTableView;

@property (weak, nonatomic) IBOutlet UITableView *firstPickTableView;

@property (weak, nonatomic) IBOutlet UITableView *secondPickTableView;

@property (weak, nonatomic) IBOutlet UIButton *firstPickListEditBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondPickListEditBtn;

@end
