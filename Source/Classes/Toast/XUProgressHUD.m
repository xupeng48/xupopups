//
//  XUProgressHUD.m
//  XURadio
//
//  Created by Leo on 2017/8/22.
//  Copyright © 2017年 Markphone Culture Media Co.Ltd. All rights reserved.
//

#import "XUProgressHUD.h"

@interface XUProgressHUDBackgroundView : UIView

@end

@implementation XUProgressHUDBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}

@end

#define CORNER_RADIUS 5.0

@interface XUProgressHUD ()

@property (nonatomic, strong) NSTimer *hideTimer;

@property (nonatomic, strong) UIView *spinnerView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong, readwrite) UIView *backgroundView;
@property (nonatomic, strong, readwrite) UIView *centerBackgroundView;

@property (nonatomic, strong) NSDate *showStarted;
@property (nonatomic, strong) NSTimer *minTimer;

@end


@implementation XUProgressHUD

#pragma mark - API

+ (instancetype)showAddedToView:(UIView *)view {
    return [self showAddedToView:view mode:XUProgressHUDModelSpinner];
}

+ (instancetype)showAddedToView:(UIView *)view mode:(XUProgressHUDMode)mode {
    XUProgressHUD *hud = [[XUProgressHUD alloc] initWithAttachedView:view mode:mode];
    return hud;
}

- (void)showInView:(UIView *)view mode:(XUProgressHUDMode)mode {
    if (self.superview != view) {
        [self removeFromSuperview];
    }
    self.showStarted = [NSDate date];
    [self.minTimer invalidate];
    self.minTimer = nil;
    self.mode = mode;
    if ([self.spinnerView isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)self.spinnerView).image = _displayImage;
    }
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [view addSubview:self];
    self.hidden = YES;
    [UIView animateWithDuration:0.33
                     animations:^{
                         self.hidden = NO;
                     } completion:nil];
}

- (void)hide {
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)aniamted delay:(CGFloat)delay {
    [self hideAnimated:aniamted delay:delay completion:self.didHiddenBlock];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self setNeedsUpdateConstraints];
    }
}

- (void)handleMinShowTimer:(NSTimer *)timer {
    BOOL animated = [[timer.userInfo objectForKey:@"animated"] boolValue];
    if (animated) {
        [UIView animateWithDuration:0.33 animations:^{
            self.hidden = YES;
        } completion:^(BOOL finished) {
            if (self->_didHiddenBlock) {
                self->_didHiddenBlock();
            }
            [self removeFromSuperview];
        }];
    } else {
        if (_didHiddenBlock) {
            _didHiddenBlock();
        }
        [self removeFromSuperview];
    }
}

- (void)hideAnimated:(BOOL)aniamted {
    if (!aniamted) { // 没有动画的时候直接隐藏，毕竟是异步，如果先隐藏其他的，再show其他的，有可能会导致后面show的信息一展示就没了
        if (_didHiddenBlock) {
            _didHiddenBlock();
        }
        [self removeFromSuperview];
        return;
    }
    if (self.showStarted && self.minDuration > 0) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.showStarted];
        if (interval < self.minDuration) {
            NSTimer *timer = [NSTimer timerWithTimeInterval:(self.minDuration - interval)
                                                     target:self
                                                   selector:@selector(handleMinShowTimer:)
                                                   userInfo:@{@"animated":@(aniamted)} repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            self.minTimer = timer;
            return;
        }
    }
    [UIView animateWithDuration:0.33
                     animations:^{
                         self.hidden = YES;
                     }
                     completion:^(BOOL finished) {
                         if (self->_didHiddenBlock) {
                             self->_didHiddenBlock();
                         }
                         [self removeFromSuperview];
                     }];
}

- (void)hideAnimated:(BOOL)animated delay:(CGFloat)delay completion:(void (^)(void))completion{
    if (self.hideTimer) {
        [self.hideTimer invalidate];
    }
    _didHiddenBlock = completion;
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                      target:self
                                                    selector:@selector(fireHideTimer:)
                                                    userInfo:@{@"animated":@(animated)}
                                                     repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.hideTimer forMode:NSRunLoopCommonModes];
}

- (void)fireHideTimer:(NSTimer *)timer {
    BOOL animated = [[timer.userInfo objectForKey:@"animated"] boolValue];
    [self hideAnimated:animated];
}

#pragma mark - Init
- (instancetype)initWithAttachedView:(UIView *)view mode:(XUProgressHUDMode)mode {
    if (self = [super initWithFrame:view.bounds]) {
        _xOffset = 0.0;
        _yOffset = 0.0;
        _mode = mode;
        _minDuration = -1.0;
        self.showStarted = [NSDate date];
        self.frame = view.bounds;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:self];
        self.userInteractionEnabled = NO;
        [self commonInit];
        [self updateSpinner];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateSpinner {
    if (self.spinnerView) {
        [self.spinnerView removeFromSuperview];
        self.spinnerView = nil;
    }
    if (self.mode == XUProgressHUDModelSpinner) {
        UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.translatesAutoresizingMaskIntoConstraints = NO;
        [spinner startAnimating];
        [_centerBackgroundView addSubview:spinner];
        self.spinnerView = spinner;
    } else if (self.mode == XUProgressHUDModelImage) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_centerBackgroundView addSubview:imageView];
        self.spinnerView = imageView;
    }
}


