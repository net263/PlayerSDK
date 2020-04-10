//
//  ChatViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/29/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatListView.h"
#import "MBProgressHUD.h"

@interface ChatViewController ()<GSPPlayerManagerDelegate>

@property (nonatomic, strong) GSPChatInputToolView *inputView;

@property (nonatomic, strong) GSPChatView *chatView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation ChatViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.chatView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playerManager.delegate = self;
    [self.playerManager enableVideo:NO];
    [self.playerManager enableAudio:NO];
    
    _progressHUD = nil;
    
    CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    //适配iOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        y = self.navigationController.navigationBar.frame.size.height;
    }

//    CGRect portraitLargeRect = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*9/16);
////    _chatView.frame = CGRectMake(0, 0, self.view.bounds.size.width, SCREENHEIGHT - portraitLargeRect.size.height - 40 - _inputView.frame.size.height);
    _chatView = [[GSPChatView alloc]initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - y - 52)];
    
    [self.view addSubview:_chatView];
    
    
    _inputView = [[GSPChatInputToolView alloc]initWithViewController:self combinedChatView:_chatView combinedQaView:nil isChatMode:YES];

    
    [self.view addSubview:_inputView];
    
    self.playerManager.chatView = _chatView;
  
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChatView:)];
    [_chatView addGestureRecognizer:_tapGestureRecognizer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark GSPPlayerManagerDelegate

- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo {
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserLeave:(GSPUserInfo *)userInfo {

}


- (void)playerManager:(GSPPlayerManager *)playerManager didSelfLeaveFor:(GSPLeaveReason)reason {
    NSString *reasonStr = nil;
    switch (reason) {
        case GSPLeaveReasonEjected:
            reasonStr = NSLocalizedString(@"被踢出直播", @"");
            break;
        case GSPLeaveReasonTimeout:
            reasonStr = NSLocalizedString(@"超时", @"");
            break;
        case GSPLeaveReasonClosed:
            reasonStr = NSLocalizedString(@"直播关闭", @"");
            break;
        case GSPLeaveReasonUnknown:
            reasonStr = NSLocalizedString(@"位置错误", @"");
            break;
        default:
            break;
    }
    if (reasonStr != nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"退出直播", @"") message:reasonStr delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", @"") otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveSelfJoinResult:(GSPJoinResult)joinResult {
    NSString *result = @"";
    switch (joinResult) {
        case GSPJoinResultCreateRtmpPlayerFailed:
            result = NSLocalizedString(@"创建直播实例失败", @"");
            break;
        case GSPJoinResultJoinReturnFailed:
            result = NSLocalizedString(@"调用加入直播失败", @"");
            break;
        case GSPJoinResultNetworkError:
            result = NSLocalizedString(@"网络错误", @"");
            break;
        case GSPJoinResultUnknowError:
            result = NSLocalizedString(@"未知错误", @"");
            break;
        case GSPJoinResultParamsError:
            result = NSLocalizedString(@"参数错误", @"");
            break;
        case GSPJoinResultOK:
            result = @"加入成功";
            break;
        case GSPJoinResultCONNECT_FAILED:
            result = NSLocalizedString(@"连接失败", @"");
            break;
        case GSPJoinResultTimeout:
            result = NSLocalizedString(@"连接超时", @"");
            break;
        case GSPJoinResultRTMP_FAILED:
            result = NSLocalizedString(@"链接媒体服务器失败", @"");
            break;
        case GSPJoinResultTOO_EARLY:
            result = NSLocalizedString(@"直播尚未开始", @"");
            break;
        case GSPJoinResultLICENSE:
            result = NSLocalizedString(@"人数已满", @"");
            break;
        default:
            result = NSLocalizedString(@"错误", @"");
            break;
    }
    
    //用于断线重连
    if (_progressHUD != nil) {
        [_progressHUD hide:YES];
        _progressHUD = nil;
    }
    
    UIAlertView *alertView;
    if ([result isEqualToString:@"加入成功"]) {
    } else {
        alertView = [[UIAlertView alloc] initWithTitle:result message:NSLocalizedString(@"请退出重试", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", @"") otherButtonTitles:nil];
        [self.view addSubview:alertView];
        [alertView show];
    }
    
    
}

- (void)playerManagerWillReconnect:(GSPPlayerManager *)playerManager {
    _progressHUD = [[MBProgressHUD alloc] initWithView:_chatView];
    _progressHUD.labelText = NSLocalizedString(@"断线重连", @"");
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
    
    [self.view endEditing:YES];
    

}


//广播消息
- (void)playerManager:(GSPPlayerManager*)playerManager didReceiveBroadcastEntity:(GSPBroadcastMsg*)msg senderID:(long long)senderID  {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:msg.sendTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"广播消息" message:[NSString stringWithFormat:@"%@:%@",[formatter stringFromDate:date],msg.msg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}


/**
 *  收到聊天信息代理
 *
 *  @param playerManager 调用该代理的直播管理实例
 *  @param message       收到的聊天信息
 */
- (void)playerManager:(GSPPlayerManager*)playerManager didReceiveChatMessage:(GSPChatMessage*)message
{

    NSLog(@"didReceiveChatMessage******");


}






#pragma mark - hidden chatListView
- (void)hideChatView:(UIGestureRecognizer *)recognizer {
    
    [_inputView hideUserListView];
    [self.view endEditing:YES];
}



#pragma mark -
- (void)dealloc {
    [self.playerManager leave];
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
