//
//  GSVodPlayerController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodPlayerController.h"
#import "UIView+GSSetRect.h"
#import "GSVodPlayerBar.h"
#import "GSMenu.h"
#import <GSCommonKit/GSCommonKit.h>
//#import "GSVodQueueController.h"
#import "GSVodChatView.h"
#import "GSItemBar.h"
#import "GSVodSwitchView.h"
#import "GSVodPlayerController+Notification.h"
#import "GSVodChatModel.h"

#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]



@interface GSVodPlayerController () <GSVodPlayerBarDelegate,GSDocViewDelegate,VodPlayDelegate>

@property (nonatomic, strong) GSVodPlayerBar *playerBar;
@property (nonatomic, strong) VodGLView *vodView;
@property (nonatomic, strong) UIView *videoArea;
@property (nonatomic, strong) UIView *docArea;
@property (nonatomic, strong) GSDocView *docView;
@property (nonatomic, strong) VodPlayer *vodPlayer;
@property (nonatomic, strong) GSVodChatView *chatView;
@property (nonatomic, assign) int msgCount;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) GSVodSwitchView *switchView;
/**
 栏目选择bar
 */
@property (nonatomic, strong) GSItemBar *itemBar;
/**
 屏幕布局提示控件
 */
@property (nonatomic, strong) UILabel *layoutShow;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GSVodPlayerController
{
    //结构体 位域
    struct {
        unsigned int isFullScreen : 1;  //是否全屏 1位
        unsigned int isDocFullScreen : 1;
        unsigned int isVideoFullScreen : 1;
        unsigned int isRotation : 1;
    } _state;
    BOOL isPlayEnd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放界面";
    self.view.backgroundColor = [UIColor whiteColor];
    _vodPlayer = [GSVodManager sharedInstance].player;
    //注意这段代码的顺序必须在_vodView.contentMode = UIViewContentModeScaleAspectFit;之前配置可能会影响视频的显示模式
    
    
    _vodView = [[VodGLView alloc] initWithFrame:CGRectMake(0, 0, Width, ceil(Width*9/16)) renderMode:_renderMode];
    _vodView.backgroundColor = [UIColor blackColor];
    _vodView.contentMode = _videoMode;
    _vodView.translatesAutoresizingMaskIntoConstraints = NO;
    _videoArea = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Width, ceil(Width*9/16))];
    //    _videoArea.backgroundColor = [UIColor greenColor];
    [_videoArea addSubview:_vodView];
    
    [self.view addSubview:_videoArea];
    
    //to fix autolayout case if you need
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_vodView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_vodView)]];
    [_videoArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_vodView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_vodView)]];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tapGR.numberOfTapsRequired = 2;
    [_videoArea addGestureRecognizer:tapGR];
    
    _playerBar = [[GSVodPlayerBar alloc] initWithFrame:CGRectMake(0, _videoArea.bottom, Width, 38)];
    _playerBar.delegate = self;
    [self.view addSubview:_playerBar];
    
    
    __weak typeof(self) wself = self;
    _itemBar = [[GSItemBar alloc] initWithFrame:CGRectMake(0, _playerBar.bottom, Width, 40) style:@[@"文档",@"聊天",@"点播切换"] event:^(int index) {
        switch (index) {
            case 0:{
                [wself.scrollView setContentOffset:CGPointMake(0, 0)];
            }
                break;
            case 1:{
                [wself.scrollView setContentOffset:CGPointMake(Width, 0)];
                [wself.scrollView setNeedsDisplay];
            }
                break;
            case 2:{
                [wself.scrollView setContentOffset:CGPointMake(Width*2, 0)];
            }
                break;
            default:
                break;
        }
    }];
    [self.view addSubview:_itemBar];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _itemBar.bottom, Width, Height - CGRectGetMaxY(_itemBar.frame))];
    _scrollView.contentSize = CGSizeMake(Width * 3, Height);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    _docArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - CGRectGetMaxY(_itemBar.frame))];
    
    _docView = [[GSDocView alloc] initWithFrame:CGRectMake(0, 5, Width, Height - CGRectGetMaxY(_itemBar.frame))];
    _docView.delegate = self;
    _docView.showMode = GSDocViewShowModeScaleAspectFit;
    _docView.translatesAutoresizingMaskIntoConstraints = NO;
    //    [_docView setBackgroundColor:51 green:51 blue:51]; //文档加载以后，侧边显示的颜色
    [self.view addSubview:_docArea];
    [_docArea addSubview:_docView];
    
    //    //to fix autolayout case if you need
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    [_docArea addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_docView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_docView)]];
    
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(docTapAction:)];
    tapGR1.numberOfTapsRequired = 2;
    [_docArea addGestureRecognizer:tapGR1];
    
    [_scrollView addSubview:_docArea];
    
    
    _chatView = [[GSVodChatView alloc] initWithFrame:CGRectMake(Width, 0, Width, Height - CGRectGetMaxY(_itemBar.frame))];
    [_scrollView addSubview:_chatView];
    
    _switchView = [[GSVodSwitchView alloc] initWithFrame:CGRectMake(Width*2, 0, Width, Height - CGRectGetMaxY(_itemBar.frame))];
    NSArray *items = [[VodManage shareManage] getListDownItem];
    _switchView.dataModelArray = [NSMutableArray arrayWithArray:items];
    [_switchView.dataModelArray addObject:_item];
    [_scrollView addSubview:_switchView];
    
    GSTagsContentView *tagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(10, Height - 40, Width - 20, 30) tags:@[@"日志上传"] handler:^(NSInteger index, NSString *text, BOOL isSelect) {
        if (index == 0) {
            __block MBProgressHUD *hud = nil;
            [GSDiagnosisInfo shareInstance].upLoadResult = ^(GSDiagnosisType type, NSString *errorDescription) {
                [hud hide:YES];
                if (type == GSDiagnosisUploadSuccess) {
                    [MBProgressHUD showHint:@"上传成功"];
                }else if (type == GSDiagnosisUploadNetError) {
                    [MBProgressHUD showHint:@"文件上传发生错误"];
                }else if (type == GSDiagnosisPackError) {
                    [MBProgressHUD showHint:@"文件打包出错"];
                }else if (type==GSDiagnosisSubmitXMLInfoError){
                    [MBProgressHUD showHint:@"提交回执数据出错"];
                }
                hud = nil;
            };
            
            [[GSDiagnosisInfo shareInstance] ReportDiagonseEx];
            hud = [MBProgressHUD showMessage:@"发送日志中"];
        }else if (index == 1) {
            
        }
    }];
    tagView.allowSelect = NO;
    [self.view addSubview:tagView];
    
    _vodPlayer.docSwfView = _docView;
    _vodPlayer.mVideoView = _vodView;
    _vodPlayer.delegate = self;
    isPlayEnd = YES;
    if (isPlayEnd) {
        //        [[GSVodManager sharedInstance] play:_item online:_isOnline];
        [GSVodManager sharedInstance].player.playItem = _item;
        if (_isOnline) {
            [[GSVodManager sharedInstance].player OnlinePlay:YES audioOnly:NO];
        }else {
            [[GSVodManager sharedInstance].player OfflinePlay:YES];
        }
        
        _playerBar.isPlay = YES;
        isPlayEnd = NO;
    }
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    //    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"1X" style:UIBarButtonItemStylePlain target:self action:@selector(speedAction)];
    //    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    
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

