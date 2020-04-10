//
//  GSVodParamController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodParamController.h"
#import "GSTextFieldTitleView.h"
#import <GSCommonKit/GSCommonKit.h>

#import "IQKeyboardManager.h"
//#import "GSVodQueueController.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

#define MO_DOMAIN @"V_FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"V_FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"V_FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"V_FAST_CONFIG_NICKNAME"
#define MO_PWD @"V_FAST_CONFIG_PWD"
#define MO_LOGIN_NAME @"V_FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"V_FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"V_FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"V_FAST_CONFIG_REWARD"
#define MO_USERID @"V_FAST_CONFIG_USERID"

#import "GSVodPlayerController.h"
//#import "ViewController.h"
#import "GSVodDownloadController.h"

@interface GSVodParamController () <UITextFieldDelegate,VodDownLoadDelegate>
//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *flvType;
@property (strong, nonatomic) UISegmentedControl *hardType;
@property (strong, nonatomic) UISegmentedControl *httpType;

@property (strong, nonatomic) UISegmentedControl *aspectType;
@property (strong, nonatomic) UISegmentedControl *chatType;
@property (strong, nonatomic) UISegmentedControl *renderType;

@property (nonatomic, strong) VodDownLoader *voddownloader;

@end

@implementation GSVodParamController
{
    struct {
        unsigned int isOnline : 1;
    } _state;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_voddownloader) {
        _voddownloader = [[VodDownLoader alloc]init];
    }
    _voddownloader.delegate = self;
    
    //UI
    self.title = @"VodSDK";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _fieldViewsDic = [[NSMutableDictionary alloc]init];
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64 - 50)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    CGFloat top = 10.f;
    int index = 0;
    
    UILabel *label = [self createTagLabel:@"点播参数设置" top:top];
    [self.scrollView addSubview:label];
    top = label.bottom + 5;
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:8];
    top = whiteBGView.bottom + 10;
    [self.scrollView addSubview:whiteBGView];
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"域名";
        fieldView.placeHolder               = @"请输入域名";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_DOMAIN];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间号";
        fieldView.placeHolder               = @"请输入房间号";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_ROOMID];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"昵称";
        fieldView.placeHolder               = @"请输入昵称";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_NICKNAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间密码";
        fieldView.placeHolder               = @"请输入房间密码(可选)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        //        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录用户名";
        fieldView.placeHolder               = @"请输入登录用户名(可选)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_NAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录密码";
        fieldView.placeHolder               = @"请输入登录密码(可选)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"第三方验证码";
        fieldView.placeHolder               = @"请输入验证码(可选)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_THIRD_KEY];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"自定义用户ID";
        fieldView.placeHolder               = @"请输入ID(可选,且应大于十亿)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_USERID];
        index ++;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"FLV" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _serviceType = [[UISegmentedControl alloc] initWithItems:@[@"Webcast",@"Training"]];
        _serviceType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _serviceType.tag = 0;
        //        _serviceType
        _serviceType.selectedSegmentIndex = 0;
        //        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_serviceType];
        //Theme
        _flvType = [[UISegmentedControl alloc] initWithItems:@[@"否",@"是"]];
        _flvType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _flvType.selectedSegmentIndex = 0;
        _flvType.tag = 1;
        //        [_flvType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_flvType];
        
        top = _flvType.bottom + 10;
        
        UILabel *label2 = [self createTagLabel:@"HTTP/HTTPS" top:top];
        [self.scrollView addSubview:label2];
        UILabel *label3 = [self createTagLabel:@"软解/硬解" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label3];
        
        top = label2.bottom + 5;
        //HTTP/HTTPS
        _httpType = [[UISegmentedControl alloc] initWithItems:@[@"HTTP",@"HTTPS"]];
        _httpType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _httpType.tag = 2;
        _httpType.selectedSegmentIndex = 0;
        //        [_httpType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_httpType];
        
        
        
        
        
        _hardType = [[UISegmentedControl alloc] initWithItems:@[@"软解",@"硬解"]];
        _hardType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _hardType.selectedSegmentIndex = 0;
        _hardType.tag = 3;
        [self.scrollView addSubview:_hardType];
        
        top = _httpType.bottom + 10;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"渲染类型" top:top];
        [self.scrollView addSubview:label];
        
        //        UILabel *label1 = [self createTagLabel:@"屏幕适配类型" top:top left:Width/2 + 15];
        //        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _renderType = [[UISegmentedControl alloc] initWithItems:@[@"OpenGL",@"AVSBDLayer"]];
        _renderType.frame = CGRectMake(15, top, (Width - 60), 28);
        _renderType.tag = 0;
        //        _serviceType
        _renderType.selectedSegmentIndex = 0;
        //        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_renderType];
        
        top = _renderType.bottom + 10;
        
    }
    
    {
        UILabel *label = [self createTagLabel:@"屏幕适配类型" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        _aspectType = [[UISegmentedControl alloc] initWithItems:@[@"按比例适配",@"按比例填充",@"填充铺满"]];
        _aspectType.frame = CGRectMake(15, top, (Width - 60), 28);
        _aspectType.selectedSegmentIndex = 0;
        _aspectType.tag = 1;
        //        [_flvType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_aspectType];
        
        top = _aspectType.bottom + 10;
        
    }
    
    {
        UILabel *label = [self createTagLabel:@"聊天推送类型" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        _chatType = [[UISegmentedControl alloc] initWithItems:@[@"实时推送",@"全部一次获取"]];
        _chatType.frame = CGRectMake(15, top, (Width - 60), 28);
        _chatType.selectedSegmentIndex = 0;
        _chatType.tag = 1;
        //        [_flvType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_chatType];
        
        top = _chatType.bottom + 10;
        
    }
    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    
    {
        //按钮事件 - 发布
        UIButton *download   = [[UIButton alloc] initWithFrame:CGRectMake(10.f, Height - 50.f + 5, (Width-40)/2, 40.f)];
        [download setTitle:@"下载" forState:UIControlStateNormal];
        download.layer.cornerRadius         = 3.f;
        download.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        download.layer.borderWidth          = 0.5f;
        download.layer.masksToBounds        = YES;
        download.backgroundColor = FASTSDK_COLOR16(0x336699);
        [download addTarget:self action:@selector(goDownload) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:download];
        
        //按钮事件 - 观看
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(30.f + (Width-40)/2, Height - 50.f + 5, (Width-40)/2, 40.f)];
        [watch setTitle:@"在线观看" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [watch addTarget:self action:@selector(watch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Gensee" style:UIBarButtonItemStylePlain target:self action:@selector(beTester)];
    
    self.navigationItem.rightBarButtonItems = @[item];
}

- (void)beTester {
    NSString *hint = self.isTester ? @"是要返回正常模式吗":@"进入开发人员模式";
    __weak typeof(self) wself = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:hint preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *makesure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        wself.isTester = !wself.isTester;
    }];
    [alertVC addAction:action];
    [alertVC addAction:makesure];
    [self presentViewController:alertVC animated:NO completion:nil];
}


- (void)goDownload {
    //存储相关参数到NSUserDefault
    [self saveCache];
    //param
    VodParam *params = [VodParam new];
    if (!self.isTester){
        params.domain = [self _fieldText:MO_DOMAIN];
        params.number = [self _fieldText:MO_ROOMID];
        params.loginName = [self _fieldText:MO_LOGIN_NAME];
        params.vodPassword = [self _fieldText:MO_PWD];
        params.loginPassword = [self _fieldText:MO_LOGIN_PWD];
        params.nickName = [self _fieldText:MO_NICKNAME];
        params.downFlag = 1; //决定是否需要下载
        params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
        params.oldVersion = NO;
        params.thirdToken = [self _fieldText:MO_THIRD_KEY];
    }else {
        //http://213.gensee.com/webcast/site/vod/play-301de09dd29247239009263d17d1359b
        //xredu.gensee.com/training/site/v/63508258
        params.domain = @"wcjy.gensee.com";
        params.number = @"14949503";
        //    params.vodID = @"972a98d2baa845009fee2e454d19c29b";
        params.vodPassword = @"zs_s_secret_w";
        params.nickName = @"support";
        params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
    }
    
    if ([self _fieldText:MO_USERID].length > 0) {
        params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }
    GSVodDownloadController *download = [[GSVodDownloadController alloc] init];
    download.item = params;
    [self.navigationController pushViewController:download animated:YES];
}


- (void)watch:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
    
    //存储相关参数到NSUserDefault
    [self saveCache];
    
    //param
    VodParam *params = [VodParam new];
    if (!self.isTester){
        params.domain = [self _fieldText:MO_DOMAIN];
        params.number = [self _fieldText:MO_ROOMID];
        params.loginName = [self _fieldText:MO_LOGIN_NAME];
        params.vodPassword = [self _fieldText:MO_PWD];
        params.loginPassword = [self _fieldText:MO_LOGIN_PWD];
        params.nickName = [self _fieldText:MO_NICKNAME];
        params.downFlag = 0; //决定是否需要下载
        params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
        params.oldVersion = NO;
        params.thirdToken = [self _fieldText:MO_THIRD_KEY];
        if ([self _fieldText:MO_USERID].length > 0) {
            params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
        }
    }else{
        //http://213.gensee.com/training/site/v/69838572
        //http://192.168.1.193/training/site/v/75858081 444444
        ////    hqzk.gensee.com/webcast/site/vod/
        params.domain = @"192.168.1.193";
        params.number = @"75858081";
//        params.vodID = @"ngAwNNOVP1";
        params.vodPassword = @"444444";
        params.nickName = @"support";
 
        params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
        
        //    params.domain = @"zhixue.gensee.com";
        //    params.number = @"36026113";
        ////    params.vodID = @"37381d83392a459d8a4f2d27307f1586";
        //    params.vodPassword = @"369125";
        //    params.nickName = @"support";
        //    params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
        //    params.thirdToken = @"15713804461916d765f88e305646b9c9";
        params.oldVersion = NO;
        if ([self _fieldText:MO_USERID].length > 0) {
            params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
        }
    }
    
    
    self.voddownloader.httpAPIEnabled = _httpType.selectedSegmentIndex == 0?YES:NO;
    [GSVodManager sharedInstance].isFlv = _flvType.selectedSegmentIndex == 1?YES:NO;
    [GSVodManager sharedInstance].player.hardwareAccelerate = _hardType.selectedSegmentIndex == 1?YES:NO;;
    _state.isOnline = YES;
    [GSVodManager sharedInstance].player.sessionCategoryOption = AVAudioSessionCategoryOptionDefaultToSpeaker |AVAudioSessionCategoryOptionAllowBluetooth;
    [[GSVodManager sharedInstance] requestParam:params enqueue:NO completion:^(downItem *item, GSVodWebaccessError type) {
        NSString *msg;
        switch (type) {
            case GSVodWebaccessSuccess:
            {
                if (_state.isOnline) {
                    GSVodPlayerController *player = [[GSVodPlayerController alloc] init];
                    player.item = item;
                    player.isOnline = YES;
                    player.renderMode = _renderType.selectedSegmentIndex == 0 ? GSVideoRenderOpenGL : GSVideoRenderAVSBDLayer;
                    player.videoMode = _aspectType.selectedSegmentIndex == 0 ? UIViewContentModeScaleAspectFit : (_aspectType.selectedSegmentIndex == 1 ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleToFill);
                    player.isChatpost = _chatType.selectedSegmentIndex == 0 ? YES : NO;
                    [self.navigationController pushViewController:player animated:YES];
                }
                return;
            }
                break;
            case GSVodWebaccessFailed:{
                msg = @"未知错误:2";
            }
                break;
            case GSVodWebaccessNumberError:{
                msg = @"房间号错误 或 站点类型设置错误";
            }
                break;
            case GSVodWebaccessWrongPassword:{
                msg = @"观看密码错误";
            }
                break;
            case GSVodWebaccessLoginFailed:{
                msg = @"登录账号密码错误";
            }
                break;
            case GSVodWebaccessVodIdError:{
                msg = @"VodID错误";
            }
                break;
            case GSVodWebaccessNoAccountOrPwd:{
                msg = @"账号为空 或 密码为空";
            }
                break;
            case GSVodWebaccessThirdKeyError:{
                msg = @"第三方验证码错误";
            }
                break;
            case GSVodWebaccessNetworkError:{
                msg = @"网络请求失败";
            }
                break;
            case GSVodWebaccessUnsupportMobile:{
                msg = @"不支持移动设备";
            }
                break;
            default:{
                msg = [NSString stringWithFormat:@"错误类型:%lu",(unsigned long)type];
            }
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    //设置间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view resignFirstResponder];
}

//data
#pragma mark - data

- (void)saveCache {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.serviceType.selectedSegmentIndex] forKey:MO_SERVICE];
    [self _saveField:MO_DOMAIN];
    [self _saveField:MO_ROOMID];
    [self _saveField:MO_NICKNAME];
    [self _saveField:MO_PWD];
    [self _saveField:MO_LOGIN_NAME];
    [self _saveField:MO_LOGIN_PWD];
    [self _saveField:MO_THIRD_KEY];
    [self _saveField:MO_USERID];
    
}

- (void)_saveField:(NSString *)fieldMark {
    NSString *text = [self _fieldText:fieldMark];
    if (text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:fieldMark];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:fieldMark]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:fieldMark];
        }
    }
}

- (NSString *)_fieldText:(NSString *)fieldMark {
    GSTextFieldTitleView *fieldView = [_fieldViewsDic objectForKey:fieldMark];
    
    NSString *cleanString = [fieldView.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return cleanString;
}

- (void)loadCache {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"qa100.gensee.com" forKey:MO_DOMAIN];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_DOMAIN];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:MO_SERVICE];
    }else{
        self.serviceType.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE] intValue];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"14949860" forKey:MO_ROOMID];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_ROOMID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"genseeTest" forKey:MO_NICKNAME];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_NICKNAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_PWD];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_NAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_THIRD_KEY];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_USERID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID];
    }
    
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    NSLog(@"GSFastConfigController dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
