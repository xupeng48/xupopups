//
//  XUAlertAction.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/15.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 添加按钮的样式
typedef NS_ENUM(NSInteger, XUAlertActionStyle) {
    XUAlertActionStyleRecommend,             // 颜色渐变, 白字
    XUAlertActionStyleNotRecommend,          // 白色背景, 红色边框, 红字
    XUAlertActionStyleSuperVip,              // 超级会员风格弹窗
    XUAlertActionStyleCustom,                // 自定义 Default font: 16.0 height: 20.0 backgroundColor: white
};

// 添加按钮的布局方式
typedef NS_ENUM(NSInteger, XUAlertActionLayout) {
    XUAlertActionLayoutFull,                 // 占据全部可用空间
    XUAlertActionLayoutHalfWidth,            // 宽度 0.5 高度 1.0
    XUAlertActionLayoutCustomHeight,         // 宽度 1.0 高度 Custom
};

extern const CGFloat DEFAULT_CONTAINER_WIDTH;
extern const CGFloat DEFAULT_BUTTON_HEIGHT;
extern const CGFloat SHORT_BUTTON_HEIGHT;
extern const CGFloat DEFAULT_PADDING_TOP;
extern const CGFloat DEFAULT_LEFTRIGHT_PADDING ;
extern const CGFloat DEFAULT_HEADERIMAGE_HEIGHT;

@interface XUAlertAction : NSObject

@property (nonatomic, copy) NSString * _Nullable title;

@property (nonatomic, assign) XUAlertActionStyle style;
@property (nonatomic, assign) XUAlertActionLayout layout;

@property (nonatomic, copy) void(^ _Nullable configBlock)(UIButton *_Nullable);
@property (nonatomic, copy) void(^ _Nullable clickBlock)(void);

@property (nonatomic, weak) UIButton * _Nullable attachButton;     // 关联按钮

@property (nonatomic, assign) BOOL shouldCloseAlert;

/**
 XUAlertActionLayoutFull
 */
+ (instancetype _Nullable)actionFullWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style;

/**
 XUAlertActionLayoutFull && click
 */
+ (instancetype _Nullable)actionFullWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style onClick:(nullable void(^)(void))onClick;

/**
 XUAlertActionLayoutFull
 */
+ (instancetype _Nullable)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style;

/**
 XUAlertActionLayoutHalfWidth && click
 */
+ (instancetype _Nullable)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style onClick:(nullable void(^)(void))onClick;


/**
 自定义按钮样式: XUAlertActionStyleCustom && XUAlertActionLayoutCustomHeight
 
 @note: Default font: 16.0 height: 20.0 backgroundColor: white
 */
+ (instancetype _Nullable)actionCustomWithTitle:(NSString * _Nullable)title config:(nonnull void(^)(UIButton * __nonnull))config;

/**
 button style
 */
- (UIButton * _Nullable)buildButton;

@end

