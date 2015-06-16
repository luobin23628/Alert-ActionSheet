//
//  TKAlertViewAction.h
//
//
//  Created by binluo on 15/6/12.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TKAlertViewButtonType) {
    TKAlertViewButtonTypeDefault = 0,
    TKAlertViewButtonTypeCancel,
    TKAlertViewButtonTypeDestructive
};


@interface TKAlertViewAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title type:(TKAlertViewButtonType)type handler:(void (^)(TKAlertViewAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) TKAlertViewButtonType type;
@property (nonatomic, readonly, copy) void (^handler)(TKAlertViewAction *action);
@property (nonatomic, getter=isEnabled, assign) BOOL enabled;

@end
