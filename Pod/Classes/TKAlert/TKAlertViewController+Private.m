//
//  TKAlertViewController+Private.m
//
//
//  Created by binluo on 15/5/28.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "TKAlertViewController+Private.h"
#import "TKAlertManager.h"
#import "TKAlertOverlayWindow.h"
#import "TKBlurView.h"
#import "UIScreen+Size.h"
#import "UIViewAdditions.h"
#import "UIImageExtend.h"
#import "TKAlertConst.h"
#import "TKAlertViewAction.h"

@implementation TKAlertViewController (Private)

- (void)updateFrameForDisplay {
    CGFloat alertViewWidth = kAlertViewDefaultWidth;
    if (self.customView && self.customView.width > 0) {
        alertViewWidth = self.customView.width + self.customeViewInset.left + self.customeViewInset.right;
        if (alertViewWidth < kAlertViewMinWidth) {
            alertViewWidth = kAlertViewMinWidth;
        }
        if (alertViewWidth > kAlertViewMaxWidth) {
            alertViewWidth = kAlertViewMaxWidth;
        }
    }
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat alertViewMaxHeigh = ([UIScreen mainScreen].flexibleBounds.size.height - 2*3);
    CGFloat height = self.customeViewInset.top;
    
    if ([self.titleView.text length]) {
        CGRect frame = self.titleView.frame;
        frame.origin.y = height;
        frame.size.width = (alertViewWidth - 2*kAlertViewBorder);
        self.titleView.frame = frame;
        height += frame.size.height + 10;
    }
    
    CGRect frame = self.customView.bounds;
    frame.size.width = (alertViewWidth - self.customeViewInset.left - self.customeViewInset.right);
    
    frame.origin.x = self.customeViewInset.left;
    frame.origin.y = height;
    
    self.customView.frame = frame;
    height += frame.size.height + self.customeViewInset.bottom;
    
    self.scrollView.contentSize = CGSizeMake(alertViewWidth, height);
    
    CGFloat y = height;
    CGFloat buttonContainerViewHeight = 0;
    
    [self.buttonContainerView removeAllSubviews];
    
    [UIView setAnimationsEnabled:NO];
    
    if (self.actions.count == 2) {
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonContainerViewHeight, alertViewWidth, kAlertButtonLineWidth)];
        topLine.backgroundColor = kAlertViewLineColor;
        [self.buttonContainerView addSubview:topLine];
        
        buttonContainerViewHeight += kAlertButtonLineWidth;
        CGFloat width = alertViewWidth;
        CGFloat maxHalfWidth = floorf(alertViewWidth*0.5);
        UIButton *button = [self buttonWithAction:[self.actions firstObject]];
        button.tag = 1;
        [self.buttonContainerView addSubview:button];
        button.frame = CGRectMake(0, buttonContainerViewHeight, maxHalfWidth, kAlertButtonHeight);
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(maxHalfWidth, buttonContainerViewHeight, kAlertButtonLineWidth, kAlertButtonHeight)];
        middleLine.backgroundColor = kAlertViewLineColor;
        [self.buttonContainerView addSubview:middleLine];
        
        button = [self buttonWithAction:[self.actions lastObject]];
        button.tag = 2;
        [self.buttonContainerView addSubview:button];
        button.frame = CGRectMake(kAlertButtonLineWidth + maxHalfWidth, buttonContainerViewHeight, width - maxHalfWidth - kAlertButtonLineWidth, kAlertButtonHeight);
        
        buttonContainerViewHeight += kAlertButtonHeight;
    } else if (self.actions.count != 0)  {
        CGFloat width = alertViewWidth;
        for (NSUInteger i = 0; i < self.actions.count; i++) {
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonContainerViewHeight, alertViewWidth, kAlertButtonLineWidth)];
            topLine.backgroundColor = kAlertViewLineColor;
            [self.buttonContainerView addSubview:topLine];
            
            UIButton *button = [self buttonWithAction:[self.actions objectAtIndex:i]];
            button.tag = i + 1;
            [self.buttonContainerView addSubview:button];
            button.frame = CGRectMake(0, kAlertButtonLineWidth + buttonContainerViewHeight, width, kAlertButtonHeight);
            if (buttonContainerViewHeight + kAlertButtonHeight + kAlertButtonLineWidth > alertViewMaxHeigh) {
                button.frame = CGRectMake(0, 0, 0, 0);
            } else {
                buttonContainerViewHeight += kAlertButtonLineWidth + kAlertButtonHeight;
            }
        }
    }
    
    [UIView setAnimationsEnabled:YES];
    
    self.buttonContainerView.frame = CGRectMake(0, y, alertViewWidth, buttonContainerViewHeight);
    height += buttonContainerViewHeight;
    
    if (height < kAlertViewMinHeigh) {
        CGFloat offset = kAlertViewMinHeigh - height;
        height = kAlertViewMinHeigh;
        
        CGRect frame = self.scrollView.frame;
        frame.size.height += offset;
        self.scrollView.frame = frame;
        
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height += offset;
        self.scrollView.contentSize = contentSize;
        
        frame = self.customView.frame;
        frame.origin.y += offset/2;
        self.customView.frame = frame;
        
        frame = self.buttonContainerView.frame;
        frame.origin.y += offset;
        self.buttonContainerView.frame = frame;
    }
    
    if (height > alertViewMaxHeigh) {
        CGFloat offset = height - alertViewMaxHeigh;
        height = alertViewMaxHeigh;
        CGRect frame = self.buttonContainerView.frame;
        frame.origin.y -= offset;
        self.buttonContainerView.frame = frame;
        
        CGRect scrollViewFrame = self.scrollView.frame;
        scrollViewFrame.size.height = self.scrollView.contentSize.height - offset;
        self.scrollView.frame = scrollViewFrame;
    } else {
        CGRect scrollViewFrame = self.scrollView.frame;
        scrollViewFrame.size.height = self.scrollView.contentSize.height;
        self.scrollView.frame = scrollViewFrame;
    }
    
    self.buttonContainerView.hidden = !buttonContainerViewHeight;
    
    CGFloat x = floorf((self.wapperView.bounds.size.width - alertViewWidth) * 0.5) - (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.vertical:self.offset.horizontal);
    y = floorf((self.wapperView.bounds.size.height - height) * 0.5) + (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.horizontal:self.offset.vertical);

    frame = CGRectMake(x, y, alertViewWidth, height);
    self.containerView.frame = frame;
}

