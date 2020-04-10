//
//  InvestigationViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/29/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "InvestigationViewController.h"
#import "MBProgressHUD.h"

@interface InvestigationViewController () <GSPPlayerManagerDelegate>

@property (nonatomic, strong) GSPInvestigationView *investigationView;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation InvestigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.playerManager enableVideo:NO];
    [self.playerManager enableAudio:NO];
    
    self.playerManager.delegate = self;
    
    //自定义返回按钮
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回",@"") style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    _investigationView = [[GSPInvestigationView alloc]initWithFrame:CGRectZero];
    _investigationView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_investigationView];
    
    CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    
    //适配iOS6
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        y = 0;
    }
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_investigationView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_investigationView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat: @"V:|-%f-[_investigationView]|", y] options:0 metrics:0 views:NSDictionaryOfVariableBindings(_investigationView)]];
    
    self.playerManager.investigationView = _investigationView;
    
    
}

- (void)backButtonClick {
    if (_investigationView.hasForceInvestigation) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"强制投票","") message:NSLocalizedString(@"不能返回，请投票",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil];
        [alertView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    [self.playerManager leave];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)playerManagerWillReconnect:(GSPPlayerManager *)playerManager {
    _progressHUD = [[MBProgressHUD alloc] initWithView:_investigationView];
    _progressHUD.labelText = NSLocalizedString(@"断线重连", @"");
    [self.view addSubview:_progressHUD];
    [_progressHUD show:YES];
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
- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo {
    //用于断线重连
    if (_progressHUD != nil) {
        [_progressHUD hide:YES];
        _progressHUD = nil;
    }
}

- (void)playerManager:(GSPPlayerManager *)playerManager onThirdVoteUrl:(NSString *)urlStr {
    NSLog(@"onThirdVoteUrl : %@",urlStr);
}

#pragma mark -
#pragma mark GSPInvestigationDelegate

- (BOOL)submitInvestigation:(NSString *)xmlString
{
    return [self.playerManager submitInvestigation:xmlString];
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
