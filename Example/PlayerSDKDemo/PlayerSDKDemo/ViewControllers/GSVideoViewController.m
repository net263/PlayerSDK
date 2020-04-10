//
//  GSVideoViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSVideoViewController.h"
#import "UIView+GSSetRect.h"
#import "UIAlertController+Blocks.h"
#import <GSCommonKit/GSCommonKit.h>
#import "InfoEditViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface GSVideoViewController () <GSPPlayerManagerDelegate,GSDocViewDelegate>

@property (nonatomic, strong) UIView *videoArea;
@property (nonatomic, strong) UIView *cameraArea;
@property (nonatomic, strong) UIView *docArea;

@property (nonatomic, strong) GSPVideoView *videoView;
@property (nonatomic, strong) GSPVideoView *preView;

@property (nonatomic, strong) GSDocView *docView;
@property (nonatomic, weak) GSPUserInfo *userInfo;

//audioPlayer test
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) GSTagsContentView* tagContent;
@property (nonatomic, strong) UILabel *layoutShow;
@property (nonatomic, strong) UITextField *textfield;

@end

@implementation GSVideoViewController
{
    BOOL bRate;
    //结构体 位域
    struct {
        unsigned int isFullScreen : 1;  //是否全屏 1位
        unsigned int isDocFullScreen : 1;
        unsigned int isVideoFullScreen : 1;
    } _state;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换比特率(Normal)" style:UIBarButtonItemStyleDone target:self action:@selector(switchRate:)];
    
    CGFloat top = 64 + 5 + UIView.additionaliPhoneXTopSafeHeight;
    
    _videoArea = [[UIView alloc] initWithFrame:CGRectMake(5, top, Width - 10, (Width - 10)*9/16)];
    _videoArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_videoArea];
    top = _videoArea.bottom + 10;
    
    
    
    self.videoView = [[GSPVideoView alloc]initWithFrame:_videoArea.bounds renderMode:GSVideoRenderOpenGL];
//    _videoView.contentMode = UIViewContentModeScaleToFill;
    UIView *view = [self.videoView valueForKey:@"_sdlglView"];
    view.contentMode = UIViewContentModeScaleAspectFit;
    _videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoArea addSubview:_videoView];
    
    //to fix autolayout case if you need
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)]];
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGR.numberOfTapsRequired = 2;
    [_videoArea addGestureRecognizer:tapGR];
    self.manager.videoView = _videoView;
    
    _cameraArea = [[UIView alloc] initWithFrame:CGRectMake(5, top, Width/2 - 10, (Width/2 - 10)*3/4)];
    //    _cameraArea.layer.cornerRadius         = 3.f;
    _cameraArea.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
    _cameraArea.layer.borderWidth          = 0.5f;
    _cameraArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_cameraArea];
    
    
    _docArea = [[UIView alloc] initWithFrame:CGRectMake((Width/2 - 10) + 10, top, Width/2 - 10, (Width/2 - 10)*3.0/4)];
    _docArea.layer.borderColor          = UICOLOR16(0x009BD8).CGColor;
    _docArea.layer.borderWidth          = 0.5f;
    _docArea.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_docArea];
    _docView = [[GSDocView alloc]initWithFrame:_docArea.bounds];
    _docView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [_docView setBackgroundColor:0.5 green:0.5 blue:0];
    self.docView.showMode = GSDocViewShowModeWidthFit;
    [_docArea addSubview:_docView];
    self.docView.delegate = self;
    
    
    
    //to fix autolayout case if you need
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(docTapAction:)];
    tapGR1.numberOfTapsRequired = 2;
    [_docArea addGestureRecognizer:tapGR1];
    top = top + _docArea.height + 5;
    // 注意下列代码的顺序
    NSLog(@"self.docView=%@",self.docView);  //打印一下
    self.manager.docView = self.docView;
    __weak typeof(self) wself = self;  //must use wself 
    _tagContent = [[GSTagsContentView alloc] initWithFrame:CGRectMake(5, top, Width - 10, 30) tags:@[@"修改昵称",@"播放音频文件Wav测试",@"推出Navigation视图",@"切换前后摄像头",@"接收前台通知"] handler:^(NSInteger index, NSString *text, BOOL isSelect) {
        switch (index) {
            case 0:
                {
                    if (wself.userInfo) {
                        InfoEditViewController *new = [[InfoEditViewController alloc] initWithChangeInfo:wself.userInfo.userName Completion:^(NSString *result) {
                            BOOL success = [[GSPPlayerManager sharedManager] changeuserName:result];
                            if (success) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [MBProgressHUD showHint:@"修改成功"];
                                });
                            }
                        }];
                        [wself.navigationController pushViewController:new animated:YES];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD showHint:@"还在加入直播中..."];
                        });
                    }

                }
                break;
            case 1:
            {
                if (!wself.audioPlayer) {
                    NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"shake_something" ofType:@"wav"];
                    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
                    //初始化播放器对象
                    wself.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundUrl error:nil];
                    //设置声音的大小
                    wself.audioPlayer.volume = 0.5;//范围为（0到1）；
                    //设置循环次数，如果为负数，就是无限循环
                    wself.audioPlayer.numberOfLoops = 1;
                    //设置播放进度
                    wself.audioPlayer.currentTime = 0;
                    //准备播放
                }

                [wself.audioPlayer prepareToPlay];
                [wself.audioPlayer play];
            }
                break;
            case 2:
            {
                UIViewController *test = [[UIViewController alloc] init];
                [wself.navigationController pushViewController:test animated:YES];
            }
                break;
            case 3:
            {
                [[GSPPlayerManager sharedManager] rotateCamera];
            }
                break;
            case 4:
            {
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
            default:
                break;
        }
    }];
    [self.view addSubview:_tagContent];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(5, _tagContent.bottom + 5, Width - 10, 30)];
    textfield.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:textfield];
    _textfield = textfield;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotationAction) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    _layoutShow = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 40, 20)];
    _layoutShow.layer.cornerRadius = 5;
    _layoutShow.clipsToBounds = YES;
    _layoutShow.textAlignment = NSTextAlignmentCenter;
    _layoutShow.userInteractionEnabled = NO;
    _layoutShow.backgroundColor = [UIColor whiteColor];
    _layoutShow.text = @"布局显示";
    _layoutShow.font = [UIFont systemFontOfSize:14.f];
    _layoutShow.textColor = [UIColor blackColor];
    [_layoutShow sizeToFit];
    _layoutShow.width += 5;
    _layoutShow.height += 5;
    [self.view addSubview:_layoutShow];
}

