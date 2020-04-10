//
//  GSPUserInfo.h
//  PlayerSDK
//
//  Created by Gaojin Hsu on 6/10/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  直播中的用户信息
 */
@interface GSPUserInfo : GSUserInfo

/**
 *  聊天所使用的ID
 */
@property (assign, nonatomic)unsigned chatID;

/**
 *  用户的角色； 组织者：role&1 == 1  嘉宾  role&4==4   观看者：role&8 == 8 web观看者：role&16==16
 */
@property (assign, nonatomic)unsigned role;

@property (assign, nonatomic) int resultCode;

+ (instancetype)infoWithUsername:(NSString *)username
                          userId:(long long)userId
                          chatId:(long long)chatId
                            role:(int)role userData:(NSString *)userData groupCode:(NSString *)groupCode;
@end
