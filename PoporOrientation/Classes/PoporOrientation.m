//
//  PoporOrientation.m
//  Pods-PoporOrientation_Example
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporOrientation.h"

#import <PoporFoundation/NSObject+Swizzling.h>

@implementation PoporOrientation

+ (instancetype)share {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)swizzlingAppDelegate:(id)appDelegate {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSEL  = @selector(application:supportedInterfaceOrientationsForWindow:);
        SEL swizzleSEL = @selector(swizzlingApplication:supportedInterfaceOrientationsForWindow:);
        
        Class class = [appDelegate class];
        
        if (![appDelegate respondsToSelector:originSEL]) {
            //NSLog(@"appDelegate 不包含");
            //class_addMethod(class, originSEL, class_getMethodImplementation([PoporOrientation class], originSEL), "lu@:@:@");
            NSString * info = [NSString stringWithFormat:@"❌❌❌ PoporOrientation : Class [%@] should add code:\n\n- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {\n\t// this will be replaced by PoporOrientation within runtime, do not remove! \n\treturn UIInterfaceOrientationMaskPortrait;\n}\n\n❌❌❌\n", NSStringFromClass([appDelegate class])];
            fprintf(stderr,"\n%s\n", [info UTF8String]);
            return;
        }else{
            NSString * info = [NSString stringWithFormat:@"✅✅✅ PoporOrientation : Class [%@] will replace application:supportedInterfaceOrientationsForWindow:  by swizzlingApplication:supportedInterfaceOrientationsForWindow: \n", NSStringFromClass([appDelegate class])];
            fprintf(stderr,"\n%s\n", [info UTF8String]);
        }
        
        // 1. 先增加一个方法.
        // https://www.jianshu.com/p/6a3672b8be40
        //比如：”v@:”意思就是这已是一个void类型的方法，没有参数传入。
        //再比如 “i@:”就是说这是一个int类型的方法，没有参数传入。
        //再再比如”i@:@”就是说这是一个int类型的方法，又一个参数传入。
        class_addMethod(class, swizzleSEL, class_getMethodImplementation([PoporOrientation class], swizzleSEL), "lu@:@:@");
        
        // 2.再交换该方法
        [class methodSwizzlingWithOriginalSelector:originSEL bySwizzledSelector:swizzleSEL];
        
    });
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    NSLog(@"PoporOrientation default.");
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientationMask)swizzlingApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    NSLog(@"PoporOrientation swizzling.");
    
    if ([PoporOrientation share].isAllowRotation) {
        //NSLog(@"oritation: %lu", [PoporOrientation share].newInterfaceOrientationMask);
        return [PoporOrientation share].newInterfaceOrientationMask;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}

//------------------------------------------------------------------------------
+ (void)rotateTo:(UIInterfaceOrientation)interfaceOrientation {
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationUnknown) forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:@(interfaceOrientation) forKey:@"orientation"];
}

+ (void)enableRatation {
    [PoporOrientation enableRatationRotateTo:UIInterfaceOrientationLandscapeRight rotatedBlock:nil];
}

+ (void)enableRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation rotatedBlock:(BlockPUIDeviceOrientation)block {
    PoporOrientation * po = [PoporOrientation share];
    po.rotatedBlock = block;
    po.allowRotation = YES;
    [PoporOrientation rotateTo:interfaceOrientation];
}

+ (void)disabledRatation {
    [PoporOrientation disabledRatationRotateTo:UIInterfaceOrientationPortrait];
}

+ (void)disabledRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation {
    PoporOrientation * po = [PoporOrientation share];
    po.rotatedBlock = nil;
    po.allowRotation = NO;
    [PoporOrientation rotateTo:interfaceOrientation];
}

+ (void)nc:(UINavigationController *)nc popGREnabled:(BOOL)enabled {
    nc.interactivePopGestureRecognizer.enabled = enabled;
}

//------------------------------------------------------------------------------
- (void)setAllowRotation:(BOOL)allowRotation{
    _allowRotation = allowRotation;
    if (allowRotation) {
        [self oritationMonitorEnabled:allowRotation];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self oritationMonitorEnabled:allowRotation];
        });
    }
    
}
- (void)oritationMonitorEnabled:(BOOL)enabled {
    if (enabled) {
        if (![UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }else{
        if ([UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

/// 设备旋转方向改变
- (void)onDeviceOrientationDidChange {
    [self performSelector:@selector(onDeviceOrientationDidChangeDelay) withObject:nil afterDelay:0.05];
}

/// 设备旋转方向改变
- (void)onDeviceOrientationDidChangeDelay {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (self.lastDeviceOrientation   != orientation) {
        self.lastDeviceOrientation   = orientation;
        if ([PoporOrientation share].isAllowRotation) {
            switch (orientation) {
                case UIDeviceOrientationPortrait:{
                    self.newInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
                    [PoporOrientation rotateTo:UIInterfaceOrientationPortrait];
                    [self rotationOritationBlock:orientation];
                    break;
                }
                case UIDeviceOrientationPortraitUpsideDown:{
                    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
                        self.newInterfaceOrientationMask = UIInterfaceOrientationMaskPortraitUpsideDown;
                        [PoporOrientation rotateTo:UIInterfaceOrientationPortraitUpsideDown];
                        [self rotationOritationBlock:orientation];
                    }else{
                        // iphone 不允许出现该模式,会崩溃.
                    }
                    break;
                }
                case UIDeviceOrientationLandscapeLeft:{
                    self.newInterfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
                    [PoporOrientation rotateTo:UIInterfaceOrientationLandscapeRight];
                    [self rotationOritationBlock:orientation];
                    break;
                }
                case UIDeviceOrientationLandscapeRight:{
                    self.newInterfaceOrientationMask = UIInterfaceOrientationMaskLandscapeLeft;
                    [PoporOrientation rotateTo:UIInterfaceOrientationLandscapeLeft];
                    [self rotationOritationBlock:orientation];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)rotationOritationBlock:(UIDeviceOrientation)orientation {
    if (self.rotatedBlock) {
        self.rotatedBlock(orientation);
    }
}

@end
