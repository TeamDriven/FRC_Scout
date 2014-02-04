//
//  Data.m
//  FIRST Scouting App
//
//  Created by Eris on 11/5/13.
//  Copyright (c) 2013 teamDriven. All rights reserved.
//

#import "Data.h"

@interface Data ()

@end

@implementation Data


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
	
    _singleTeamBtn.layer.cornerRadius = 10;
    
    _withinRegionalBtn.layer.cornerRadius = 10;
    
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end










