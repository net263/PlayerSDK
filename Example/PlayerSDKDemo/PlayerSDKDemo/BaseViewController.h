//
//  BaseViewController.h
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/29/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlayerSDK/PlayerSDK.h>
#import <GSCommonKit/GSCommonKit.h>
@interface BaseViewController : UIViewController

@property (nonatomic, strong)GSPPlayerManager *playerManager;

@end