- (void)rotationAction {
    UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
    
    if (statusOrient == UIInterfaceOrientationLandscapeRight){
        _state.isFullScreen = 1;
        [self.manager setCameraOrientation:YES];
        
//        _display.hidden = YES;
//        _speaker.hidden = YES;
        
        self.navigationController.navigationBar.hidden = YES;
        CGRect full = CGRectMake(0, 0, Width, Height);
        CGRect lsmall = CGRectMake(5, 5, Width/3 - 10, (Width/3 - 10)*3.0/4);
        CGRect rsmall = CGRectMake(Width - (Width/3 - 10) - 5, 5, Width/3 - 10, (Width/3 - 10)*3.0/4);
        if (_state.isVideoFullScreen) {
            _videoArea.frame = full;
            _cameraArea.frame = lsmall;
            _docArea.frame = rsmall;
            [self.view bringSubviewToFront:_docArea];
            [self.view bringSubviewToFront:_cameraArea];
        }else if (_state.isDocFullScreen){
            _docArea.frame = full;
            _cameraArea.frame = lsmall;
            _videoArea.frame = rsmall;
            [self.view bringSubviewToFront:_videoArea];
            [self.view bringSubviewToFront:_cameraArea];
        }
//        _videoView.frame = _videoArea.bounds;
        _preView.frame = _cameraArea.bounds;
//        _docView.frame = _docArea.bounds;
        
        _layoutShow.x = 10;
        _layoutShow.y = 30;
        
        [self.view bringSubviewToFront:_layoutShow];
    }else if (statusOrient == UIInterfaceOrientationPortrait){
        _state.isFullScreen = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.manager setCameraOrientation:NO];
        self.navigationController.navigationBar.hidden = NO;
        CGFloat top = 64 + 5 + UIView.additionaliPhoneXTopSafeHeight;
        _videoArea.frame = CGRectMake(5, top, Width - 10, (Width - 10)*3.0/4);
//        _videoView.frame = _videoArea.bounds;
        top = _videoArea.bottom + 5;
        _cameraArea.frame = CGRectMake(5, top, Width/2 - 10, (Width/2 - 10)*3.0/4);
        _preView.frame = _cameraArea.bounds;
        _docArea.frame = CGRectMake((Width/2 - 10) + 10, top, Width/2 - 10, (Width/2 - 10)*3.0/4);
//        _docView.frame = _docArea.bounds;
        _tagContent.top = _docArea.bottom + 5;
        _textfield.top = _tagContent.bottom + 5;
        _layoutShow.x = 10;
        _layoutShow.y = 74;
        [self.view bringSubviewToFront:_layoutShow];
    }
    
}

