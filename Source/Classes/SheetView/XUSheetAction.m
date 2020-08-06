//
//  XUSheetAction.m
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "XUSheetAction.h"
#import "UIImage+XUPopups.h"
#import "UIColor+XUPopups.h"

const CGFloat SHEET_BUTTON_HEIGHT = 50.0;
const CGFloat SHEETVIEW_FIXIPHONEX = 34.0;

@implementation XUSheetAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(XUSheetActionStyle)style
                        onClick:(void(^)(void))onClick {
    XUSheetAction *action = [[XUSheetAction alloc] init];
    action.title = title;
    action.style = style;
    action.clickBlock = onClick;
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title {
    return [self actionWithTitle:title style:XUSheetActionStyleDefault];
}

+ (instancetype)actionWithTitle:(NSString *)title style:(XUSheetActionStyle)style {
    return [self actionWithTitle:title style:style onClick:nil];
}

- (UIButton *)buildButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:self.title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.backgroundColor = [UIColor PopupsBackgroundBaseColor];
    switch (self.style) {
        case XUSheetActionStyleDefault:
            [button setTitleColor:[UIColor PopupsFontSubtitleColor] forState:UIControlStateNormal];
            break;
        case XUSheetActionStyleRed:
            [button setTitleColor:[UIColor PopupsThemeColor] forState:UIControlStateNormal];
            break;
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 0.5)];
    lineView.backgroundColor = [UIColor PopupsBackgroundShallowerColor];
    [button addSubview:lineView];
    return button;
}

@end
