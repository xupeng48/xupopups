//
//  XUSheetView.m
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "XUSheetView.h"
#import "XUSheetDisplayManager.h"
#import "UIColor+XUPopups.h"

#define SHEETVIEW_ANIMATE_DURATION  0.3f

@interface XUSheetView ()

// Data
@property (nonatomic, strong) NSMutableArray<XUSheetAction *> * actions;

// Views
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIView * backgroundView;

// Gesture
@property (nonatomic, strong) UIPanGestureRecognizer * pan;

@property (nonatomic, copy) void(^maskViewBlock)(void);

@end

@implementation XUSheetView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }
    }
    return self;
}

- (instancetype)initWithAction:(XUSheetAction *)action {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self addAction:action];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }
    }
    return self;
}

+ (instancetype)sheetView {
    return [[XUSheetView alloc] init];
}

+ (instancetype)sheetViewWithCancel {
    return [[XUSheetView alloc] initWithAction:[XUSheetAction actionWithTitle:@"取消"]];
}

// MARK: - UI
- (void)buildSubViews {
    // BackgroundView
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _backgroundView.alpha = 0.0;
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backgroundView];
    
    [self addSubview:self.containerView];
    
    [self.actions enumerateObjectsUsingBlock:^(XUSheetAction *action, NSUInteger idx, BOOL *stop) {
        UIButton *button = [action buildButton];
        [button setTitle:action.title forState:UIControlStateNormal];
        button.tag = idx;
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        action.attachButton = button;
        [self->_containerView addSubview:button];
    }];
    
    // Gesture
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_containerView addGestureRecognizer:_pan];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (NSInteger i = 0; i < self.actions.count; i ++) {
        XUSheetAction * currentAction = [self.actions objectAtIndex:i];
        [currentAction.attachButton setFrame:CGRectMake(0, SHEET_BUTTON_HEIGHT * (self.actions.count - i - 1), self.bounds.size.width, SHEET_BUTTON_HEIGHT)];
        for (CALayer *layer in currentAction.attachButton.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer setFrame:currentAction.attachButton.bounds];
            }
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    _containerView.backgroundColor = [UIColor PopupsBackgroundBaseColor];
    for (NSInteger i = 0; i < self.actions.count; i ++) {
        XUSheetAction * currentAction = [self.actions objectAtIndex:i];
        [currentAction.attachButton setFrame:CGRectMake(0, SHEET_BUTTON_HEIGHT * (self.actions.count - i - 1), self.bounds.size.width, SHEET_BUTTON_HEIGHT)];
        for (CALayer *layer in currentAction.attachButton.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer setFrame:currentAction.attachButton.bounds];
            }
        }
    }
}

- (void)didChangeStatusBarOrientation {
    self.frame = [UIScreen mainScreen].bounds;
    [self displayAdaptation];
}

// MARK: - external action
- (void)display {
    [self display:nil];
}

- (void)display:(void (^)(void))completion {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window == nil) {
        NSLog(@"window should not be nil!!!");
        return;
    }
    if ([XUSheetDisplayManager sharedInstance].inDisplay) {
        [[XUSheetDisplayManager sharedInstance].sheetViewArray addObject:self];
        return;
    }
    [XUSheetDisplayManager sharedInstance].inDisplay = YES;
    NSAssert([[NSThread currentThread] isMainThread], @"You must call this function on main thread");
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self buildSubViews];
    [window addSubview:self];
    [self becomeFirstResponder];
    [UIView animateWithDuration:SHEETVIEW_ANIMATE_DURATION
                     animations:^{
                         self.backgroundView.alpha = 1.0;
                         [self displayAdaptation];
                         [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapped)]];
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)displayAdaptation {
    CGFloat fixBottom;
    if (@available(iOS 11.0, *)) {
        fixBottom = self.safeAreaInsets.bottom;
    } else {
        fixBottom = 0;
    }
    self.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.actions.count * SHEET_BUTTON_HEIGHT - fixBottom, [UIScreen mainScreen].bounds.size.width, self.actions.count * SHEET_BUTTON_HEIGHT + fixBottom);
    [self setTopCornerRadius];
}

- (void)hide {
    [self hide:nil];
}

- (void)hide:(void (^)(void))completion {
    [UIView animateWithDuration:SHEETVIEW_ANIMATE_DURATION
                     animations:^{
                         self.backgroundView.alpha = 0.0;
                         self.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.actions.count * SHEET_BUTTON_HEIGHT);
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                         [self removeFromSuperview];
                     }];
    [XUSheetDisplayManager sharedInstance].inDisplay = NO;
    if ([XUSheetDisplayManager sharedInstance].sheetViewArray.count != 0) {
        XUSheetView *Sheet = [[XUSheetDisplayManager sharedInstance].sheetViewArray objectAtIndex:0];
        [[XUSheetDisplayManager sharedInstance].sheetViewArray removeObjectAtIndex:0];
        [Sheet display];
    }
}

- (void)addAction:(XUSheetAction *)action {
    [self.actions addObject:action];
}

// MARK: - internal action
- (void)handleButtonClick:(UIButton *)button {
    if (button.tag >= 0 && button.tag <= self.actions.count) {
        XUSheetAction * action = [self.actions objectAtIndex:button.tag];
        if (action.clickBlock) {
            action.clickBlock();
        }
    }
    [self hide:nil];
}


- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.containerView];
    [self.actions enumerateObjectsUsingBlock:^(XUSheetAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = obj.attachButton;
        button.highlighted = CGRectContainsPoint(button.frame, point);
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (button.isHighlighted) {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

// MARK: - lazy loading
- (NSMutableArray *)actions {
    if (_actions == nil) {
        _actions = [NSMutableArray new];
    }
    return _actions;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        _containerView.backgroundColor = [UIColor PopupsBackgroundBaseColor];
    }
    return _containerView;
}

- (void)setTopCornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_containerView.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _containerView.bounds;
    maskLayer.path = maskPath.CGPath;
    _containerView.layer.mask = maskLayer;
}

- (void)maskViewTapped {
    if (self.maskViewBlock) {
        self.maskViewBlock();
    }
    [self hide:nil];
}

- (void)addMaskViewAction:(nullable void(^)(void))action {
    self.maskViewBlock = action;
}

// MARK: - suger
+ (void)showSheetViewWithTitle:(NSString * _Nullable)title style:(XUSheetActionStyle)style onClick:(nullable void(^)(void))onClick {
    XUSheetView *sheet = [[XUSheetView alloc] initWithAction:[XUSheetAction actionWithTitle:@"取消"]];
    XUSheetAction *action = [XUSheetAction actionWithTitle:title style:style onClick:onClick];
    [sheet addAction:action];
    [sheet display];
}

@end