- (void)pushNotification {
    [self pushNewNotification];
}

- (void)rotationAction {
    UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
    
    if (statusOrient == UIInterfaceOrientationLandscapeRight){
        _state.isFullScreen = 1;
        [_docArea removeFromSuperview];
        [self.view addSubview:_docArea];
        self.navigationController.navigationBar.hidden = YES;
        CGRect full = CGRectMake(0, 0, Width, Height - 38);
        CGRect small = CGRectMake(Width - (Width/3 - 10) - 5, 5, Width/3 - 10, (Width/3 - 10)*3.0/4);
        CGRect bar = CGRectMake(0, Height - 38, Width, 38);
        if (_state.isVideoFullScreen) {
            _videoArea.frame = full;
            _playerBar.frame = bar;
            _docArea.frame = small;
            [self.view bringSubviewToFront:_docArea];
        }else if (_state.isDocFullScreen){
            _docArea.frame = full;
            _playerBar.frame = bar;
            _videoArea.frame = small;
            [self.view bringSubviewToFront:_videoArea];
        }
        _layoutShow.x = 10;
        _layoutShow.y = 30;
        _itemBar.hidden = YES;
        
    }else if (statusOrient == UIInterfaceOrientationPortrait){
        _state.isFullScreen = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBar.hidden = NO;
        CGFloat top = 64;
        _videoArea.frame = CGRectMake(5, top, Width - 10, ceil(Width*9/16));
        _playerBar.frame = CGRectMake(0, _videoArea.bottom, Width, 38);
        [_docArea removeFromSuperview];
        _docArea.frame = CGRectMake(0, 0, Width, Height - CGRectGetMaxY(_itemBar.frame));
        [_scrollView addSubview:_docArea];
        
        _scrollView.hidden = NO;
        _scrollView.frame = CGRectMake(0, _itemBar.bottom, Width, Height - CGRectGetMaxY(_itemBar.frame));
        _layoutShow.x = 10;
        _layoutShow.y = 74;
        _itemBar.hidden = NO;
        [self.view bringSubviewToFront:_itemBar];
    }
    [self.view bringSubviewToFront:_layoutShow];
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

- (NSArray *)refs {
    return [NSArray arrayWithObjects:@"1X", @"1.25X", @"1.5X", @"1.75X", @"2X", @"2.5X", @"3X", @"3.5X", @"4X", nil];
}


- (void)selectSpeed:(GSMenuItem *)item {
    [_vodPlayer SpeedPlay:item.tag];
    [_playerBar setValue:self.refs[item.tag] forKeyPath:@"speedLabel.text"];
    [_playerBar layoutIfNeeded];
    //    [self.navigationItem.rightBarButtonItem setTitle:self.refs[item.tag]];
}

- (void)backAction {
    receiveChatCount = 0;
    if (self.vodPlayer) {
        [self.vodPlayer stop];
        //        [self.vodPlayer.docSwfView  clearVodLastPageAndAnno];//退出前清理一下文档模块
        self.vodPlayer.docSwfView = nil;
        self.vodPlayer = nil;
        self.item = nil;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"[VodPlayer] dealloc");
    [[GSVodManager sharedInstance] cleanPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -VodPlayDelegate
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos
{
    
    _playerBar.totalTime = duration;
    //    [_vodPlayer seekTo:1668020];
    NSLog(@"[VodPlayer] onInit :%d duration %d , %@",result,duration,_vodPlayer.playItem.strDownloadID);
    if (isPlayEnd) {
        isPlayEnd = NO;
        if (_playerBar.currentTime != 0) {
            [_vodPlayer seekTo:_playerBar.currentTime];
        }
    }
    [self.chatView.dataModelArray removeAllObjects];
    receiveChatCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatView refresh];
    });
    if (self.isOnline) {
        if (!self.isChatpost) {
            [_vodPlayer getChatListWithPageIndex:1];
        }
    }
    [_vodPlayer getQaListWithPageIndex:1];
}

