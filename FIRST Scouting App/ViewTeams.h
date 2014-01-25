//
//  ViewTeams.h
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation/Foundation.h"
#import "CoreData/CoreData.h"
#import "PitTeam.h"
#import "PitTeam+Category.h"
#import "PitCell.h"
#import "CoreDataTableViewController.h"

@interface ViewTeams : UIViewController<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *teamSearch;

@end
