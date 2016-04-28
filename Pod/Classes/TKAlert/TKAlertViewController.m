//
//  TKAlertViewController.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKAlertViewController.h"
#import "TKAlertViewController+Private.h"
#import "TKAlertOverlayWindow.h"
#import "TKAlertManager.h"
#import "TKBlurView.h"
#import "UIImageExtend.h"
#import "UIWindow+Alert.h"
#import "UIScreen+Size.h"
#import "UIDeviceAdditions.h"
#import "TKAlertViewAction.h"

void TKAlert1(NSString *title) {
    TKAlert2(title, nil);
}

void TKAlert2(NSString *title, NSString *message) {
    TKAlert3(title, message, nil);
}

void TKAlert3(NSString *title, NSString *message, NSString *buttonTitle) {
    TKAlertViewController *alert = [[TKAlertViewController alloc] initWithTitle:title message:message];
    [alert addButtonWithTitle:buttonTitle?:@"确定" block:nil];
    [alert show];
}

@interface TKAlertView : UIView

@property (nonatomic, strong) NSMutableDictionary *titleColorDic;

- (void)setTitleColor:(UIColor *)color forButton:(TKAlertViewButtonType)type UI_APPEARANCE_SELECTOR;
- (UIColor *)titleColorForButton:(TKAlertViewButtonType)type;

@end

@implementation TKAlertView

- (void)setTitleColor:(UIColor *)color forButton:(TKAlertViewButtonType)type {
    [self.titleColorDic setObject:color forKey:@(type)];
}

- (UIColor *)titleColorForButton:(TKAlertViewButtonType)type {
    return [self.titleColorDic objectForKey:@(type)]?:kAlertViewButtonTextColor;
}

@end


typedef void (^FinishedCallback)(BOOL finished);

@implementation TKAlertViewController

static UIFont *titleFont = nil;
static UIFont *messageFont = nil;
static UIFont *buttonFont = nil;

#pragma mark - init

+ (void)initialize {
    if (self == [TKAlertViewController class]) {
        titleFont = kAlertViewTitleFont;
        messageFont = kAlertViewMessageFont;
        buttonFont = kAlertViewButtonFont;
    }
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[TKAlertViewController alloc] initWithTitle:title message:message];
}

