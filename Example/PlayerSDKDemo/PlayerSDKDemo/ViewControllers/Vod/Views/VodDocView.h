//
//  VodDocView.h
//  VodSDKDemo
//
//  Created by jiangcj on 2018/5/7.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <PlayerSDK/VodSDK.h>

typedef void(^VodDocFullScreenBlock)();

typedef void(^VodDocSwitchHiddenAndShowBlock)();


@interface VodDocView : UIView<GSVodDocViewDelegate>

@property (nonatomic, strong) UIView *vodDocDefaultView;

@property (nonatomic, strong) GSVodDocView* vodDocSwfView;


@property (nonatomic, copy) VodDocFullScreenBlock  vodDocFullScreenBlock;

@property (nonatomic, copy) VodDocSwitchHiddenAndShowBlock  vodDocSwitchHiddenAndShowBlock;


@property (nonatomic, assign) BOOL isDocLoaded;



@end
