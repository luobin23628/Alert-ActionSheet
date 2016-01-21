//
//  TKActionSheetController.m
//  
//
//  Created by luobin on 15-5-14.
//  Copyright (c) 2015年 luobin. All rights reserved.
//

#import "TKActionSheetController.h"
#import "TKActionSheetOverlayWindow.h"
#import "TKActionSheetManager.h"
#import "UIWindow+Alert.h"
#import "UIScreen+Size.h"
#import "UIViewAdditions.h"
#import "UIImageExtend.h"
#import "UIDeviceAdditions.h"

// Action Sheet constants

#define kActionSheetBorder         0
#define kActionSheetButtonHeight   50
#define kActionSheetTopMargin      0
#define kActionSheetCancelButtonTopMargin      8

#define kActionSheetBackgroundColor [UIColor colorWithRed:213/255.0 green:213/255.0 blue:221/255.0 alpha:1]

#define kActionSheetTitleFont           [UIFont systemFontOfSize:16]
#define kActionSheetTitleTextColor      [UIColor colorWithWhite:113/255.0 alpha:1]

#define kActionSheetButtonFont          [UIFont systemFontOfSize:18]
#define kActionSheetButtonTextColor     [UIColor blackColor]
#define kActionSheetCancelButtonTextColor     [UIColor blackColor]
#define kActionSheetDestructiveButtonTextColor    [UIColor colorWithRed:229/255.0 green:71/255.0 blue:68/255.0 alpha:1]

#define kActionSheetButtonColor [UIColor colorWithWhite:244/255.0 alpha:1]
#define kActionSheetHighlightButtonColor [UIColor colorWithWhite:223/255.0 alpha:1]

#define kActionSheetBackgroundCapHeight     30

@interface TKActionSheetAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title type:(TKActionSheetButtonType)type handler:(void (^)(NSUInteger index))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) TKActionSheetButtonType type;
@property (nonatomic, getter=isEnabled, assign) BOOL enabled;

@end

@interface TKActionSheetAction()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) TKActionSheetButtonType type;
@property (nonatomic, copy) void (^handler)(NSUInteger index);

@end

@implementation TKActionSheetAction

+ (instancetype)actionWithTitle:(NSString *)title type:(TKActionSheetButtonType)type handler:(void (^)(NSUInteger index))handler {
    TKActionSheetAction *action = [[TKActionSheetAction alloc] init];
    action.title = title;
    action.type = type;
    action.handler = handler;
    return action;
}

@end

@interface _TKActionSheetLine : UIView

@end

@implementation _TKActionSheetLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        [self addSubview:topLine];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, frame.size.width, 0.5)];
        bottomLine.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1];
        [self addSubview:bottomLine];

    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = 1;
    [super setFrame:frame];
}

@end


@interface TKActionSheetController()<UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, strong) UIView *customView;
@property (nonatomic, strong) UIView *warpperView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) TKActionSheetOverlayWindow *backgroundWindow;
@property (nonatomic, strong) NSMutableDictionary *titleColorDic;
@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, copy)  void (^dismissWhenTapWindowHandler)() ;

@end

@implementation TKActionSheetController

static UIFont *titleFont = nil;
static UIFont *buttonFont = nil;

#pragma mark - init

+ (void)initialize {
    if (self == [TKActionSheetController class]){
        titleFont = kActionSheetTitleFont;
        buttonFont = kActionSheetButtonFont;
    }
}

- (instancetype)init {
    return [self initWithTitle:nil];
}

