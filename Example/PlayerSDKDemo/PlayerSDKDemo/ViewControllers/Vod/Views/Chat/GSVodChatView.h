//
//  GSChatView.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSVodChatViewCell.h"

@interface GSVodChatView : UIView

@property (nonatomic, strong) NSMutableArray *dataModelArray;

//刷新视图
- (void)refresh;

//插入数据 并插入cell
- (void)insert:(GSVodChatModel*)model;
//插入数据 并插入cell
- (void)insert:(GSVodChatModel*)model forceBottom:(BOOL)isBottom;


@end
