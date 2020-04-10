//
//  NSUserDefaults+UserDefaults.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/28/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "NSUserDefaults+UserDefaults.h"

static NSString *kDomain = @"domain";
static NSString *kServiceType = @"serviceType";
static NSString *kRoomNumber = @"roomNumber";
static NSString *kNickname = @"nickname";
static NSString *kWatchPassword = @"watchPassword";

@implementation NSUserDefaults (UserDefaults)

- (NSString*)getDomain
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kDomain];
}

- (void)setDomain:(NSString*)domain
{
    [[NSUserDefaults standardUserDefaults]setObject:domain forKey:kDomain];
}

- (NSString*)getServiceType
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kServiceType];
}

- (void)setServiceType:(NSString*)serviceType
{
    [[NSUserDefaults standardUserDefaults]setObject:serviceType forKey:kServiceType];
}

- (NSString*)getRoomNumber
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kRoomNumber];
}

- (void)setRoomNumber:(NSString*)roomNumber
{
    [[NSUserDefaults standardUserDefaults]setObject:roomNumber forKey:kRoomNumber];
}

- (NSString *)getNickname
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kNickname];
}

- (void)setNickname:(NSString *)nickname
{
    [[NSUserDefaults standardUserDefaults]setObject:nickname forKey:kNickname];
}

- (NSString *)getWatchPassword
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kWatchPassword];
}

- (void)setWatchPassword:(NSString *)watchPassword
{
    [[NSUserDefaults standardUserDefaults]setObject:watchPassword forKey:kWatchPassword];
}

@end
