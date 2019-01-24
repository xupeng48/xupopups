//
//  UIImage+QTAlert.m
//  QTAlertView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "UIImage+QTAlert.h"
#import "UIColor+QTAlert.h"

@implementation UIImage (QTAlert)

+ (UIImage *)qtAlertImageWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(1, 1);
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)qtAlertImageWithString:(NSString *)string {
    return [self qtAlertImageWithColor:[UIColor qtAlertColorWithString:string]];
}

@end
