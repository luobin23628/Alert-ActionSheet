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

// Called when click button.
- (void)actionSheet:(TKActionSheetController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentActionSheet:(TKActionSheetController *)actionSheet; // before animation and showing view
- (void)didPresentActionSheet:(TKActionSheetController *)actionSheet;  // after animation

- (void)actionSheet:(TKActionSheetController *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)actionSheet:(TKActionSheetController *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end


@interface TKActionSheetController : UIViewController {

}

@property (nonatomic, readonly, strong) UIView *customView;

@property (nonatomic, readwrite) BOOL dismissWhenTapWindow;
@property (nonatomic, assign)    BOOL dragable;

- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler;

@property (nonatomic, readwrite) BOOL vignetteBackground;
@property (nonatomic, weak) id<TKActionSheetControllerDelegate>delegate;
@property (nonatomic, readonly) NSInteger cancelButtonIndex;

- (void)setTitleColor:(UIColor *)color forButton:(TKActionSheetButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(TKActionSheetButtonType)type;

- (instancetype)initWithTitle:(NSString *)title;
+ (instancetype)sheetWithTitle:(NSString *)title;

- (instancetype)initWithCustomView:(UIView *)customView;
+ (instancetype)sheetWithCustomView:(UIView *)customView;

- (instancetype)initWithViewController:(UIViewController *)viewController;
+ (instancetype)sheetWithViewController:(UIViewController *)viewController;

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index)) handler;
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index)) handler;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index)) handler;

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSUInteger)index block:(void (^)(NSUInteger index)) handler;
- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)(NSUInteger index)) handler;

- (void)showInViewController:(UIViewController *)parentController animated: (BOOL)flag completion:(void (^)(void))completion;


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSUInteger)buttonCount;

@end


@interface TKActionSheetController(Deprecated)

- (void)setCancelButtonWithTitle:(NSString *)title handler:(void (^)()) handler __attribute__((deprecated("use setCancelButtonWithTitle:block: instead.")));
- (void)setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)()) handler __attribute__((deprecated("use setDestructiveButtonWithTitle:block: instead.")));
- (void)addButtonWithTitle:(NSString *)title handler:(void (^)()) handler __attribute__((deprecated("use addButtonWithTitle:block: instead.")));

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)()) handler __attribute__((deprecated("use setDestructiveButtonWithTitle:atIndex:block: instead.")));
- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)()) handler __attribute__((deprecated("use addButtonWithTitle:atIndex:block: instead.")));

@end


