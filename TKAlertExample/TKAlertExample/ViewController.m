//
//  ViewController.m
//  TKAlertExample
//
//  Created by binluo on 15/6/16.
//  Copyright (c) 2015年 binluo. All rights reserved.
//

#import "ViewController.h"
#import "TKActionSheetController.h"
#import "TKAlertViewController.h"
#import "TKTextFieldAlertViewController.h"
#import "TKAlertManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"system alert" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 30, 120, 30);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"custom alert" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 30, 120, 30);
    [btn addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"TextFieldAlertView" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 60, 120, 30);
    [btn addTarget:self action:@selector(testTextFieldAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"system actionSheet" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 150, 140, 30);
    [btn addTarget:self action:@selector(test3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"custom actionSheet" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 150, 140, 30);
    [btn addTarget:self action:@selector(test4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"cancel all alerts" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 200, 120, 30);
    [btn addTarget:self action:@selector(cancelAllAlerts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}


- (void)test {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test1" message:@"系统alertview" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"a",@"a",@"a", @"a",@"a",@"a", nil];
    [alert show];
    //     alert = [[AlertView alloc] initWithTitle:@"test2" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    //    alert.tag = 2;
    //    [alert show];
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    NSLog(@"%@ bounds == %@", alertView, NSStringFromCGRect(alertView.bounds));
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)test2 {
    TKAlertViewController *alert2 = [TKAlertViewController alertWithTitle:@"test" message:@"自定义AlertView和ActionSheet. cocoapads 使用 pod 'TKAlert&TKActionSheet', '~>1.0.1'"];
    
    [alert2 addButtonWithTitle:@"ok" handler:^{
        [self testTextFieldAlertView];
    }];
    [alert2 addButtonWithTitle:@"cancel" handler:nil];
    [alert2 showWithAnimationType:TKAlertViewAnimationPathStyle];
    alert2.dismissWhenTapWindow = YES;
    
//    [self performSelector:@selector(cancelAllAlerts) withObject:nil afterDelay:5];
}

- (void)testTextFieldAlertView {
    TKTextFieldAlertViewController *textFieldAlertView = [[TKTextFieldAlertViewController alloc] initWithTitle:@"TextFieldAlertView" placeholder:@"defaultText"];
    [textFieldAlertView addButtonWithTitle:@"确定" handler:^{
        
    }];
    [textFieldAlertView addButtonWithTitle:@"取消" handler:^{
        
    }];
    [textFieldAlertView show];
}

- (void)test3 {
    UIActionSheet *uActionSheet = [[UIActionSheet alloc] initWithTitle:@"test" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructive" otherButtonTitles:@"test", nil];
    [uActionSheet showInView:self.view];
}

- (void)test4 {
    TKActionSheetController *uActionSheet = [TKActionSheetController sheetWithTitle:@"自定义AlertView和ActionSheet. cocoapads 使用 pod 'TKAlert&TKActionSheet', '~>1.0.1'"];
    [uActionSheet addButtonWithTitle:@"test" handler:nil];
    [uActionSheet setCancelButtonWithTitle:@"取消" handler:nil];
    [uActionSheet showInViewController:self animated:YES completion:nil];
}

- (void)cancelAllAlerts {
    [TKAlertManager cancelAllAlertsAnimated:YES];
}


@end
