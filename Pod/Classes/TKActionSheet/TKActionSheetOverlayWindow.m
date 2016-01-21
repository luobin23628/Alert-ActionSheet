//
//  TKActionSheetOverlayWindow.m
//  
//
//  Created by luobin on 13-3-16.
//  Copyright (c) 2013年 luobin. All rights reserved.
//

#import "TKActionSheetOverlayWindow.h"

const UIWindowLevel TKWindowLevelActionSheet = 2000;

@implementation TKActionSheetOverlayWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = TKWindowLevelActionSheet;
    }
    return self;
}

- (id)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = TKWindowLevelActionSheet;
    }
    return self;
}

@end
