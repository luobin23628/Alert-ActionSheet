//
//  BJOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "BJFullScreenWindow.h"
#import "BJFullScreenWindowBackground.h"

@interface BJFullScreenWindow()

@property (nonatomic, strong, readwrite) BJFullScreenWindowBackground *backgroundView;
@property (nonatomic, strong, readwrite) UIWindow *previousKeyWindow;

@end

@implementation BJFullScreenWindow

+(BJFullScreenWindow *)defaultWindow {
    static BJFullScreenWindow *backgroundWindow = nil;
    if (backgroundWindow == nil) {
        backgroundWindow = [[self alloc] init];
    }
    return backgroundWindow;
}

- (id)initWithFrame:(CGRect)frame {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake(0, 0, MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height))];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[BJFullScreenWindowBackground alloc] initWithFrame:self.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backgroundView];
    }
    return self;
}

- (void)dealloc {

}

- (id)init
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(0, 0, MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height))];
    return self;
}

- (void)addOverlayToMainWindow:(UIView *)overlay {
    if (self.hidden)
    {
        _previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
        self.alpha = 1.0f;
        self.backgroundView.alpha = 1;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        
        [self makeKeyWindow];
    }
//    [self addSubview:overlay];
}

- (void)reduceAlphaIfEmpty {
    if (self.subviews.count == 1 || (self.subviews.count == 2 && [[self.subviews objectAtIndex:0] isKindOfClass:[BJFullScreenWindowBackground class]]))
    {
        self.backgroundView.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
}

- (void)removeOverlay:(UIView *)overlay {
    [overlay removeFromSuperview];
    if (self.subviews.count == 0 || self.subviews.count == 1)
    {
        self.hidden = YES;
        [_previousKeyWindow makeKeyWindow];
        _previousKeyWindow = nil;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}

@end
