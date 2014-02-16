//
//  WithinRegional.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "WithinRegional.h"

@interface WithinRegional ()

@end

@implementation WithinRegional

UISegmentedControl *weekSelector;
NSInteger weekSelected;
NSString *regionalSelected;

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
    _rankingsBtn.layer.cornerRadius = 10;
    _nextMatchBtn.layer.cornerRadius = 10;
    _allianceSelectionBtn.layer.cornerRadius = 10;
    
    
    
    weekSelector = [[UISegmentedControl alloc] initWithItems:@[@"All",@"1", @"2", @"3", @"4", @"5", @"6", @"7+"]];
    weekSelector.frame = CGRectMake(-35, 324, 215, 30);
    [weekSelector addTarget:self action:@selector(changeWeek) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:weekSelector];
    weekSelector.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    for (UIView *v in [weekSelector subviews]) {
        for (UIView *sbv in [v subviews]) {
            if ([sbv isKindOfClass:[UILabel class]]) {
                sbv.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
            }
        }
    }
    if (weekSelected) {
        weekSelector.selectedSegmentIndex = weekSelected;
    }
    else{
        weekSelector.selectedSegmentIndex = 0;
        weekSelected = 0;
    }
    
    
    _regionalPicker.delegate = self;
    _regionalPicker.dataSource = self;
    _regionalPicker.layer.cornerRadius = 5;
    _regionalPicker.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    if (regionalSelected) {
        [_regionalPicker selectRow:[[allWeekRegionals objectAtIndex:weekSelected] indexOfObject:regionalSelected] inComponent:0 animated:YES];
    }
    
    if (!regionalSelected) {
        regionalSelected = [regionalNames firstObject];
    }
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called by the weekSelector UISegmentedControl
-(void)changeWeek{
    if ([[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex]containsObject:[[allWeekRegionals objectAtIndex:weekSelected] objectAtIndex:[_regionalPicker selectedRowInComponent:0]]]) {
        NSString *regional = [[allWeekRegionals objectAtIndex:weekSelected] objectAtIndex:[_regionalPicker selectedRowInComponent:0]];
        [_regionalPicker reloadAllComponents];
        [_regionalPicker selectRow:[[allWeekRegionals objectAtIndex:weekSelector.selectedSegmentIndex]indexOfObject:regional] inComponent:0 animated:YES];
    }
    else{
        [_regionalPicker reloadAllComponents];
        [_regionalPicker selectRow:0 inComponent:0 animated:YES];
    }
    
    weekSelected = weekSelector.selectedSegmentIndex;
}

-(void)viewDidAppear:(BOOL)animated{

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger numRows;
    if (weekSelector.selectedSegmentIndex == 0) {
        numRows = regionalNames.count;
    }
    else if (weekSelector.selectedSegmentIndex == 1){
        numRows = week1Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 2){
        numRows = week2Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 3){
        numRows = week3Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 4){
        numRows = week4Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 5){
        numRows = week5Regionals.count;
    }
    else if (weekSelector.selectedSegmentIndex == 6){
        numRows = week6Regionals.count;
    }
    else{
        numRows = week7Regionals.count;
    }
    
    return numRows;
}

// Tell the picker how many components it will have (1)
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Give the picker its source of list items based on WeekSelector's selection
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        
        if (weekSelector.selectedSegmentIndex == 0) {
            tView.text = [regionalNames objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 1){
            tView.text = [week1Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 2){
            tView.text = [week2Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 3){
            tView.text = [week3Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 4){
            tView.text = [week4Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 5){
            tView.text = [week5Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 6){
            tView.text = [week6Regionals objectAtIndex:row];
        }
        else if (weekSelector.selectedSegmentIndex == 7){
            tView.text = [week7Regionals objectAtIndex:row];
        }
        
        tView.textAlignment = NSTextAlignmentLeft;
        tView.font = [UIFont systemFontOfSize:20];
        tView.minimumScaleFactor = 0.2;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    return tView;
}

// Tell the picker the width of each row for a given component (420)
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int sectionWidth = 580;
    
    return sectionWidth;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UILabel *selectedRow = (UILabel *)[_regionalPicker viewForRow:row forComponent:0];
    regionalSelected = selectedRow.text;
}

@end
