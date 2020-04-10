//
//  HongbaoSelfGrabListView.m
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/5.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import "HongbaoSelfGrabListView.h"
@interface UIUserGrabInfoCell()
@property(nonatomic, strong)UILabel *labelName;
@property(nonatomic, strong)UILabel *labelMoney;
@end

@implementation UIUserGrabInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    CGFloat cellWidth = 300;
    self.labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth - 50, 30)];
    self.labelName.textColor = [UIColor blackColor];
    [self.contentView addSubview: self.labelName];
    
    self.labelMoney = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth - 50, 0, 50, 30)];
    self.labelMoney.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.labelMoney];
}

-(void)setUserGrabInfo:(GSUserGrabInfo *)userGrabInfo
{
    _userGrabInfo = userGrabInfo;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:_userGrabInfo.grabTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *text = _userGrabInfo.userName;
    if(_userGrabInfo.bBest)
    {
        text = [NSString stringWithFormat:@"%@    %@%@", dateString,_userGrabInfo.userName, @"(手气最佳)"];
    }else{
        text = [NSString stringWithFormat:@"%@    %@", dateString,_userGrabInfo.userName];
    }
    self.labelName.text = text;
    self.labelMoney.text  = [NSString stringWithFormat:@"%d", _userGrabInfo.money];
}

@end
@interface HongbaoSelfGrabListView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tabView;
@property(nonatomic, strong)UILabel *labelInfo;
@property(nonatomic, strong)UILabel *labelEmpty;
@property(nonatomic, strong)UIButton *btnClose;
@end
@implementation HongbaoSelfGrabListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)setUserGrabInfos:(NSArray<GSUserGrabInfo *> *)userGrabInfos
{
    _userGrabInfos = userGrabInfos;
    self.labelEmpty.hidden = [_userGrabInfos count] > 0 ? YES : NO;
    [self.tabView reloadData];
}

-(void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.btnClose = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 10, 100, 30)];
    [self.btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [self.btnClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnClose];
    
    CGFloat top = 40;
    self.labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.frame.size.width, 20)];
    self.labelInfo.text = @"查询我抢的红包列表";
    self.labelInfo.textColor = [UIColor redColor];
    self.labelInfo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelInfo];
    
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, top + self.labelInfo.frame.size.height + 10, self.frame.size.width, self.frame.size.height - self.labelInfo.frame.size.height - 10 - top) style:UITableViewStylePlain];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    [self.tabView registerClass:[UIUserGrabInfoCell class] forCellReuseIdentifier:@"USERGRABINFOCELL"];
    [self addSubview:self.tabView];
    
    
    self.labelEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, top + self.labelInfo.frame.size.height + 10, self.frame.size.width, 20)];
    self.labelEmpty.text = @"暂无数据";
    self.labelEmpty.textColor = [UIColor redColor];
    self.labelEmpty.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelEmpty];
}

-(void)close:(UIButton *)sender
{
    if(self.closeBlock)
    {
        self.closeBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userGrabInfos ? self.userGrabInfos.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIUserGrabInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USERGRABINFOCELL"];
    if([cell isKindOfClass:[UIUserGrabInfoCell class]])
    {
        UIUserGrabInfoCell *grabInfoCell = (UIUserGrabInfoCell *)cell;
        grabInfoCell.userGrabInfo = [self.userGrabInfos objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
@end