- (void)refreshChatView {
    
    if (self.msgCount != self.chatView.dataModelArray.count) {
        self.itemBar.styles = @[@"文档",[NSString stringWithFormat:@"聊天(%d)",receiveChatCount],@"点播切换"];
        self.msgCount = self.chatView.dataModelArray.count;
        [self.chatView refresh];
    }
}

static long receiveChatCount = 0;

/*
 *获取聊天列表
 *@chatList   列表数据 (sender: 发送者  text : 聊天内容   time： 聊天时间)
 */
- (void)vodRecChatList:(NSArray*)chatList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    NSLog(@"vodRecChatList %u",chatList.count);
    receiveChatCount += chatList.count;
    if (!_timer) {
        __weak typeof(self) wself = self;
        _timer = [NSTimer timerWithTimeInterval:1.f target:wself selector:@selector(refreshChatView) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (chatList.count > 0) {
            for (int i = 0; i < chatList.count; i ++) {
                VodChatInfo *chatInfo = [chatList objectAtIndex:i];
                //TODO:demo的chatView只会存储200记录，如需变动请自行设计数据存储
                GSVodChatModel *model = [[GSVodChatModel alloc] initWithModel:chatInfo];
                [_chatView insert:model];
            }
        }
    });
}


- (void)OnChat:(NSArray *)chatArray {
    NSLog(@"OnChat %u",chatArray.count);
    receiveChatCount += chatArray.count;
    if (!_timer) {
        __weak typeof(self) wself = self;
        _timer = [NSTimer timerWithTimeInterval:1.f target:wself selector:@selector(refreshChatView) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (chatArray.count > 0) {
            for (int i = 0; i < chatArray.count; i ++) {
                VodChatInfo *chatInfo = [chatArray objectAtIndex:i];
                //TODO:demo的chatView只会存储200记录，如需变动请自行设计数据存储
                GSVodChatModel *model = [[GSVodChatModel alloc] initWithModel:chatInfo];
                [_chatView insert:model];
            }
        }
    });
}
/*
 *获取问题列表
 *@qaList   列表数据 （answer：回答内容 ; answerowner：回答者 ; id：问题id ;qaanswertimestamp:问题回答时间 ;question : 问题内容  ，questionowner:提问者 questiontimestamp：提问时间）
 *
 */
