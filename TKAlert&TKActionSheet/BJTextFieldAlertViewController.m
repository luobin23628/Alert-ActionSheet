//
//  BJTextFieldAlertViewController.m
//  
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import "BJTextFieldAlertViewController.h"
#import "BJAlertViewController+Private.h"
#import "BJAlertOverlayWindow.h"
#import "UIDeviceAdditions.h"

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

@interface BJTextFieldAlertViewController()

@property (nonatomic, readwrite, retain) UITextField *textField;

@end

@implementation BJTextFieldAlertViewController

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
            BOOL shouldEnable = [(id<BJTextFieldAlertViewDelegate>)self.delegate alertView:self shouldEnableButtonForIndex:i];
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
    
	CGPoint center = self.view.center;
    if (self.orientation == UIInterfaceOrientationPortrait) {
        center.y = [BJAlertOverlayWindow defaultWindow].bounds.size.height - (keyboardBounds.size.height + self.view.frame.size.height/2+ 5);
    } else if (self.orientation == UIDeviceOrientationPortraitUpsideDown) {
        center.y = (keyboardBounds.size.height + self.view.frame.size.height/2)+ 5;
    } else if (UIInterfaceOrientationLandscapeRight == self.orientation) {
        center.x = (keyboardBounds.size.width + self.view.frame.size.width/2)+ 5;
    } else if (UIInterfaceOrientationLandscapeLeft == self.orientation) {
        center.x = [BJAlertOverlayWindow defaultWindow].bounds.size.width - (keyboardBounds.size.width + self.view.frame.size.width/2 + 5);
    }
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
	
	// set views with new info
	self.view.center = center;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    if (![self.textField isFirstResponder]) {
        return;
    }
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect frame = self.view.frame;
    frame.origin.y = [BJAlertOverlayWindow defaultWindow].bounds.size.height - frame.size.height;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	self.view.frame = frame;
	
	// commit animations
	[UIView commitAnimations];
}

@end
