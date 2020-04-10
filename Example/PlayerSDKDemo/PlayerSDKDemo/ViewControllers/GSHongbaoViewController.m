//
//  GSHongbaoViewController.m
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/3.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import "GSHongbaoViewController.h"
#import "HongbaoGrabView.h"
#import "HongbaoAmountView.h"
#import "HongbaoGragListView.h"
#import "HongbaoSelfGrabListView.h"
#define VIEW_HEIGHT 400
#define VIEW_SEP 10
#define VIEW_WIDTH 300

#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSHongbaoViewController ()<GSPPlayerManagerDelegate, GSHongbaoImplDelegate>
@property(nonatomic, strong)UIView *containerView;
@property(nonatomic, strong)UIButton *createHongbao;
@property(nonatomic, strong)UIButton *btnSelfGrabList;
@property(nonatomic, strong)HongBaoGrabView *grabView;
@property(nonatomic, strong)HongbaoAmountView *amountView;
@property(nonatomic, strong)HongbaoGragListView *grabInfosView;
@property(nonatomic, strong)HongbaoSelfGrabListView *selfGrabListView;
@end

@implementation GSHongbaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.containerView.backgroundColor = RGBA(0, 0, 0, 48);
    [self.view addSubview:_containerView];
    [[GSPPlayerManager sharedManager] setHongbaoDelegate:self];

    CGFloat top = self.view.centerY - (VIEW_HEIGHT / 2);
    self.createHongbao = [UIButton buttonWithType:UIButtonTypeCustom];
    self.createHongbao.frame = CGRectMake(15, top, (Width - 30.f), 60);
    [self.createHongbao setTitle:@"创建红包" forState:UIControlStateNormal];
    [self.createHongbao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.createHongbao.layer.cornerRadius         = 3.f;
    self.createHongbao.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
    self.createHongbao.layer.borderWidth          = 0.5f;
    self.createHongbao.layer.masksToBounds        = YES;
    self.createHongbao.backgroundColor = FASTSDK_COLOR16(0x009BD8);
    [self.createHongbao addTarget:self action:@selector(createHongbao:) forControlEvents:UIControlEventTouchUpInside];
    [self.createHongbao setHidden:YES];
    [self.containerView addSubview:self.createHongbao];
    
    top += VIEW_SEP + 80;
    self.btnSelfGrabList = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSelfGrabList.frame = CGRectMake(15, top, (Width - 30.f), 60);
    [self.btnSelfGrabList setTitle:@"我抢红包列表" forState:UIControlStateNormal];
    [self.btnSelfGrabList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnSelfGrabList.layer.cornerRadius         = 3.f;
    self.btnSelfGrabList.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
    self.btnSelfGrabList.layer.borderWidth          = 0.5f;
    self.btnSelfGrabList.layer.masksToBounds        = YES;
    self.btnSelfGrabList.backgroundColor = FASTSDK_COLOR16(0x009BD8);
    [self.btnSelfGrabList addTarget:self action:@selector(selfGrabHongbaoList:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.btnSelfGrabList];
    
    
}

-(HongbaoSelfGrabListView *)selfGrabListView
{
    if(!_selfGrabListView)
    {
        _selfGrabListView = [[HongbaoSelfGrabListView alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 200, VIEW_WIDTH, VIEW_HEIGHT)];
        __weak typeof (self) weakSelf = self;
        _selfGrabListView.closeBlock = ^{
            [weakSelf.selfGrabListView removeFromSuperview];
        };
    }
    return _selfGrabListView;
}

-(HongbaoGragListView *)grabInfosView
{
    if(!_grabInfosView)
    {
        _grabInfosView = [[HongbaoGragListView alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 200, VIEW_WIDTH, VIEW_HEIGHT)];
        __weak typeof (self) weakSelf = self;
        _grabInfosView.closeBlock = ^{
            [weakSelf.grabInfosView removeFromSuperview];
        };
    }
    return _grabInfosView;
}

-(HongbaoAmountView *)amountView
{
    if(!_amountView)
    {
        _amountView = [[HongbaoAmountView alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 200, VIEW_WIDTH, VIEW_HEIGHT)];
        __weak typeof (self) weakSelf = self;
        _amountView.closeBlock = ^{
            [weakSelf.amountView removeFromSuperview];
        };
        _amountView.queryHongbaoGrabListBlock = ^(NSString * _Nonnull hongbaoId) {
            [[GSPPlayerManager sharedManager] queryHongbaoGrabList:hongbaoId];
        };
    }
    return _amountView;
}
-(HongBaoGrabView *)grabView
{
    if(!_grabView)
    {
        _grabView = [[HongBaoGrabView alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 200, VIEW_WIDTH, VIEW_HEIGHT)];
        _grabView.grabHongbaoBlock = ^(GSHongbaoInfo * _Nonnull hongbaoInfo) {
            [[GSPPlayerManager sharedManager] grabHongbao:hongbaoInfo.hongbaoID];
        };
        __weak typeof (self) weakSelf = self;
        _grabView.closeBlock = ^{
            [weakSelf.grabView removeFromSuperview];
        };
    }
    return _grabView;
}

#pragma mark --hongbaodelegate
- (void)onHongbaoEnable:(bool)bEnable
{
    NSLog(@"onHongbaoEnable bEnable = %d", bEnable);
}
//-(void)onHongbaoCreate:(GSHongbaoCreateResult)result strId:(NSString*)strid
//{
//    NSLog(@"onHongbaoCreate result = %d strid = %@", (int)result, strid);
//    if(result != 0)
//    {
//        NSString *errorMsg = @"";
//        if(result == GSHongbaoCreateResultSystemError)
//        {
//            errorMsg = @"系统错误";
//        }else if(result == GSHongbaoCreateResultHongbaoFunctionError)
//        {
//            errorMsg = @"会议不存在或者未开启红包功能";
//        }else if(result == GSHongbaoCreateResultMoneyNotEnough)
//        {
//            errorMsg = @"会议红包余额不足";
//        }else if(result == GSHongbaoCreateResultHongbaoIDExist)
//        {
//            errorMsg = @"红包ID已存在";
//        }else if(result == GSHongbaoCreateResultMeetingHongbaoLimitError)
//        {
//            errorMsg = @"超过会议红包上限";
//        }else if(result == GSHongbaoCreateResultHongbaoCountLimitError)
//        {
//            errorMsg = @"红包份数超过上限";
//        }
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

- (void)onHongbaoComingNotify:(GSHongbaoInfo *)hongbaoInfo
{
    NSLog(@"onHongbaoComingNotify hongbaoInfo = %@", hongbaoInfo);
    self.grabView.hongbaoInfo = hongbaoInfo;
    [self.amountView removeFromSuperview];
    if(![self.grabView superview])
    {
        [self.view addSubview:self.grabView];
    }
}

- (void)onHongbaoGrabbedNotify:(NSString *)strid grabInfo:(GSGrabInfo *)grabInfo type:(int)hongbaoType
{
    NSLog(@"onHongbaoGrabbedNotify strid = %@ grabInfo = %@ hongbaoType = %d", strid, grabInfo, hongbaoType);
    if(hongbaoType == GSHongbaoTypeDirect)
    {
        long long selfUserId = [[GSPPlayerManager sharedManager] selfUserInfo].userID;
        if(grabInfo.llUserID == selfUserId)
        {
            self.amountView.hongbaoType = hongbaoType;
            self.amountView.grabResult  = GSHongbaoGrabResultSuccess;
            self.amountView.hongbaoId = strid;
            self.amountView.grabMoney = grabInfo.money;
            [self.grabView removeFromSuperview];
            if(![self.amountView superview])
            {
                [self.view addSubview:self.amountView];
            }
        }
    }
}

- (void)onHongbaoGrabHongbao:(GSHongbaoGrabResult)result strId:(NSString *)strid money:(unsigned int)money
{
    NSLog(@"onHongbaoGrabHongbao strid = %@ money = %d", strid, money);
    self.amountView.grabResult  = result;
    self.amountView.hongbaoId = strid;
    self.amountView.grabMoney = money;
    [self.grabView removeFromSuperview];
    if(![self.amountView superview])
    {
        [self.view addSubview:self.amountView];
    }
}

- (void)onHongbaoQueryHongbaoGrabList:(NSArray<GSGrabInfo *> *)grabs strId:(NSString *)strid
{
    [self.amountView removeFromSuperview];
    self.grabInfosView.grabInfos = grabs;
    if(![self.grabInfosView superview])
    {
        [self.view addSubview: self.grabInfosView];
    }
}

- (void)onHongbaoQuerySelfGrabList:(NSArray<GSUserGrabInfo *> *)grabs
{
    self.selfGrabListView.userGrabInfos = grabs;
    if(![self.selfGrabListView superview])
    {
        [self.view addSubview:self.selfGrabListView];
    }
}

#pragma mark -honbbao request
-(void)createHongbao:(UIButton *)sender
{
    [[GSPPlayerManager sharedManager] createRandomHongbao:1000 count:2 timeLimit:1000 fixed:NO comment:@"红包测试"];
}

-(void)selfGrabHongbaoList:(UIButton *)sender
{
    [[GSPPlayerManager sharedManager] querySelfGrabList];
}


@end
