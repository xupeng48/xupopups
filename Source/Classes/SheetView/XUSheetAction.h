//
//  XUSheetAction.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**< 添加按钮的样式 */
typedef NS_ENUM(NSInteger, XUSheetActionStyle) {
    XUSheetActionStyleDefault,               /**< 灰字 */
    XUSheetActionStyleRed,                   /**< 红字 */
};

extern const CGFloat SHEET_BUTTON_HEIGHT;
extern const CGFloat SHEETVIEW_FIXIPHONEX;

@interface XUSheetAction : NSObject

@property (nonatomic, copy) NSString * _Nullable title;
@property (nonatomic, assign) XUSheetActionStyle style;     /**< 添加按钮的样式 */

@property (nonatomic, copy) void(^ _Nullable clickBlock)(void);

@property (nonatomic, weak) UIButton * _Nullable attachButton;     // 关联按钮

/** XUSheetActionStyleDefault */
+ (instancetype _Nullable )actionWithTitle:(NSString * _Nullable)title;

/** XUSheetActionStyle */
+ (instancetype _Nullable)actionWithTitle:(NSString * _Nullable)title style:(XUSheetActionStyle)style;

/** XUSheetActionStyle && click */
+ (instancetype _Nullable)actionWithTitle:(NSString * _Nullable)title style:(XUSheetActionStyle)style onClick:(nullable void(^)(void))onClick;

/** button style */
- (UIButton *_Nullable)buildButton;

@end

