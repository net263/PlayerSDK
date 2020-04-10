//
//  GSVodPlayerController+Notification.m
//  VodSDKDemo
//
//  Created by gensee on 2019/12/6.
//  Copyright © 2019年 Gensee. All rights reserved.
//

#import "GSVodPlayerController+Notification.h"
#import <UserNotifications/UserNotifications.h>
@implementation GSVodPlayerController (Notification)

- (void)pushNewNotification {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"测试通知";
    content.body = @"这是一条测试通知";
    //            content.userInfo = @"userInfo111";
    content.sound = [UNNotificationSound defaultSound];
    //            ios 12 后失败，会导致闪退
    //            [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notif" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
}

@end
