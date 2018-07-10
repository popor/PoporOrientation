//
//  PoporOrientationAppDelegate.m
//  PoporOrientation
//
//  Created by wangkq on 07/10/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporOrientationAppDelegate.h"
#import <PoporOrientation/PoporOrientation.h>

#import <objc/runtime.h>

@implementation PoporOrientationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PoporOrientation swizzlingAppDelegate:self];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        SEL originSEL  = @selector(application:supportedInterfaceOrientationsForWindow:);
    //        if ([self respondsToSelector:originSEL]) {
    //            NSLog(@"最终监测 包含");
    //        }else{
    //            NSLog(@"最终监测 不包含");
    //        }
    //        [self performSelector:originSEL withObject:application withObject:self.window];
    //    });
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    // this will be replaced by PoporOrientation within runtime, do not remove!
    return UIInterfaceOrientationMaskPortrait;
}

@end
