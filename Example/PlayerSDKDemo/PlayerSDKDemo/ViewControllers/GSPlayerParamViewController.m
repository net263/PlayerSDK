//
//  GSPlayerParamViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSPlayerParamViewController.h"
#import "GSTextFieldTitleView.h"
#import "IQKeyboardManager.h"

#import "GSPlayerSelectViewController.h"
#import "GSVodParamController.h"

#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"FAST_CONFIG_NICKNAME"
#define MO_PWD @"FAST_CONFIG_PWD"
#define MO_LOGIN_NAME @"FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"FAST_CONFIG_REWARD"
#define MO_USERID @"FAST_CONFIG_USERID"
#define MO_GROUPID @"FAST_CONFIG_GROUPID"

@interface GSPlayerParamViewController ()

//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *httpType;
@property (strong, nonatomic) UISegmentedControl *boxType;
//编解码
@property (strong, nonatomic) UISegmentedControl *encodeType;
@property (strong, nonatomic) UISegmentedControl *decodeType;
//视频采集
@property (strong, nonatomic) GSTagsContentView *dpisTagView;
@property (strong, nonatomic) UITextField *wField;
@property (strong, nonatomic) UITextField *hField;
@property (strong, nonatomic) GSTagsContentView *cropTagView;

@end

@implementation GSPlayerParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary*infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString*app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString*app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    //UI
    self.title = [NSString stringWithFormat:@"PlayerSDK(%@,%@)",app_Version,app_build];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _fieldViewsDic = [[NSMutableDictionary alloc]init];
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + UIView.additionaliPhoneXTopSafeHeight, Width, Height - 64 - 50 - UIView.additionaliPhoneXTopSafeHeight - UIView.additionaliPhoneXBottomSafeHeight)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    
    
    CGFloat top = 10.f;
    int index = 0;
    
    UILabel *label = [self createTagLabel:@"点播参数设置" top:top];
    [self.scrollView addSubview:label];
    top = label.bottom + 5;
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:9];
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
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
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
    
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"课堂分组ID";
        fieldView.placeHolder               = @"请输入课堂分组ID)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_GROUPID];
        index ++;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"HTTP/HTTPS" top:top left:Width/2 + 15];
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
        _httpType = [[UISegmentedControl alloc] initWithItems:@[@"否",@"是"]];
        _httpType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _httpType.selectedSegmentIndex = 0;
        _httpType.tag = 1;
        //        [_flvType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_httpType];
        
        top = _httpType.bottom + 10;
       
    }
    
    {
        UILabel *label = [self createTagLabel:@"Box用户" top:top];
        [self.scrollView addSubview:label];
        
        top = label.bottom + 5;
        //Webcast/Trainig
        _boxType = [[UISegmentedControl alloc] initWithItems:@[@"否",@"是"]];
        _boxType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _boxType.tag = 0;
        //        _serviceType
        _boxType.selectedSegmentIndex = 0;
        //        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_boxType];
        
        top = _boxType.bottom + 10;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"软解/硬解" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"硬编/软编" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _decodeType = [[UISegmentedControl alloc] initWithItems:@[@"硬解",@"软解"]];
        _decodeType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _decodeType.tag = 0;
        _decodeType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_decodeType];
    
        
        //Webcast/Trainig
        _encodeType = [[UISegmentedControl alloc] initWithItems:@[@"硬编",@"软编"]];
        _encodeType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _encodeType.tag = 2;
        _encodeType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_encodeType];
        
        top = _encodeType.bottom + 10;
        
    }
    
   
    
    //video config dpis
    {
        UILabel *label = [self createTagLabel:@"摄像头期望输出分辨率(默认640x480)" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        UILabel *w = [self createTagLabel:@"宽 :" top:top + 5];
        [self.scrollView addSubview:w];
        
        _wField = [[UITextField alloc] initWithFrame:CGRectMake(w.right + 5, top, 60, 25)];
        _wField.keyboardType = UIKeyboardTypeNumberPad;
        _wField.textAlignment = NSTextAlignmentCenter;
        _wField.font          = [UIFont systemFontOfSize:14.f];
        _wField.layer.borderColor = [UIColor grayColor].CGColor;
        //        _wField.layer.cornerRadius = 3.f;
        _wField.layer.borderWidth = 0.5f;
        [self.scrollView addSubview:_wField];
        
        UILabel *h = [self createTagLabel:@"高 :" top:top + 5 left:_wField.right + 10];
        [self.scrollView addSubview:h];
        
        _hField = [[UITextField alloc] initWithFrame:CGRectMake(h.right + 5, top, 60, 25)];
        _hField.keyboardType = UIKeyboardTypeNumberPad;
        _hField.textAlignment = NSTextAlignmentCenter;
        _hField.font          = [UIFont systemFontOfSize:14.f];
        _hField.layer.borderColor = [UIColor grayColor].CGColor;
        //        _hField.layer.cornerRadius = 3.f;
        _hField.layer.borderWidth = 0.5f;
        [self.scrollView addSubview:_hField];
        
        top = _hField.bottom + 5;
        
        UILabel *quick = [self createTagLabel:@"快速选择分辨率" top:top];
        [self.scrollView addSubview:quick];
        top = quick.bottom + 5;
        NSArray *array = [NSArray arrayWithObjects:[NSValue valueWithCGSize:CGSizeMake(352,288)],
                          [NSValue valueWithCGSize:CGSizeMake(640,480)],
                          [NSValue valueWithCGSize:CGSizeMake(960,540)],
                          [NSValue valueWithCGSize:CGSizeMake(1280,720)],
                          [NSValue valueWithCGSize:CGSizeMake(1920,1080)],[NSValue valueWithCGSize:CGSizeMake(288,352)],
                          [NSValue valueWithCGSize:CGSizeMake(480,640)],
                          [NSValue valueWithCGSize:CGSizeMake(540,960)],
                          [NSValue valueWithCGSize:CGSizeMake(720,1280)],
                          [NSValue valueWithCGSize:CGSizeMake(1080,1920)],
                          nil];
        NSMutableArray *titles = [NSMutableArray array];
        for (int i = 0; i <array.count; i ++) {
            NSValue *value = array[i];
            [titles addObject:NSStringFromCGSize(value.CGSizeValue)];
        }
        _dpisTagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)]
        .allowSelectSet(YES)
        .supportMultiSelectSet(NO)
        .tagTextsSet(titles);
        __weak typeof(self)wself = self;
        _dpisTagView.handler = ^(NSInteger index, NSString *text, BOOL isSelect) {
            NSValue *value = array[index];
            CGSize size = value.CGSizeValue;
            wself.wField.text = [NSString stringWithFormat:@"%.0f",size.width];
            wself.hField.text = [NSString stringWithFormat:@"%.0f",size.height];
        };
        _dpisTagView.selectIndex = 1;
        _dpisTagView.handler(1,@"",1);
        
        [self.scrollView addSubview:_dpisTagView];
        top = _dpisTagView.bottom + 10;
        
    }
    
    //video crop
    {
        UILabel *label = [self createTagLabel:@"摄像头输出比例(默认4x3)" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        NSArray *array = @[@"4x3",@"16x9",@"9x16"];
        _cropTagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)]
        .allowSelectSet(YES)
        .supportMultiSelectSet(NO)
        .tagTextsSet(array);
        
        _cropTagView.handler = ^(NSInteger index, NSString *text, BOOL isSelect) {
            [GSPPlayerManager sharedManager].videoConfiguration.cropMode = (GSCropMode)index;
        };
        _cropTagView.selectIndex = 0;
        [self.scrollView addSubview:_cropTagView];
        top = _cropTagView.bottom + 10;
    }
    
    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    
    {

        //按钮事件 - 观看
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, self.scrollView.y + self.scrollView.height + 5, (Width - 60.f)/2, 40.f)];
        [watch setTitle:@"下一步" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [watch addTarget:self action:@selector(watch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
        
        //按钮事件 - 观看
        UIButton *vodAction   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15.f, self.scrollView.y + self.scrollView.height + 5, (Width - 60.f)/2, 40.f)];
        [vodAction setTitle:@"点播" forState:UIControlStateNormal];
        vodAction.layer.cornerRadius         = 3.f;
        vodAction.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        vodAction.layer.borderWidth          = 0.5f;
        vodAction.layer.masksToBounds        = YES;
        vodAction.backgroundColor = FASTSDK_COLOR16(0x336699);
        [vodAction addTarget:self action:@selector(vodAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vodAction];
    }
}

