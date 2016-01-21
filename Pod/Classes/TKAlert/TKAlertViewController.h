//
//  TKAlertViewController.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <TKAlert&TKActionSheet/TKAlertConst.h>


void TKAlert1(NSString *title);
void TKAlert2(NSString *title, NSString *message);
void TKAlert3(NSString *title, NSString *message, NSString *buttonTitle);

@protocol TKAlertViewControllerDelegate;

@interface TKAlertViewController : UIViewController<UIAppearance>

@property (nonatomic, readonly, strong) UIView *customView;

//默认为毛玻璃效果, 优先使用backgroundView作为背景，其次为backgroundColor，都不设置默认为毛玻璃， 必须在show之前设置。
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backgroundView;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message textAlignment:(NSTextAlignment) alignment;

/*
 *  customView的宽度在90－290之间， 设置0为默认，默认为250。
 */
+ (instancetype)alertWithTitle:(NSString *)title customView:(UIView *)customView;
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView;

/**
 * 设置customeView间距， 默认为［15, 15, 15, 15］
 *
 */
@property (nonatomic, readwrite) UIEdgeInsets customeViewInset;


- (instancetype)initWithTitle:(NSString *)title viewController:(UIViewController *)viewController;
+ (instancetype)alertWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

+ (CGFloat)defaultWidthForCustomView;

@property (nonatomic, readwrite) BOOL dismissWhenTapWindow;
- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler;

- (void)setTitleColor:(UIColor *)color forButton:(TKAlertViewButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(TKAlertViewButtonType)type;


- (void)addDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler;
- (void)addCancelButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler;

- (void)show;
- (void)showWithAnimationType:(TKAlertViewAnimation)animationType;
- (void)showWithAnimationType:(TKAlertViewAnimation)animationType offset:(UIOffset)offset landscapeOffset:(UIOffset)landscapeOffset;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion;

@property (nonatomic, weak) id<TKAlertViewControllerDelegate>delegate;
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

@end

@interface TKAlertViewController(Deprecated)

- (void)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())handler __attribute__((deprecated("use addDestructiveButtonWithTitle:block: instead.")));
- (void)addCancelButtonWithTitle:(NSString *)title handler:(void (^)())handler __attribute__((deprecated("use addCancelButtonWithTitle:block: instead.")));
- (void)addButtonWithTitle:(NSString *)title handler:(void (^)())handler __attribute__((deprecated("use addButtonWithTitle:block: instead.")));

@end


@protocol TKAlertViewControllerDelegate <NSObject>

@optional
//点击按钮dismiss才会回调
- (BOOL)alertView:(TKAlertViewController *)alertView shouldDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)alertView:(TKAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(TKAlertViewController *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(TKAlertViewController *)alertView;  // after animation

- (void)alertView:(TKAlertViewController *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(TKAlertViewController *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