+ (instancetype)sheetWithTitle:(NSString *)title {
    return [[TKActionSheetController alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title {
    
    UILabel *labelView = nil;
    if (title) {
        CGRect frame = [[UIScreen mainScreen] fixedBounds];
        CGSize size = CGSizeZero;
        
        if ([[UIDevice currentDevice] isIOS7]) {
            size = [title boundingRectWithSize:CGSizeMake(frame.size.width-kActionSheetBorder*2, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil] context:nil].size;
        } else {
            size = [title sizeWithFont:titleFont
                     constrainedToSize:CGSizeMake(frame.size.width-kActionSheetBorder*2, 1000)
                         lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        CGFloat height = size.height + 20;
        if (height < kActionSheetButtonHeight) {
            height = kActionSheetButtonHeight;
        }
        
        labelView = [[UILabel alloc] initWithFrame:CGRectMake(kActionSheetBorder, kActionSheetTopMargin, frame.size.width - kActionSheetBorder*2, height)];
        labelView.font = titleFont;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.textColor = kActionSheetTitleTextColor;
        labelView.backgroundColor = kActionSheetButtonColor;
        labelView.textAlignment = NSTextAlignmentCenter;
        labelView.text = title;
    }
    
    self = [self initWithCustomView:labelView];
    if (self) {
        self.title = title;
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView {
    if ((self = [super init])) {
        
        self.titleColorDic = [[NSMutableDictionary alloc] init];
        [self setTitleColor:kActionSheetCancelButtonTextColor forButton:TKActionSheetButtonTypeCancel];
        [self setTitleColor:kActionSheetButtonTextColor forButton:TKActionSheetButtonTypeDefault];
        [self setTitleColor:kActionSheetDestructiveButtonTextColor forButton:TKActionSheetButtonTypeDestructive];
        
        self.actions = [[NSMutableArray alloc] init];
        self.height = kActionSheetTopMargin;
        
        self.customView = customView;
        self.customView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.vignetteBackground = NO;
        self.dismissWhenTapWindow = YES;
    }
    return self;
}

+ (instancetype)sheetWithCustomView:(UIView *)customView {
    return [[TKActionSheetController alloc] initWithCustomView:customView];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [self initWithCustomView:viewController.view];
    if (self) {
        [self addChildViewController:viewController];
    }
    return self;
}

+ (instancetype)sheetWithViewController:(UIViewController *)viewController {
    return [[TKActionSheetController alloc] initWithViewController:viewController];
}

- (void) dealloc {
    [self dismissWithClickedButtonIndex:-1 animated:NO];
}

- (void)viewDidLoad {
    CGRect frame = self.backgroundWindow.bounds;
    self.view.frame = frame;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //ios7或以下，旋转屏幕会给self.view做transform，导致frame和bounds不一致，因此增加warpperView
    self.warpperView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.warpperView.backgroundColor = [UIColor clearColor];
    self.warpperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.warpperView];
    
    frame.origin.y = frame.size.height - 44;
    frame.size.height = 44;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(kActionSheetBorder, 0, self.warpperView.width - kActionSheetBorder, 0)];
    self.containerView.backgroundColor = kActionSheetBackgroundColor;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.containerView.clipsToBounds = YES;
    [self.warpperView addSubview:self.containerView];
    
    [self.containerView addSubview:self.customView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    topLine.backgroundColor = [UIColor colorWithWhite:180/255.0 alpha:1];
    [self.containerView addSubview:topLine];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWindow:)];
    self.tapGestureRecognizer.delegate = self;
    [self.backgroundWindow addGestureRecognizer:self.tapGestureRecognizer];
}

- (NSUInteger)buttonCount {
    return self.actions.count;
}

- (void)setTitleColor:(UIColor *)color forButton:(TKActionSheetButtonType)type UI_APPEARANCE_SELECTOR {
    [self.titleColorDic setObject:color forKey:@(type)];
}

- (UIColor *)titleColorForButton:(TKActionSheetButtonType)type {
    return [self.titleColorDic objectForKey:@(type)];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self setDestructiveButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)setCancelButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self setCancelButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    } ];
}

- (void)addButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self addButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)())handler {
    [self setDestructiveButtonWithTitle:title atIndex:index block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index handler:(void (^)())handler {
    [self addButtonWithTitle:title atIndex:index block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}


- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKActionSheetButtonTypeDestructive handler:handler atIndex:-1];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKActionSheetButtonTypeCancel handler:handler atIndex:-1];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKActionSheetButtonTypeDefault handler:handler atIndex:-1];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title atIndex:(NSUInteger)index block:(void (^)(NSUInteger NSUInteger))handler {
    [self addButtonWithTitle:title type:TKActionSheetButtonTypeDestructive handler:handler atIndex:index];
}

