//
//  ViewTeams.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/20/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "ViewTeams.h"
#import "Globals.h"

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

UIView *grayOutview;
UIView *pitDetailView;
CGRect selectedCellRect;

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
    _teamSearch.delegate = self;
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PitTeam *ptSelected = [frc objectAtIndexPath:indexPath];
    selectedCellRect = [tableView convertRect:[tableView rectForRowAtIndexPath:indexPath] toView:[tableView superview]];
    
    grayOutview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    grayOutview.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:grayOutview];
    
    pitDetailView = [[UIView alloc] initWithFrame:CGRectMake(109, 190, 550, 600)];
    pitDetailView.layer.cornerRadius = 10;
    pitDetailView.backgroundColor = [UIColor whiteColor];
    [grayOutview addSubview:pitDetailView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(480, 15, 60, 15);
    [closeButton setTitle:@"Close X" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeButton addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *teamNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(305, 70, 100, 40)];
    teamNumberLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamNumber];
    teamNumberLbl.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35.0f];
    teamNumberLbl.textAlignment = NSTextAlignmentCenter;
    
    UILabel *teamNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 120, 200, 20)];
    teamNameLbl.text = [[NSString alloc] initWithFormat:@"%@", ptSelected.teamName];
    teamNameLbl.font = [UIFont fontWithName:@"HeitiSC-Light" size:15.0f];
    teamNameLbl.adjustsFontSizeToFitWidth = true;
    teamNameLbl.textAlignment = NSTextAlignmentCenter;
    
    UIImage *image = [UIImage imageWithData:[ptSelected valueForKey:@"image"]];
    UIImageView *robotImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    robotImage.image = image;
    
    UILabel *driveTrainLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 240, 240, 25)];
    driveTrainLbl.textAlignment = NSTextAlignmentCenter;
    driveTrainLbl.text = [[NSString alloc] initWithFormat:@"Drive Train: %@", ptSelected.driveTrain];
    driveTrainLbl.adjustsFontSizeToFitWidth = true;
    driveTrainLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    driveTrainLbl.layer.cornerRadius = 5;
    driveTrainLbl.font = [UIFont boldSystemFontOfSize:15];
    
    UILabel *shooterLbl = [[UILabel alloc] initWithFrame:CGRectMake(310, 240, 180, 25)];
    shooterLbl.textAlignment = NSTextAlignmentCenter;
    shooterLbl.text = [[NSString alloc] initWithFormat:@"Shooter: %@", ptSelected.shooter];
    shooterLbl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    shooterLbl.layer.cornerRadius = 5;
    shooterLbl.font = [UIFont boldSystemFontOfSize:15];
    
    pitDetailView.frame = CGRectMake(selectedCellRect.origin.x + 364, selectedCellRect.origin.y + 40, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(109, 190, 550, 600);
    } completion:^(BOOL finished) {
        [pitDetailView addSubview:closeButton];
        [pitDetailView addSubview:teamNumberLbl];
        [pitDetailView addSubview:teamNameLbl];
        [pitDetailView addSubview:robotImage];
        [pitDetailView addSubview:driveTrainLbl];
        [pitDetailView addSubview:shooterLbl];
    }];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)closeDetailView{
    for (UIView *v in [pitDetailView subviews]) {
        [v removeFromSuperview];
    }
    [UIView animateWithDuration:0.2 animations:^{
        pitDetailView.frame = CGRectMake(selectedCellRect.origin.x + 364, selectedCellRect.origin.y + 40, 1, 1);
    } completion:^(BOOL finished) {
        [pitDetailView removeFromSuperview];
        [grayOutview removeFromSuperview];
    }];
}

- (IBAction)searching:(id)sender {
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)screenTapped:(id)sender {
    [_teamSearch resignFirstResponder];
}

@end