- (void)tapAction:(UIGestureRecognizer *)sender {
    if (_state.isDocFullScreen) {
        return;
    }
    if (_state.isFullScreen) {
        _state.isVideoFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
    }else{
        _state.isVideoFullScreen = 1;
        [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
    }
}

- (void)docTapAction:(UIGestureRecognizer *)sender {
    if (_state.isVideoFullScreen) {
        return;
    }
    if (_state.isFullScreen) {
        _state.isDocFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
    }else{
        _state.isDocFullScreen = 1;
        [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
    }
}

- (void)updateScreenOriention:(UIDeviceOrientation)oriention{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = oriention;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)didPlayerJoinSuccess {
    _userInfo = [GSPPlayerManager sharedManager].selfUserInfo;
}


- (void)didPlayerleave {
    _videoView = nil;
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    _preView = nil;
    _userInfo = nil;
    [GSPPlayerManager sharedManager].videoView = nil;
}

- (void)switchRate:(id)sender
{
    [self.manager getUserInfoById:@[[NSNumber numberWithLongLong:self.manager.selfUserInfo.userID]]];
    
    bRate = !bRate;
    [self.manager switchRate:bRate?GSRateLow:GSRateNormal];
    
    if (bRate) {
        self.navigationItem.rightBarButtonItem.title = @"切换比特率(Low)";
    }else{
        self.navigationItem.rightBarButtonItem.title = @"切换比特率(Normal)";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
//            [playerManager activateMicrophone:NO];
            [playerManager acceptMediaInvitation:NO type:type];
        }
    }else if (GSPMediaInvitationTypeVideoOnly == type) {
        if (on) {
            [self showAlterWithType:GSPMediaInvitationTypeVideoOnly message:@"直播间邀请您视频对话"];
        }else{
            [_preView removeFromSuperview];
            [playerManager acceptMediaInvitation:NO type:type];
        }
    }
}
-(void)showAlterWithType:(GSPMediaInvitationType)type message:(NSString *)message{
    [UIAlertController showAlertInViewController:self withTitle:nil  message:message cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==controller.cancelButtonIndex) {//取消
            if (type==GSPMediaInvitationTypeVideoOnly) {
                [_preView removeFromSuperview];
                [self.manager acceptMediaInvitation:NO type:GSPMediaInvitationTypeVideoOnly];
            }else if (type==GSPMediaInvitationTypeAudioOnly){
                [self.manager acceptMediaInvitation:NO type:GSPMediaInvitationTypeAudioOnly];
            }
        }else{//确认
            if (type==GSPMediaInvitationTypeVideoOnly) {
                [_preView removeFromSuperview];
                //                _videoView = nil;
                _preView = [[GSPVideoView alloc]initWithFrame:self.cameraArea.bounds];
                [self.cameraArea addSubview:_preView];
                _preView.contentMode = UIViewContentModeScaleAspectFit;
                self.manager.previewVideoView = _preView;
                [self.manager acceptMediaInvitation:YES type:GSPMediaInvitationTypeVideoOnly];
            }else if (type==GSPMediaInvitationTypeAudioOnly){
                [self.manager acceptMediaInvitation:YES type:GSPMediaInvitationTypeAudioOnly];
            }
        }
    }];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveVideoData:(const unsigned char *)data height:(int)height width:(int)width {
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveMediaModuleFocus:(GSModuleFocusType)focus {
    if (focus == 2) {
        _state.isDocFullScreen = 1;
        _state.isVideoFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
    }else if (focus == 1) {
        _state.isVideoFullScreen = 1;
        _state.isDocFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
        
        
    }else if (focus == 3) {
        _state.isVideoFullScreen = 0;
        _state.isDocFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
        
    }
    NSString *hint;
    switch (focus) {
        case 0:
            hint = @"文档为主(0)[暂未适配]";
            break;
        case 1:
            hint = @"视频最大化(1)";
            break;
        case 2:
            hint = @"文档最大化(2)";
            break;
        case 3:
            hint = @"视频为主(3)";
            break;
        default:
            break;
    }
    
    [_layoutShow setText:hint];
    [_layoutShow sizeToFit];
    _layoutShow.width += 5;
    _layoutShow.height += 5;
}

#pragma mark - rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeRight;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