- (void)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKActionSheetButtonTypeDefault handler:handler atIndex:index];
}


- (void)showInViewController:(UIViewController *)parentController animated: (BOOL)flag completion:(void (^)(void))completion {
    
    if (self.backgroundWindow) {
        return;
    }
    
    NSParameterAssert([self.actions count] || self.customView || self.title);
    
    self.backgroundWindow = [[TKActionSheetOverlayWindow alloc] init];
    self.backgroundWindow.frame = [[UIScreen mainScreen] bounds];
    self.backgroundWindow.backgroundView.vignetteBackground = _vignetteBackground;
    [self.backgroundWindow makeKeyAndVisible];
    self.backgroundWindow.rootViewController = self;
    self.backgroundWindow.frame = [[UIScreen mainScreen] bounds];
    
    [TKActionSheetManager addToStack:self];
    
    [self updateFrameForDisplay];
    
    __block CGPoint center = self.containerView.center;
    center.y = self.warpperView.height + self.height/2;
    self.containerView.center = center;
    
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    
    if (flag) {
        self.backgroundWindow.backgroundView.alpha = 0.f;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.backgroundWindow.backgroundView.alpha = 1.0f;
                             center.y -= self.height;
                             self.containerView.center = center;
                         } completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                             
                             if ([self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
                                 [self.delegate didPresentActionSheet:self];
                             }
                         }];
    } else {
        self.backgroundWindow.backgroundView.alpha = 1.0f;
        center.y -= self.height;
        self.containerView.center = center;
        
        if (completion) {
            completion();
        }
        
        if ([self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [self.delegate didPresentActionSheet:self];
        }
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self dismissWithClickedButtonIndex:buttonIndex animated:animated completion:nil];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion {
    
    if (!self.backgroundWindow) {
        return;
    }
    
    if (buttonIndex >= 0 && buttonIndex < [self.actions count]) {
        TKActionSheetAction *action = [self.actions objectAtIndex: buttonIndex];
        if (action.handler)
        {
            ((void (^)())action.handler)(buttonIndex);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    
    [self.backgroundWindow removeGestureRecognizer:self.tapGestureRecognizer];
    
    if (animated) {
        CGPoint center = self.containerView.center;
        center.y += self.containerView.height;
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.containerView.center = center;
                             [self.backgroundWindow reduceAlphaIfEmpty];
                         } completion:^(BOOL finished) {
                            
                             [self.backgroundWindow revertKeyWindowAndHidden];
                             self.backgroundWindow.rootViewController = nil;
                             self.view = nil;
                             [self removeFromParentViewController];
                             [TKActionSheetManager removeFromStack:self];
                             self.backgroundWindow =  nil;
                             
                             if (completion) {
                                 completion();
                             }
                             
                             if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
                                 [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
                             }
                         }];
    } else {
        [self.backgroundWindow revertKeyWindowAndHidden];
        self.backgroundWindow.rootViewController = nil;
        [self.view removeFromSuperview];
        self.view = nil;
        [self removeFromParentViewController];
        [TKActionSheetManager removeFromStack:self];

        self.backgroundWindow = nil;
        
        if (completion) {
            completion();
        }
        
        if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
        }
    }
}

- (NSInteger)cancelButtonIndex {
    TKActionSheetAction *lastAction = [self.actions lastObject];
    if (lastAction.type == TKActionSheetButtonTypeCancel) {
        return [self.actions count] - 1;
    }
    return -1;
}

- (void)setDismissWhenTapWindow:(BOOL)dismissWhenTapWindow {
    [self setDismissWhenTapWindow:dismissWhenTapWindow handler:nil];
}

- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler {
    self.dismissWhenTapWindowHandler = handler;
    _dismissWhenTapWindow = flag;
}

#pragma mark - Tap Gesture Recognizer

