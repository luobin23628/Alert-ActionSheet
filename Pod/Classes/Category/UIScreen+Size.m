//
//  UIScreen+Size.m
//  
//
//  Created by binluo on 15/5/26.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "UIScreen+Size.h"

@implementation UIScreen (Size)

- (CGRect)fixedBounds {
    CGRect bounds = [self bounds];
    CGFloat width = MIN(bounds.size.width, bounds.size.height);
    CGFloat height = MAX(bounds.size.width, bounds.size.height);
    bounds.size.width = width;
    bounds.size.height = height;
    return bounds;
}

- (CGRect)flexibleBounds {
    CGRect bounds = [self bounds];
    CGFloat width = MIN(bounds.size.width, bounds.size.height);
    CGFloat height = MAX(bounds.size.width, bounds.size.height);
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        bounds.size.width = height;
        bounds.size.height = width;
    } else {
        bounds.size.width = width;
        bounds.size.height = height;
    }
    return bounds;
}

@end
