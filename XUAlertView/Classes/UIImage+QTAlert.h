//
//  UIImage+QTAlert.h
//  QTAlertView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QTAlert)

+ (UIImage *)qtAlertImageWithColor:(UIColor *)color;
+ (UIImage *)qtAlertImageWithString:(NSString *)string;

@end
