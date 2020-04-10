//
//  HongbaoGragListView.m
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/5.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import "HongbaoGragListView.h"
@interface UIGrabInfoCell()
@property(nonatomic, strong)UILabel *labelName;
@property(nonatomic, strong)UILabel *labelMoney;
@end

@implementation UIGrabInfoCell

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

-(void)setGrabInfo:(GSGrabInfo *)grabInfo
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:grabInfo.grabTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    _grabInfo = grabInfo;
    NSString *text = _grabInfo.username;
    if(_grabInfo.bBest)
    {
        text = [NSString stringWithFormat:@"%@    %@%@", dateString,_grabInfo.username, @"(手气最佳)"];
    }else{
        text = [NSString stringWithFormat:@"%@    %@", dateString,_grabInfo.username];
    }
    self.labelName.text = text;
    self.labelMoney.text  = [NSString stringWithFormat:@"%d", grabInfo.money];
}

@end

@interface HongbaoGragListView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tabView;
@property(nonatomic, strong)UILabel *labelInfo;
@property(nonatomic, strong)UIButton *btnClose;
@end
@implementation HongbaoGragListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)setGrabInfos:(NSArray<GSGrabInfo *> *)grabInfos
{
    _grabInfos = grabInfos;
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
    self.labelInfo.text = @"查看大家的手气";
    self.labelInfo.textColor = [UIColor redColor];
    self.labelInfo.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labelInfo];
    
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, top + self.labelInfo.frame.origin.y + self.labelInfo.frame.size.height + 10, self.frame.size.width, self.frame.size.height - self.labelInfo.frame.size.height - 10 - top) style:UITableViewStylePlain];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    [self.tabView registerClass:[UIGrabInfoCell class] forCellReuseIdentifier:@"GRABINFOCELL"];
    [self addSubview:self.tabView];
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
    return self.grabInfos ? self.grabInfos.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIGrabInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GRABINFOCELL"];
    if([cell isKindOfClass:[UIGrabInfoCell class]])
    {
        UIGrabInfoCell *grabInfoCell = (UIGrabInfoCell *)cell;
        grabInfoCell.grabInfo = [self.grabInfos objectAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