- (UIButton *)buttonForIndex:(NSInteger)buttonIndex {
    id button = [self.buttonContainerView viewWithTag:buttonIndex + 1];
    if ([button isKindOfClass:UIButton.class]) {
        return button;
    } else {
        return nil;
    }
}

- (UIButton *)buttonWithAction:(TKAlertViewAction *)action {

    NSString *title = action.title;
    TKAlertViewButtonType type = action.type;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = kAlertViewButtonFont;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor clearColor];
    
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:208.0/255 green:209.0/255 blue:210.0/255 alpha:1]] forState:UIControlStateHighlighted];
    
    UIColor *textColor = [self titleColorForButton:type];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:[textColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    button.adjustsImageWhenDisabled = NO;
    button.accessibilityLabel = title;
    
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)popupAlertAnimated:(BOOL)animated animationType:(TKAlertViewAnimation)animationType atOffset:(UIOffset)offset noteDelegate:(BOOL)noteDelegate {
    if (noteDelegate && [self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.delegate willPresentAlertView:self];
    }
    
    self.visible = YES;
    
    if (!self.backgroundView) {
        self.backgroundView = [[TKBlurView alloc] initWithFrame:self.containerView.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.backgroundColor = kAlertViewBackgroundColor;
    }
    
    [self.containerView insertSubview:self.backgroundView atIndex:0];
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWindow:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWindow:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
    [TKAlertOverlayWindow defaultWindow].backgroundView.backgroundColor = self.windowBackgroundColor;
    
    [TKAlertOverlayWindow defaultWindow].frame = [[UIScreen mainScreen] bounds];
    [[TKAlertOverlayWindow defaultWindow] makeKeyAndVisible];
    
    [self updateFrameForDisplay];
    
    [TKAlertOverlayWindow defaultWindow].rootViewController = self;

    [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
    [TKAlertOverlayWindow defaultWindow].frame = [[UIScreen mainScreen] bounds];

    self.isAnimating = YES;
    
    __block TKAlertViewController *selfObj = self;
    void (^completion)(BOOL) = ^(BOOL finished) {
        selfObj.isAnimating = NO;
        
        [self addParallaxEffect];
        
        if (noteDelegate && [selfObj.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
            [selfObj.delegate didPresentAlertView:selfObj];
        }
        if (selfObj.cancelWhenDoneAnimating) {
            selfObj.cancelWhenDoneAnimating = NO;
            [selfObj temporarilyHideAnimated:YES];
        }
    };
    [self showAlertWithAnimationType:animationType completion:completion];
}

- (void)showAlertWithAnimationType:(TKAlertViewAnimation)animationType completion:(void (^)(BOOL finished))completion1 {
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (completion1) {
            completion1(finished);
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    switch (self.animationType) {
        case TKAlertViewAnimationBounce:
            [self showAlertWithBounce:completion];
            break;
        case TKAlertViewAnimationFromTop:
            [self showAlertWithFromTop:completion];
            break;
            
        case TKAlertViewAnimationFromBottom:
            [self showAlertWithFromBottom:completion];
            break;
            
        case TKAlertViewAnimationFade:
            [self showAlertWithFade:completion];
            break;
            
        case TKAlertViewAnimationDropDown:
            [self showAlertWithDropDown:completion];
            break;
            
        case TKAlertViewAnimationPathStyle:
            [self showAlertWithPathStyle:completion];
            break;
            
        default:
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            NSAssert(NO, @"Unkown animate type.");
            break;
    }
}

- (void)rePopupAnimated:(BOOL)animated {
    [self popupAlertAnimated:animated animationType:self.animationType atOffset:self.offset noteDelegate:NO];
}

- (void)removeAlertWindowOrShowAnOldAlert {
    NSMutableArray *alertStack = [TKAlertManager alertSheetStack];
    NSInteger index = [alertStack indexOfObject:self];
    if (index != NSNotFound && index < alertStack.count - 1) {
        index++;
        TKAlertViewController *oldAlertView = [alertStack objectAtIndex:index];
        [oldAlertView popupAlertAnimated:YES animationType:oldAlertView.animationType atOffset:oldAlertView.offset noteDelegate:YES];
    } else {
        [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
    }
}

- (void)hiddenAlertAnimatedWithCompletion:(void (^)(BOOL finished))completion1 {
    self.isAnimating = YES;
    void (^completion)(BOOL) = ^(BOOL finished) {
        self.isAnimating = NO;
        
        if (completion1) {
            completion1(finished);
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    switch (self.animationType) {
        case TKAlertViewAnimationBounce:
            [self hiddenAlertWithBounce:completion];
            break;
        case TKAlertViewAnimationFromTop:
            [self hiddenAlertWithFromTop:completion];
            break;
            
        case TKAlertViewAnimationFromBottom:
            [self hiddenAlertWithFromBottom:completion];
            break;
            
        case TKAlertViewAnimationFade:
            [self hiddenAlertWithFade:completion];
            break;
            
        case TKAlertViewAnimationDropDown:
            [self hiddenAlertWithDropDown:completion];
            break;
            
        case TKAlertViewAnimationPathStyle:
            [self hiddenAlertWithPathStyle:completion];
            break;

        default:
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            NSAssert(NO, @"Unkown animate type.");
            break;
    }
}

- (void)temporarilyHideAnimated:(BOOL)animated {
    
    if (self.isAnimating || !self.isVisible) {
        self.cancelWhenDoneAnimating = YES;
    } else {
        if (animated){
            __block TKAlertViewController *selfObj = self;
            void (^completion)(BOOL) = ^(BOOL finished) {
                [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
                [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
                selfObj.visible = NO;
                [selfObj removeAlertWindowOrShowAnOldAlert];
            };
            [self hiddenAlertAnimatedWithCompletion:completion];
        } else {
            [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
            [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
            self.visible = NO;
            [self removeAlertWindowOrShowAnOldAlert];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissWithClickedButtonIndex:-1 animated:animated completion:nil noteDelegate:NO];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))comp noteDelegate:(BOOL)noteDelegate{
    if (!self.isVisible) {
        return;
    }
    
    if (noteDelegate && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
    }
    
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer = nil;
    
    [self.view removeGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer = nil;
    
    if (animated){
        __block TKAlertViewController *selfObj = self;
        void (^completion)(BOOL) = ^(BOOL finished) {
            [self removeParallaxEffect];
            [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
            [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
            selfObj.visible = NO;
            [TKAlertManager removeFromStack:selfObj];
            [[TKAlertManager topMostAlert] rePopupAnimated:animated];
            
            if (noteDelegate && buttonIndex >= 0 && buttonIndex < [selfObj.actions count]) {
                TKAlertViewAction *action = [selfObj.actions objectAtIndex: buttonIndex];
                if (action.handler) {
                    action.handler(buttonIndex);
                }
            }
            
            if (noteDelegate && [selfObj.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
                [selfObj.delegate alertView:selfObj didDismissWithButtonIndex:buttonIndex];
            }
            
            if (comp) {
                comp();
            }
        };
        [self hiddenAlertAnimatedWithCompletion:completion];
        
    } else {
        [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
        [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
        [TKAlertManager removeFromStack:self];
        self.visible = NO;
        
        if (noteDelegate && buttonIndex >= 0 && buttonIndex < [self.actions count]) {
            TKAlertViewAction *action = [self.actions objectAtIndex: buttonIndex];
            if (action.handler) {
                action.handler(buttonIndex);
            }
        }
        
        if (noteDelegate && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
            [self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
        }
        
        if (comp) {
            comp();
        }
    }
}

- (void)showOverlayWindowAniamted {
    [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = .0f;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
                     }
                     completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action

- (void)buttonClicked:(UIButton *)sender {
    long buttonIndex = [sender tag] - 1;
    
    BOOL shouldDismiss = YES;
    if ([self.delegate respondsToSelector:@selector(alertView:shouldDismissWithButtonIndex:)]) {
        shouldDismiss = [self.delegate alertView:self shouldDismissWithButtonIndex:buttonIndex];
    }

    if (shouldDismiss) {
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
        }
        [self dismissWithClickedButtonIndex:buttonIndex animated:YES completion:nil noteDelegate:YES];
    }
}


#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completion)(BOOL) = [anim valueForKey:kAnimationCompletionKey];
    if (completion) {
        completion(flag);
    }
}

#pragma mark - Bounce

- (void)showAlertWithBounce:(void (^)(BOOL finished))completion {
    
    [self showOverlayWindowAniamted];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [animation setValue:[completion copy] forKey:kAnimationCompletionKey];
    
    NSMutableArray *values = [NSMutableArray array];
    
    CATransform3D transform = self.containerView.layer.transform;
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, 0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, 0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.containerView.layer addAnimation:animation forKey:nil];
}

- (void)hiddenAlertWithBounce:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.containerView.alpha = 0;
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = .0f;
                     }
                     completion:^(BOOL finished) {
                         self.containerView.alpha = 1;
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

#pragma mark - FromTop

- (void)showAlertWithFromTop:(void (^)(BOOL finished))completion {
    __block CGPoint center = self.containerView.center;
    CGFloat yPositionOutOfBounds = self.wapperView.height/2 + self.containerView.height/2;
    center.y -= yPositionOutOfBounds;
    self.containerView.center = center;
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
                         center.y += kAlertViewBounce + yPositionOutOfBounds;
                         selfObj.containerView.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              selfObj.containerView.center = center;
                                          }
                                          completion:completion];
                     }];
}

- (void)hiddenAlertWithFromTop:(void (^)(BOOL finished))completion {
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         CGPoint center = self.containerView.center;
                         center.y += kAlertViewBounce;
                         selfObj.containerView.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGPoint center = selfObj.containerView.center;
                                              center.y = - selfObj.containerView.height/2;
                                              selfObj.containerView.center = center;
                                              [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
                                          }
                                          completion:completion];
                     }];
}

#pragma mark - FromBottom

- (void)showAlertWithFromBottom:(void (^)(BOOL finished))completion {
    __block CGPoint center = self.containerView.center;
    CGFloat yPositionOutOfBounds = self.wapperView.height/2 + self.containerView.height/2;
    center.y += yPositionOutOfBounds;
    self.containerView.center = center;
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
                         center.y -= kAlertViewBounce + yPositionOutOfBounds;
                         selfObj.containerView.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y += kAlertViewBounce;
                                              selfObj.containerView.center = center;
                                          }
                                          completion:completion];
                     }];
}

- (void)hiddenAlertWithFromBottom:(void (^)(BOOL finished))completion {
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         CGPoint center = self.containerView.center;
                         center.y -= kAlertViewBounce;
                         selfObj.containerView.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGPoint center = selfObj.containerView.center;
                                              center.y = selfObj.containerView.height/2 + self.wapperView.height;
                                              selfObj.containerView.center = center;
                                              [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
                                          }
                                          completion:completion];
                     }];
}


#pragma mark - Fade

- (void)showAlertWithFade:(void (^)(BOOL finished))completion {
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
                         self.containerView.alpha = 1;
                     }
                     completion:completion];
}

