//
//  XUSheetDisplayManager.h
//  XUAlertView_Example
//
//  Created by peng xu on 2019/2/18.
//  Copyright © 2019 xupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XUSheetView;

@interface XUSheetDisplayManager : NSObject

@property (nonatomic, strong) NSMutableArray<XUSheetView *> *sheetViewArray;
@property (nonatomic, assign) BOOL inDisplay;

+ (XUSheetDisplayManager *)sharedInstance;

@end
