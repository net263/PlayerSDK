//
//  HongBaoGrabView.m
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/4.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import "HongBaoGrabView.h"
@interface HongBaoGrabView()
@property(nonatomic, strong)UIButton *btnGrab;
@property(nonatomic, strong)UILabel *labelComment;
@property(nonatomic, strong)UIButton *btnClose;
@property(nonatomic, strong)UILabel *labelInfo;
@end
@implementation HongBaoGrabView

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
    CGFloat centerX = self.frame.size.width / 2;
    
    self.labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, centerY, self.frame.size.width, 30)];
    self.labelInfo.textColor = [UIColor blackColor];
    self.labelInfo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelInfo];
    
    self.btnGrab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnGrab setTitle:@"抢红包" forState:UIControlStateNormal];
    [self.btnGrab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.btnGrab.frame = CGRectMake(centerX - 50, self.labelInfo.frame.origin.y - 100, 100, 80);
    [self.btnGrab addTarget:self action:@selector(grabHongbao:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnGrab];
    
    self.labelComment = [[UILabel alloc] initWithFrame:CGRectMake(0, self.labelInfo.frame.origin.y + 20, self.frame.size.width, 80)];
    self.labelComment.textColor = [UIColor blackColor];
    self.labelComment.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelComment];
}

-(void)grabHongbao:(UIButton *)sender
{
    if(self.grabHongbaoBlock)
    {
        self.grabHongbaoBlock(_hongbaoInfo);
    }
}

-(void)close:(UIButton *)sender
{
    if(self.closeBlock)
    {
        self.closeBlock();
    }
}

- (void)setHongbaoInfo:(GSHongbaoInfo *)hongbaoInfo
{
    _hongbaoInfo = hongbaoInfo;
    [self updateHongbaoInfo];
}

-(void)updateHongbaoInfo
{
    self.labelInfo.text = [NSString stringWithFormat:@"%@发了一个红包", _hongbaoInfo.userName];
    self.labelComment.text = _hongbaoInfo.comment;
}

@end
