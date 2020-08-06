//
//  XUHUDManager.h
//  XURadio
//
//  Created by yangtingzhang on 15/3/27.
//  Copyright (c) 2015年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XU_HUDMAG                              XUHUDManager

// HUDView show priority POTENTIAL
typedef NS_ENUM(NSInteger, XUHUDType) {
    XUHUDWithDefault                        = 0x1000000,
    XUHUDWithUnknow                         = 0x10000000,
};

@interface XUHUDManager : NSObject

/** Display the specified message until hide manually */
+ (void)displayMessage:(NSString *)message;

/** Display the message for the duration */
+ (void)displayMessage:(NSString *)message duration:(CGFloat)duration;

/** Display an indicate view with specified message */
+ (void)displayIndicateWithMessage:(NSString *)message;

/** Display an indicate view with specified message for the duration */
+ (void)displayIndicateWithMessage:(NSString *)message duration:(CGFloat)duration;

+ (void)hideHUDView;            // 带动画，异步

+ (void)hideDirectlyHUDView;    // 同步，立即执行

/** 显示对号图片和文字 */
+ (void)displaySuccessMessage:(NSString *)message duration:(CGFloat)duration;

@end
