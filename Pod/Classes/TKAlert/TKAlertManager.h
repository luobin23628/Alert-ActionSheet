//
//  TKAlertManager.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TKAlert&TKActionSheet/TKAlertViewController.h>

@interface TKAlertManager : NSObject

+ (NSMutableArray *)alertSheetStack;
+ (BOOL)stackContainsAlert:(TKAlertViewController *)alertView;
+ (void)removeFromStack:(TKAlertViewController *)alertView;
+ (void)addToStack:(TKAlertViewController *)alertView dontDimBackground:(BOOL)flag;
+ (TKAlertViewController *)visibleAlert;
+ (TKAlertViewController *)topMostAlert;
+ (BOOL)cancelTopMostAlertAnimated:(BOOL)animated;
+ (BOOL)cancelAllAlertsAnimated:(BOOL)animated;
+ (BOOL)hideTopMostAlertAnimated:(BOOL)animated;
@end
