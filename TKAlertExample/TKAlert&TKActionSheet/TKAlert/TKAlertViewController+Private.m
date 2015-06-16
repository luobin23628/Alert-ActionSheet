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

@implementation TKAlertViewController (Private)

- (void)updateFrameForDisplay {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat alertViewMaxHeigh = ((UIInterfaceOrientationIsLandscape(orientation)? [TKAlertOverlayWindow defaultWindow].width : [TKAlertOverlayWindow defaultWindow].height) - 2*3);
    CGFloat height = 15;
    
    if ([self.titleView.text length]) {
        CGRect frame = self.titleView.frame;
        frame.origin.y = height;
        frame.size.width = (kAlertViewWidth - 2*kAlertViewBorder);
        self.titleView.frame = frame;
        height += frame.size.height + 10;
    }
    
    CGRect frame = self.customView.bounds;
    frame.size.width = (kAlertViewWidth - 2*kAlertViewBorder);
    
    frame.origin.x = (kAlertViewWidth - frame.size.width)/2;
    frame.origin.y = height;
    
    self.customView.frame = frame;
    height += frame.size.height + 10;
    
    self.scrollView.contentSize = CGSizeMake(self.warpperView.bounds.size.width, height);
    
    CGFloat y = height;
    CGFloat buttonContainerViewHeight = 0;
    
    [self.buttonContainerView removeAllSubviews];
    
    if (self.actions.count == 2) {
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonContainerViewHeight, kAlertViewWidth, kAlertButtonLineWidth)];
        topLine.backgroundColor = kAlertViewLineColor;
        [self.buttonContainerView addSubview:topLine];
        
        buttonContainerViewHeight += kAlertButtonLineWidth;
        CGFloat width = kAlertViewWidth;
        CGFloat maxHalfWidth = floorf(kAlertViewWidth*0.5);
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
        CGFloat width = kAlertViewWidth;
        for (NSUInteger i = 0; i < self.actions.count; i++) {
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonContainerViewHeight, kAlertViewWidth, kAlertButtonLineWidth)];
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
    
    self.buttonContainerView.frame = CGRectMake(0, y, kAlertViewWidth, buttonContainerViewHeight);
    height += buttonContainerViewHeight;
    
    if (height < kAlertViewMinHeigh) {
        CGFloat offset = kAlertViewMinHeigh - height;
        height = kAlertViewMinHeigh;
        CGRect frame = self.buttonContainerView.frame;
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
    
    CGFloat x = floorf((self.warpperView.bounds.size.width - kAlertViewWidth) * 0.5) - (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.vertical:self.offset.horizontal);
    y = floorf((self.warpperView.bounds.size.height - height) * 0.5) + (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.horizontal:self.offset.vertical);
    NSLog(@"%@", NSStringFromCGRect(self.warpperView.bounds));
    frame = CGRectMake(x, y, kAlertViewWidth, height);
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

- (void)popupAlertAnimated:(BOOL)animated animationType:(TKAlertViewAnimation)animationType atOffset:(UIOffset)offset{
    if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)]) {
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
        
        if ([selfObj.delegate respondsToSelector:@selector(didPresentAlertView:)]) {
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
    
    if (animationType == TKAlertViewAnimationPop) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self popinAlertWithCompletion:completion];
    } else if (animationType == TKAlertViewAnimationBack) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self backinAlertWithCompletion:completion];
    } else if (animationType == TKAlertViewAnimationPath) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self showPathStyleWithCompletion:completion];
    }
}

- (void)rePopupAnimated:(BOOL)animated {
    [self popupAlertAnimated:animated animationType:self.animationType atOffset:self.offset];
}

- (void)removeAlertWindowOrShowAnOldAlert {
    NSMutableArray *alertStack = [TKAlertManager alertSheetStack];
    NSInteger index = [alertStack indexOfObject:self];
    if (index != NSNotFound && index < alertStack.count - 1) {
        index++;
        TKAlertViewController *oldAlertView = [alertStack objectAtIndex:index];
        [oldAlertView popupAlertAnimated:YES animationType:oldAlertView.animationType atOffset:oldAlertView.offset];
    } else {
        [[TKAlertOverlayWindow defaultWindow] reduceAlphaIfEmpty];
    }
}

