//
//  PoporOrientation.m
//  Pods-PoporOrientation_Example
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "PoporOrientation.h"
#import "PoporMotionManager.h"
#import "PoporAppDelegate.h"
#import "PoporInterfaceOrientation.h"

@interface PoporOrientation ()

@property (nonatomic, strong) PoporMotionManager * pmm;

@property (nonatomic, getter=isEnableNotificationCenter) BOOL enableNotificationCenter;

@end


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
    [PoporAppDelegate swizzlingAppDelegate:appDelegate];
}

//------------------------------------------------------------------------------
+ (void)enableRatationAutoRotatedBlock:(BlockPUIDeviceOrientation)block {
    PoporOrientation * po = [PoporOrientation share];
    po.rotatedBlock = block;
    po.allowRotation = YES;
    UIInterfaceOrientation io = [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:po.lastDeviceOrientation];
    [PoporInterfaceOrientation rotateTo:io];
    
    if (!po.pmm) {
        po.pmm = [PoporMotionManager new];
    }
    [po.pmm startMonitor:^(BOOL success) {
        PoporOrientation * po_ = [PoporOrientation share];
        UIInterfaceOrientation io = [po_.pmm interfaceOrientation];
        [PoporInterfaceOrientation rotateTo:io];
        [po_.pmm stopMonitor];
    }];
}

+ (void)enableRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation rotatedBlock:(BlockPUIDeviceOrientation)block {
    PoporOrientation * po = [PoporOrientation share];
    po.rotatedBlock = block;
    po.allowRotation = YES;
    [PoporInterfaceOrientation rotateTo:interfaceOrientation];
}


+ (void)disabledRatation {
    [PoporOrientation disabledRatationRotateTo:UIInterfaceOrientationPortrait];
}

+ (void)disabledRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation {
    PoporOrientation * po = [PoporOrientation share];
    po.rotatedBlock = nil;
    po.allowRotation = NO;
    [PoporInterfaceOrientation rotateTo:interfaceOrientation];
}

//------------------------------------------------------------------------------
- (void)setAllowRotation:(BOOL)allowRotation{
    _allowRotation = allowRotation;
    if (allowRotation) {
        [self sysOritationMonitor_NotificationCenterEnabled:allowRotation];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sysOritationMonitor_NotificationCenterEnabled:allowRotation];
        });
    }
}

// 该函数enabled == NO,将关闭系统触发application:supportedInterfaceOrientationsForWindow:功能,需要的话可以重新打开.
- (void)sysOritationMonitor_NotificationCenterEnabled:(BOOL)enabled {
    [self sysOritationMonitorEnabled:enabled];
    [self notificationCenterEnabled:enabled];
}

- (void)sysOritationMonitorEnabled:(BOOL)enabled {
    if (enabled) {
        if (![UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
    }else{
        if ([UIDevice currentDevice].isGeneratingDeviceOrientationNotifications) {
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
        }
    }
}

#pragma mark - 通知部分
- (void)notificationCenterEnabled:(BOOL)enabled {
    if (enabled) {
        if (!self.isEnableNotificationCenter) {
            self.enableNotificationCenter = !self.enableNotificationCenter;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        }
    }else{
        if (self.isEnableNotificationCenter) {
            self.enableNotificationCenter = !self.enableNotificationCenter;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
        }
    }
    
    // __weak typeof(self) weakSelf = self;
    // [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:nil] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification * _Nullable x) {
    //         NSLog(@"%@", x);
    //         [weakSelf onDeviceOrientationDidChange];
    // }];
}

// 设备方向改变
- (void)onDeviceOrientationDidChange {
    [self performSelector:@selector(onDeviceOrientationDidChangeDelay) withObject:nil afterDelay:0.05];
}

- (void)onDeviceOrientationDidChangeDelay {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (self.lastDeviceOrientation != orientation) {
        self.lastDeviceOrientation  = orientation;
        if (self.isLock) {
            
        }else if ([PoporOrientation share].isAllowRotation) {
            
            self.newInterfaceOrientationMask = [PoporInterfaceOrientation interfaceOrientationMask_deviceOrientation:orientation];
            self.newInterfaceOrientation = [PoporInterfaceOrientation interfaceOrientation_deviceOrientation:orientation];
            [PoporInterfaceOrientation rotateTo:self.newInterfaceOrientation];
            [self rotationOritationBlock:orientation];
            //NSLog(@"方向UI监测 %lu, 刷新", self.newInterfaceOrientation);
        }
    }else{
        //NSLog(@"方向UI监测 %lu, 忽略", self.newInterfaceOrientation);
    }
}

#pragma mark - 处理block
- (void)rotationOritationBlock:(UIDeviceOrientation)orientation {
    if (self.rotatedBlock) {
        self.rotatedBlock(orientation);
    }
}

@end
