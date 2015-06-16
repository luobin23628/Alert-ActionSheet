//
//  BJAlertViewController.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BJAlertViewAction.h"
//#import <MZAppearance/MZAppearance.h>

//Will support more animation in future
typedef enum {
    BJAlertViewAnimationPop,    //default
    BJAlertViewAnimationBack,
    BJAlertViewAnimationPath NS_ENUM_AVAILABLE_IOS(7_0),
} TKAlertViewAnimation;

@protocol BJAlertViewControllerDelegate;

@interface BJAlertViewController : UIViewController

@property (nonatomic, readonly, strong) UIView *customView;
@property (nonatomic, readonly, assign) UIInterfaceOrientation orientation;

//默认为毛玻璃效果, 优先使用backgroundView作为背景，其次为backgroundColor，都不设置默认为毛玻璃， 必须在show之前设置。
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIView *backgroundView;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message textAlignment:(NSTextAlignment) alignment;

+ (instancetype)alertWithTitle:(NSString *)title customView:(UIView *)customView;
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView;

- (instancetype)initWithTitle:(NSString *)title viewController:(UIViewController *)viewController;
+ (instancetype)alertWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

+ (CGFloat)widthForCustomView;

@property (nonatomic, readwrite) BOOL dismissWhenTapWindow;
- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler;

@property (nonatomic, readwrite) BOOL dismissBySwipe;

- (void)setTitleColor:(UIColor *)color forButton:(BJAlertViewButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(BJAlertViewButtonType)type;


- (void)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())handler;
- (void)addCancelButtonWithTitle:(NSString *)title handler:(void (^)())handler;
- (void)addButtonWithTitle:(NSString *)title handler:(void (^)())handler;

- (void)show;
- (void)showWithAnimationType:(TKAlertViewAnimation)animationType;
- (void)showWithAnimationType:(TKAlertViewAnimation)animationType offset:(UIOffset)offset landscapeOffset:(UIOffset)landscapeOffset;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion;

@property (nonatomic, assign) id<BJAlertViewControllerDelegate>delegate;
@property (nonatomic, readwrite, getter=isVisible) BOOL visible;

@end


@protocol BJAlertViewControllerDelegate <NSObject>

@optional
- (void)alertView:(BJAlertViewController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentAlertView:(BJAlertViewController *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(BJAlertViewController *)alertView;  // after animation

- (void)alertView:(BJAlertViewController *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(BJAlertViewController *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

