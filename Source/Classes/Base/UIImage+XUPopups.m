//
//  UIImage+popups.m
//  popupsView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "UIImage+XUPopups.h"
#import "UIColor+XUPopups.h"

@implementation UIImage (popups)

+ (UIImage *)popupsImageWithColor:(UIColor *)color {
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

+ (UIImage *)popupsImageWithString:(NSString *)string {
    return [self popupsImageWithColor:[UIColor popupsColorWithString:string]];
}

@end
