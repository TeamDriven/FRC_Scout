//
//  UIAlertView+Blocks.h
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 1/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
           completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock;

- (void)showCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock;

@end
