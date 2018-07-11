//
//  PoporOrientationAppDelegate.m
//  PoporOrientation
//
//  Created by wangkq on 07/10/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporOrientationAppDelegate.h"
#import <PoporOrientation/PoporOrientation.h>

@implementation PoporOrientationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PoporOrientation swizzlingAppDelegate:self];
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    // this will be replaced by PoporOrientation within runtime, do not remove!
    return UIInterfaceOrientationMaskPortrait;
}

@end
