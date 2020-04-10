//
//  VideoViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/29/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "VideoViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ChatListView.h"
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#import "UIAlertController+Blocks.h"
@interface VideoViewController () <GSPPlayerManagerDelegate> {
    CGRect videoViewRect;//记录videoView的原始尺寸
    BOOL hasOrientation;
    UIAlertController *_alterVc;
}
@property (weak, nonatomic) IBOutlet UIView *videoArea;

@property (nonatomic, strong) Reachability *internetReachability;

@property (nonatomic, strong) GSPVideoView *videoView;
@property (nonatomic, strong) GSPVideoView *preView;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

//chatView
@property (nonatomic, strong) GSPChatInputToolView *inputView;

@property (nonatomic, strong) GSPChatView *chatView;

//@property (nonatomic, strong) UIButton *showListBtn;

//@property (nonatomic, strong) NSMutableArray *chatList_username_array;

//@property (nonatomic, strong) ChatListView *chatListView;

//@property (nonatomic) BOOL isChatListViewHidden;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UIAlertView *alert;

@end

@implementation VideoViewController
{
    int i;
    BOOL bRate;
    NSDateFormatter *_df;
    UIAlertController *_controller ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换比特率(Normal)" style:UIBarButtonItemStyleDone target:self action:@selector(switchRate:)];
    
    i = 0;
    
    hasOrientation = NO;
    
    self.playerManager.delegate = self;
    CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    [self.playerManager enableVideo:YES];
    [self.playerManager enableAudio:YES];
    //适配iOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        y = 0;
    }
    
    //Video View
//    videoViewRect = CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height/2);
    videoViewRect = _videoArea.bounds;
    _videoView = [[GSPVideoView alloc]initWithFrame:_videoArea.bounds];
    [self.videoArea addSubview:_videoView];
    self.playerManager.videoView = _videoView;

    _videoView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    _df = [[NSDateFormatter alloc] init ];
    [_df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    //双击 全屏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rotationVideoView:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [_videoView addGestureRecognizer:tapGestureRecognizer];
    //单击 收键盘
    UITapGestureRecognizer *singleGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    singleGestureRecognizer.numberOfTapsRequired = 1;
    [singleGestureRecognizer requireGestureRecognizerToFail:tapGestureRecognizer];
    [_videoView addGestureRecognizer:singleGestureRecognizer];

    _progressHUD = nil;
    
//    _chatView = [[GSPChatView alloc]initWithFrame:CGRectMake(0, _videoView.frame.origin.y + _videoView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - (_videoView.frame.origin.y + _videoView.frame.size.height) - 52)];
//    [self.view addSubview:_chatView];
//  
//    GSPChatInputToolView *inputView= [[GSPChatInputToolView alloc]initWithViewController:self combinedChatView:_chatView combinedQaView:nil isChatMode:YES];
//
//    
//    [self.view addSubview:inputView];
    
//    self.playerManager.chatView = _chatView;
    
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChatView:)];
    [_chatView addGestureRecognizer:_tapGestureRecognizer];
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)
//                                                 name:AVAudioSessionRouteChangeNotification
//                                               object:nil];
//    
//    
//    if  ([self isHeadsetPluggedIn])
//    {
//        
//        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
//        
//        [audioSession setActive:YES error:nil];
//
//    }
//    else
//    {
//        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
//        
//        [audioSession setActive:YES error:nil];
//
//    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
}


- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}





- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];

        switch (netStatus)
        {
            case NotReachable:        {
           
                break;
            }
                
            case ReachableViaWWAN:        {
                
//                [self.playerManager reconnect];
        
                
                
                break;
            }
            case ReachableViaWiFi:        {
                
//                [self.playerManager reconnect];
     
            }
        }
        
    }
}


- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveChatMessage:(GSPChatMessage *)message {
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager userInfo:(NSArray *)userInfos count:(unsigned int)count {
    
}


-(void)switchRate:(id)sender
{
    
    [self.playerManager getUserInfoById:@[[NSNumber numberWithLongLong:self.playerManager.selfUserInfo.userID]]];
    
    bRate = !bRate;
    [self.playerManager switchRate:bRate?GSRateLow:GSRateNormal];
    
    if (bRate) {
        self.navigationItem.rightBarButtonItem.title = @"切换比特率(Low)";
    }else{
        self.navigationItem.rightBarButtonItem.title = @"切换比特率(Normal)";
    }
}


// If the user pulls out he headphone jack, stop playing.
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification
{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"Headphone/Line plugged in");
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"Headphone/Line was pulled. Stopping player....");
            
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
            
            [audioSession setActive:YES error:nil];
            
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}


- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - videoView

- (void)rotationVideoView:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];//收起键盘
    //强制旋转
    if (!hasOrientation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            _videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            hasOrientation = YES;
            self.chatView.hidden = YES;
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            _videoView.frame = videoViewRect;
            hasOrientation = NO;
            self.chatView.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.navigationController.navigationBarHidden = NO;
        }];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - 
#pragma mark - chatView

- (void)hideChatView:(UIGestureRecognizer *)recognizer {

    [_inputView hideUserListView];
    _tapGestureRecognizer = nil;
    
    [self.view endEditing:YES];
}


#pragma mark - GSPPlayerManagerDelegate

- (void)playerManager:(GSPPlayerManager *)playerManager resultCode:(int)code userInfo:(GSPUserInfo *)userInfo
{
    
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
    _progressHUD = [[MBProgressHUD alloc] initWithView:_videoView];
    _progressHUD.labelText = NSLocalizedString(@"断线重连", @"");
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
    
    [self.view endEditing:YES];
    
}


