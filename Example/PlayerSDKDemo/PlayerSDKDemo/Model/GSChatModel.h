//
//  GSChatModel.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSBaseModel.h"



@interface GSChatModel : GSBaseModel

//---------- MODEL --------------

@property (nonatomic, strong) GSPChatMessage *chatMessage;//消息实体

@property (nonatomic, strong) GSPUserInfo *userModel;//用户信息



- (instancetype)initWithModel:(GSPChatMessage*)obj type:(GSChatModelType)type;

@end
