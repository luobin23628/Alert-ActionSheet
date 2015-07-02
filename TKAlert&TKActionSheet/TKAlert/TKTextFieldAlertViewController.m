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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

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
    UITextField *textFiled = [[_TKTextFieldAlertView_TextFiled alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    textFiled.backgroundColor = [UIColor colorWithWhite:240.0/255 alpha:1];
    textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFiled.borderStyle = UITextBorderStyleNone;
    textFiled.layer.cornerRadius = 4.f;
    textFiled.layer.borderWidth = 0.5f;
    textFiled.layer.borderColor = [UIColor colorWithWhite:180.0/255 alpha:1].CGColor;
    textFiled.returnKeyType = UIReturnKeyDone;
    textFiled.keyboardType = UIKeyboardTypeDefault;
    textFiled.placeholder = placeholder;
    textFiled.font = [UIFont systemFontOfSize:14];
    textFiled.textAlignment = NSTextAlignmentLeft;;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textFiled addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField = textFiled;
    self = [super initWithTitle:title customView:textFiled];
    if (self) {
        // Initialization code
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

@end
