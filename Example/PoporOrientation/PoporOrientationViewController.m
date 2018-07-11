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

@property (nonatomic, strong) UIButton * bt1;
@property (nonatomic, strong) UIButton * bt2;

@end

@implementation PoporOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[PoporOrientation share].allowRotation = YES;
    
    for (int i = 0; i<2; i++) {
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
        switch (i) {
            case 0:{
                [oneBT setTitle:@"未开启" forState:UIControlStateNormal];
                [oneBT setTitle:@"已开启" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(enableAction:) forControlEvents:UIControlEventTouchUpInside];
                self.bt1 = oneBT;
                break;
            }
            case 1:{
                [oneBT setTitle:@"旋转" forState:UIControlStateNormal];
                //[oneBT setTitle:@"已开启" forState:UIControlStateSelected];
                [oneBT addTarget:self action:@selector(rotateAction:) forControlEvents:UIControlEventTouchUpInside];
                self.bt2 = oneBT;
                break;
            }
            default:
                break;
        }
        
    }
    
    [self.bt1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(44);
    }];
    [self.bt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bt1.mas_top);
        make.left.mas_equalTo(self.bt1.mas_right).mas_offset(20);
        make.width.mas_equalTo(self.bt1.mas_width);
        make.height.mas_equalTo(self.bt1.mas_height);
        make.right.mas_equalTo(-20);
    }];
}

- (void)enableAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        //[PoporOrientation enableRatationRotateTo:UIInterfaceOrientationLandscapeRight rotatedBlock:nil];
        [PoporOrientation enableRatationAutoRotatedBlock:nil];
        
    }else{
        [PoporOrientation disabledRatation];
    }
}

- (void)rotateAction:(UIButton *)bt {
    
}

@end
