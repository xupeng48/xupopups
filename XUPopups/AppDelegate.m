//
//  AppDelegate.m
//  XUPopups
//
//  Created by peng xu on 2020/8/6.
//  Copyright © 2020 peng xu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
       
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    return YES;
}

@end
