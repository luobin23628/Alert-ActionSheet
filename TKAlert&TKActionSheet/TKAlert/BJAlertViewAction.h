//
//  BJAlertViewAction.h
//  BJEducation_student
//
//  Created by binluo on 15/6/12.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BJAlertViewButtonType) {
    BJAlertViewButtonTypeDefault = 0,
    BJAlertViewButtonTypeCancel,
    BJAlertViewButtonTypeDestructive
};


@interface BJAlertViewAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title type:(BJAlertViewButtonType)type handler:(void (^)(BJAlertViewAction *action))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) BJAlertViewButtonType type;
@property (nonatomic, readonly, copy) void (^handler)(BJAlertViewAction *action);
@property (nonatomic, getter=isEnabled, assign) BOOL enabled;

@end
