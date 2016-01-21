//
//  TKAlertViewAction.m
//
//
//  Created by binluo on 15/6/12.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "TKAlertViewAction.h"


@interface TKAlertViewAction()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) TKAlertViewButtonType type;
@property (nonatomic, copy) void (^handler)(NSUInteger index);

@end

@implementation TKAlertViewAction

+ (instancetype)actionWithTitle:(NSString *)title type:(TKAlertViewButtonType)type handler:(void (^)(NSUInteger index))handler {
    TKAlertViewAction *action = [[TKAlertViewAction alloc] init];
    action.title = title;
    action.type = type;
    action.handler = handler;
    return action;
}

@end
