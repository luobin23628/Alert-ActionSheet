//
//  BJTextFieldAlertViewController.h
//  
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import "BJAlertViewController.h"

@class BJTextFieldAlertViewController;
@protocol BJTextFieldAlertViewDelegate <BJAlertViewControllerDelegate>

@optional
// Called after edits in any of the field
- (BOOL)alertView:(BJTextFieldAlertViewController *)alertView shouldEnableButtonForIndex:(NSUInteger)buttonIndex;

@end

@interface BJTextFieldAlertViewController : BJAlertViewController

@property (nonatomic, readonly, retain) UITextField *textField;
@property (nonatomic, assign) id<BJTextFieldAlertViewDelegate>delegate;

- (id)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
