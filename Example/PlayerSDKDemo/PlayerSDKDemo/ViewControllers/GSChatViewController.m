//
//  GSChatViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSChatViewController.h"
#import "GSChatView.h"
@interface GSChatViewController () <GSPPlayerManagerDelegate>
//test
@property (nonatomic, strong) NSTimer *testTimer;
@property (nonatomic, assign) unsigned long i;
//
@property (nonatomic, strong) GSChatView *chatView;
//
@property (nonatomic, strong) MBProgressHUD *bufferHud;

@end

@implementation GSChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"聊天性能测试" style:UIBarButtonItemStyleDone target:self action:@selector(test)];
    
    self.chatView = [[GSChatView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
    
    [self.view addSubview:self.chatView];
    
}

- (void)didPlayerJoinSuccess {
    //这里由于demo需要单独功能演示，故去掉音视频数据
    [[GSPPlayerManager sharedManager] enableVideo:NO];
    [[GSPPlayerManager sharedManager] enableAudio:NO];
}

- (void)test {
    if (_testTimer.isValid) {
        [_testTimer invalidate];
        _testTimer = nil;
    } else {
        _testTimer = [NSTimer timerWithTimeInterval:0.3f
                                         target:self
                                       selector:@selector(makeFakeChatMsg)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_testTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)makeFakeChatMsg {
    //这个方法仅用于测试单位时间内聊天数量时fps卡顿，请勿理解为聊天数据发出
    GSPChatMessage *testMsg = [GSPChatMessage new];
    testMsg.richText = [NSString stringWithFormat:@"这是一条测试消息:<IMG src=\"emotion\\emotion.se.gif\" custom=\"false\"> %lu", _i++];
    testMsg.senderName = @"测试人员";
    [self playerManager:[GSPPlayerManager sharedManager] didReceiveChatMessage:testMsg];
}

- (void)playerManager:(GSPPlayerManager *)playerManager isPaused:(BOOL)isPaused {
    NSString *info = isPaused ? @"直播已暂停" : @"直播进行中";
    self.title = info;
}

//- (void)playerManagerWillBuffer:(GSPPlayerManager *)playerManager isBuffering:(BOOL)isBuffering {
//    if (isBuffering) {
//        _bufferHud = [MBProgressHUD showMessage:@"正在缓冲..."];
//    }else{
//        if (_bufferHud) {
//            [_bufferHud hide:YES];
//            _bufferHud = nil;
//        }
//    }
//}

//直播间是否允许聊天
- (void)playerManager:(GSPPlayerManager *)playerManager didSetChatEnable:(BOOL)bEnable {
    if (!bEnable) {
        NSString *info = bEnable ? @"直播间允许聊天":@"直播间禁止聊天";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:info preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)playerManager:(GSPPlayerManager*)playerManager isSelfMute:(BOOL)bMute {//自己是否被禁止聊天和问答
    NSString *info = bMute ? @"你已被禁言":@"你的禁言被取消";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:info preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//接收聊天,聊天可能会很频繁，但是不宜刷新界面太频繁,这里没有优化
- (void)playerManager:(GSPPlayerManager*)playerManager didReceiveChatMessage:(GSPChatMessage *)message {
    GSChatModel *model = [[GSChatModel alloc]initWithModel:message type:message.chatType];
    [self.chatView insert:model];
}

- (void)playerManager:(GSPPlayerManager *)playerManager OnChatcensor:(NSString *)strType msgID:(NSString *)strMsgId {
    if ([strType isEqualToString:@"msg"]) {
        [self.chatView removeByMessage:strMsgId];
    } else {
        [self.chatView removeByUser:strMsgId];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
