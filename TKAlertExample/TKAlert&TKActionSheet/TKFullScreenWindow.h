//
//  TKOverlayWindow.h
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKFullScreenWindowBackground.h"

@interface TKFullScreenWindow : UIWindow

+ (TKFullScreenWindow *)defaultWindow;

- (void)makeKeyAndVisible;
- (void)reduceAlphaIfEmpty;
- (void)revertKeyWindowAndHidden;

@property (nonatomic, strong, readonly) TKFullScreenWindowBackground *backgroundView;
@property (nonatomic, readonly) UIWindow *previousKeyWindow;

@end
