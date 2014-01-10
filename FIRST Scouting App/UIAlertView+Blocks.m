//
//  UIAlertView+Blocks.m
//  FIRST Scouting App
//
//  Created by Louie Bertoncin on 1/8/14.
//  Copyright (c) 2014 teamDriven. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

@interface UIAlertViewWrapper : NSObject <UIAlertViewDelegate>

@property (copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex);

@end

@implementation UIAlertViewWrapper

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completionBlock)
        self.completionBlock(alertView, buttonIndex);
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (self.completionBlock)
        self.completionBlock(alertView, alertView.cancelButtonIndex);
}

@end

static const char kUIAlertViewWrapper;

@implementation UIAlertView (Blocks)

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSArray *)otherButtonTitles
           completion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil];
    for (NSString *buttonTitle in otherButtonTitles)
        [alertView addButtonWithTitle:buttonTitle];
    
    [alertView showCompletion:completionBlock];
}

- (void)showCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock
{
    UIAlertViewWrapper *wrapper = [[UIAlertViewWrapper alloc] init];
    wrapper.completionBlock = completionBlock;
    self.delegate = wrapper;
    objc_setAssociatedObject(self, &kUIAlertViewWrapper, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self show];
}

@end