- (void)tapWindow:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.dismissWhenTapWindow) {
        [self dismissWithClickedButtonIndex:-1 animated:YES completion:^{
            if (self.dismissWhenTapWindowHandler) {
                self.dismissWhenTapWindowHandler();
            }
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isDescendantOfView:self.containerView];
}

#pragma mark - Private

- (void)addButtonWithTitle:(NSString *)title type:(TKActionSheetButtonType)type handler:(void (^)(NSUInteger index))handler atIndex:(NSInteger)index {
    TKActionSheetAction *action = [TKActionSheetAction actionWithTitle:title type:type handler:handler];
    TKActionSheetAction *lastAction = [self.actions lastObject];
    
    if (type == TKActionSheetButtonTypeCancel) {
        if (lastAction.type == TKActionSheetButtonTypeCancel) {
            [self.actions removeLastObject];
        }
        [self.actions addObject:action];
    } else {
        
        if (lastAction.type == TKActionSheetButtonTypeCancel) {
            [self.actions removeLastObject];
        }
        if (index  >= 0) {
            [self.actions insertObject:action
                               atIndex:index];
        } else {
            [self.actions addObject:action];
        }
        if (lastAction.type == TKActionSheetButtonTypeCancel) {
            [self.actions addObject:lastAction];
        }
    }
}

- (void)updateFrameForDisplay {
    self.height = kActionSheetTopMargin;
    
    CGFloat width = [[UIScreen mainScreen] fixedBounds].size.width - kActionSheetBorder*2;
    CGFloat height = self.customView.frame.size.height;
    self.customView.frame = CGRectMake(kActionSheetBorder, kActionSheetTopMargin, width, height);
    
    self.height += height;
    
    NSUInteger i = 1;
    for (TKActionSheetAction *action in self.actions) {
        if ((i == 1 && self.title) || (i != 1 && action.type != TKActionSheetButtonTypeCancel)) {
            CGRect frame = CGRectMake(kActionSheetBorder, self.height, width, 1);
            _TKActionSheetLine *line = [[_TKActionSheetLine alloc] initWithFrame:frame];
            self.height += 1;
            [self.containerView addSubview:line];
        }
        UIButton *button = [self buttonWithAction:action];
        CGRect frame = CGRectMake(kActionSheetBorder, self.height, width, kActionSheetButtonHeight);
        frame.size.height = kActionSheetButtonHeight;
        if (action.type == TKActionSheetButtonTypeCancel && [self.actions count] > 1) {
            frame.origin.y += kActionSheetCancelButtonTopMargin;
            self.height += kActionSheetCancelButtonTopMargin;
        }
        button.frame = frame;
        button.tag = i++;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:button];
        self.height += kActionSheetButtonHeight;
    }
    self.containerView.frame = CGRectMake((self.warpperView.width - width)/2, self.warpperView.height - self.height, width, self.height);
}


- (UIButton *)buttonWithAction:(TKActionSheetAction *)action {
    NSString *title = action.title;
    TKActionSheetButtonType type = action.type;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = buttonFont;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.backgroundColor = [UIColor clearColor];
    
    UIColor *textColor = nil;
    [button setBackgroundImage:[UIImage imageWithColor:kActionSheetButtonColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:kActionSheetHighlightButtonColor] forState:UIControlStateHighlighted];
    
    textColor = [self titleColorForButton:type];
    if (!textColor) {
        textColor = kActionSheetButtonTextColor;
    }
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.accessibilityLabel = title;
    return button;
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)sender {
    NSInteger buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
}

#pragma mark -  Autorotate

#if __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}
#endif

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIWindow *previousKeyWindow = self.backgroundWindow.previousKeyWindow;
    
    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIWindow *previousKeyWindow = self.backgroundWindow.previousKeyWindow;
    
    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIWindow *previousKeyWindow = self.backgroundWindow.previousKeyWindow;
    
    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *previousKeyWindow = self.backgroundWindow.previousKeyWindow;
    if (!previousKeyWindow) {
        previousKeyWindow = [UIApplication sharedApplication].windows[0];
    }
    return [[previousKeyWindow viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *previousKeyWindow = self.backgroundWindow.previousKeyWindow;
    if (!previousKeyWindow) {
        previousKeyWindow = [UIApplication sharedApplication].windows[0];
    }
    return [[previousKeyWindow viewControllerForStatusBarHidden] prefersStatusBarHidden];
}



@end
