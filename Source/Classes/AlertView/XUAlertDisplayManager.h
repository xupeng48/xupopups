//
//  XUAlertDisplayManager.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/1/29.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XUAlertView;

@interface XUAlertDisplayManager : NSObject

@property (nonatomic, strong) NSMutableArray<XUAlertView *> *alertViewArray;
@property (nonatomic, assign) BOOL inDisplay;

+ (XUAlertDisplayManager *)sharedInstance;

@end
