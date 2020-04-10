//
//  GSVodDownloadController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/6.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodDownloadController.h"
#import "GSProgressView.h"
#import "GSVodPlayerController.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSVodDownloadController () <GSVodManagerDelegate>
@property (nonatomic, strong) downItem *downloadingItem;
@property (nonatomic, strong) GSProgressView *progress;
@property (nonatomic, strong) GSVodManager *manager;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *stopResume;
@property (nonatomic, strong) UIButton *delete;
@property (nonatomic, strong) UIButton *play;

@property (nonatomic, strong) UILabel *vodID;
@property (nonatomic, strong) UILabel *name;

@end

@implementation GSVodDownloadController
{
    struct {
        unsigned int isPause : 1;
        unsigned int isFinish : 1;
        unsigned int isStop : 1;
    } _state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Vod下载";
    // Do any additional setup after loading the view.
    CGFloat top = 64.f + 10.f;
    
    _manager = [GSVodManager sharedInstance];
    _manager.delegate = self;
    {
        UILabel *info = [self createTagLabel:@"点播ID" top:top];
        [self.view addSubview:info];
        top = info.bottom + 10;
        _vodID = [self createElementLabel:@"未知" top:top];
        top = _vodID.bottom + 10;
        
        UILabel *info1 = [self createTagLabel:@"点播件名称" top:top];
        [self.view addSubview:info1];
        top = info1.bottom + 10;
        _name = [self createElementLabel:@"未知" top:top];
        top = _name.bottom + 10;
       
        [self.view addSubview:_vodID];
        [self.view addSubview:_name];
    }
    
    
    {
        UILabel *label = [self createTagLabel:@"下载进度" top:top];
        [self.view addSubview:label];
        
        top = label.bottom + 10;
        
        GSProgressView *progress = [[GSProgressView alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)];
        progress.percent = 0.0;
        [self.view addSubview:progress];
        _progress = progress;
        
        
        top = progress.bottom + 10;
    }
    
    
    
    {
        UILabel *label1 = [self createTagLabel:@"操作按钮" top:top];
        [self.view addSubview:label1];
        
        top = label1.bottom + 10;
        //按钮事件 - 发布
        UIButton *start   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, top, Width/2 - 30.f, 40.f)];
        [start setTitle:@"开始下载" forState:UIControlStateNormal];
        start.tag = 0;
        [self resetCustomButton:start flag:0];
        [self.view addSubview:start];
        _start = start;
        //按钮事件 - 观看
        UIButton *stopResume   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15.f, top, Width/2 - 30.f, 40.f)];
        [stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
        stopResume.tag = 1;
        [self resetCustomButton:stopResume flag:0];
        [self.view addSubview:stopResume];
        _stopResume = stopResume;
        top = stopResume.bottom + 10;
    }
    
    {
        //按钮事件 - 发布
        UIButton *delete   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, top, Width/2 - 30.f, 40.f)];
        [delete setTitle:@"删除下载" forState:UIControlStateNormal];
        delete.tag = 2;
        [self resetCustomButton:delete flag:0];
        [self.view addSubview:delete];
        _delete = delete;
        //按钮事件 - 观看
        UIButton *play   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15.f, top, Width/2 - 30.f, 40.f)];
        [play setTitle:@"离线观看" forState:UIControlStateNormal];
        play.tag = 3;
        [self resetCustomButton:play flag:0];
        [self.view addSubview:play];
        _play = play;
        top = play.bottom + 10;
    }
    
    
    [[GSVodManager sharedInstance] requestParam:self.item enqueue:YES completion:^(downItem *item, GSVodWebaccessError type) {
        NSString *msg;
        switch (type) {
            case GSVodWebaccessSuccess:
                {
                    _downloadingItem = item;
                    NSArray *items = [[VodManage shareManage] searchFinishedItems];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self resetCustomButton:_start  flag:1];
                        [items enumerateObjectsUsingBlock:^(downItem*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj.strDownloadID isEqualToString:_downloadingItem.strDownloadID]) {
                                NSLog(@"GSVodDownloadController : 已经下载过该点播件");
                                [self resetCustomButton:_stopResume  flag:0];
                                [self resetCustomButton:_play  flag:1];
                                [self resetCustomButton:_delete  flag:1];
                                [self resetCustomButton:_start  flag:0];
                                _progress.percent = 1.f;
                            }
                        }];
                        
                        _vodID.text = _downloadingItem.strDownloadID;
                        _name.text = _downloadingItem.name;
                        [_vodID sizeToFit];
                        [_name sizeToFit];
                    });
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
            default:
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)customAction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:{ //开始下载
            [[GSVodManager sharedInstance] startQueue];
            [self resetCustomButton:_start  flag:0];
            [_start setTitle:@"下载中" forState:UIControlStateNormal];
        }
            break;
        case 1:{ //暂停 恢复
            if (_state.isPause) {
                [[GSVodManager sharedInstance] startQueue];
            }else{
                [[GSVodManager sharedInstance] pauseQueue:nil];
            }
        }
            break;
        case 2:{ //删除下载
            _progress.percent = 0.f;
            [self resetCustomButton:_start  flag:1];
            [_start setTitle:@"开始下载" forState:UIControlStateNormal];
            [self resetCustomButton:_stopResume  flag:0];
            [self resetCustomButton:_delete  flag:0];
            [self resetCustomButton:_play  flag:0];
            //从存储空间中删除该点播
            [[GSVodManager sharedInstance] removeOnDisk:_downloadingItem.strDownloadID];
            //由于之前请求过数据 这里直接再次加入队列
            _downloadingItem.state = REDAY;
            [[GSVodManager sharedInstance] insertQueue:_downloadingItem atIndex:0];
        }
            
            break;
        case 3:{ //离线观看
            GSVodPlayerController *player = [[GSVodPlayerController alloc] init];
            player.item = _downloadingItem;
            player.isOnline = NO;
            [self.navigationController pushViewController:player animated:YES];
        }
