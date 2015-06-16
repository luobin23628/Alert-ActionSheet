//
//  UIWin.h
//  
//
//  Created by binluo on 15/6/15.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWindow(Alert)

- (UIViewController *)currentViewController;

- (UIViewController *)viewControllerForStatusBarStyle;
- (UIViewController *)viewControllerForStatusBarHidden;

@end
