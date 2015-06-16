//
//  BJOverlayWindow.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BJFullScreenWindowBackground.h"

@interface BJFullScreenWindow : UIWindow


+ (BJFullScreenWindow *)defaultWindow;


- (void)addOverlayToMainWindow:(UIView *)overlay;
- (void)reduceAlphaIfEmpty;
- (void)removeOverlay:(UIView *)overlay;

@property (nonatomic, strong, readonly) BJFullScreenWindowBackground *backgroundView;
@property (nonatomic, readonly) UIWindow *previousKeyWindow;

@end
