//
//  AMBlurView.m
//  blur
//
//  Created by Cesar Pinto Castillo on 7/1/13.
//  Copyright (c) 2013 Arctic Minds Inc. All rights reserved.
//

#import "TKBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+Invocation.h"

@interface TKBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation TKBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    [super setBackgroundColor:[UIColor clearColor]];
    
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blur];
            effectview.frame = self.bounds;
            [self addSubview:effectview];
    #endif
    } else
#endif
 
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        if (![self toolbar]) {
            [self setToolbar:[[UIToolbar alloc] initWithFrame:[self frame]]];
            [self.toolbar setTranslucent:YES];
            [self.toolbar setBarTintColor:nil];

            //            [self.layer insertSublayer:[self.toolbar layer] atIndex:0];

            NSString *layer = [NSString stringWithFormat:@"%c%c%c%c%c",
                                        'l', 'a', 'y', 'e', 'r'],
            *insertLayer = [NSString stringWithFormat:@"%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
                                  'i', 'n', 's', 'e', 'r', 't', 'S', 'u', 'b', 'l', 'a', 'y', 'e', 'r', ':', 'a', 't', 'I', 'n', 'd', 'e', 'x', ':'];
            SEL layerSelector = NSSelectorFromString(layer),
            addLayerSelector = NSSelectorFromString(insertLayer);
            
            // @see http://stackoverflow.com/a/8862061/456536
            id __autoreleasing container = nil, toolBarLayer = nil;
            unsigned index = 0;
            [self invokeWithSelector:layerSelector returnValue:&container];
            [self.toolbar invokeWithSelector:layerSelector returnValue:&toolBarLayer];
            [container invokeWithSelector:addLayerSelector arguments:&toolBarLayer, &index];
        }
    }
    else
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    }
}

- (void) setBlurTintColor:(UIColor *)blurTintColor {
    [self.toolbar setBarTintColor:blurTintColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0){
        [super setBackgroundColor:backgroundColor];
    } else if (self.toolbar) {
//        [self.toolbar setBarTintColor:backgroundColor];

    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolbar setFrame:[self bounds]];
}

@end
