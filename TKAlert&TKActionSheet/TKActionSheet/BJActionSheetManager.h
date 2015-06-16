//
//  BJAlertManager.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BJActionSheetController.h"

@interface BJActionSheetManager : NSObject

+ (NSArray *)actionSheetStack;
+ (BOOL)stackContainsAlert:(BJActionSheetController *)actionSheet;
+ (void)addToStack:(BJActionSheetController *)actionSheet;
+ (void)removeFromStack:(BJActionSheetController *)actionSheet;
+ (BJActionSheetController *)topMostActionSheet;
+ (BOOL)canceltopMostActionSheetAnimated:(BOOL)animated;
+ (BOOL)cancelAlertsAnimated:(BOOL)animated;

@end
