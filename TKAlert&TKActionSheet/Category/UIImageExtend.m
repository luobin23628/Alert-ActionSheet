//
//  UIImageExtend.m
//  Utility
//
//  Created by test on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImageExtend.h"

#pragma mark -


#pragma mark - ImageGenerator
@implementation UIImage(ImageGenerator)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1., 1.)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aImage;
}

@end

@implementation UIImage(Resizable)

- (UIImage *)resizableImage {
    CGFloat x = (self.size.width - 1) / 2, y = (self.size.height - 1) / 2;
    
    if (![self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self stretchableImageWithLeftCapWidth:x topCapHeight:y];
    }
    
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y, x)];
}

@end
