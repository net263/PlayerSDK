//
//  GSChatView.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChatViewCell.h"
#import "GSChatToolBar.h"

@interface GSChatView : UIView

@property (nonatomic, strong) NSMutableArray *dataModelArray;

@property (nonatomic, strong) GSChatToolBar *chatToolbar;

//刷新视图
- (void)refresh;

//插入数据 并插入cell
- (void)insert:(GSChatModel*)model;
//插入数据 并插入cell
- (void)insert:(GSChatModel*)model forceBottom:(BOOL)isBottom;

- (void)removeByUser:(NSString *)userID;

- (void)removeByMessage:(NSString *)messageID;

@end
