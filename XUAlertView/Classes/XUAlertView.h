//
//  XUAlertView.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/11.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUAlertAction.h"

/**
 蜻蜓风格的弹窗
 */
@interface XUAlertView : UIView

/**
 创建一个弹窗实例
 
 @param iconImage icon 图片
 @param headerImage header 图片
 @param title 标题
 @param message 文字描述
 @param customView 自定义View 自带距离顶部: 16.0 底部按钮: 20.0
 @return 弹窗实例
 */

+ (instancetype)alertWithIconImage:(UIImage * _Nullable)iconImage
                       headerImage:(UIImage * _Nullable)headerImage
                             title:(NSString * _Nullable)title
                           message:(NSString * _Nullable)message
                        customView:(UIView * _Nullable)customView;

/**
 添加动作，按钮会按照添加的顺序由高到低排列
 */
- (void)addAction:(XUAlertAction * _Nonnull)action;

/**
 添加右上角的圆形关闭按钮，并添加动作
 */
- (void)addCloseButtonWithAction:(nullable void(^)(void))action;

/**
 对标题和message进行额外的配置，比如修改字体，对齐方式
 
 @note: 修改frame无效
 */
- (void)addExtraConfig:(nonnull void(^)(UILabel * __nullable titleLabel, UILabel * __nullable messageLabel))config;


/**
 完全自定义 View
 */
+ (instancetype)alertWithCompleteCustomView:(UIView * _Nonnull)view;

/**
 展示
 */
- (void)display;
- (void)display:(nullable void(^)(void))completion;

/**
 隐藏
 */
- (void)hide;
- (void)hide:(nullable void(^)(void))completion;

// MAKR: - sugar

/**
 icon 底部单按钮 右上角关闭按钮 AlertView
 
 @param icon icon
 @param title 标题
 @param message 内容
 @param isShowClose  是否显示关闭按钮
 @param closeClick   关闭按钮点击事件
 @param confirmTitle 确认按钮标题
 @param confirmStyle 确认按钮风格
 @param confirmClick 确认按钮点击事件
 */
+ (void)showAlertWithIcon:(UIImage * _Nullable)icon title:(NSString * _Nullable)title message:(NSString * _Nullable)message showClose:(BOOL)isShowClose closeClick:(nullable void(^)(void))closeClick confirmTitle:(NSString * _Nullable)confirmTitle confirmStyle:(XUAlertActionStyle)confirmStyle confirmClick:(nullable void(^)(void))confirmClick;

/**
 底部单按钮 右上角关闭按钮 AlertView
 
 @param title 标题
 @param message 内容
 @param isShowClose  是否显示关闭按钮
 @param closeClick   关闭按钮点击事件
 @param confirmTitle 确认按钮标题
 @param confirmStyle 确认按钮风格
 @param confirmClick 确认按钮点击事件
 */
+ (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message showClose:(BOOL)isShowClose closeClick:(nullable void(^)(void))closeClick confirmTitle:(NSString * _Nullable)confirmTitle confirmStyle:(XUAlertActionStyle)confirmStyle confirmClick:(nullable void(^)(void))confirmClick;

/**
 底部单按钮 AlertView
 
 @param title 标题
 @param message 内容
 @param confirmTitle 确认按钮标题
 @param confirmStyle 确认按钮风格
 @param confirmClick 确认按钮点击事件
 */
+ (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message confirmTitle:(NSString * _Nullable)confirmTitle confirmStyle:(XUAlertActionStyle)confirmStyle confirmClick:(nullable void(^)(void))confirmClick;

/**
 底部双按钮 AlertView
 
 @param title 标题
 @param message 内容
 @param cancelTitle  取消按钮标题
 @param cancelClick  取消按钮点击事件
 @param confirmTitle 确认按钮标题
 @param confirmClick 确认按钮点击事件
 */
+ (void)showAlertWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message cancelTitle:(NSString * _Nullable)cancelTitle cancelClick:(nullable void(^)(void))cancelClick confirmTitle:(NSString * _Nullable)confirmTitle confirmClick:(nullable void(^)(void))confirmClick;


/**
 icon 底部双按钮 AlertView
 
 @param icon icon
 @param title 标题
 @param message 内容
 @param cancelTitle  取消按钮标题
 @param cancelClick  取消按钮点击事件
 @param confirmTitle 确认按钮标题
 @param confirmClick 确认按钮点击事件
 */
+ (void)showAlertWithIcon:(UIImage * _Nullable)icon title:(NSString * _Nullable)title message:(NSString * _Nullable)message cancelTitle:(NSString * _Nullable)cancelTitle cancelClick:(nullable void(^)(void))cancelClick confirmTitle:(NSString * _Nullable)confirmTitle confirmClick:(nullable void(^)(void))confirmClick;

@end