//chatView
- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo {
    
}

//chatView
- (void)playerManager:(GSPPlayerManager *)playerManager didUserLeave:(GSPUserInfo *)userInfo {

}



/**
 *  收到聊天信息代理
 *
 *  @param playerManager 调用该代理的直播管理实例
 *  @param message       收到的聊天信息
 */
//- (void)playerManager:(GSPPlayerManager*)playerManager didReceiveChatMessage:(GSPChatMessage*)message
//{
//    
//    NSLog(@"didReceiveChatMessage******");
//    
//    
//}


/**
 *  直播是否暂停
 *
 *  @param playerManager 调用该代理的直播管理实例
 *  @param isPaused      YES表示直播已暂停，NO表示直播进行中
 */
- (void)playerManager:(GSPPlayerManager*)playerManager isPaused:(BOOL)isPaused
{
  
    NSLog(@"isPaused******");

}


/**
 *  收到音视频邀请
 *  @param playerManager 调用该代理的直播管理实例
 *  @param type          邀请类型
 *  @param on            打开或关闭
 */
- (void)playerManager:(GSPPlayerManager *)playerManager  didReceiveMediaInvitation:(GSPMediaInvitationType)type action:(BOOL)on
{
    NSLog(@"didReceiveMediaInvitation------");
    if (GSPMediaInvitationTypeAudioOnly == type) {
        if (on) {
            [self showAlterWithType:GSPMediaInvitationTypeAudioOnly message:@"直播间邀请您语音对话"];
        }else{
            [playerManager activateMicrophone:NO];
            [playerManager acceptMediaInvitation:NO type:type];
        }
    }else if (GSPMediaInvitationTypeVideoOnly == type) {
         if (on) {
             [self showAlterWithType:GSPMediaInvitationTypeVideoOnly message:@"直播间邀请您视频对话"];
         }else{
             [_preView removeFromSuperview];
             [playerManager activateCamera:NO];
             [playerManager acceptMediaInvitation:NO type:type];
         }
    }
}
-(void)showAlterWithType:(GSPMediaInvitationType)type message:(NSString *)message{
    [UIAlertController showAlertInViewController:self withTitle:nil  message:message cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==controller.cancelButtonIndex) {//取消
            if (type==GSPMediaInvitationTypeVideoOnly) {
                [_preView removeFromSuperview];
                [self.playerManager activateCamera:NO];
                [self.playerManager acceptMediaInvitation:NO type:GSPMediaInvitationTypeVideoOnly];
            }else if (type==GSPMediaInvitationTypeAudioOnly){
                [self.playerManager activateMicrophone:NO];
                [self.playerManager acceptMediaInvitation:NO type:GSPMediaInvitationTypeAudioOnly];
            }
        }else{//确认
            if (type==GSPMediaInvitationTypeVideoOnly) {
                [_preView removeFromSuperview];
//                _videoView = nil;
                _preView = [[GSPVideoView alloc]initWithFrame:videoViewRect];
                [self.videoArea addSubview:_preView];
                _preView.contentMode = UIViewContentModeScaleAspectFit;
                self.playerManager.previewVideoView = _preView;
                [self.playerManager activateCamera:YES];
                [self.playerManager acceptMediaInvitation:YES type:GSPMediaInvitationTypeVideoOnly];
            }else if (type==GSPMediaInvitationTypeAudioOnly){
                [self.playerManager activateMicrophone:YES];
                [self.playerManager acceptMediaInvitation:YES type:GSPMediaInvitationTypeAudioOnly];
            }
        }
    }];
}


////直播未开始返回
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 999 && buttonIndex == 1) {
//
//        [self.playerManager activateMicrophone:YES];
//        [self.playerManager acceptMediaInvitation:YES type:GSPMediaInvitationTypeAudioOnly];
//
//    }
//    else if (alertView.tag == 999 && buttonIndex == 0) {
//        [self.playerManager acceptMediaInvitation:NO type:GSPMediaInvitationTypeAudioOnly];
//    }
//}

- (void)playerManager:(GSPPlayerManager *)playerManager  didReceiveMediaScreenStatus:(BOOL)bIsOpen
{
    NSLog(@"didReceiveMediaScreenStatus=%d",bIsOpen);
    
}


- (void)playerManager:(GSPPlayerManager *)playerManager  didReceiveMediaModuleFocus:(GSModuleFocusType)focus
{

    NSLog(@"didReceiveMediaModuleFocus=%lu",(unsigned long)focus);
    
    
}


- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveRewardDic:(NSDictionary *)rewardDic{
    
}


- (IBAction)reward:(id)sender {
    
//    [self.playerManager rewardMoney:100 comment:@"hehe" payType:GSPayTypeAliPay expireTime:900 extra:nil];
}


- (IBAction)rename:(id)sender {
    [[GSPPlayerManager sharedManager]changeuserName:@"小 红@#$%!^()//??..,,"];
}
#pragma mark -

- (void)dealloc {
     [self.playerManager activateMicrophone:NO];
    [self.playerManager leave];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveBroadcastMessage:(GSPBroadcastMsg *)msg senderID:(long long)senderID {
    NSString *time =  [_df stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:(double)msg.sendTime]];
    if (_controller) {
        [_controller dismissViewControllerAnimated:NO completion:^{}];
        _controller = nil;
    }
    _controller = [UIAlertController alertControllerWithTitle:time message:msg.msg preferredStyle:UIAlertControllerStyleAlert];
    [_controller addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _controller = nil;
    }]];
    [self.navigationController presentViewController:_controller animated:YES completion:nil];
}
@end
