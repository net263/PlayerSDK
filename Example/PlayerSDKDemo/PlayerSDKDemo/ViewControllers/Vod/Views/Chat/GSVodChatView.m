//
//  GSChatView.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSVodChatView.h"
#import "UIView+GSSetRect.h"
#import "GSTextAttachment.h"
#import "GSVodChatModel.h"

#pragma mark - tableView gategory

@implementation UITableView (scrollBottom)

- (void)scrollToBottom:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger rows = [self numberOfRowsInSection:0];
        if (rows > 0 && (self.contentSize.height > self.bounds.size.height)) {
            [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    });
}

@end

#define Keyboard_H 0

@interface GSVodChatView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GSVodChatView
{
    BOOL isSetupViews;
    BOOL bottomflag; //tableView是否处于底部
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadContent];
    }
    return self;
}


#pragma mark - public

- (void)refresh{
    
//    if (_dataModelArray.count == 0) {
//        return;
//    }
    
    [self.tableView reloadData];
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        NSUInteger rows = [self.tableView numberOfRowsInSection:0];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
//插入数据 并插入cell
- (void)insert:(GSVodChatModel*)model{
    [self insert:model forceBottom:NO];
}

- (void)insert:(GSVodChatModel*)model forceBottom:(BOOL)isBottom{
    

    
    if (self.dataModelArray.count > 200) {
        [self.dataModelArray removeObjectAtIndex:0];
    }
    
    [self.dataModelArray addObject:model];
    
    if ((!bottomflag) && !isBottom ) {
        
        //这里应该是未读消息提示操作
        
    }else{
        [self.tableView scrollToBottom:NO];
        
    }
 
}


static NSString *modelCellFlag = @"GSChatViewCell.h";

- (void)loadContent{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Keyboard_H) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self _setExtraCellLineHidden:_tableView];
    
    [_tableView registerClass:[GSVodChatViewCell class] forCellReuseIdentifier:modelCellFlag];
    
    [self addSubview:_tableView];
    
    isSetupViews = YES;
    bottomflag = YES;
    [self setupEmotion];
}

- (void)setupEmotion
{
    //初始化emoj表情
    
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
    
//    NSDictionary* key2fileDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"key2file" ofType:@"plist"]];
    NSDictionary* text2keyDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"text2key" ofType:@"plist"]];
    
    NSMutableArray* emotionSortArray = text2keyDic.allKeys;
    
    NSLog(@"text2keyDic %@",emotionSortArray);
    
    NSMutableArray *emotions = [NSMutableArray array];

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
    GSVodChatViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:modelCellFlag];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:self.dataModelArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSBaseModel *model = self.dataModelArray[indexPath.row];
//    NSLog(@"row :%d, height:%f",(int)indexPath.row,model.totalHeight);
    return 10 + model.totalHeight;
}


- (BOOL)judgeIsOnBottom
{
    CGFloat height = self.tableView.frame.size.height;
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    CGFloat bottomOffset = self.tableView.contentSize.height - contentOffsetY;
    
    if (bottomOffset <= height)
    {
        //在最底部
        return  YES;
    }
    else
    {
        return  NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat MAX_RANGE = 20; //是手指拖动的最大误差范围
    
    if (scrollView == self.tableView) {
        bottomflag = ((self.tableView.contentSize.height - self.tableView.contentOffset.y) - MAX_RANGE)  <= self.tableView.frame.size.height;
    }
}

#pragma mark - Utilities
-(void)_setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    CGRect rect = self.tableView.frame;
//    rect.origin.y = 0;
    rect.size.height = self.frame.size.height - toHeight;
    self.tableView.frame = rect;
    [self.tableView reloadData];
    
    [self.tableView scrollToBottom:NO];
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{

}





@end
