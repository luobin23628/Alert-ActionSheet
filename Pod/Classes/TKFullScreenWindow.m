//
//  TKOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKFullScreenWindow.h"
#import "TKFullScreenWindowBackground.h"

@interface TKFullScreenWindow()

@property (nonatomic, strong, readwrite) TKFullScreenWindowBackground *backgroundView;
@property (nonatomic, strong, readwrite) UIWindow *previousKeyWindow;

@end

@implementation TKFullScreenWindow

+(TKFullScreenWindow *)defaultWindow {
    static TKFullScreenWindow *backgroundWindow = nil;
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
        
        self.backgroundView = [[TKFullScreenWindowBackground alloc] initWithFrame:self.bounds];
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

- (void)makeKeyAndVisible {
    [super makeKeyAndVisible];
}

- (void)makeKeyWindow {
    if (!self.isKeyWindow) {
        self.alpha = 1.0f;
        self.backgroundView.alpha = 1;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        
        _previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    [super makeKeyWindow];
}

- (void)reduceAlphaIfEmpty {
    if (self.subviews.count == 1 || (self.subviews.count == 2 && [[self.subviews objectAtIndex:0] isKindOfClass:[TKFullScreenWindowBackground class]]))
    {
        self.backgroundView.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
}

- (void)revertKeyWindowAndHidden {
    self.hidden = YES;
    
    if (self.isKeyWindow) {
        [_previousKeyWindow makeKeyWindow];
    }
    _previousKeyWindow = nil;
}

@end
