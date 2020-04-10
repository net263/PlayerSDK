//
//  HongbaoAmountView.m
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/4.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import "HongbaoAmountView.h"
@interface HongbaoAmountView()
@property(nonatomic, strong)UIButton *btnClose;
@property(nonatomic, strong)UILabel *labelInfo;
@property(nonatomic, strong)UIButton *btnQuery;
@end
@implementation HongbaoAmountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 10, 100, 30)];
    [self.btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnClose];
    
    CGFloat centerY = self.frame.size.height / 2;    
    self.labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY, self.frame.size.width, 30)];
    self.labelInfo.textColor = [UIColor blackColor];
    self.labelInfo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelInfo];
    
    self.btnQuery = [[UIButton alloc] initWithFrame:CGRectMake(0, self.labelInfo.frame.origin.y + self.labelInfo.frame.size.height + 20, self.frame.size.width, 30)];
    [self.btnQuery setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.btnQuery setTitle:@"查看大家的手气" forState:UIControlStateNormal];
    [self.btnQuery addTarget:self action:@selector(queryHongbaoGrabList:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnQuery];
}

-(void)close:(UIButton *)sender
{
    if(self.closeBlock)
    {
        self.closeBlock();
    }
}

-(void)queryHongbaoGrabList:(UIButton *)sender
{
    if(self.queryHongbaoGrabListBlock)
    {
        self.queryHongbaoGrabListBlock(self.hongbaoId);
    }
}


- (void)setGrabMoney:(NSInteger)grabMoney
{
    _grabMoney = grabMoney;
    if(self.hongbaoType == GSHongbaoTypeDirect)
    {
        //定向红包，不需要查询红包抢的列表
        self.btnQuery.hidden = YES;
    }else{
        self.btnQuery.hidden = NO;
    }
    
    if(self.grabResult == GSHongbaoGrabResultSuccess)
    {
        self.labelInfo.text = [NSString stringWithFormat:@"已抢到红包的金额:%zd", self.grabMoney];
    }else if(self.grabResult == GSHongbaoCreateResultGrabDuplicate)
    {
        self.labelInfo.text = @"您已抢过该红包";
    }else if(self.grabResult == GSHongbaoCreateResultHongbaoEmpty)
    {
        self.labelInfo.text = @"红包已被抢空";
    }else if(self.grabResult == GSHongbaoCreateResultHongbaoTimedout)
    {
        self.labelInfo.text = @"红包超时";
    }else if(self.grabResult == GSHongbaoCreateResultHongbaoNotAllowed)
    {
        self.labelInfo.text = @"定向红包，不允许争抢";
    }else if(self.grabResult == GSHongbaoCreateResultGrabNetError)
    {
        self.labelInfo.text = @"抢红包失败，网络原因";
    }
}
@end
