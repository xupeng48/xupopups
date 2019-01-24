//
//  QTAlertAction.h
//  QTAlertView_Example
//
//  Created by peng xu on 2019/1/15.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 添加按钮的样式
typedef NS_ENUM(NSInteger, QTAlertActionStyle) {
    QTAlertActionStyleRecommend,             // 颜色渐变, 白字
    QTAlertActionStyleNotRecommend,          // 白色背景, 红色边框, 红字
    QTAlertActionStyleCustom,                // 自定义 Default font: 16.0 height: 20.0 backgroundColor: white
};

// 添加按钮的布局方式
typedef NS_ENUM(NSInteger, QTAlertActionLayout) {
    QTAlertActionLayoutFull,                 // 占据全部可用空间
    QTAlertActionLayoutHalfWidth,            // 宽度 0.5 高度 1.0
    QTAlertActionLayoutCustomHeight,         // 宽度 1.0 高度 Custom
};

extern const CGFloat DEFAULT_CONTAINER_WIDTH;
extern const CGFloat DEFAULT_BUTTON_HEIGHT;
extern const CGFloat SHORT_BUTTON_HEIGHT;
extern const CGFloat DEFAULT_PADDING_TOP;
extern const CGFloat DEFAULT_LEFTRIGHT_PADDING ;
extern const CGFloat DEFAULT_HEADERIMAGE_HEIGHT;

@interface QTAlertAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) QTAlertActionStyle style;
@property (nonatomic, assign) QTAlertActionLayout layout;

@property (nonatomic, copy) void(^configBlock)(UIButton *);
@property (nonatomic, copy) void(^clickBlock)(void);

@property (nonatomic, weak) UIButton *attachButton;     // 关联按钮

/**
 QTAlertActionLayoutFull
 */
+ (instancetype)actionFullWithTitle:(NSString * _Nullable)title style:(QTAlertActionStyle)style;

/**
 QTAlertActionLayoutFull && click
 */
+ (instancetype)actionFullWithTitle:(NSString * _Nullable)title style:(QTAlertActionStyle)style onClick:(nullable void(^)(void))onClick;

/**
 QTAlertActionLayoutFull
 */
+ (instancetype)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(QTAlertActionStyle)style;

/**
 QTAlertActionLayoutHalfWidth && click
 */
+ (instancetype)actionHalfWidthWithTitle:(NSString * _Nullable)title style:(QTAlertActionStyle)style onClick:(nullable void(^)(void))onClick;


/**
 自定义按钮样式: QTAlertActionStyleCustom && QTAlertActionLayoutCustomHeight
 
 @note: Default font: 16.0 height: 20.0 backgroundColor: white
 */
+ (instancetype)actionCustomWithTitle:(NSString * _Nullable)title config:(nonnull void(^)(UIButton * __nonnull))config;

/**
 button style
 */
- (UIButton *)buildButton;

@end