- (void)vodAction:(UIButton *)sender {
    GSVodParamController *vodVC = [[GSVodParamController alloc] init];
    [self.navigationController pushViewController:vodVC animated:YES];
}

- (void)watch:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
    
    //存储相关参数到NSUserDefault
    [self saveCache];
    //param
    GSConnectInfo *params = [GSConnectInfo new];
#if 1
    params.domain = [self _fieldText:MO_DOMAIN];
    params.roomNumber = [self _fieldText:MO_ROOMID];
    params.loginName = [self _fieldText:MO_LOGIN_NAME];
    params.watchPassword = [self _fieldText:MO_PWD];
    params.loginPassword = [self _fieldText:MO_LOGIN_PWD];
    params.nickName = [self _fieldText:MO_NICKNAME];
    params.serviceType = self.serviceType.selectedSegmentIndex;
    
    params.thirdToken = [self _fieldText:MO_THIRD_KEY];
    params.oldVersion = self.boxType.selectedSegmentIndex;
#else
    //http://edusoho.gensee.com/webcast/site/entry/join-308676e2f8994b1e97f2d65db17e2944?token=992745&nickName=dasdlakladkal&uid=42550000133013&k=15713683356d3e1858ed1ad40f97e0be
//    http://edusoho.gensee.com/webcast/site/entry/join-35fefe41089b43b29eab6219a391b1e5?token=764159&nickName=dasdlakladkal&uid=42550000133013&k=15713825840fa0d03dcafa214e66c106
    params.domain = @"product.gensee.com";
    params.serviceType = self.serviceType.selectedSegmentIndex;