- (void)hiddenAlertAnimatedWithCompletion:(void (^)(BOOL finished))completion1 {
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (completion1) {
            completion1(finished);
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    if (self.animationType == TKAlertViewAnimationPop) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self popoutAlertWithCompletion:completion];
    } else if (self.animationType == TKAlertViewAnimationBack) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self backoutAlertWithCompletion:completion];
    } else if (self.animationType == TKAlertViewAnimationPath) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self hiddenPathStyleWithCompletion:completion];
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
    [self dismissWithClickedButtonIndex:0 animated:animated completion:nil noteDelegate:NO];
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
            [[TKAlertOverlayWindow defaultWindow] revertKeyWindowAndHidden];
            [TKAlertOverlayWindow defaultWindow].rootViewController = nil;
            selfObj.visible = NO;
            [TKAlertManager removeFromStack:selfObj];
            [[TKAlertManager topMostAlert] rePopupAnimated:animated];
            
            if (noteDelegate && buttonIndex >= 0 && buttonIndex < [selfObj.actions count]) {
                TKAlertViewAction *action = [selfObj.actions objectAtIndex: buttonIndex];
                if (action.handler) {
                    action.handler(action);
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
                action.handler(action);
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


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Action

- (void)buttonClicked:(UIButton *)sender {
    long buttonIndex = [sender tag] - 1;
    
    if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:buttonIndex];
    }
    
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES completion:nil noteDelegate:YES];
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void (^completion)(BOOL) = [anim valueForKey:kAnimationCompletionKey];
    if (completion) {
        completion(flag);
    }
}

#pragma mark - Pop

- (void)popoutAlertWithCompletion:(void (^)(BOOL finished))completion {
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

- (void)popinAlertWithCompletion:(void (^)(BOOL finished))completion {
    
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

#pragma mark - Back

- (void)backinAlertWithCompletion:(void (^)(BOOL finished))completion {
    __block CGPoint center = self.containerView.center;
    CGFloat yPositionOutOfBounds = self.warpperView.height/2 + self.containerView.height/2;
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

- (void)backoutAlertWithCompletion:(void (^)(BOOL finished))completion {
    __block TKAlertViewController *selfObj = self;
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         CGPoint center = self.containerView.center;
                         center.y += 20;
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

#pragma mark － Path Style

- (UIDynamicAnimator *)createAnimatorIfNeed {
    if (!self.animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.warpperView];
    }
    return self.animator;
}

- (void)showPathStyleWithCompletion:(void (^)(BOOL finished))completion {
    self.dismissBySwipe = YES;
    [self showOverlayWindowAniamted];
    
    __block CGPoint center = self.containerView.center;
    CGFloat yPositionOutOfBounds = self.warpperView.height/2 + self.containerView.height/2;
    center.y -= yPositionOutOfBounds;
    self.containerView.center = center;
    
    center.y += kAlertViewBounce + yPositionOutOfBounds;
    
    [self createAnimatorIfNeed];
    [self.animator removeAllBehaviors];
    CGFloat showMagnitude = 200.0f;
    
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
}

- (void)hiddenPathStyleWithCompletion:(void (^)(BOOL finished))completion {
    
    [self createAnimatorIfNeed];
    [self.animator removeAllBehaviors];
    
    CGFloat closeMagnitude = 150.0f;;
    
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
    
}

- (void)fixOnCenterWithCompletion:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.08 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CGPoint center = self.containerView.center;
        center.y = self.warpperView.height/2 + kAlertViewBounce;
        self.containerView.center = center;
        self.containerView.transform = CGAffineTransformMakeRotation(M_PI / 90.0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGPoint center = self.containerView.center;
            center.y = self.warpperView.height/2;
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
    CGFloat width = CGRectGetWidth(self.warpperView.bounds);
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
    if (self.dismissBySwipe) {
        CGFloat alpha = 0;
        [self.windowBackgroundColor getWhite:nil alpha:&alpha];
        
        UIView *warpperView = self.warpperView;
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
                CGPoint center = self.warpperView.center;
                center.y = warpperView.height/2 + (isDownGesuture ? translation.y : translation.y / 10.0);
                self.containerView.center = center;
                window.backgroundView.backgroundColor = [window.backgroundView.backgroundColor colorWithAlphaComponent:(isDownGesuture ? alpha * (1 - panYAmountOnBackground) : alpha)];
                
                break;
                
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded:
                if (self.containerView.center.y >= CGRectGetHeight(self.warpperView.bounds)
                    || velocityY >= 500.0) {
                    [self dismissWithClickedButtonIndex:-1 animated:YES completion:nil noteDelegate:YES];
                } else {
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
                        self.containerView.transform = CGAffineTransformIdentity;
                        CGPoint center = self.containerView.center;
                        center.y = self.warpperView.height/2;
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


@end
