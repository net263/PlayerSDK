//
//  VoteThemesListView.m
//  PlayerSDK
//
//  Created by Gaojin Hsu on 6/26/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "ChatListView.h"

@interface ChatListView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChatListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self commonSetup];
    }
    
    return self;
}

- (void)commonSetup
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.borderColor = [[UIColor colorWithRed:187/255.f green:187/255.f blue:187/255.f alpha:1] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.5f;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2.0;

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self setExtraCellLineHidden:_tableView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_tableView]-3-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_tableView]-3-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_tableView)]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"themeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12.f]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectRow) {
        self.selectRow(indexPath.row);
    }
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)reloadData
{

    [_tableView reloadData];
}

@end
