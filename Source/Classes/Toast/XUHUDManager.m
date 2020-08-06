//
//  XUHUDManager.m
//  XURadio
//
//  Created by yangtingzhang on 15/3/27.
//  Copyright (c) 2015年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "XUHUDManager.h"
#import "XUProgressHUD.h"

@implementation XUHUDManager

XUProgressHUD *SharedHUD(){
    static XUProgressHUD * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [XUProgressHUD showAddedToView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelSpinner];
        _instance.minDuration = 0.8;
        [_instance removeFromSuperview];
    });
    return _instance;
}

void dispatch_toMain(dispatch_block_t block) {
    if ([[NSThread currentThread] isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}


+ (void)displayMessage:(NSString *)message {
    dispatch_toMain(^{
        SharedHUD().displayText = message;
        [SharedHUD() showInView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelPureText];
    });
}

+ (void)displayMessage:(NSString *)message duration:(CGFloat)duration {
    dispatch_toMain(^{
        SharedHUD().displayText = message;
        [SharedHUD() showInView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelPureText];
        [SharedHUD() hideAnimated:YES delay:duration];
    });
}

+ (void)displayIndicateWithMessage:(NSString *)message {
    dispatch_toMain(^{
        SharedHUD().displayText = message;
        [SharedHUD() showInView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelSpinner];
    });
}

+ (void)displayIndicateWithMessage:(NSString *)message duration:(CGFloat)duration {
    dispatch_toMain(^{
        SharedHUD().displayText = message;
        [SharedHUD() showInView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelSpinner];
        [SharedHUD() hideAnimated:YES delay:duration];
    });
}


+ (void)hideHUDView {
    dispatch_toMain(^{
        [SharedHUD() hide];
    });
}

+ (void)hideDirectlyHUDView {
    dispatch_toMain(^{
        [SharedHUD() hideAnimated:NO];
    });
}

+ (void)displaySuccessMessage:(NSString *)message duration:(CGFloat)duration {
    dispatch_toMain(^{
        SharedHUD().displayText = message;
        SharedHUD().displayImage = [UIImage imageNamed:@"success_hud"];
        [SharedHUD() showInView:[UIApplication sharedApplication].keyWindow mode:XUProgressHUDModelImage];
        [SharedHUD() hideAnimated:YES delay:duration];
    });
}

@end
