//
//  QTAlertView.m
//  QTAlertView_Example
//
//  Created by peng xu on 2019/1/11.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "QTAlertView.h"
#import "UIColor+QTAlert.h"

@interface QTAlertView ()

// Data
@property (nonatomic, copy) UIImage * iconImage;
@property (nonatomic, copy) UIImage * headerImage;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, strong) NSMutableArray<QTAlertAction *> * actions;
@property (nonatomic, assign) BOOL showCloseButton;
@property (nonatomic, copy) void(^closeButtonBlock)(void);
@property (nonatomic, copy) void(^extraConfig)(UILabel * titleLabel, UILabel * messageLabel);
@property (nonatomic, assign) CGFloat offsetStart;
@property (nonatomic, assign) BOOL isCompleteCustomView;

// Views
@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIView * customView;      // 自定义View
@property (nonatomic, strong) UIButton * closeButton;

// Gesture
@property (nonatomic, strong) UIPanGestureRecognizer * pan;

@end

@implementation QTAlertView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (instancetype)initWithIconImage:(UIImage *)iconImage
                      headerImage:(UIImage *)headerImage
                            title:(NSString *)title
                          message:(NSString *)message
                       customView:(UIView *)customView {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.iconImage = iconImage;
        self.headerImage = headerImage;
        self.title = title;
        self.message = message;
        self.customView = customView;
        self.showCloseButton = NO;
        self.offsetStart = 0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        }
    }
    return self;
}

+ (instancetype)alertWithIconImage:(UIImage *)iconImage
                       headerImage:(UIImage *)headerImage
                             title:(NSString *)title
                           message:(NSString *)message
                        customView:(UIView *)customView {
    return [[QTAlertView alloc] initWithIconImage:iconImage headerImage:headerImage title:title message:message customView:customView];
}

+ (instancetype)alertWithCompleteCustomView:(UIView *)view {
    QTAlertView * alert = [[QTAlertView alloc] initWithIconImage:nil headerImage:nil title:nil message:nil customView:nil];
    alert.containerView = view;
    alert.showCloseButton = YES;
    alert.isCompleteCustomView = YES;
    return alert;
}

