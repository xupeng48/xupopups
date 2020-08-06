//
//  XUSheetDisplayManager.m
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import "XUSheetDisplayManager.h"

@implementation XUSheetDisplayManager

+ (XUSheetDisplayManager *)sharedInstance {
    static XUSheetDisplayManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XUSheetDisplayManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sheetViewArray = [[NSMutableArray alloc] init];
        self.inDisplay = NO;
    }
    return self;
}

@end
