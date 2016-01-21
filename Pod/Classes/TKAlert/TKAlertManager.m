//
//  TKAlertManager.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKAlertManager.h"
#import "TKAlertViewController.h"
#import "TKAlertOverlayWindow.h"
#import "TKAlertViewController+Private.h"

static NSMutableArray *alertViewStack = nil;
static NSUInteger visibleAlertIndex = NSNotFound;

@implementation TKAlertManager

+ (void)initialize {
    
    alertViewStack = [[NSMutableArray alloc] init];
    visibleAlertIndex = NSNotFound;
}

+ (NSMutableArray *)alertSheetStack {
    return alertViewStack;
}

+ (BOOL)stackContainsAlert:(TKAlertViewController *)alertView {
    return [alertViewStack indexOfObject:alertView] != NSNotFound;
}

+ (void)removeFromStack:(TKAlertViewController *)alertView {
    [alertViewStack removeObject:alertView];
}

+ (void)addToStack:(TKAlertViewController *)alertView dontDimBackground:(BOOL)flag {
    [alertViewStack addObject:alertView];
}

+ (TKAlertViewController *)visibleAlert {
    for (TKAlertViewController *alertView in alertViewStack) {
        if (alertView.isVisible) {
            return alertView;
        }
    }
    return nil;
}

+ (TKAlertViewController *)topMostAlert {
    return alertViewStack.lastObject;
}

+ (BOOL)cancelAllAlertsAnimated:(BOOL)animated {
//    if (animated) {
//        void (^completion)(BOOL) = ^(BOOL finished) {
//            TKAlertView *alertView = TKAlertManager.topMostAlert;
//            [[TKAlertOverlayWindow defaultWindow] removeOverlay:alertView];
//            alertView.visible = NO;
//            [[alertView retain] autorelease];
//            [TKAlertManager removeFromStack:alertView];
//            
//            [TKAlertManager cancelAlertsAnimated:NO];
//        };
//        [TKAlertManager.topMostAlert hiddenAlertAnimatedWithCompletion:completion];
//    } else {
//        TKAlertView *topMostAlert = TKAlertManager.topMostAlert;
//        while (topMostAlert) {
//            [[TKAlertOverlayWindow defaultWindow] removeOverlay:topMostAlert];
//            topMostAlert.visible = NO;
//            [[topMostAlert retain] autorelease];
//            [TKAlertManager removeFromStack:topMostAlert];
//            
//            topMostAlert = TKAlertManager.topMostAlert;
//        }
//    }
//    return YES;
    
    TKAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        return [self cancelTopMostAlertAnimated:animated completion:^(BOOL success) {
            if (success) {
                [TKAlertManager cancelAllAlertsAnimated:animated];
            }
        }];
    } else {
        return YES;
    }
}

+ (BOOL)cancelTopMostAlertAnimated:(BOOL)animated {
    return [self cancelTopMostAlertAnimated:animated completion:nil];
}

+ (BOOL)cancelTopMostAlertAnimated:(BOOL)animated completion:(void(^)(BOOL success))completion{
    TKAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        if (animated) {
            void (^hiddenAlertCompletion)(BOOL) = ^(BOOL finished) {
                [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
                [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
                topMostAlert.visible = NO;
                [TKAlertManager removeFromStack:topMostAlert];
                
                if (completion) {
                    completion(YES);
                }
            };
            [topMostAlert hiddenAlertAnimatedWithCompletion:hiddenAlertCompletion];
        } else {
            [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
            [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
            topMostAlert.visible = NO;
            [TKAlertManager removeFromStack:topMostAlert];
            
            if (completion) {
                completion(YES);
            }
        }
    } else {
        if (completion) {
            completion(NO);
        }
    }
    return NO;
}

+ (BOOL)hideTopMostAlertAnimated:(BOOL)animated {
    TKAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        [topMostAlert temporarilyHideAnimated:animated];
        return YES;
    }
    return NO;
}

@end
