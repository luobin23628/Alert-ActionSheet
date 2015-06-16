//
//  BJAlertOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "BJFullScreenWindow.h"

extern const UIWindowLevel BJWindowLevelAlertView;

@interface BJAlertOverlayWindow : BJFullScreenWindow

+ (BJAlertOverlayWindow *)defaultWindow;

@end
