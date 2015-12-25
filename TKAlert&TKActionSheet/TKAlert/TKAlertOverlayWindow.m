//
//  TKAlertOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKAlertOverlayWindow.h"

const UIWindowLevel TKWindowLevelAlertView = 2000;

@implementation TKAlertOverlayWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = TKWindowLevelAlertView;
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
        self.windowLevel = TKWindowLevelAlertView;
    }
    return self;
}

+(TKAlertOverlayWindow *)defaultWindow {
    static TKAlertOverlayWindow *backgroundWindow = nil;
    if (backgroundWindow == nil) {
        backgroundWindow = [[TKAlertOverlayWindow alloc] init];
    }
    return backgroundWindow;
}

@end
