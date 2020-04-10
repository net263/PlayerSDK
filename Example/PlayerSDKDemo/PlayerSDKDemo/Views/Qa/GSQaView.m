//
//  GSQaView.m
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//
#import "GSQaView.h"
#import "UIView+GSSetRect.h"
#import "GSFaceView.h"
#import "GSTextAttachment.h"
#import "GSChatModel.h"
#import "GSQaAnswerCell.h"
#import "GSQaQuestionCell.h"

#define Keyboard_H 44

#pragma mark - tableView gategory

@implementation UITableView (scrollBottom)

- (void)scrollToBottom:(BOOL)animated{
    NSUInteger rows = [self numberOfRowsInSection:0];
    if (rows > 0 && (self.contentSize.height > self.bounds.size.height)) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

@end

#pragma mark - GSQaView

@interface GSQaView () <UITableViewDelegate,UITableViewDataSource, GSChatToolbarDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *tableView;
//背景提示图


@end

@implementation GSQaView
{

    BOOL bottomflag; //tableView是否处于底部
    NSTimer *privateTimer;
    NSTimer *showMyTimer;
    BOOL isShowMy;//显示我的
    long long userID;
    
    BOOL isKeyboardShow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadContent];
    }
    return self;
}

static NSString *answerCellFlag = @"answerCellFlag";
static NSString *questionCellFlag = @"questionCellFlag";

- (void)loadContent{
    
    self.backgroundColor = UICOLOR16(0xF4F4F6);
    _tableView = [self commonInitTableCreate];
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];


    self.chatToolbar = [[GSChatToolBar alloc]initWithFrame:CGRectMake(0, self.frame.size.height - Keyboard_H, self.frame.size.width, Keyboard_H)];
    self.chatToolbar.delegate = self;
    
    [self addSubview:_chatToolbar];
 

    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    

    bottomflag = YES;
    _editable = YES;
    userID = [GSPPlayerManager sharedManager].selfUserInfo.userID;
}

- (long long)_userID {
    if (userID == 0) {
        userID = [GSPPlayerManager sharedManager].selfUserInfo.userID;
    }
    return userID;
}



- (UITableView *)commonInitTableCreate{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Keyboard_H) style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.zh_backgroundColorPicker =TMColorWithKey(GSThemeColorChatBack);
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue >= 11.0) {  // >= 11
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    
    [self _setExtraCellLineHidden:tableView];
    
    [tableView registerClass:[GSQaAnswerCell class] forCellReuseIdentifier:answerCellFlag];
    [tableView registerClass:[GSQaQuestionCell class] forCellReuseIdentifier:questionCellFlag];
    
    return tableView;
}


