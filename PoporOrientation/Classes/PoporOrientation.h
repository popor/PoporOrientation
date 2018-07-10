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

@property(nonatomic, getter=isAllowRotation) BOOL allowRotation;

@property (nonatomic        ) UIDeviceOrientation        lastDeviceOrientation  ;// 自己使用
@property (nonatomic        ) UIInterfaceOrientationMask newInterfaceOrientationMask;// AppDelegate使用
@property (nonatomic, copy  ) BlockPUIDeviceOrientation  rotatedBlock; // 完成旋转后的回调

+ (instancetype)share;
// 1.你需要注册 AppDelegate Class.
+ (void)swizzlingAppDelegate:(id)appDelegate;

+ (void)enableRatation;
+ (void)enableRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation rotatedBlock:(BlockPUIDeviceOrientation)block;

+ (void)disabledRatation;
+ (void)disabledRatationRotateTo:(UIInterfaceOrientation)interfaceOrientation;

+ (void)rotateTo:(UIInterfaceOrientation)interfaceOrientation;

+ (void)nc:(UINavigationController *)nc popGREnabled:(BOOL)enabled;

@end



// 示例代码
//- (void)rotateAction:(UIButton *)sender {
//    sender.selected = !sender.isSelected;
//    if (sender.isSelected) {
//        [UIDevice setAppAllowRotation:YES];
//        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
//        __weak typeof(self) weakSelf = self;
//        [UIDevice setRotationBlock:^(NSDictionary *dic) {
//            if (weakSelf) {
//                UIDeviceOrientation orientation = [dic[@"orientation"] integerValue];
//                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//                    [UIDevice nc:weakSelf.view.vc.navigationController popGREnabled:NO];
//                }else{
//                    [UIDevice nc:weakSelf.view.vc.navigationController popGREnabled:YES];
//                }
//            }
//        }];
//    }else{
//        [UIDevice setAppAllowRotation:NO];
//        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
//        [UIDevice setRotationBlock:nil];
//        [UIDevice nc:self.view.vc.navigationController popGREnabled:YES];
//    }
//}

