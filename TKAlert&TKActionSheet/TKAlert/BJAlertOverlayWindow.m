//
//  BJAlertOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "BJAlertOverlayWindow.h"

const UIWindowLevel BJWindowLevelAlertView = 1996;

@implementation BJAlertOverlayWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = BJWindowLevelAlertView;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (id)init {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:CGRectMake(0, 0, MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height))];
    if (self) {
        self.windowLevel = BJWindowLevelAlertView;
    }
    return self;
}

+(BJAlertOverlayWindow *)defaultWindow {
    static BJAlertOverlayWindow *backgroundWindow = nil;
    if (backgroundWindow == nil) {
        backgroundWindow = [[BJAlertOverlayWindow alloc] init];
    }
    return backgroundWindow;
}

@end