- (void)setChatToolbar:(GSChatToolBar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    
    [_chatToolbar setInputViewRightItems:nil];
    
    if (_chatToolbar) {
        [self addSubview:_chatToolbar];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.frame.size.height - _chatToolbar.frame.size.height;
    self.tableView.frame = tableFrame;
    if ([chatToolbar isKindOfClass:[GSChatToolBar class]]) {
        [(GSChatToolBar *)self.chatToolbar setDelegate:self];
        //        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
    }
}


- (NSMutableArray *)dataModelArray
{
    if (!_dataModelArray) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
}



- (void)setEditable:(BOOL)editable{
    _editable = editable;
    
    [self.chatToolbar endEditing:YES];
    
    _chatToolbar.editable = editable;
    
    if (editable) {
        _chatToolbar.inputTextView.placeHolder = @"";
    }else{
        _chatToolbar.inputTextView.placeHolder = @"禁止提问";
    }
    
}

- (void)refresh{
    
    if (_dataModelArray.count == 0) {
        return;
    }
    
    [self.tableView reloadData];
    
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        NSUInteger rows = [self.tableView numberOfRowsInSection:0];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

//插入数据 并插入cell
- (void)insert:(GSQaModel*)model{
    [self insert:model forceBottom:NO];
}

- (void)insert:(GSQaModel*)model forceBottom:(BOOL)isBottom{
    
    if (model.qaData.isCanceled) {

        NSMutableArray *array1 = [NSMutableArray array];
        
        for (GSQaModel *tmp in self.dataModelArray) {
            if ([tmp.qaData.questionID isEqualToString:model.qaData.questionID]) {
                [array1 addObject:tmp];
                
            }
        }
        if (array1.count > 0) {
            [self.dataModelArray removeObjectsInArray:array1];
            [self.tableView reloadData];
        }
 
        return;
    }
    __block BOOL flag = NO;
    if (self.dataModelArray.count > 0) {
        [self.dataModelArray enumerateObjectsUsingBlock:^(GSQaModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.qaData.isQuestion && [model.qaData.questionID isEqualToString:obj.qaData.questionID]) {
                flag = YES;
                *stop = YES;
            }else if (!model.qaData.isQuestion && [model.qaData.answerContent isEqualToString:obj.qaData.answerContent]) {
                flag = YES;
                *stop = YES;
            }
        }];
    }
    
    if (!flag) {
        [self.dataModelArray addObject:model];
        
        [self.tableView reloadData];
        
        if ((!bottomflag) && !isBottom ) {
            //TODO:未读消息逻辑
        }else{
            [self.tableView scrollToBottom:NO];
        }
    }else{
        NSLog(@"QA消息过滤");
    }
    
    
}

- (void)clear{
    
    if (self.dataModelArray.count > 0) {
        [self.dataModelArray removeAllObjects];
    }
    
    [_tableView reloadData];
}





- (void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSQaModel *model;
    NSArray *currentArray;
    model = self.dataModelArray[indexPath.row];
    currentArray = self.dataModelArray;
    GSQaBaseCell *cell = nil;
    
    if (model.qaData.isQuestion) {
        cell     = [tableView dequeueReusableCellWithIdentifier:questionCellFlag];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell     = [tableView dequeueReusableCellWithIdentifier:answerCellFlag];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.tableView = tableView;
    
    [cell setModel:model];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //TODO:未读消息置为已读
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSQaModel *model;
    model = self.dataModelArray[indexPath.row];
    return model.cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSQaModel *model;
    model = self.dataModelArray[indexPath.row];
    
    if (!model.qaData.isQuestion) {
        if (model.expandHeight > model.noExpandHeight) {
            GSQaAnswerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell clickEvent];
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        bottomflag = ((self.tableView.contentSize.height - self.tableView.contentOffset.y) - 20)  <= self.tableView.frame.size.height;
        
    }
}

#pragma mark - Utilities
-(void)_setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Gesture Delegate


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    /**
     *判断如果点击的是tableView的cell，就把手势给关闭了 不是点击cell手势开启
     **/
    
    if (isKeyboardShow) {
        return YES;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"YYLabel"]) {
        return NO;
    }
    
    
    return YES;
}


#pragma mark - GSChatToolbarDelegate


- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    

    CGRect rect = _tableView.frame;
    rect.size.height = self.frame.size.height - toHeight;
    _tableView.frame = rect;
    [_tableView reloadData];
    [self.tableView scrollToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(GSTextView *)inputTextView
{
    //    if (_menuController == nil) {
    //        _menuController = [UIMenuController sharedMenuController];
    //    }
    //    [_menuController setMenuItems:nil];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        
        NSString *str =[text stringByReplacingOccurrencesOfString:@"\r" withString:@"<BR>"];
        
        NSString *queID = [[NSUUID UUID] UUIDString];
        if (!self.editable) {
            //禁止提问
        }else {
            [[GSPPlayerManager sharedManager] askQuestion:queID content:str];
//            [[GSPPlayerManager sharedManager] askQuestion:queID content:str];
        }
        
        GSPUserInfo *info = [GSPPlayerManager sharedManager].selfUserInfo;
        
        GSPQaData *data = [[GSPQaData alloc]init];
        data.questionOwnerName = info.userName;
        data.ownnerID = info.userID;
        data.questionTime =  [[NSDate date] timeIntervalSince1970];
        data.isQuestion = YES;
        data.questionContent = text;
        data.questionID = queID; // 过滤收到的同样的问题
        
        GSQaModel *model = [[GSQaModel alloc]initWithQaData:data];
        [self insert:model forceBottom:YES];
  
    }
}



#pragma mark - private

- (BOOL)endEditing:(BOOL)force //重写endEditing方法
{
    BOOL result = [super endEditing:force];
    
    [self.chatToolbar endEditing:force];
    
    return result;
}


#pragma mark - dealloc

- (void)dealloc{
    
    
}

@end