+ (instancetype)alertWithTitle:(NSString *)title customView:(UIView *)customView {
    return [[TKAlertViewController alloc] initWithTitle:title customView:customView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    return [self initWithTitle:nil customView:nil];
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    
    return [self initWithTitle:title message:message textAlignment:NSTextAlignmentCenter];
}
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message textAlignment:(NSTextAlignment) alignment
{
    UIView *customView = nil;
    if (message) {
        customView = [[UIView alloc] init];        
        
        CGSize size = CGSizeZero;
        size.height = MAXFLOAT;
        if ([[UIDevice currentDevice] isIOS7]) {
            size = [message boundingRectWithSize:CGSizeMake([self.class defaultWidthForCustomView], NSIntegerMax) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:messageFont,NSFontAttributeName, nil] context:nil].size;
        } else {
            size = [message sizeWithFont:messageFont
                       constrainedToSize:CGSizeMake([self.class defaultWidthForCustomView], NSIntegerMax)
                           lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        UILabel *messageView = [[UILabel alloc] initWithFrame:CGRectMake(([self.class defaultWidthForCustomView] - size.width)/2, 0, size.width,  size.height)];
        messageView.font = messageFont;
        messageView.numberOfLines = 0;
        messageView.lineBreakMode = NSLineBreakByWordWrapping;
        messageView.textColor = kAlertViewMessageTextColor;
        messageView.backgroundColor = [UIColor clearColor];
        messageView.textAlignment = alignment;
        messageView.text = message;
        [customView addSubview:messageView];
        customView.frame = CGRectMake(0, 0, [self.class defaultWidthForCustomView], size.height);
    }
    
    if ((self = [self initWithTitle:title customView:customView])) {
    }
    return self;

}
- (instancetype)initWithTitle:(NSString *)title customView:(UIView *)customView {
    if ((self = [super init])) {
        
        self.titleColorDic = [[NSMutableDictionary alloc] init];
        
        self.windowBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.actions = [NSMutableArray array];
        self.title = title;
        self.customView = customView;
        self.customView.autoresizingMask = UIViewAutoresizingNone;
        self.animationType = TKAlertViewAnimationBounce;
        self.enabledParallaxEffect = YES;
        self.customeViewInset = UIEdgeInsetsMake(kAlertViewBorder, kAlertViewBorder, kAlertViewBorder, kAlertViewBorder);
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    self = [self initWithTitle:title customView:viewController.view];
    if (self) {
        [self addChildViewController:viewController];
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    return [[TKAlertViewController alloc] initWithTitle:title viewController:viewController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    
    self.scrollView = nil;
    self.titleView = nil;
    self.customView = nil;
    self.actions = nil;
    self.backgroundView = nil;
}

+ (CGFloat)defaultWidthForCustomView {
    return kAlertViewDefaultWidth - 2*kAlertViewBorder;
}

- (void)loadView {
    self.view = [[TKAlertView alloc] init];
}

- (void)viewDidLoad {
    self.view.frame = [[UIScreen mainScreen] flexibleBounds];
    self.view.backgroundColor = [UIColor clearColor];
    
    //ios7或以下，旋转屏幕会给self.view做transform，导致frame和bounds不一致，因此增加warpperView
    self.wapperView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.wapperView.backgroundColor = [UIColor clearColor];
    self.wapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.wapperView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(([TKAlertOverlayWindow defaultWindow].bounds.size.width - kAlertViewDefaultWidth)/2, 0, kAlertViewDefaultWidth, kAlertViewMinHeigh)];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    self.containerView.layer.cornerRadius = 6.f;
    self.containerView.clipsToBounds = YES;
    [self.wapperView addSubview:self.containerView];
    
    UIWindow *parentView = [TKAlertOverlayWindow defaultWindow];
    CGRect frame = parentView.bounds;
    frame.origin.x = floorf((frame.size.width - kAlertViewDefaultWidth) * 0.5);
    frame.size.width = kAlertViewDefaultWidth;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView = scrollView;
    [self.containerView addSubview:self.scrollView];
    
    if (self.title) {
        CGSize size = [self.title sizeWithFont:titleFont
                        constrainedToSize:CGSizeMake(frame.size.width-kAlertViewBorder*2, 1000)
                            lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, 0, frame.size.width-kAlertViewBorder*2, size.height)];
        titleView.font = titleFont;
        titleView.numberOfLines = 0;
        titleView.lineBreakMode = NSLineBreakByWordWrapping;
        titleView.textColor = kAlertViewTitleTextColor;
        titleView.backgroundColor = [UIColor clearColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = self.title;
        self.titleView = titleView;
        [self.scrollView addSubview:titleView];
    }
    
    self.customView.autoresizingMask = UIViewAutoresizingNone;
    [self.scrollView addSubview:self.customView];
    
    UIView *buttonContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    buttonContainerView.userInteractionEnabled = YES;
    buttonContainerView.backgroundColor = [UIColor clearColor];
    self.buttonContainerView = buttonContainerView;
    [self.containerView addSubview:buttonContainerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.backgroundView.frame = self.containerView.bounds;
    [self.containerView sendSubviewToBack:self.backgroundView];
}

#pragma mark - Public

- (void)setTitleColor:(UIColor *)color forButton:(TKAlertViewButtonType)type {
    [self.titleColorDic setObject:color forKey:@(type)];
}

- (UIColor *)titleColorForButton:(TKAlertViewButtonType)type {
    UIColor *color = [self.titleColorDic objectForKey:@(type)];
    if (!color) {
        color = [[self.class appearance] titleColorForButton:type];
    }
    if (!color) {
        if (type == TKAlertViewButtonTypeDestructive) {
            color = [UIColor redColor];
        } else {
            color = kAlertViewButtonTextColor;
        }
    }
    return color;
}

- (void)addButtonWithTitle:(NSString *)title type:(TKAlertViewButtonType)type handler:(void (^)(NSUInteger index))handler atIndex:(NSInteger)index {
    TKAlertViewAction *action = [TKAlertViewAction actionWithTitle:title type:type handler:handler];
    [self.actions addObject:action];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self addDestructiveButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)addCancelButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self addCancelButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)addButtonWithTitle:(NSString *)title handler:(void (^)())handler {
    [self addButtonWithTitle:title block:^(NSUInteger index) {
        if (handler) {
            handler();
        }
    }];
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKAlertViewButtonTypeDefault handler:handler atIndex:-1];
}

- (void)addCancelButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKAlertViewButtonTypeCancel handler:handler atIndex:-1];
}

- (void)addDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSUInteger index))handler {
    [self addButtonWithTitle:title type:TKAlertViewButtonTypeDestructive handler:handler atIndex:-1];
}

