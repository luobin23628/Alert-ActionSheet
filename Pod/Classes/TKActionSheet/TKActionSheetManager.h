//
//  TKAlertManager.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TKAlert&TKActionSheet/TKActionSheetController.h>

@interface TKActionSheetManager : NSObject

+ (NSArray *)actionSheetStack;
+ (BOOL)stackContainsAlert:(TKActionSheetController *)actionSheet;
+ (void)addToStack:(TKActionSheetController *)actionSheet;
+ (void)removeFromStack:(TKActionSheetController *)actionSheet;
+ (TKActionSheetController *)topMostActionSheet;
+ (BOOL)canceltopMostActionSheetAnimated:(BOOL)animated;
+ (BOOL)cancelAllAlertsAnimated:(BOOL)animated;

@end
