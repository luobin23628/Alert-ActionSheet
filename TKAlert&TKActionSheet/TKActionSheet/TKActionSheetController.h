//
//  TKActionSheetController.h
//
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TKActionSheetButtonType) {
    TKActionSheetButtonTypeDefault = 0,
    TKActionSheetButtonTypeCancel,
    TKActionSheetButtonTypeDestructive
};


@class TKActionSheetController;
@protocol TKActionSheetControllerDelegate <NSObject>

- (void)actionSheet:(TKActionSheetController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface TKActionSheetController : UIViewController {

}

@property (nonatomic, readonly, strong) UIView *customView;

@property (nonatomic, readwrite) BOOL dismissWhenTapWindow;
@property (nonatomic, assign)    BOOL dragable;

- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler;

@property (nonatomic, readwrite) BOOL vignetteBackground;
@property (nonatomic, assign) id<TKActionSheetControllerDelegate>delegate;
@property (nonatomic, readonly) NSInteger cancelButtonIndex;

- (void)setTitleColor:(UIColor *)color forButton:(TKActionSheetButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(TKActionSheetButtonType)type;

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)sheetWithTitle:(NSString *)title;

- (instancetype)initWithCustomView:(UIView *)customView;
+ (instancetype)sheetWithCustomView:(UIView *)customView;

- (instancetype)initWithViewController:(UIViewController *)viewController;
+ (instancetype)sheetWithViewController:(UIViewController *)viewController;

- (void)setCancelButtonWithTitle:(NSString *)title handler:(void (^)()) handler;
- (void)setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)()) handler;
- (void)addButtonWithTitle:(NSString *)title handler:(void (^)()) handler;

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)()) handler;
- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)()) handler;

- (void)showInViewController:(UIViewController *)parentController animated: (BOOL)flag completion:(void (^)(void))completion;


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSUInteger)buttonCount;

@end


