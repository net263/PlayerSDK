//
//  MainTableViewController.h
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/28/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlayerSDK/PlayerSDK.h>
#import <GSCommonKit/GSCommonKit.h>
@interface MainTableViewController : UITableViewController

@property (nonatomic, strong)GSPPlayerManager *playerManager;

@property (nonatomic, strong)NSString *domain;
@property (nonatomic, strong)NSString *serviceType;
@property (nonatomic, strong)NSString *roomNumber;
@property (nonatomic, strong)NSString *niceName;
@property (nonatomic, strong)NSString *watchPassword;
@property (nonatomic, strong)NSString *thirdToken;
@end
