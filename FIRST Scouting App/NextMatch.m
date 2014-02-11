//
//  NextMatch.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 2/3/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "NextMatch.h"
#import "WithinRegional.h"
#import "Globals.h"

@interface NextMatch ()

@end

@implementation NextMatch

NSString *regionalSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _red1SearchBox.delegate = self;
    _red2SearchBox.delegate = self;
    _red3SearchBox.delegate = self;
    _blue1SearchBox.delegate = self;
    _blue2SearchBox.delegate = self;
    _blue3SearchBox.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)red1FinishedEditing:(id)sender {
}

- (IBAction)red2FinishedEditing:(id)sender {
}

- (IBAction)red3FinishedEditing:(id)sender {
}

- (IBAction)blue1FinishedEditing:(id)sender {
}

- (IBAction)blue2FinishedEditing:(id)sender {
}

- (IBAction)blue3FinishedEditing:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)baseScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)redScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)blueScreenTapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe1Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe2Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe3Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe4Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe5Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe6Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}
- (IBAction)grayStripe7Tapped:(id)sender {
    [_red1SearchBox resignFirstResponder];
    [_red2SearchBox resignFirstResponder];
    [_red3SearchBox resignFirstResponder];
    [_blue1SearchBox resignFirstResponder];
    [_blue2SearchBox resignFirstResponder];
    [_blue3SearchBox resignFirstResponder];
}




@end






















