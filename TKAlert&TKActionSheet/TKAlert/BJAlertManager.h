//
//  BJAlertManager.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJAlertViewController.h"

@interface BJAlertManager : NSObject

+ (NSMutableArray *)alertSheetStack;
+ (BOOL)stackContainsAlert:(BJAlertViewController *)alertView;
+ (void)removeFromStack:(BJAlertViewController *)alertView;
+ (void)addToStack:(BJAlertViewController *)alertView dontDimBackground:(BOOL)flag;
+ (BJAlertViewController *)visibleAlert;
+ (BJAlertViewController *)topMostAlert;
+ (BOOL)cancelTopMostAlertAnimated:(BOOL)animated;
+ (BOOL)cancelAlertsAnimated:(BOOL)animated;
+ (BOOL)hideTopMostAlertAnimated:(BOOL)animated;
@end
