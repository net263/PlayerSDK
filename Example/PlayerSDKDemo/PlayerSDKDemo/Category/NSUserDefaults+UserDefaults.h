//
//  NSUserDefaults+UserDefaults.h
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/28/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (UserDefaults)

- (NSString*)getDomain;

- (void)setDomain:(NSString*)domain;

- (NSString*)getServiceType;

- (void)setServiceType:(NSString*)serviceType;

- (NSString*)getRoomNumber;

- (void)setRoomNumber:(NSString*)roomNumber;

- (NSString *)getNickname;

- (void)setNickname:(NSString *)nickname;

- (NSString *)getWatchPassword;

- (void)setWatchPassword:(NSString *)watchPassword;

@end