//    params.loginName = self.loginName;
//    params.loginPassword = self.loginPassword;
    params.webcastID = @"ab27f1b001694a36a9a0fd69e21fe20d";
//    params.roomNumber = @"80733512";
    params.nickName = @"展示互动-PlayerSDK";
    params.watchPassword = @"333333";
//    params.customUserID = 3333333333;
    params.oldVersion = NO;
//    params.thirdToken = @"15713825840fa0d03dcafa214e66c106";
    params.oldVersion = self.boxType.selectedSegmentIndex;
#endif
    if ([self _fieldText:MO_USERID].length > 0) {
        params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }
    if([self _fieldText:MO_GROUPID].length > 0)
    {
        params.groupCode = [self _fieldText:MO_GROUPID];
    }
    params.userData = @"chenfuwei userdata test";
    
    [GSPPlayerManager sharedManager].httpAPIEnabled = self.httpType.selectedSegmentIndex==0?YES:NO;
    [GSPPlayerManager sharedManager].hardwareAccelerateEncode = (self.encodeType.selectedSegmentIndex==0)?YES:NO;
    [GSPPlayerManager sharedManager].hardwareAccelerateDecode = (self.decodeType.selectedSegmentIndex==0)?YES:NO;
    if (_wField.text.length > 0 && _hField.text.length > 0) {
        [GSPPlayerManager sharedManager].videoConfiguration.videoSize = CGSizeMake(_wField.text.intValue, _hField.text.intValue);
    }
    
    GSPlayerSelectViewController *selectVC = [[GSPlayerSelectViewController alloc] init];
    selectVC.param = params;
    [self.navigationController pushViewController:selectVC animated:YES];
    
    //设置间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self _saveField:MO_GROUPID];
    
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
    return fieldView.field.text;
}

- (void)loadCache {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"213.gensee.com" forKey:MO_DOMAIN];
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
        [[NSUserDefaults standardUserDefaults] setObject:@"38738043" forKey:MO_ROOMID];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_ROOMID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"support" forKey:MO_NICKNAME];
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
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_GROUPID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_GROUPID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_GROUPID];
    }
    
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    NSLog(@"GSPlayerParamViewController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
