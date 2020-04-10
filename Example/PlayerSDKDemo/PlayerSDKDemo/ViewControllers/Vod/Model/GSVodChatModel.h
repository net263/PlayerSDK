//
//  GSChatModel.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSBaseModel.h"

@interface GSVodChatModel : GSBaseModel

@property (nonatomic, strong) VodChatInfo *chatMessage;//消息实体

- (instancetype)initWithModel:(VodChatInfo*)obj;

@end
