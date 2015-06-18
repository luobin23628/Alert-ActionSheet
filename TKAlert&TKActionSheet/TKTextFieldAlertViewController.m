//
//  TKTextFieldAlertViewController.m
//  
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import "TKTextFieldAlertViewController.h"
#import "TKAlertViewController+Private.h"
#import "TKAlertOverlayWindow.h"
#import "UIDeviceAdditions.h"
#import "UIViewAdditions.h"

@interface _TKTextFieldAlertView_TextFiled : UITextField

@end

@implementation _TKTextFieldAlertView_TextFiled


- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 6, 0, 0));
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 6, 0, 0))];
}

@end

@interface TKTextFieldAlertViewController()

@property (nonatomic, readwrite, strong) UITextField *textField;
@property (nonatomic, readwrite, assign) CGFloat keyboardBoundHeight;

@end

@implementation TKTextFieldAlertViewController

@dynamic delegate;

- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    UITextField *textFiled;
    if ([[UIDevice currentDevice] isIOS7]) {
        textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        textFiled.borderStyle = UITextBorderStyleRoundedRect;
    } else {
        textFiled = [[_TKTextFieldAlertView_TextFiled alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFiled.borderStyle = UITextBorderStyleNone;
        textFiled.layer.cornerRadius = 4.f;
        textFiled.layer.borderWidth = 0.5f;
        textFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    textFiled.returnKeyType = UIReturnKeyDone;
    textFiled.keyboardType = UIKeyboardTypeDefault;
    textFiled.placeholder = placeholder;
    textFiled.font = [UIFont systemFontOfSize:14];
    textFiled.textAlignment = 0;//NSTextAlignmentLeft;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFiled addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField = textFiled;
    self = [super initWithTitle:title customView:textFiled];
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
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.textField = nil;
}

- (void)showWithAnimationType:(TKAlertViewAnimation)animationType {
    [super showWithAnimationType:animationType];
    [self.textField becomeFirstResponder];
    [self textFiledDidChange:self.textField];
}

- (void)textFiledDidChange:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(alertView:shouldEnableButtonForIndex:)]) {
        int i = 0;
        UIButton *button;
        while ((button = [self buttonForIndex:i])) {
            BOOL shouldEnable = [(id<TKTextFieldAlertViewDelegate>)self.delegate alertView:self shouldEnableButtonForIndex:i];
            button.enabled = shouldEnable;
            i++;
        }
    }
}

-(void) keyboardWillShow:(NSNotification *)note{
    if (![self.textField isFirstResponder]) {
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
    
    center.y = (self.wapperView.height - self.keyboardBoundHeight) * 4/7;
    
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
        if ([self.textField isFirstResponder]) {
            CGPoint center = self.containerView.center;
            center.y = (self.wapperView.height - self.keyboardBoundHeight) * 4/7;
            self.containerView.center = center;
        }
    } completion:nil];
}
#endif

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if ([self.textField isFirstResponder]) {
        CGPoint center = self.containerView.center;
        center.y = (self.wapperView.height - self.keyboardBoundHeight) * 4/7;
        self.containerView.center = center;
    }
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (![self.textField isFirstResponder]) {
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
