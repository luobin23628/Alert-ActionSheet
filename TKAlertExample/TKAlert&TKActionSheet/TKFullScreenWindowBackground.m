//
//  TKFullScreenWindowBackground.m
//  
//
//  Created by binluo on 15/5/26.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "TKFullScreenWindowBackground.h"

@implementation TKFullScreenWindowBackground

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (_backgroundImage || _vignetteBackground) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    if (_backgroundImage) {
        [_backgroundImage drawInRect:self.bounds];
    } else if (_vignetteBackground) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        size_t locationsCount = 2;
        CGFloat locations[2] = {0.0f, 1.0f};
        CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
        CGColorSpaceRelease(colorSpace);
        
        CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
        CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    
}

@end
