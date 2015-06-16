//
//  BJAlertViewAction.m
//  BJEducation_student
//
//  Created by binluo on 15/6/12.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "BJAlertViewAction.h"


@interface BJAlertViewAction()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) BJAlertViewButtonType type;
@property (nonatomic, copy) void (^handler)(BJAlertViewAction *action);

@end

@implementation BJAlertViewAction

+ (instancetype)actionWithTitle:(NSString *)title type:(BJAlertViewButtonType)type handler:(void (^)(BJAlertViewAction *))handler {
    BJAlertViewAction *action = [[BJAlertViewAction alloc] init];
    action.title = title;
    action.type = type;
    action.handler = handler;
    return action;
}

@end
