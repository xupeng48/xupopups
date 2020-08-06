//
//  XUSheetView.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUSheetAction.h"

@interface XUSheetView : UIView

/** 创建一个Sheet实例 */
+ (instancetype _Nullable )sheetView;
+ (instancetype _Nullable )sheetViewWithCancel;

/** 添加动作，按钮会按照添加的顺序由高到低排列 */
- (void)addAction:(XUSheetAction * _Nonnull)action;

/** 展示 */
- (void)display;
- (void)display:(nullable void(^)(void))completion;

/** 隐藏 */
- (void)hide;
- (void)hide:(nullable void(^)(void))completion;

/** 添加右上角的圆形关闭按钮，并添加动作 */
- (void)addMaskViewAction:(nullable void(^)(void))action;

/** 一个取消和一个自定义的SheetView */
+ (void)showSheetViewWithTitle:(NSString * _Nullable)title style:(XUSheetActionStyle)style onClick:(nullable void(^)(void))onClick;

@end
