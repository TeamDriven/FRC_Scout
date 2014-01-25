//
//  ViewTeams.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "ViewTeams.h"

@interface ViewTeams ()

@end

@implementation ViewTeams

NSFileManager *FSAfileManager;
NSURL *FSAdocumentsDirectory;
NSString *FSAdocumentName;
NSURL *FSApathurl;
UIManagedDocument *FSAdocument;
NSManagedObjectContext *context;
CoreDataTableViewController *cdtvc;
NSFetchedResultsController *frc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    _tableView.layer.borderWidth = 1;
    _tableView.layer.cornerRadius = 5;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PitTeam"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamNumber" ascending:YES selector:@selector(localizedStandardCompare:)]];
    frc = [[NSFetchedResultsController alloc]
                                       initWithFetchRequest:request
                                       managedObjectContext:context
                                       sectionNameKeyPath:nil
                                       cacheName:nil];  // careful!
    cdtvc = [[CoreDataTableViewController alloc] init];
    cdtvc.fetchedResultsController = frc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section
{
    return [[[frc sections] objectAtIndex:section] numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)sender
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PitCell *cell = (PitCell *)[_tableView dequeueReusableCellWithIdentifier:@"PitCell"];
    PitTeam *pt = [frc objectAtIndexPath:indexPath];
    
    UIImage *image = [UIImage imageWithData:[pt valueForKey:@"image"]];
    
    cell.botImage.image = image;
    cell.teamName.text = pt.teamName;
    cell.teamNumber.text = pt.teamNumber;
    
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    // here you are supposed call appropriate UITableView methods to update rows!
    // but don’t worry, we’re going to make it easy on you ...
}

- (IBAction)searching:(id)sender {
    NSString *textString = _teamSearch.text;
    _teamSearch.text = [textString stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PitTeam"];
    NSNumberFormatter *checker = [[NSNumberFormatter alloc] init];
    if ([checker numberFromString:_teamSearch.text]) {
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamNumber" ascending:YES selector:@selector(localizedStandardCompare:)]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamNumber contains %@", _teamSearch.text];
        request.predicate = predicate;
    }
    else if (_teamSearch.text.length == 0){
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamNumber" ascending:YES selector:@selector(localizedStandardCompare:)]];
    }
    else{
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamName" ascending:YES selector:@selector(localizedStandardCompare:)]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamName contains[c] %@", _teamSearch.text];
        request.predicate = predicate;
    }
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    cdtvc = [[CoreDataTableViewController alloc] init];
    cdtvc.fetchedResultsController = frc;
    [_tableView reloadData];
}

@end










