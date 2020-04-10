//
//  GSChatViewCell.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChatModel.h"
//#import "YYLabel.h"

@interface GSChatViewCell : UITableViewCell


@property (nonatomic,retain) UILabel *nickName;

@property (nonatomic,retain) UILabel *timeLab;

/**
 类型
 */
@property (nonatomic,retain) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *content;

@property (nonatomic,strong) GSChatModel *model;


@end
