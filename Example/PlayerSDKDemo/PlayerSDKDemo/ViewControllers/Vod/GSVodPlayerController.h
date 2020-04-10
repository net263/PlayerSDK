//
//  GSVodPlayerController.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
#import <UIKit/UIKit.h>
#import <PlayerSDK/VodSDK.h>
@interface GSVodPlayerController : UIViewController
@property (nonatomic, strong) downItem *item;
@property (nonatomic, assign) BOOL isOnline;

@property (nonatomic, assign) UIViewContentMode videoMode;
@property (nonatomic, assign) GSVideoRenderMode renderMode;
@property (nonatomic, assign) BOOL isChatpost; //聊天实时推送
@end
