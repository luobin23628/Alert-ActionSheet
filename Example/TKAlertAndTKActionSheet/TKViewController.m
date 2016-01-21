//
//  TKViewController.m
//  TKAlertAndTKActionSheet
//
//  Created by luobin on 01/21/2016.
//  Copyright (c) 2016 luobin. All rights reserved.
//

#import "TKViewController.h"
#import <TKAlert&TKActionSheet/TKAlert&TKActionSheet.h>

@interface TKViewController ()

@end

@implementation TKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"system alert" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 30, 120, 30);
    [btn addTarget:self action:@selector(testSystemAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"custom alert" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 30, 120, 30);
    [btn addTarget:self action:@selector(testCustomAlert) forControlEvents:UIControlEventTouchUpInside];
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
    [btn addTarget:self action:@selector(testSystemActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"custom actionSheet" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 150, 140, 30);
    [btn addTarget:self action:@selector(testCustomActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"cancel all alerts" forState:UIControlStateNormal];
    btn.frame = CGRectMake(160, 200, 120, 30);
    [btn addTarget:self action:@selector(cancelAllAlerts) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


- (void)testSystemAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test1" message:@"系统alertview" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"a",@"a",@"a", @"a",@"a",@"a", nil];
    [alert show];
    //     alert = [[AlertView alloc] initWithTitle:@"test2" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    //    alert.tag = 2;
    //    [alert show];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)testCustomAlert {
    TKAlertViewController *alert = [TKAlertViewController alertWithTitle:@"test" message:@"自定义AlertView和ActionSheet. cocoapads 使用 pod 'TKAlert&TKActionSheet', '~>1.0.1'"];
    //    alert.customeViewInset = UIEdgeInsetsMake(100, 0, 100, 0);
    [alert addButtonWithTitle:@"ok" block:^(NSUInteger index) {
        [self testTextFieldAlertView];
    }];
    
    [alert addButtonWithTitle:@"cancel" block:nil];
    alert.dismissWhenTapWindow = YES;
    [alert showWithAnimationType:TKAlertViewAnimationPathStyle];
//    alert.delegate = self;
    //    [self performSelector:@selector(cancelAllAlerts) withObject:nil afterDelay:5];
}

- (void)testTextFieldAlertView {
    TKTextFieldAlertViewController *textFieldAlertView = [[TKTextFieldAlertViewController alloc] initWithTitle:@"TextFieldAlertView" placeholder:@"defaultText"];
    [textFieldAlertView addButtonWithTitle:@"确定"  block:^(NSUInteger index) {
        
    }];
    [textFieldAlertView addButtonWithTitle:@"取消" block:^(NSUInteger index) {
        
    }];
    [textFieldAlertView show];
}

- (void)testSystemActionSheet {
    UIActionSheet *uActionSheet = [[UIActionSheet alloc] initWithTitle:@"test" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"destructive" otherButtonTitles:@"test", nil];
    [uActionSheet showInView:self.view];
}

- (void)testCustomActionSheet {
    TKActionSheetController *uActionSheet = [TKActionSheetController sheetWithTitle:@"自定义AlertView和ActionSheet. cocoapads 使用 pod 'TKAlert&TKActionSheet', '~>1.0.1'"];
    [uActionSheet addButtonWithTitle:@"test" block:^(NSUInteger index) {
        NSLog(@"test");
    }];
    [uActionSheet setCancelButtonWithTitle:@"取消" block:^(NSUInteger index) {
        NSLog(@"cancel");
    }];
    [uActionSheet showInViewController:self animated:YES completion:nil];
}

- (void)cancelAllAlerts {
    [TKAlertManager cancelAllAlertsAnimated:YES];
}

@end
