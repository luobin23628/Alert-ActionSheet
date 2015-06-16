//
//  UIImageExtend.h
//  Utility
//
//  Created by test on 10-11-18.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(ImageGenerator)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@interface UIImage(Resizable)

- (UIImage *)resizableImage;
@end