- (void)hiddenAlertWithFade:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         self.containerView.alpha = 0;
                         [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
                     }
                     completion:completion];
}

#pragma mark - DropDown

- (void)showAlertWithDropDown:(void (^)(BOOL finished))completion {
    __block CGPoint center = self.containerView.center;
    center.y = -self.containerView.height/2;
    self.containerView.center = center;
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [TKAlertOverlayWindow defaultWindow].backgroundView.alpha = 1.0f;
                         center.y += kAlertViewBounce + self.containerView.height/2 + self.wapperView.height/2;
                         selfObj.containerView.center = center;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              center.y -= kAlertViewBounce;
                                              selfObj.containerView.center = center;
                                          }
                                          completion:completion];
                     }];
}

- (void)hiddenAlertWithDropDown:(void (^)(BOOL finished))completion {
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:0
                     animations:^{
                         CGPoint center = selfObj.containerView.center;
                         center.y = selfObj.containerView.height/2 + self.wapperView.height;
                         selfObj.containerView.center = center;
                         [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
                     }
                     completion:completion];
}

#pragma mark － Path Style

- (UIDynamicAnimator *)createAnimatorIfNeed {
    if (!self.animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.wapperView];
    }
    return self.animator;
}

- (void)showAlertWithPathStyle:(void (^)(BOOL finished))completion {
    [self showOverlayWindowAniamted];
    
    if (NSClassFromString(@"UIPushBehavior")) {
        self.dismissBySwipe = YES;
        __block CGPoint center = self.containerView.center;
        CGFloat yPositionOutOfBounds = self.wapperView.height/2 + self.containerView.height/2;
        center.y -= yPositionOutOfBounds;
        self.containerView.center = center;
        
        center.y += kAlertViewBounce + yPositionOutOfBounds;
        
        [self createAnimatorIfNeed];
        [self.animator removeAllBehaviors];
        CGFloat showMagnitude = (self.containerView.height)*70/150;
        
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.containerView] mode:UIPushBehaviorModeInstantaneous];
        [push setTargetOffsetFromCenter:UIOffsetMake(-1.0, 0) forItem:self.containerView];
        push.pushDirection = CGVectorMake(0, 1.0);
        push.magnitude = showMagnitude;
        __weak TKAlertViewController *selfObj = self;;
        [push setAction:^{
            if (selfObj.containerView.center.y >= center.y) {
                [selfObj.animator removeAllBehaviors];
                [selfObj fixOnCenterWithCompletion:completion];
            }
        }];
        [self.animator addBehavior:push];
    } else {
        [self showAlertWithDropDown:completion];
    }
}

