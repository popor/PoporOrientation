//
//  PoporInterfaceOrientation.h
//  Masonry
//
//  Created by apple on 2018/7/11.
//

#import <Foundation/Foundation.h>

@interface PoporInterfaceOrientation : NSObject

// 强制调整设备显示方向
+ (void)rotateTo:(UIInterfaceOrientation)interfaceOrientation;

+ (UIInterfaceOrientation)interfaceOrientation_deviceOrientation:(UIDeviceOrientation)deviceOrientation;
+ (UIInterfaceOrientationMask)interfaceOrientationMask_deviceOrientation:(UIDeviceOrientation)deviceOrientation;

@end
