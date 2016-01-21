//
//  TKAlertConst.h
//  Pods
//
//  Created by binluo on 16/1/21.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TKAlertViewButtonType) {
    TKAlertViewButtonTypeDefault = 0,
    TKAlertViewButtonTypeCancel,
    TKAlertViewButtonTypeDestructive
};


//Will support more animation in future
typedef NS_ENUM(NSInteger, TKAlertViewAnimation) {
    TKAlertViewAnimationBounce,    //default
    TKAlertViewAnimationFromTop,
    TKAlertViewAnimationFromBottom,
    TKAlertViewAnimationFade,
    TKAlertViewAnimationDropDown,
    TKAlertViewAnimationPathStyle,   //模仿path效果
} ;
