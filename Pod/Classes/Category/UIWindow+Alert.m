//
//  UIWin.m
//
//
//  Created by binluo on 15/6/15.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "UIWindow+Alert.h"

@implementation UIWindow(Alert)

- (UIViewController *)currentViewController
{
    UIViewController *viewController = self.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

- (UIViewController *)viewControllerForStatusBarStyle
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarStyle]) {
        currentViewController = [currentViewController childViewControllerForStatusBarStyle];
    }
    return currentViewController;
}

- (UIViewController *)viewControllerForStatusBarHidden
{
    UIViewController *currentViewController = [self currentViewController];
    
    while ([currentViewController childViewControllerForStatusBarHidden]) {
        currentViewController = [currentViewController childViewControllerForStatusBarHidden];
    }
    return currentViewController;
}

@end