// MARK: - UI
- (void)buildSubViews {
    // BackgroundView
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_backgroundView];
    
    [self addSubview:self.containerView];
    if (_headerImage) {
        _headerImageView = [[UIImageView alloc] initWithImage:_headerImage];
        [_containerView addSubview:_headerImageView];
    }
    if (_iconImage) {
        _iconImageView = [[UIImageView alloc] initWithImage:_iconImage];
        [_containerView addSubview:_iconImageView];
    }
    if (_title) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor qtAlertColorWithString:@"#333333"];
        if (@available(iOS 8.2, *)) {
            _titleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        } else {
            _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        }
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = _title;
        [_containerView addSubview:_titleLabel];
    }
    if (_message) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14.0];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor qtAlertColorWithString:@"#666666"];
        _messageLabel.text = _message;
        [_containerView addSubview:_messageLabel];
    }
    if (_customView) {
        [_containerView addSubview:_customView];
    }
    if (self.extraConfig) {
        self.extraConfig(_titleLabel, _messageLabel);
    }
    
    [self.actions enumerateObjectsUsingBlock:^(QTAlertAction *action, NSUInteger idx, BOOL *stop) {
        UIButton *button = [action buildButton];
        [button setTitle:action.title forState:UIControlStateNormal];
        button.tag = idx;
        [button addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (action.configBlock) {
            action.configBlock(button);
        }
        action.attachButton = button;
        [self->_containerView addSubview:button];
    }];
    
    // Set up to default state
    _backgroundView.alpha = 0.0;
    _containerView.alpha = 0.0;
    _containerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    // Gesture
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_containerView addGestureRecognizer:_pan];
    
    if (_showCloseButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                                stringByAppendingPathComponent:@"/QTAlertView.bundle"];
        NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
        UIImage *image = [UIImage imageNamed:@"close"
                                    inBundle:resource_bundle
               compatibleWithTraitCollection:nil];
        [_closeButton setImage:image forState:UIControlStateNormal];
        [_closeButton setImage:image forState:UIControlStateHighlighted];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(3.5, 3.5, 3.5, 3.5)];
        [self addSubview:_closeButton];
        CGSize closeButtonSize = CGSizeMake(35.0, 35.0);
        _closeButton.frame = CGRectMake(CGRectGetMaxX(_containerView.frame) - 31.5, CGRectGetMinY(_containerView.frame) - 47.5, closeButtonSize.width, closeButtonSize.height);
        _closeButton.alpha = 0.0;
        _closeButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat offsetY = self.offsetStart;
    if (_iconImage) {
        offsetY -= 35.0;
        CGSize imageSize = CGSizeMake(70.0, 70.0);
        _iconImageView.frame = CGRectMake(DEFAULT_CONTAINER_WIDTH / 2.0 - imageSize.width / 2.0, offsetY, imageSize.width, imageSize.height);
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 35.0;
        _iconImageView.layer.borderWidth = 4.0;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        offsetY += imageSize.height;
    }
    if (_headerImage) {
        offsetY = 0.0;
        _headerImageView.frame = CGRectMake(0, 0, DEFAULT_CONTAINER_WIDTH, DEFAULT_HEADERIMAGE_HEIGHT);
        offsetY += DEFAULT_HEADERIMAGE_HEIGHT;
    }
    if (_title) {
        offsetY += _iconImage ? 12.0 : DEFAULT_PADDING_TOP;
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(DEFAULT_CONTAINER_WIDTH - DEFAULT_LEFTRIGHT_PADDING * 2, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(DEFAULT_LEFTRIGHT_PADDING, offsetY, DEFAULT_CONTAINER_WIDTH - DEFAULT_LEFTRIGHT_PADDING * 2, size.height);
        offsetY += CGRectGetHeight(_titleLabel.frame);
    }
    if (_message) {
        offsetY += 12.0;
        CGSize size = [_messageLabel sizeThatFits:CGSizeMake(DEFAULT_CONTAINER_WIDTH - DEFAULT_LEFTRIGHT_PADDING * 2, CGFLOAT_MAX)];
        _messageLabel.frame = CGRectMake(DEFAULT_LEFTRIGHT_PADDING, offsetY, DEFAULT_CONTAINER_WIDTH - DEFAULT_LEFTRIGHT_PADDING * 2, size.height);
        offsetY += CGRectGetHeight(_messageLabel.frame);
    }
    if (_customView) {
        offsetY += 16.0;
        _customView.frame = CGRectMake(0, offsetY, DEFAULT_CONTAINER_WIDTH, _customView.frame.size.height);
        offsetY += CGRectGetHeight(_customView.frame);
    }
    offsetY += 20.0;
    CGFloat buttonX = 16.0;
    for (NSInteger i = 0; i < self.actions.count; i ++) {
        QTAlertAction * currentAction = [self.actions objectAtIndex:i];
        if (currentAction.layout == QTAlertActionLayoutHalfWidth) {// 占用一半
            if (i != 0 && buttonX == 16.0) offsetY += 12.0;
            [currentAction.attachButton setFrame:CGRectMake(buttonX, offsetY, 118.0, DEFAULT_BUTTON_HEIGHT)];
            if (buttonX == 16.0) {
                buttonX = DEFAULT_CONTAINER_WIDTH / 2 + 6.0;
                if (i == self.actions.count - 1) offsetY += DEFAULT_BUTTON_HEIGHT;
            } else {
                buttonX = 16.0;
                offsetY += DEFAULT_BUTTON_HEIGHT;
            }
        } else {
            if (i != 0) offsetY += 12.0;
            if (buttonX != 16.0) offsetY += DEFAULT_BUTTON_HEIGHT;
            CGFloat height = currentAction.layout == QTAlertActionLayoutFull ? DEFAULT_BUTTON_HEIGHT : CGRectGetHeight(currentAction.attachButton.bounds) != 0 ? CGRectGetHeight(currentAction.attachButton.bounds) : SHORT_BUTTON_HEIGHT;
            if (buttonX != 16.0) {
                buttonX = 16.0;
            }
            [currentAction.attachButton setFrame:CGRectMake(buttonX, offsetY, DEFAULT_CONTAINER_WIDTH - 32.0, height)];
            offsetY += height;
        }
        
        for (CALayer *layer in currentAction.attachButton.layer.sublayers) {
            if ([layer isKindOfClass:[CAGradientLayer class]]) {
                [layer setFrame:currentAction.attachButton.bounds];
            }
        }
    }
    
    if (!self.isCompleteCustomView) {
        _containerView.frame = CGRectMake(0, 0, DEFAULT_CONTAINER_WIDTH, offsetY + 16.0);
    }
    CGFloat containerCenterY = _showCloseButton ? CGRectGetHeight(self.bounds) / 2 + 22.0 : CGRectGetHeight(self.bounds) / 2;
    _containerView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, containerCenterY);
    
    // Close Button
    if (_closeButton) {
        CGSize closeButtonSize = CGSizeMake(35.0, 35.0);
        _closeButton.frame = CGRectMake(CGRectGetMaxX(_containerView.frame) - 31.5, CGRectGetMinY(_containerView.frame) - 47.5, closeButtonSize.width, closeButtonSize.height);
    }
}

