//
//  NewPage.m
//  FIRST Scouting App
//
//  Created by Bertoncin,Louie on 1/15/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "NewPage.h"

@interface NewPage ()

@end

@implementation NewPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

float startX = 0;
float startY = 0;
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if( [touch view] == _imageView)
    {
        CGPoint location = [touch locationInView:self.view];
        startX = self.view.center.x;
        startY = location.y - _imageView.center.y;
    }
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if( [touch view] == _imageView)
    {
        CGPoint location = [touch locationInView:self.view];
        location.x = startX;
        location.y = location.y - startY;
        if (location.y > 897) {
            location.y = 897;
        }
        else if (location.y < 75){
            location.y = 75;
        }
        _imageView.center = location;
    }
}

@end
