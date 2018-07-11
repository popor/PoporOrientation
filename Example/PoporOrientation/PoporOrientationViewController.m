//
//  PoporOrientationViewController.m
//  PoporOrientation
//
//  Created by wangkq on 07/10/2018.
//  Copyright (c) 2018 wangkq. All rights reserved.
//

#import "PoporOrientationViewController.h"

#import <PoporOrientation/PoporOrientation.h>
#import <Masonry/Masonry.h>

@interface PoporOrientationViewController ()

@property (nonatomic, strong) UIButton * autoRotateBT;
@property (nonatomic, strong) UIButton * lockBT;

@property (nonatomic, strong) UIButton * autoRotateFisrtLeftBT;
@property (nonatomic, strong) UIButton * autoRotateFisrtRightBT;

@property (nonatomic, strong) NSMutableArray * rotationBTArray;

@end

@implementation PoporOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[PoporOrientation share].allowRotation = YES;
    
    self.rotationBTArray = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        UIButton * oneBT = ({
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame =  CGRectMake(100, 100 + 60*i, 80, 44);
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor brownColor]];
            
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 1;
            button.clipsToBounds = YES;
            
            [self.view addSubview:button];
            button;
        });
        if (i != 1) {
            [self.rotationBTArray addObject:oneBT];
        }
        switch (i) {
            case 0:{
                [oneBT setTitle:@"自动-关" forState:UIControlStateNormal];
                [oneBT setTitle:@"自动-开" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(autoRotationAction:) forControlEvents:UIControlEventTouchUpInside];
                self.autoRotateBT = oneBT;
                break;
            }
            case 1:{
                [oneBT setTitle:@"锁定-关" forState:UIControlStateNormal];
                [oneBT setTitle:@"锁定-开" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
                self.lockBT = oneBT;
                break;
            }
            case 2:{
                [oneBT setTitle:@"自动先左-关" forState:UIControlStateNormal];
                [oneBT setTitle:@"自动先左-开" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(autoFisrtLeftAction:) forControlEvents:UIControlEventTouchUpInside];
                self.autoRotateFisrtLeftBT = oneBT;
                break;
            }
            case 3:{
                [oneBT setTitle:@"自动先右-关" forState:UIControlStateNormal];
                [oneBT setTitle:@"自动先右-开" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(autoFisrtRightAction:) forControlEvents:UIControlEventTouchUpInside];
                self.autoRotateFisrtRightBT = oneBT;
                break;
            }
            default:
                break;
        }
        
    }
    
    [self.autoRotateBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    [self.lockBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.autoRotateBT.mas_top);
        make.left.mas_equalTo(self.autoRotateBT.mas_right).mas_offset(20);
        make.width.mas_equalTo(self.autoRotateBT.mas_width);
        make.height.mas_equalTo(self.autoRotateBT.mas_height);
        make.right.mas_equalTo(-20);
    }];
    // -----
    [self.autoRotateFisrtRightBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.autoRotateBT.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.autoRotateBT.mas_left);
        make.height.mas_equalTo(self.autoRotateBT.mas_height);
    }];
    
    [self.autoRotateFisrtLeftBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.autoRotateFisrtRightBT.mas_top);
        make.left.mas_equalTo(self.autoRotateFisrtRightBT.mas_right).mas_offset(20);
        make.width.mas_equalTo(self.autoRotateFisrtRightBT.mas_width);
        make.height.mas_equalTo(self.autoRotateFisrtRightBT.mas_height);
        make.right.mas_equalTo(-20);
    }];
}

- (void)autoRotationAction:(UIButton *)bt {
    [self removeOtherStatus:bt];
    bt.selected = !bt.isSelected;
    if (bt.isSelected) {
        [PoporOrientation enableRatationAutoRotatedBlock:nil];
        [self closeLockEvent];
    }else{
        [PoporOrientation disabledRatation];
    }
}

- (void)lockAction:(UIButton *)bt {
    bt.selected = !bt.isSelected;
    [PoporOrientation share].lock = bt.isSelected;
}

- (void)autoFisrtLeftAction:(UIButton *)bt {
    [self removeOtherStatus:bt];
    bt.selected = !bt.isSelected;
    if (bt.isSelected) {
        [PoporOrientation enableRatationRotateTo:UIInterfaceOrientationLandscapeLeft rotatedBlock:nil];
        [self closeLockEvent];
    }else{
        [PoporOrientation disabledRatation];
    }
}

- (void)autoFisrtRightAction:(UIButton *)bt {
    [self removeOtherStatus:bt];
    bt.selected = !bt.isSelected;
    if (bt.isSelected) {
        [PoporOrientation enableRatationRotateTo:UIInterfaceOrientationLandscapeRight rotatedBlock:nil];
        [self closeLockEvent];
    }else{
        [PoporOrientation disabledRatation];
    }
}

- (void)removeOtherStatus:(UIButton *)bt {
    for (UIButton * oneBT in self.rotationBTArray) {
        if (oneBT != bt) {
            [oneBT setSelected:NO];
        }
    }
}

- (void)closeLockEvent {
    if (self.lockBT.isSelected) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.lockBT.selected = YES;
            [self lockAction:self.lockBT];
        });
    }
}

@end
