//
//  QTAlertAction.m
//  QTAlertView_Example
//
//  Created by peng xu on 2019/1/15.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "QTAlertAction.h"
#import "UIColor+QTAlert.h"
#import "UIImage+QTAlert.h"

const CGFloat DEFAULT_CONTAINER_WIDTH = 280.0;
const CGFloat DEFAULT_BUTTON_HEIGHT = 40.0;
const CGFloat SHORT_BUTTON_HEIGHT = 20.0;
const CGFloat DEFAULT_PADDING_TOP = 16.0;
const CGFloat DEFAULT_LEFTRIGHT_PADDING = 16.0;
const CGFloat DEFAULT_HEADERIMAGE_HEIGHT = 120.0;

@implementation QTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(QTAlertActionStyle)style
                         layout:(QTAlertActionLayout)layout
                         config:(void(^)(UIButton *))config
                        onClick:(void(^)(void))onClick {
    QTAlertAction *action = [[QTAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.configBlock = config;
    action.clickBlock = onClick;
    action.layout = layout;
    return action;
}

+ (instancetype)actionFullWithTitle:(NSString *)title style:(QTAlertActionStyle)style {
    return [self actionFullWithTitle:title style:style onClick:nil];
}

+ (instancetype)actionFullWithTitle:(NSString *)title style:(QTAlertActionStyle)style onClick:(void(^)(void))onClick {
    return [self actionWithTitle:title style:style layout:QTAlertActionLayoutFull config:nil onClick:onClick];
}

+ (instancetype)actionHalfWidthWithTitle:(NSString *)title style:(QTAlertActionStyle)style {
    return [self actionHalfWidthWithTitle:title style:style onClick:nil];
}

+ (instancetype)actionHalfWidthWithTitle:(NSString *)title style:(QTAlertActionStyle)style onClick:(void(^)(void))onClick {
    return [self actionWithTitle:title style:style layout:QTAlertActionLayoutHalfWidth config:nil onClick:onClick];
}

+ (instancetype)actionCustomWithTitle:(NSString *)title config:(void (^)(UIButton *))config {
    return [self actionWithTitle:title style:QTAlertActionStyleCustom layout:QTAlertActionLayoutCustomHeight config:config onClick:nil];
}

- (UIButton *)buildButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:self.title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    switch (self.style) {
        case QTAlertActionStyleRecommend:
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            {
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.cornerRadius = DEFAULT_BUTTON_HEIGHT / 2;
                gradientLayer.masksToBounds = YES;
                gradientLayer.startPoint = CGPointMake(0, 1);
                gradientLayer.endPoint = CGPointMake(1, 1);
                gradientLayer.colors = @[(__bridge id)[UIColor qtAlertColorWithString:@"#FF8A8A"].CGColor,(__bridge id)[UIColor qtAlertColorWithString:@"#FD5353"].CGColor];
                [button.layer insertSublayer:gradientLayer atIndex:0];
            }
            break;
        case QTAlertActionStyleNotRecommend:
            [button setTitleColor:[UIColor qtAlertColorWithString:@"#FD5353"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            {
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.cornerRadius = DEFAULT_BUTTON_HEIGHT / 2;
                gradientLayer.masksToBounds = YES;
                gradientLayer.borderColor = [UIColor qtAlertColorWithString:@"#FD5353"].CGColor;
                gradientLayer.borderWidth = 0.7;
                [button.layer insertSublayer:gradientLayer atIndex:0];
            }
            break;
        case QTAlertActionStyleCustom:
            [button setTitleColor:[UIColor qtAlertColorWithString:@"#999999"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage qtAlertImageWithColor:[UIColor clearColor]] forState:UIControlStateHighlighted];
            break;
    }
    return button;
}

@end
