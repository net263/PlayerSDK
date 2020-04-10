//
//  GSVodBroadcastMessage.h
//  VodSDK
//
//  Created by gensee on 2019/1/7.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface GSVodBroadcastMessage : NSObject

@property (nonatomic, strong) NSString *text;  //内容

@property (nonatomic, strong) NSString *senderName; //发送者

@property (nonatomic, assign) long long sendTime; //发送时间 秒

@property (nonatomic, assign) long long playTime; //播放时间点 秒

@end

NS_ASSUME_NONNULL_END
