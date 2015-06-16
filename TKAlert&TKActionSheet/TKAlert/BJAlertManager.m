//
//  BJAlertManager.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "BJAlertManager.h"
#import "BJAlertViewController.h"
#import "BJAlertOverlayWindow.h"
#import "BJAlertViewController+Private.h"

static NSMutableArray *alertViewStack = nil;
static NSUInteger visibleAlertIndex = NSNotFound;

@implementation BJAlertManager

+ (void)initialize {
    
    alertViewStack = [[NSMutableArray alloc] init];
    visibleAlertIndex = NSNotFound;
}

+ (NSMutableArray *)alertSheetStack {
    return alertViewStack;
}

+ (BOOL)stackContainsAlert:(BJAlertViewController *)alertView {
    return [alertViewStack indexOfObject:alertView] != NSNotFound;
}

+ (void)removeFromStack:(BJAlertViewController *)alertView {
    [alertViewStack removeObject:alertView];
}

+ (void)addToStack:(BJAlertViewController *)alertView dontDimBackground:(BOOL)flag {
    [alertViewStack addObject:alertView];
}

+ (BJAlertViewController *)visibleAlert {
    for (BJAlertViewController *alertView in alertViewStack) {
        if (alertView.isVisible) {
            return alertView;
        }
    }
    return nil;
}

+ (BJAlertViewController *)topMostAlert {
    return alertViewStack.lastObject;
}

+ (BOOL)cancelAlertsAnimated:(BOOL)animated {
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
    
    BJAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        return [self cancelTopMostAlertAnimated:animated completion:^(BOOL success) {
            if (success) {
                [BJAlertManager cancelAlertsAnimated:animated];
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
    BJAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        if (animated) {
            void (^hiddenAlertCompletion)(BOOL) = ^(BOOL finished) {
                [[BJAlertOverlayWindow defaultWindow] removeOverlay:topMostAlert.view];
                topMostAlert.visible = NO;
                [BJAlertManager removeFromStack:topMostAlert];
                
                if (completion) {
                    completion(YES);
                }
            };
            [topMostAlert hiddenAlertAnimatedWithCompletion:hiddenAlertCompletion];
        } else {
            [[BJAlertOverlayWindow defaultWindow] removeOverlay:topMostAlert.view];
            topMostAlert.visible = NO;
            [BJAlertManager removeFromStack:topMostAlert];
            
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
    BJAlertViewController *topMostAlert = self.topMostAlert;
    if (topMostAlert) {
        [topMostAlert temporarilyHideAnimated:animated];
        return YES;
    }
    return NO;
}

@end