//        case 4:{ //离线观看
//            VodParam *vodParam =  [VodParam new];
//            vodParam.domain = @"simuwang.gensee.com";
//            //    vodParam.number = @"87079577";
//            vodParam.loginName = @"";
//            vodParam.loginPassword = @"";
//            vodParam.vodPassword = @"";
//            vodParam.vodID = @"c9206ab8b4144f20af20bb9e52a4f994";
//            vodParam.downFlag = 0;
//            vodParam.serviceType = @"webcast";
//            //    vodParam.number = @"85010722";
////            vodParam.customUserID = 1010507411;
//            [[GSVodManager sharedInstance] requestParam:vodParam enqueue:YES completion:^(downItem *item, RESULT_TYPE type) {
//                _downloadingItem = item;
//                [[GSVodManager sharedInstance] startQueue];
//            }];
//        }
            break;
        default:
            break;
    }
}

- (UILabel *)createElementLabel:(NSString *)tagContent top:(CGFloat)top {
    return [self createElementLabel:tagContent top:top left:15];
}

- (UILabel *)createElementLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, 20)];
    label.text = tagContent;
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    return label;
}

- (void)resetCustomButton:(UIButton *)btn flag:(int)i {
    if (i == 0) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = [UIColor grayColor].CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = [UIColor grayColor];
        btn.userInteractionEnabled = NO;
    }else if (i == 1) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        btn.userInteractionEnabled = YES;
    }else if (i == 2) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = FASTSDK_COLOR16(0x336699);
        btn.userInteractionEnabled = YES;
    }
    [btn addTarget:self action:@selector(customAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - GSVodManagerDelegate

//已经请求到点播件数据,并加入队列
- (void)vodManager:(GSVodManager *)manager downloadEnqueueItem:(downItem *)item state:(RESULT_TYPE)type {
//    [self resetCustomButton:_start flag:0];
}
//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
    //按钮状态逻辑
    {
        _state.isPause = NO;
        [self resetCustomButton:_stopResume  flag:1];
        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
    }
    
}
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
    NSLog(@"percent ： %f",percent);
    {
        _state.isPause = NO;
        [self resetCustomButton:_stopResume  flag:1];
        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _progress.percent = percent/100;
    });
}
//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
    {
        [self resetCustomButton:_stopResume  flag:1];
        [_stopResume setTitle:@"恢复下载" forState:UIControlStateNormal];
        _state.isPause = YES;
    }
}
//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
    //按钮状态逻辑
    {
        [self resetCustomButton:_start  flag:1];
        [_start setTitle:@"开始下载" forState:UIControlStateNormal];
        [self resetCustomButton:_stopResume  flag:0];
        [self resetCustomButton:_delete  flag:0];
        [self resetCustomButton:_play  flag:0];
        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
        _state.isStop = YES;
    }
    
}
//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item {
    //按钮状态逻辑
    {
        [self resetCustomButton:_stopResume  flag:0];
        [_stopResume setTitle:@"暂停下载" forState:UIControlStateNormal];
        [self resetCustomButton:_play  flag:1];
        [self resetCustomButton:_delete  flag:1];
        [self resetCustomButton:_start  flag:0];
        [_start setTitle:@"开始下载" forState:UIControlStateNormal];
        _downloadingItem = item;
    }
    
}
//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
    //按钮状态逻辑
    {
        [self resetCustomButton:_start  flag:1];
        [self resetCustomButton:_play  flag:0];
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