- (void)setDismissWhenTapWindow:(BOOL)dismissWhenTapWindow {
    [self setDismissWhenTapWindow:dismissWhenTapWindow handler:nil];
}

- (void)setDismissWhenTapWindow:(BOOL)flag handler:(void (^)()) handler {
    self.dismissWhenTapWindowHandler = handler;
    _dismissWhenTapWindow = flag;
}

- (void)show {
    [self showWithAnimationType:self.animationType];
}

- (void)showWithAnimationType:(TKAlertViewAnimation)animationType{
    [self showWithAnimationType:animationType offset:UIOffsetZero landscapeOffset:UIOffsetZero];
}

- (void)showWithAnimationType:(TKAlertViewAnimation)animationType offset:(UIOffset)offset landscapeOffset:(UIOffset)landscapeOffset {
    if (self.isVisible) {
        return;
    }
    self.animationType = animationType;
    self.offset = offset;
    self.landscapeOffset = landscapeOffset;
    
    TKAlertViewController * visibleAlert = TKAlertManager.visibleAlert;
    TKAlertViewController * topMostAlert = TKAlertManager.topMostAlert;
    if (visibleAlert && topMostAlert) {
        [TKAlertManager hideTopMostAlertAnimated:YES];
        [TKAlertManager addToStack:self dontDimBackground:YES];
        return;
    }
    
    [TKAlertManager addToStack:self dontDimBackground:YES];
    [self popupAlertAnimated:YES animationType:animationType atOffset:offset noteDelegate:YES];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated{
    [self dismissWithClickedButtonIndex:buttonIndex animated:animated completion:nil];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated completion:(void (^)(void))completion {
    [self dismissWithClickedButtonIndex:buttonIndex animated:animated completion:completion noteDelegate:NO];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = backgroundColor;
        
        if (_backgroundView.superview == self.view) {
            [self.containerView insertSubview:backgroundView aboveSubview:_backgroundView];
            [_backgroundView removeFromSuperview];
        }
        _backgroundView = backgroundView;
    }
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView != backgroundView) {
        if (_backgroundView.superview == self.view) {
            [self.containerView insertSubview:backgroundView aboveSubview:_backgroundView];
            [_backgroundView removeFromSuperview];
        }
        _backgroundView = backgroundView;
        _backgroundColor = nil;
    }
}

#pragma mark -  Autorotate

#if __IPHONE_8_0
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateFrameForDisplay];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}
#endif

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateFrameForDisplay];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIWindow *previousKeyWindow = [TKAlertOverlayWindow defaultWindow].previousKeyWindow;
    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIWindow *previousKeyWindow = [TKAlertOverlayWindow defaultWindow].previousKeyWindow;

    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIWindow *previousKeyWindow = [TKAlertOverlayWindow defaultWindow].previousKeyWindow;

    UIViewController *viewController = [previousKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *previousKeyWindow = [TKAlertOverlayWindow defaultWindow].previousKeyWindow;
    if (!previousKeyWindow) {
        previousKeyWindow = [UIApplication sharedApplication].windows[0];
    }
    return [[previousKeyWindow viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *previousKeyWindow = [TKAlertOverlayWindow defaultWindow].previousKeyWindow;
    if (!previousKeyWindow) {
        previousKeyWindow = [UIApplication sharedApplication].windows[0];
    }
    return [[previousKeyWindow viewControllerForStatusBarHidden] prefersStatusBarHidden];
}

#pragma mark - UIAppearance

+ (instancetype)appearance {
    return (id)[TKAlertView appearance];
}

+ (instancetype)appearanceWhenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION {
    return [self appearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait {
    return [self appearance];
}

+ (instancetype)appearanceForTraitCollection:(UITraitCollection *)trait whenContainedIn:(Class <UIAppearanceContainer>)ContainerClass, ... NS_REQUIRES_NIL_TERMINATION {
    return [self appearance];
}

@end
