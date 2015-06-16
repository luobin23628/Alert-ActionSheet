//
//  BJActionSheetController.h
//
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BJActionSheetButtonType) {
    BJActionSheetButtonTypeDefault = 0,
    BJActionSheetButtonTypeCancel,
    BJActionSheetButtonTypeDestructive
};


@class BJActionSheetController;
@protocol BJActionSheetControllerDelegate <NSObject>

- (void)actionSheet:(BJActionSheetController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


@interface BJActionSheetController : UIViewController {

}

@property (nonatomic, readonly, strong) UIView *customView;

@property (nonatomic, readwrite) BOOL dismissWhenTapWindow;
@property (nonatomic, assign)    BOOL dragable;

- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler;

@property (nonatomic, readwrite) BOOL vignetteBackground;
@property (nonatomic, assign) id<BJActionSheetControllerDelegate>delegate;
@property (nonatomic, readonly) NSInteger cancelButtonIndex;

- (void)setTitleColor:(UIColor *)color forButton:(BJActionSheetButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(BJActionSheetButtonType)type;

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


