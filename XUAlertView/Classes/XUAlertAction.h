//
//  XUAlertAction.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/15.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 添加按钮的样式
typedef NS_ENUM(NSInteger, XUAlertActionStyle) {
    XUAlertActionStyleRecommend,             // 颜色渐变, 白字
    XUAlertActionStyleNotRecommend,          // 白色背景, 红色边框, 红字
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
extern const CGFloat DEFAULT_LEFTRIGHT_PADDING;
extern const CGFloat DEFAULT_HEADERIMAGE_HEIGHT;

@interface XUAlertAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) XUAlertActionStyle style;
@property (nonatomic, assign) XUAlertActionLayout layout;

@property (nonatomic, copy) void(^configBlock)(UIButton *);
@property (nonatomic, copy) void(^clickBlock)(void);

@property (nonatomic, weak) UIButton *attachButton;     // 关联按钮

/**
 XUAlertActionLayoutFull
 */
+ (instancetype)actionFullWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style;

/**
 XUAlertActionLayoutFull && click
 */
+ (instancetype)actionFullWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style onClick:(nullable void(^)(void))onClick;

/**
 XUAlertActionLayoutFull
 */
+ (instancetype)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style;

/**
 XUAlertActionLayoutHalfWidth && click
 */
+ (instancetype)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(XUAlertActionStyle)style onClick:(nullable void(^)(void))onClick;


/**
 自定义按钮样式: XUAlertActionStyleCustom && XUAlertActionLayoutCustomHeight
 
 @note: Default font: 16.0 height: 20.0 backgroundColor: white
 */
+ (instancetype)actionCustomWithTitle:(NSString * _Nullable)title config:(nonnull void(^)(UIButton * __nonnull))config;

/**
 button style
 */
- (UIButton *)buildButton;

@end