- (void)hiddenAlertWithPathStyle:(void (^)(BOOL finished))completion {
    
    if (NSClassFromString(@"UIPushBehavior")) {
        [self createAnimatorIfNeed];
        [self.animator removeAllBehaviors];
        
        CGFloat closeMagnitude = (self.containerView.height)*70/150;;
        
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.containerView] mode:UIPushBehaviorModeInstantaneous];
        [push setTargetOffsetFromCenter:UIOffsetMake(-2.0, 0) forItem:self.containerView];
        push.pushDirection = CGVectorMake(0, 1.0);
        push.magnitude = closeMagnitude;
        
        [self.animator addBehavior:push];
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
                         }
                         completion:^(BOOL finished) {
                             [self.animator removeAllBehaviors];
                             self.animator = nil;
                             
                             if (completion) {
                                 completion(finished);
                             }
                         }];
    } else {
        [self hiddenAlertWithDropDown:completion];
    }
}

- (void)fixOnCenterWithCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGPoint center = self.containerView.center;
        center.y = self.wapperView.height/2 + kAlertViewBounce;
        self.containerView.center = center;
        self.containerView.transform = CGAffineTransformMakeRotation(M_PI / 90.0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGPoint center = self.containerView.center;
            center.y = self.wapperView.height/2;
            self.containerView.center = center;
            self.containerView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    }];
}


