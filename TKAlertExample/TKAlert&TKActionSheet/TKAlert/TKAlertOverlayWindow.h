//
//  TKAlertOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKFullScreenWindow.h"

extern const UIWindowLevel TKWindowLevelAlertView;

@interface TKAlertOverlayWindow : TKFullScreenWindow

+ (TKAlertOverlayWindow *)defaultWindow;

@end
