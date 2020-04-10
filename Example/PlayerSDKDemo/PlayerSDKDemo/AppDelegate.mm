//
//  AppDelegate.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/10/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "AppDelegate.h"
#import "GSPlayerParamViewController.h"
#import "GSBaseNavigationController.h"
#import <GSCommonKit/GSCommonKit.h>
#import <Bugly/Bugly.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
    // 如果你需要多个参数则用 | 分开 例 completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert)
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[GSDiagnosisInfo shareInstance] redirectNSlogToDocumentFolder];
    
//    [[GSPPlayerManager sharedManager] setLogLevel:GSPLogLevelOff];
    
//    [GSPPlayerManager sharedManager].sessionCategoryOption = AVAudioSessionCategoryOptionDefaultToSpeaker;
    
    //必须写代理，不然无法监听通知的接收与点击事件
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionSound|UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"granted %d",granted);
        
    }];
    center.delegate = self;
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:@"96e5425a5e" config:config];
    
    NSLog(@"Use PlayerSDK verison %.02f %s",PlayerSDKVersionNumber,PlayerSDKVersionString);
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    GSPlayerParamViewController *mainVC = [[GSPlayerParamViewController alloc]init];
    GSBaseNavigationController *navigation = [[GSBaseNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    NSLog(@"[APP CYCLE] application:didFinishLaunchingWithOptions:");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"[APP CYCLE] applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"[APP CYCLE] applicationDidEnterBackground");
//    [_playerManager leave];
//    [application beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"[APP CYCLE] applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    [_playerManager resetAudioHelper];
    NSLog(@"[APP CYCLE] applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"[APP CYCLE] applicationWillTerminate");
}

@end
