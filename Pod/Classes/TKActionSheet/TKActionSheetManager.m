//
//  TKAlertManager.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKActionSheetManager.h"
#import "TKActionSheetController.h"

static NSMutableArray *actionSheetStack = nil;

@implementation TKActionSheetManager

+ (void)initialize {
    
    actionSheetStack = [[NSMutableArray alloc] init];
}

+ (NSArray *)actionSheetStack {
    return actionSheetStack;
}

+ (BOOL)stackContainsAlert:(TKActionSheetController *)actionSheet {
    return [actionSheetStack indexOfObject:actionSheet] != NSNotFound;
}

+ (void)addToStack:(TKActionSheetController *)actionSheet {
    [actionSheetStack addObject:actionSheet];
}

+ (void)removeFromStack:(TKActionSheetController *)actionSheet {
    [actionSheetStack removeObject:actionSheet];
}

+ (TKActionSheetController *)topMostActionSheet {
    return actionSheetStack.lastObject;
}

+ (BOOL)cancelAllAlertsAnimated:(BOOL)animated {
    TKActionSheetController *topMostActionSheet = self.topMostActionSheet;
    if (topMostActionSheet) {
        return [self canceltopMostActionSheetAnimated:animated completion:^(BOOL success) {
            if (success) {
                [self cancelAllAlertsAnimated:animated];
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
