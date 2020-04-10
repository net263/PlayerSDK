//
//  AppDelegate.h
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/10/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlayerSDK/PlayerSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GSPPlayerManager *playerManager;
@property (nonatomic, strong) GSPJoinParam *joinParam;
//@property (nonatomic, strong)AVPlayer *timerPlayer;
//
//@property (nonatomic, strong) AVPlayerItem *item;
@end