- (void)vodRecQaList:(NSArray*)qaList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    
}


//进度条定位播放，如快进、快退、拖动进度条等操作回调方法
- (void)onSeek:(int)position
{
    
}

//进度回调方法
- (void)onPosition:(int)position
{
    //    NSLog(@"[VodPlayer] onPosition : %d",position);
    _playerBar.currentTime = position;
}


/**
 * 文档信息通知
 * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
 */
- (void)onPage:(int) position width:(unsigned int)width height:(unsigned int)height;
{
    NSLog(@"[VodPlayer][Doc] onPosition : %d",position);
}


- (void)onAnnotaion:(int)position
{
    NSLog(@"[VodPlayer][Doc] onAnnotaion : %d",position);
}

//web布局适配
//0 文档为主
//1 视频最大化
//2 文档最大化
//3 视频为主
- (void)onVodLayoutSet:(unsigned int)timestamp type:(int)type {
    if (type == 2) {
        _state.isDocFullScreen = 1;
        _state.isVideoFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
    }else if (type == 1) {
        _state.isVideoFullScreen = 1;
        _state.isDocFullScreen = 0;
        UIInterfaceOrientation statusOrient = [UIApplication sharedApplication].statusBarOrientation;
        
        if (statusOrient == UIInterfaceOrientationLandscapeRight) {
            [self rotationAction];
        }else {
            [self updateScreenOriention:UIDeviceOrientationLandscapeLeft];
        }
        
        
    }else if (type == 3) {
        _state.isVideoFullScreen = 0;
        _state.isDocFullScreen = 0;
        [self updateScreenOriention:UIDeviceOrientationPortrait];
        
    }
    NSString *hint;
    switch (type) {
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

- (void)onVideoStart
{
    NSLog(@"[VodPlayer] onVideoStart");
}

//播放完成停止通知，
- (void)onStop{
    NSLog(@"[VodPlayer] onStop");
    _playerBar.currentTime = 0;
    _playerBar.isPlay = NO;
    isPlayEnd = YES;
}

#pragma mark - GSVodPlayerBarDelegate

- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSetPlay:(BOOL)isPlay {
    NSLog(@"[VodPlayer] didSetPlay : %d",isPlay);
    if (isPlayEnd) {
        if (isPlay) {
            [[GSVodManager sharedInstance] play:_item online:_isOnline];
            _playerBar.isPlay = YES;
        }
    }else{
        if (isPlay) {
            [_vodPlayer resume];
        }else{
            [_vodPlayer pause];
        }
    }
    
}
- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSlideToValue:(int)value {
    NSLog(@"[VodPlayer] didSlideToValue : %d",value);
    if (isPlayEnd) {
        [[GSVodManager sharedInstance] play:_item online:_isOnline];
        _playerBar.isPlay = YES;
    }else{
        [_vodPlayer seekTo:value];
        if (value != bar.totalTime) { //不是结尾
            _playerBar.isPlay = YES;
        }
    }
}

- (void)vodPlayerBar:(GSVodPlayerBar *)bar beginSlide:(int)value {
    NSLog(@"[VodPlayer] beginSlide : %d",value);
    //    [_vodPlayer pause];
    _playerBar.isPlay = NO;
}


- (void)vodPlayerBar:(GSVodPlayerBar *)bar didClickSpeed:(UILabel *)label {
    [GSMenu setTitleFont:[UIFont systemFontOfSize:12.f]];
    NSMutableArray *items = [NSMutableArray array];
    NSArray *refs = [self refs];
    for (int i = 0; i < refs.count; i++) {
        GSMenuItem *report;
        report = [GSMenuItem menuItem:refs[i]
                                image:nil  //pure_fault
                               target:self
                               action:@selector(selectSpeed:)];
        report.tag = i;
        report.foreColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
        
        [items addObject:report];
    }
    [GSMenu showMenuInView:self.view
                  fromRect:[self.view convertRect:label.frame fromView:bar]
                 menuItems:items];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
