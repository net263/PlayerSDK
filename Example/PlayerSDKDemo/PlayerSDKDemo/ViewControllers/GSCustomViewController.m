//  GSCustomViewController.m
//  PlayerSDKDemo
//  Created by Sheng on 2018/9/6.
//  Copyright © 2018年 Geensee. All rights reserved.
#import "GSCustomViewController.h"
#import "Reachability.h"
@interface GSCustomViewController () <GSPPlayerManagerDelegate>
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) Reachability *internetReachability;
@end
@implementation GSCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.manager = [GSPPlayerManager sharedManager];
    [GSPPlayerManager sharedManager].delegate =self;
    BOOL br = [[GSPPlayerManager sharedManager] joinWithParam:self.param];
    if (!br) {
        [MBProgressHUD showHint:@"直播参数不正确"];
        [self popAction];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}
static UIAlertController *alertC = nil;

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable:{
                UIAlertController *alertC1 = [UIAlertController alertControllerWithTitle:@"" message:@"当前无网络！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertC1 addAction:action];
                [self presentViewController:alertC1 animated:YES completion:nil];
                alertC = alertC1;
                break;
            }
                
            case ReachableViaWWAN:{
                UIAlertController *alertC1 = [UIAlertController alertControllerWithTitle:@"" message:@"当前是移动网络,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"是" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[GSPPlayerManager sharedManager] leave];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertC1 addAction:action];
                [alertC1 addAction:action1];
                [self presentViewController:alertC1 animated:YES completion:nil];
                
                alertC = alertC1;
                
                break;
            }
            case ReachableViaWiFi:{
                if (alertC) {
                    [alertC dismissViewControllerAnimated:NO completion:nil];
                }
            }
        }
        
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    [self updateInterfaceWithReachability:curReach];
}

- (void)popAction {
    [[GSPPlayerManager sharedManager] leave];
    [self didPlayerleave];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPlayerJoinSuccess {
    
}

- (void)didPlayerleave {
    
}

#pragma mark GSPPlayerManagerDelegate

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveSelfJoinResult:(GSPJoinResult)joinResult
{
    if (_hud){
        [_hud hide:YES];
    }
    
    if (joinResult == GSPJoinResultOK) {
        
        [self didPlayerJoinSuccess];
        return;
    }
    
    if (joinResult != GSPJoinResultOK) {
        
        NSString *failedString;
        if  (joinResult == GSPJoinResultNetworkError) {
            failedString = NSLocalizedString(@"网络错误",@"");
            
        }else if  (joinResult == GSPJoinResultTOO_EARLY) {
            failedString = NSLocalizedString(@"直播尚未开始",@"");
            
        }else if (joinResult == GSPJoinResultLICENSE) {
            failedString = NSLocalizedString(@"人数已满",@"");
            
        }else if (joinResult == GSPJoinResultTimeout) {
            failedString = NSLocalizedString(@"连接超时",@"");
            
        }else if (joinResult == GSPJoinResultParamsError) {
            failedString = NSLocalizedString(@"参数错误",@"");
            
        }else if (joinResult == GSPJoinResultREJOIN) {
            failedString = NSLocalizedString(@"重复加入",@"");
            
        }else if (joinResult == GSPJoinResultRTMP_FAILED) {
            failedString = NSLocalizedString(@"链接媒体服务器失败",@"");
            
        }else if (joinResult == GSPJoinResultIP_FORBID) {
            failedString = NSLocalizedString(@"ip被封禁",@"");
            
        }else if (joinResult == GSPJoinResultCONNECT_FAILED) {
            failedString = NSLocalizedString(@"连接失败",@"");
            
        }else if (joinResult == GSPJoinResultWebcastIDInvalid) {
            failedString = NSLocalizedString(@"webcastID错误",@"");
            
        }else if (joinResult == GSPJoinResultJoinCastPasswordError) {
            failedString = NSLocalizedString(@"加会口令错误",@"");
            
        }else if (joinResult == GSPJoinResultRoomExpired) {
            failedString = NSLocalizedString(@"直播过期",@"");
            
        }else if(joinResult == GSPJoinGroupCodeInvalid)
        {
            failedString = NSLocalizedString(@"分课的分组编号非法",@"");
        }else{
            failedString = [NSString stringWithFormat:@"加入直播错误:%ld",joinResult];
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:failedString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了",@"") style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[GSPPlayerManager sharedManager] leave];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        //
    }
}

- (void)playerManager:(GSPPlayerManager *)playerManager didSelfLeaveFor:(GSPLeaveReason)reason {
    if (_hud) [_hud hide:YES];
    NSString *message;
    if (reason == GSPLeaveReasonEjected) {
        message = NSLocalizedString(@"抱歉，您已被组织者踢出" ,@"");
    }else if (reason ==GSPLeaveReasonClosed) {
        message = NSLocalizedString(@"本次直播已结束，谢谢观看",@"");
    }else if(reason == GSPLeaveReasonReLogin){
        message = NSLocalizedString(@"在其它地方登陆" ,@"");
    }else if (reason == GSPLeaveReasonTimeout) {
        message = NSLocalizedString(@"超时" ,@"");
    }else if(reason == GSPLeaveReasonUnknown) {
        message = NSLocalizedString(@"未知错误" ,@"");
    }else if(reason == GSPLeaveReasonNormal){
        NSLog(@"自行退出");
        message = NSLocalizedString(@"您已经断开与该直播间的连接" ,@"");
        //        [_hud hide:YES];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else {
        message = NSLocalizedString(@"错误退出" ,@"");
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];//先隐藏已经显示的HUD
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了" ,@"") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertC addAction:action];
    
    
    
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)playerManagerWillReconnect:(GSPPlayerManager *)playerManager {
    _hud = [MBProgressHUD showMessage:@"断线重连中..."];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveBroadcastMessage:(GSPBroadcastMsg *)msg senderID:(long long)senderID {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time =  [format stringFromDate:[[NSDate alloc]initWithTimeIntervalSince1970:(double)msg.sendTime]];
    //接收到广播消息
    
    GSPBroadcastMsg *message = [msg copy];
    
    [MBProgressHUD showHint:[NSString stringWithFormat:@"%@ : %@",time,message.msg]];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo
{
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserLeave:(GSPUserInfo *)userInfo
{
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserStatusChange:(GSPUserInfo *)userInfo
{
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveSubjectInfo:(NSString *)subject
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)playerManager:(GSPPlayerManager *)playerManager onDoubleTeacherStatusChange:(GSDTStatus)satus
{
    NSString *subMsg = @"正在进入名师课堂";
    if(satus == GSSubClassStatus)
    {
        subMsg = @"正在进入分课堂";
    }
    
    _hud = [MBProgressHUD showMessage:subMsg];
}

@end
