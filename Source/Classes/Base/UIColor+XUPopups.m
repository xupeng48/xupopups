//
//  UIColor+popups.m
//  popupsView_Example
//
//  Created by peng xu on 2019/1/16.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "UIColor+XUPopups.h"

@implementation UIColor (popups)

+ (UIColor *)popupsColorWithString:(NSString *)colorString {
    CGFloat alpha = 1.f;
    NSArray *_components = [colorString componentsSeparatedByString:@"^"];
    NSString *_c = colorString;
    if ([_components count] == 2) {
        _c = [_components objectAtIndex:0];
        NSString *_alphaString = [_components lastObject];
        if ([_alphaString rangeOfString:@"."].location == 0) {
            _alphaString = [@"0" stringByAppendingString:_alphaString];
        }
        alpha = [_alphaString floatValue];
    }
    if ([_c length] == 7) {
        _c = [_c substringFromIndex:1];
    }
    if ([_c length] != 6) {
        return [UIColor clearColor];
    }
    
    int r, g, b;
    sscanf(_c.UTF8String, "%02x%02x%02x", &r, &g, &b);
    return [UIColor colorWithRed:(double)r/255.f green:(double)g/255.f blue:(double)b/255.f alpha:alpha];
}


// UIDynamicColor
+ (UIColor *)PopupsBackgroundBaseColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor whiteColor];
            } else {
                return [UIColor popupsColorWithString:@"#313135"];
            }
        }];
    } else {
        return [UIColor whiteColor];
    }
}

+ (UIColor *)PopupsFontSubtitleColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor popupsColorWithString:@"#666666"];
            } else {
                return [UIColor popupsColorWithString:@"#C0C0C0"];
            }
        }];
    } else {
        return [UIColor popupsColorWithString:@"#666666"];
    }
}

+ (UIColor *)PopupsThemeColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor popupsColorWithString:@"#FF313A"];
            } else {
                return [UIColor popupsColorWithString:@"#FD5353"];
            }
        }];
    } else {
        return [UIColor popupsColorWithString:@"#FF313A"];
    }
}

+ (UIColor *)PopupsBackgroundShallowerColor {
     if (@available(iOS 13.0, *)) {
         return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
             if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                 return [UIColor popupsColorWithString:@"#EFEFEF"];
             } else {
                 return [UIColor popupsColorWithString:@"#45454A"];
             }
         }];
     } else {
         return [UIColor popupsColorWithString:@"#EFEFEF"];
     }
}

@end
