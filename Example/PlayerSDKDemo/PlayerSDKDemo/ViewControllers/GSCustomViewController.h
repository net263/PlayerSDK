//
//  GSCustomViewController.h
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/9/6.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSBaseViewController.h"

@interface GSCustomViewController : GSBaseViewController

@property (nonatomic, strong) GSConnectInfo *param;
@property (nonatomic, strong) GSPPlayerManager *manager;

- (void)didPlayerJoinSuccess;
- (void)didPlayerleave;
@end
