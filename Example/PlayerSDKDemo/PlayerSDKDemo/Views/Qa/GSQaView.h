//
//  GSQaView.h
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSQaModel.h"
#import "GSChatToolBar.h"

@interface GSQaView : UIView

@property (nonatomic, strong) NSMutableArray *dataModelArray;

@property (nonatomic, strong) GSChatToolBar *chatToolbar;


@property (nonatomic, assign) BOOL editable;//是否禁言

//刷新视图
- (void)refresh;

//插入数据 并插入cell
- (void)insert:(GSQaModel*)model;

//插入数据 并插入cell
- (void)insert:(GSQaModel*)model forceBottom:(BOOL)isBottom;

- (void)clear;

@end