- (void)didChangeStatusBarOrientation {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundView.center = self.center;
}

// MARK: - external action
- (void)display {
    [self display:nil];
}

- (void)display:(void (^)(void))completion {
    NSAssert([[NSThread currentThread] isMainThread], @"You must call this function on main thread");
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self buildSubViews];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self becomeFirstResponder];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
                         self.backgroundView.alpha = 1.0;
                         self.closeButton.alpha = 1.0;
                         self.containerView.alpha = 1.0;
                         self.closeButton.transform = CGAffineTransformIdentity;
                         self.containerView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)hide {
    [self hide:nil];
}

- (void)hide:(void (^)(void))completion {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:^{
                         self.backgroundView.alpha = 0.0;
                         self.closeButton.alpha = 0.0;
                         self.containerView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion();
                         }
                         [self removeFromSuperview];
                     }];
}

- (void)addExtraConfig:(void (^)(UILabel *, UILabel *))config {
    self.extraConfig = config;
}

- (void)addAction:(QTAlertAction *)action {
    [self.actions addObject:action];
}

- (void)addCloseButtonWithAction:(void (^)(void))action {
    self.showCloseButton = YES;
    self.closeButtonBlock = action;
}

// MARK: - internal action
- (void)handleButtonClick:(UIButton *)button {
    if (button.tag >= 0 && button.tag <= self.actions.count) {
        QTAlertAction * action = [self.actions objectAtIndex:button.tag];
        if (action.clickBlock) {
            action.clickBlock();
        }
    }
    [self hide:nil];
}

- (void)closeButtonClicked:(UIButton *)button {
    if (self.closeButtonBlock) {
        self.closeButtonBlock();
    }
    [self hide:nil];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.containerView];
    [self.actions enumerateObjectsUsingBlock:^(QTAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = obj.attachButton;
        button.highlighted = CGRectContainsPoint(button.frame, point);
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
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_CONTAINER_WIDTH, 0)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8.0;
        _containerView.layer.masksToBounds = NO;
    }
    return _containerView;
}

// MAKR: - sugar

+ (void)showAlertWithIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message showClose:(BOOL)isShowClose closeClick:(void (^)(void))closeClick confirmTitle:(NSString *)confirmTitle confirmStyle:(QTAlertActionStyle)confirmStyle confirmClick:(void (^)(void))confirmClick {
    QTAlertAction *confirmAction = [QTAlertAction actionFullWithTitle:confirmTitle style:confirmStyle onClick:confirmClick];
    QTAlertView *alert = [[QTAlertView alloc] initWithIconImage:icon headerImage:nil title:title message:message customView:nil];
    [alert addAction:confirmAction];
    if (isShowClose) {
        [alert addCloseButtonWithAction:closeClick];
    }
    [alert display];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message showClose:(BOOL)isShowClose closeClick:(void (^)(void))closeClick confirmTitle:(NSString *)confirmTitle confirmStyle:(QTAlertActionStyle)confirmStyle confirmClick:(void (^)(void))confirmClick {
    [self showAlertWithIcon:nil title:title message:message showClose:isShowClose closeClick:closeClick confirmTitle:confirmTitle confirmStyle:confirmStyle confirmClick:confirmClick];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle confirmStyle:(QTAlertActionStyle)confirmStyle confirmClick:(void (^)(void))confirmClick {
    [self showAlertWithTitle:title message:message showClose:NO closeClick:nil confirmTitle:confirmTitle confirmStyle:confirmStyle confirmClick:confirmClick];
}

+ (void)showAlertWithIcon:(UIImage *)icon title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelClick:(void (^)(void))cancelClick confirmTitle:(NSString *)confirmTitle confirmClick:(void (^)(void))confirmClick {
    QTAlertAction *cancelAction = [QTAlertAction actionHalfWidthWithTitle:cancelTitle style:QTAlertActionStyleNotRecommend onClick:cancelClick];
    QTAlertAction *confirmAction = [QTAlertAction actionHalfWidthWithTitle:confirmTitle style:QTAlertActionStyleRecommend onClick:confirmClick];
    QTAlertView *alert = [[QTAlertView alloc] initWithIconImage:icon headerImage:nil title:title message:message customView:nil];
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
    [alert display];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelClick:(void (^)(void))cancelClick confirmTitle:(NSString *)confirmTitle confirmClick:(void (^)(void))confirmClick {
    [self showAlertWithIcon:nil title:title message:message cancelTitle:cancelTitle cancelClick:cancelClick confirmTitle:confirmTitle confirmClick:confirmClick];
}

@end
