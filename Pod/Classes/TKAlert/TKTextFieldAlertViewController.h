//
//  TKTextFieldAlertViewController.h
//  
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import <TKAlert&TKActionSheet/TKFirstResponseAlertViewController.h>

@class TKTextFieldAlertViewController;
@protocol TKTextFieldAlertViewDelegate <TKAlertViewControllerDelegate>

@optional
// Called after edits in any of the field
- (BOOL)alertView:(TKTextFieldAlertViewController *)alertView shouldEnableButtonForIndex:(NSUInteger)buttonIndex;

@end

@interface TKTextFieldAlertViewController : TKFirstResponseAlertViewController

@property (nonatomic, readonly, strong) UITextField *textField;
@property (nonatomic, assign) id<TKTextFieldAlertViewDelegate>delegate;

- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
