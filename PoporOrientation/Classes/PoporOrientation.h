//
//  PoporOrientation.h
//  Pods-PoporOrientation_Example
//
//  Created by popor on 2018/1/20.
//  Copyright © 2018年 popor. All rights reserved.
//

//作者：木语先生
//链接：https://www.jianshu.com/p/d6cb54d2eaa1
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
// 部分代码摘自:木语先生

#import <Foundation/Foundation.h>

typedef void(^BlockPUIDeviceOrientation) (UIDeviceOrientation orientation);

@interface PoporOrientation : NSObject

@property(nonatomic, getter=isAllowRotation)             BOOL allowRotation;
@property(nonatomic, getter=isLock)                      BOOL lock;

@property (nonatomic        ) UIDeviceOrientation        lastDeviceOrientation;// 自己使用
@property (nonatomic        ) UIInterfaceOrientationMask lastInterfaceOrientationMask;// AppDelegate使用

@property (nonatomic        ) UIInterfaceOrientation     newInterfaceOrientation;// AppDelegate使用
@property (nonatomic        ) UIInterfaceOrientationMask newInterfaceOrientationMask;// AppDelegate使用

@property (nonatomic, copy  ) BlockPUIDeviceOrientation  rotatedBlock; // 完成旋转后的回调

+ (instancetype)share;

+ (void)swizzlingAppDelegate:(id)appDelegate;

+ (void)enableRatationAutoRotatedBlock:(BlockPUIDeviceOrientation)block;
+ (void)enableRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation rotatedBlock:(BlockPUIDeviceOrientation)block;

+ (void)disabledRatation;
+ (void)disabledRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation;

- (void)sysOritationMonitor_NotificationCenterEnabled:(BOOL)enabled;
// 该函数enabled == NO,将关闭系统触发application:supportedInterfaceOrientationsForWindow:功能,需要的话可以重新打开.
- (void)sysOritationMonitorEnabled:(BOOL)enabled;
- (void)notificationCenterEnabled:(BOOL)enabled;

@end


