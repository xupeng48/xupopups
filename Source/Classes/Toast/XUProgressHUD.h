//
//  XUProgressHUD.h
//  XURadio
//
//  Created by Leo on 2017/8/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XUProgressHUDMode){
    XUProgressHUDModelImage,    /**< 成功图 + 文字 */
    XUProgressHUDModelSpinner,  /**< 小菊花 + 文字 */
    XUProgressHUDModelPureText, /**< 纯文字 */
};

/** 小菊花和提示文字 */
@interface XUProgressHUD : UIView

+ (instancetype)showAddedToView:(UIView *)view;

+ (instancetype)showAddedToView:(UIView *)view mode:(XUProgressHUDMode)mode;

/** 因为是上层是全局的HUD，之后应该去掉这个接口 */
- (void)showInView:(UIView *)view mode:(XUProgressHUDMode)mode;

- (void)hide;

- (void)hideAnimated:(BOOL)aniamted;

- (void)hideAnimated:(BOOL)aniamted delay:(CGFloat)delay;

- (void)hideAnimated:(BOOL)aniamted delay:(CGFloat)delay completion:(void(^)(void))completion;

@property (strong, nonatomic) NSString * displayText;
@property (strong, nonatomic) UIImage * displayImage;
@property (assign,nonatomic) XUProgressHUDMode mode;

@property (strong, nonatomic, readonly) UIView * backgroundView;
@property (strong, nonatomic, readonly) UIView * centerBackgroundView;

@property (copy, nonatomic) void(^didHiddenBlock)(void);
@property (assign, nonatomic) CGFloat yOffset;
@property (assign, nonatomic) CGFloat xOffset;

@property (assign, nonatomic) CGFloat minDuration; /**< 最少显示的时间间隔 */

@end

