//
//  XUAlertDisplayManager.m
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/29.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "XUAlertDisplayManager.h"

@implementation XUAlertDisplayManager

+ (XUAlertDisplayManager *)sharedInstance {
    static XUAlertDisplayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XUAlertDisplayManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.alertViewArray = [[NSMutableArray alloc] init];
        self.inDisplay = NO;
    }
    return self;
}
    
@end