- (CGFloat)tapPointXPercentage:(CGFloat)pointX {
    /* return |-1 0 1| */
    CGFloat width = CGRectGetWidth(self.wapperView.bounds);
    if (pointX >= width / 2.0) {
        return (2.0 - width / pointX);
    } else {
        return -(2.0 - width / (width - (pointX + 1)));
    }
}

#pragma mark - Tap Gesture Recognizer

- (void)tapWindow:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.dismissWhenTapWindow) {
        [self dismissWithClickedButtonIndex:-1 animated:YES completion:^{
            if (self.dismissWhenTapWindowHandler) {
                self.dismissWhenTapWindowHandler();
            }
        }];
    }
}

- (void)panWindow:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.dismissBySwipe && self.animationType == TKAlertViewAnimationPathStyle) {
        CGFloat alpha = 0;
        [self.windowBackgroundColor getWhite:nil alpha:&alpha];
        
        UIView *warpperView = self.wapperView;
        TKAlertOverlayWindow *window = [TKAlertOverlayWindow defaultWindow];
        
        CGPoint location = [gestureRecognizer locationInView:warpperView];
        CGPoint translation = [gestureRecognizer translationInView:warpperView];
        CGFloat velocityY = [gestureRecognizer velocityInView:warpperView].y;
        
        BOOL isDownGesuture = self.containerView.center.y > warpperView.center.y;
        CGFloat panYAmountOnBackground = translation.y / CGRectGetHeight(warpperView.bounds);
        CGFloat angle = (M_PI / 180.0) * [self tapPointXPercentage:location.x] * (8.0 * panYAmountOnBackground);
        
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateChanged:
                self.containerView.transform = CGAffineTransformMakeRotation(isDownGesuture ? angle : 0);
                CGPoint center = self.wapperView.center;
                center.y = warpperView.height/2 + (isDownGesuture ? translation.y : translation.y / 10.0);
                self.containerView.center = center;
                window.backgroundView.backgroundColor = [window.backgroundView.backgroundColor colorWithAlphaComponent:(isDownGesuture ? alpha * (1 - panYAmountOnBackground) : alpha)];
                
                break;
                
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
                if (self.containerView.center.y >= CGRectGetHeight(self.wapperView.bounds)
                    || velocityY >= 500.0) {
                    [self dismissWithClickedButtonIndex:-1 animated:YES completion:nil noteDelegate:YES];
                } else {
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
                        self.containerView.transform = CGAffineTransformIdentity;
                        CGPoint center = self.containerView.center;
                        center.y = self.wapperView.height/2;
                        self.containerView.center = center;
                        self.containerView.transform = CGAffineTransformIdentity;
                        window.backgroundView.backgroundColor = self.windowBackgroundColor;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            default:
                break;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.containerView];
}


#pragma mark - Parallax effect

- (void)addParallaxEffect
{
    if (self.enabledParallaxEffect && NSClassFromString(@"UIInterpolatingMotionEffect"))
    {
        UIInterpolatingMotionEffect *effectHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"position.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        UIInterpolatingMotionEffect *effectVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"position.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        [effectHorizontal setMaximumRelativeValue:@(10.0f)];
        [effectHorizontal setMinimumRelativeValue:@(-10.0f)];
        [effectVertical setMaximumRelativeValue:@(15.0f)];
        [effectVertical setMinimumRelativeValue:@(-15.0f)];
        [self.containerView addMotionEffect:effectHorizontal];
        [self.containerView addMotionEffect:effectVertical];
    }
}

- (void)removeParallaxEffect
{
    if (self.enabledParallaxEffect && NSClassFromString(@"UIInterpolatingMotionEffect"))
    {
        [self.containerView.motionEffects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.containerView removeMotionEffect:obj];
        }];
    }
}

@end
