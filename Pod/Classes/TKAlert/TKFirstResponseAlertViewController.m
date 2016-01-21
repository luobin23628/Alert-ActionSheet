//
//  TKTextFieldAlertViewController.m
//  
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import "TKFirstResponseAlertViewController.h"
#import "TKAlertViewController+Private.h"
#import "TKAlertOverlayWindow.h"
#import "UIDeviceAdditions.h"
#import "UIViewAdditions.h"

@interface TKFirstResponseAlertViewController()

@property (nonatomic, readwrite, assign) CGFloat keyboardBoundHeight;

@end

@implementation TKFirstResponseAlertViewController

@dynamic delegate;

- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView {
    self = [super initWithTitle:title customView:customView];
    if (self) {
        if (self) {
            // Initialization code
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showWithAnimationType:(TKAlertViewAnimation)animationType {
    [super showWithAnimationType:animationType];
}

-(void) keyboardWillShow:(NSNotification *)note{
    if (![self.customView findFirstResponder]) {
        return;
    }
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	CGPoint center = self.containerView.center;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(fixedCoordinateSpace)]) {
        keyboardBounds = [[[UIScreen mainScreen] fixedCoordinateSpace] convertRect:keyboardBounds fromCoordinateSpace:[[UIScreen mainScreen] coordinateSpace]];
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.keyboardBoundHeight = keyboardBounds.size.height;
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.keyboardBoundHeight = keyboardBounds.size.width;
    }
    
    center.y = floorf((self.wapperView.height - self.keyboardBoundHeight) * 4/7);
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]?:0.1];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
	
	// set views with new info
	self.containerView.center = center;
	
	// commit animations
	[UIView commitAnimations];
}

#if __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([self.customView findFirstResponder]) {
            CGPoint center = self.containerView.center;
            center.y = floorf((self.wapperView.height - self.keyboardBoundHeight) * 4/7);
            self.containerView.center = center;
        }
    } completion:nil];
}
#endif

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if ([self.customView findFirstResponder]) {
        CGPoint center = self.containerView.center;
        center.y = floorf((self.wapperView.height - self.keyboardBoundHeight) * 4/7);
        self.containerView.center = center;
    }
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (![self.customView findFirstResponder]) {
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
    CGRect frame = self.containerView.frame;
    
    frame.origin.x = floorf((self.wapperView.bounds.size.width - frame.size.width) * 0.5) - (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.vertical:self.offset.horizontal);
    frame.origin.y = floorf((self.wapperView.height - frame.size.height) * 0.5) + (UIInterfaceOrientationIsLandscape(orientation)?self.landscapeOffset.horizontal:self.offset.vertical);
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
    self.containerView.frame = frame;
    
	// commit animations
	[UIView commitAnimations];
}

@end