- (void)commonInit {
    _backgroundView = [[XUProgressHUDBackgroundView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundView];
    
    _centerBackgroundView = [[XUProgressHUDBackgroundView alloc] initWithFrame:CGRectZero];
    _centerBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _centerBackgroundView.layer.cornerRadius = CORNER_RADIUS;
    _centerBackgroundView.layer.masksToBounds = YES;
    [self addSubview:_centerBackgroundView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.numberOfLines = 2;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_centerBackgroundView addSubview:_textLabel];
    
    [self setNeedsUpdateConstraints];
}

#pragma mark - Constraints

- (void)updateConstraints {
    [self removeConstraints:self.constraints];
    [self.centerBackgroundView removeConstraints:self.centerBackgroundView.constraints];
    
    //Center contain View
    CGFloat paddingX = self.xOffset;
    CGFloat paddingY = self.yOffset;
    
    NSMutableArray * centerConstraints = [NSMutableArray new];
    [centerConstraints addObject:[NSLayoutConstraint constraintWithItem:_centerBackgroundView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_backgroundView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:paddingX]];
    
    [centerConstraints addObject:[NSLayoutConstraint constraintWithItem:_centerBackgroundView
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_backgroundView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:paddingY]];
    
    [self addConstraints:centerConstraints];
    
    
    NSLayoutConstraint * widthGreaterThanHeight = [NSLayoutConstraint constraintWithItem:_centerBackgroundView
                                                                               attribute:NSLayoutAttributeWidth
                                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                  toItem:_centerBackgroundView
                                                                               attribute:NSLayoutAttributeHeight
                                                                              multiplier:1.0
                                                                                constant:0.0];
    [self addConstraint:widthGreaterThanHeight];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_centerBackgroundView
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                          toItem:self
                                                       attribute:NSLayoutAttributeWidth
                                                      multiplier:0.8
                                                        constant:0.0]];
    if (self.spinnerView) {
        [self setUpConstraintsWithSpinner];
    } else {
        [self setupConstraintsWithoutSpinner];
    }
    [super updateConstraints];
}


- (void)setUpConstraintsWithSpinner {
    if (self.spinnerView == nil) {
        return;
    }
    NSNumber * margin = self.textLabel.text.length > 0 ? @(30.0) : @(20.0);
    NSDictionary * matrics = @{@"margin":margin};
    NSMutableArray * centerInsideConstraints = [NSMutableArray new];
    [centerInsideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=margin)-[_spinnerView]-(>=margin)-|"
                                                                                         options:0
                                                                                         metrics:matrics
                                                                                           views:NSDictionaryOfVariableBindings(_spinnerView)]];
    
    [centerInsideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20.0)-[_textLabel]-(==20.0)-|"
                                                                                         options:0
                                                                                         metrics:matrics
                                                                                           views:NSDictionaryOfVariableBindings(_textLabel)]];
    NSNumber * topBottomMargin = self.textLabel.text.length > 0 ? @(15.0) : @(20.0);
    NSDictionary * spaceMargin = @{@"topBottomMargin":topBottomMargin};
    NSString * format = self.textLabel.text.length > 0 ? @"V:|-topBottomMargin-[_spinnerView]-15.0-[_textLabel]-topBottomMargin-|" : @"V:|-topBottomMargin-[_spinnerView]-topBottomMargin-|";
    [centerInsideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format
                                                                                         options:0
                                                                                         metrics:spaceMargin
                                                                                           views:NSDictionaryOfVariableBindings(_spinnerView,_textLabel)]];
    
    [centerInsideConstraints addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_centerBackgroundView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    [centerInsideConstraints addObject:[NSLayoutConstraint constraintWithItem:_spinnerView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_centerBackgroundView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    
    [_centerBackgroundView addConstraints:centerInsideConstraints];
}

- (void)setupConstraintsWithoutSpinner {
    NSMutableArray * labelConstraints = [NSMutableArray new];
    NSNumber * margin = self.textLabel.text.length > 0 ? @(11.0) : @(20.0);
    NSDictionary * spaceMargin = @{@"margin":margin};
    [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==margin)-[_textLabel]-(==margin)-|"
                                                                                  options:0
                                                                                  metrics:spaceMargin
                                                                                    views:NSDictionaryOfVariableBindings(_textLabel)]];
    [labelConstraints addObject:[NSLayoutConstraint constraintWithItem:_textLabel
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_centerBackgroundView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
    [labelConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[_textLabel]-margin-|"
                                                                                  options:0
                                                                                  metrics:spaceMargin
                                                                                    views:NSDictionaryOfVariableBindings(_textLabel)]];
    [_centerBackgroundView addConstraints:labelConstraints];
}

- (void)setXOffset:(CGFloat)xOffset {
    _xOffset = xOffset;
    [self setNeedsUpdateConstraints];
}

- (void)setYOffset:(CGFloat)yOffset {
    _yOffset = yOffset;
    [self setNeedsUpdateConstraints];
}

- (void)setDisplayText:(NSString *)displayText {
    _displayText = displayText;
    self.textLabel.text = _displayText;
    [self setNeedsUpdateConstraints];
}

- (void)setDisplayImage:(UIImage *)displayImage {
    _displayImage = displayImage;
    if ([self.spinnerView isKindOfClass:[UIImageView class]]) {
        ((UIImageView *)self.spinnerView).image = displayImage;
    }
}

- (void)setMode:(XUProgressHUDMode)mode {
    _mode = mode;
    [self updateSpinner];
    [self setNeedsUpdateConstraints];
}

- (void)setMinDuration:(CGFloat)minDuration {
    _minDuration = minDuration;
}

@end
