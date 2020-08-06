//
//  UIColor+XUAlert.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XUAlert)

+ (UIColor *)popupsColorWithString:(NSString *)colorString;


// UIDynamicColor
+ (UIColor *)PopupsBackgroundBaseColor;
+ (UIColor *)PopupsFontSubtitleColor;
+ (UIColor *)PopupsThemeColor;
+ (UIColor *)PopupsBackgroundShallowerColor;

@end
