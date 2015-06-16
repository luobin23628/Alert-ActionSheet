//
//  BJAlertManager.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "BJActionSheetManager.h"
#import "BJActionSheetController.h"

static NSMutableArray *actionSheetStack = nil;

@implementation BJActionSheetManager

+ (void)initialize {
    
    actionSheetStack = [[NSMutableArray alloc] init];
}

+ (NSArray *)actionSheetStack {
    return actionSheetStack;
}

+ (BOOL)stackContainsAlert:(BJActionSheetController *)actionSheet {
    return [actionSheetStack indexOfObject:actionSheet] != NSNotFound;
}

+ (void)addToStack:(BJActionSheetController *)actionSheet {
    [actionSheetStack addObject:actionSheet];
}

+ (void)removeFromStack:(BJActionSheetController *)actionSheet {
    [actionSheetStack removeObject:actionSheet];
}

+ (BJActionSheetController *)topMostActionSheet {
    return actionSheetStack.lastObject;
}

+ (BOOL)cancelAlertsAnimated:(BOOL)animated {
    BJActionSheetController *topMostActionSheet = self.topMostActionSheet;
    if (topMostActionSheet) {
        return [self canceltopMostActionSheetAnimated:animated completion:^(BOOL success) {
            if (success) {
                [self cancelAlertsAnimated:animated];
            }
        }];
    } else {
        return YES;
    }
}

+ (BOOL)canceltopMostActionSheetAnimated:(BOOL)animated {
    return [self canceltopMostActionSheetAnimated:animated completion:nil];
}

+ (BOOL)canceltopMostActionSheetAnimated:(BOOL)animated completion:(void(^)(BOOL success))completion{
    [self.topMostActionSheet dismissWithClickedButtonIndex:-1 animated:animated completion:^{
        if (completion) {
            completion(YES);
        }
    }];
    return YES;
}

@end
