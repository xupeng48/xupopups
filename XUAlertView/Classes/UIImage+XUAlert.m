//
//  UIImage+XUAlert.m
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "UIImage+XUAlert.h"
#import "UIColor+XUAlert.h"

@implementation UIImage (XUAlert)

+ (UIImage *)XUAlertImageWithColor:(UIColor *)color {
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

+ (UIImage *)XUAlertImageWithString:(NSString *)string {
    return [self XUAlertImageWithColor:[UIColor XUAlertColorWithString:string]];
}

@end
