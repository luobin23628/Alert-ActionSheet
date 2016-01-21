//
//  UIDeviceAdditions.m
//  ActionSheetAndAlert
//
//  Created by luobin on 14-8-9.
//  Copyright (c) 2014年 luobin. All rights reserved.
//

#import "UIDeviceAdditions.h"

@implementation UIDevice(Additions)

- (NSInteger)majorVersion {
    static NSInteger result = -1;
    if (result == -1) {
        NSNumber *majorVersion = (NSNumber *)[[self.systemVersion componentsSeparatedByString:@"."] objectAtIndex:0];
        result = majorVersion.integerValue;
    }
    return result;
}

- (BOOL)isIOS7 {
    static NSInteger result = -1;
    if (result == -1) {
        result = [self majorVersion] >= 7;
    }
    return (BOOL)result;
}

@end
