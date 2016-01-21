//
//  TKAlertViewAction.h
//
//
//  Created by binluo on 15/6/12.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TKAlert&TKActionSheet/TKAlertConst.h>

@interface TKAlertViewAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title type:(TKAlertViewButtonType)type handler:(void (^)(NSUInteger index))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) TKAlertViewButtonType type;
@property (nonatomic, readonly, copy) void (^handler)(NSUInteger index);
@property (nonatomic, getter=isEnabled, assign) BOOL enabled;

@end
