//
//  GSVodSwitchView.m
//  VodSDKDemo
//
//  Created by gensee on 2019/8/2.
//  Copyright © 2019年 Gensee. All rights reserved.
//

#import "GSVodSwitchView.h"

@interface GSVodSwitchView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation GSVodSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadContent];
    }
    return self;
}

static NSString *modelCellFlag = @"SwitchTableViewCell";

- (void)loadContent{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self _setExtraCellLineHidden:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:modelCellFlag];
    
    [self addSubview:_tableView];

}

- (NSMutableArray *)dataModelArray
{
    if (!_dataModelArray) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:modelCellFlag];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    downItem *item = [self.dataModelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    downItem *item = [self.dataModelArray objectAtIndex:indexPath.row];
    [[GSVodManager sharedInstance].player stop];
    [[GSVodManager sharedInstance] play:item online:YES];
}

#pragma mark - Utilities
-(void)_setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
