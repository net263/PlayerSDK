//
//  GSChatView.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSChatView.h"
#import "UIView+GSSetRect.h"
#import "GSFaceView.h"
#import "GSTextAttachment.h"
#import "GSChatModel.h"

#pragma mark - tableView gategory

@implementation UITableView (scrollBottom)

- (void)scrollToBottom:(BOOL)animated{
    NSUInteger rows = [self numberOfRowsInSection:0];
    if (rows > 0 && (self.contentSize.height > self.bounds.size.height)) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

@end

#define Keyboard_H 49

@interface GSChatView () <UITableViewDelegate,UITableViewDataSource, GSChatToolbarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) GSFaceView *faceView;

@end

@implementation GSChatView
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
- (void)insert:(GSChatModel*)model{
    [self insert:model forceBottom:NO];
}

- (void)insert:(GSChatModel*)model forceBottom:(BOOL)isBottom{
    

    
    if (self.dataModelArray.count > 200) {
        [self.dataModelArray removeObjectAtIndex:0];
    }
    
    [self.dataModelArray addObject:model];
    
    [self.tableView reloadData];
    
    if ((!bottomflag) && !isBottom ) {
        
        //这里应该是未读消息提示操作
        
    }else{
        [self.tableView scrollToBottom:NO];
        
    }
 
}

- (void)removeByUser:(NSString *)userID{
    NSMutableArray *removeArr = [NSMutableArray array];
    for (GSChatModel *model in self.dataModelArray) {
        if (model.chatMessage.senderUserID == userID.longLongValue) {
            [removeArr addObject:model];
        }
    }
    
    [self.dataModelArray removeObjectsInArray:removeArr];


    
    if (!self.tableView.hidden) {
        [self.tableView reloadData];
    }

}
- (void)removeByMessage:(NSString *)messageID{
    
    GSChatModel *deleteModel;
    
    for (GSChatModel *model in self.dataModelArray) {
        if ([model.chatMessage.msgID isEqualToString:messageID]) {
            deleteModel = model;
            break;
        }
    }
    
    [self.dataModelArray removeObject:deleteModel];
    

    if (!self.tableView.hidden) {
        [self.tableView reloadData];
    }

    
}

static NSString *modelCellFlag = @"GSChatViewCell.h";

- (void)loadContent{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Keyboard_H) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self _setExtraCellLineHidden:_tableView];

    
    
    
    self.chatToolbar = [[GSChatToolBar alloc]initWithFrame:CGRectMake(0, self.frame.size.height - Keyboard_H, self.frame.size.width, Keyboard_H)];
    self.chatToolbar.delegate = self;

    [self addSubview:_chatToolbar];

    
    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self addGestureRecognizer:tap];
    
    [_tableView registerClass:[GSChatViewCell class] forCellReuseIdentifier:modelCellFlag];
    
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
//    [emotionSortArray addObject:@"你好"];
//    [emotionSortArray addObject:@"再见"];
//    [emotionSortArray addObject:@"高兴"];
//    [emotionSortArray addObject:@"伤心"];
//    [emotionSortArray addObject:@"愤怒"];
//    [emotionSortArray addObject:@"无聊"];
//    [emotionSortArray addObject:@"流汗"];
//    [emotionSortArray addObject:@"疑问"];
//    [emotionSortArray addObject:@"鄙视"];
//    [emotionSortArray addObject:@"鲜花"];
//    [emotionSortArray addObject:@"凋谢"];
//    [emotionSortArray addObject:@"礼物"];
//    [emotionSortArray addObject:@"太快了"];
//    [emotionSortArray addObject:@"太慢了"];
//    [emotionSortArray addObject:@"赞同"];
//    [emotionSortArray addObject:@"反对"];
//    [emotionSortArray addObject:@"鼓掌"];
//    [emotionSortArray addObject:@"值得思考"];
    
    NSMutableArray *emotions = [NSMutableArray array];
    
    for (int i = 0; i <= emotionSortArray.count - 1; i++) {
        NSString *key = emotionSortArray[i];
//        NSString *text = [NSString stringWithFormat:@"【%@】",key];
        NSString *value = [text2keyDic objectForKey:key];
        
        NSString *file = [key stringByReplacingOccurrencesOfString:@"【" withString:@""];
        NSString *file1 = [file stringByReplacingOccurrencesOfString:@"】" withString:@""];
        NSString *path = [resourceBundle pathForResource:file1 ofType:@"png"];
        GSEmotion *emotion = [[GSEmotion alloc] initWithName:key emotionId:value emotionThumbnail:key emotionOriginal:path emotionOriginalURL:@"" emotionType:GSEmotionGensee];
        [emotions addObject:emotion];
    }
    
    GSEmotion *emotion = [emotions objectAtIndex:0];
    GSEmotionManager *manager= [[GSEmotionManager alloc] initWithType:GSEmotionGensee emotionRow:3 emotionCol:6 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionOriginal]];
//    GSEmotionManager *manager2= [[GSEmotionManager alloc] initWithType:GSEmotionGensee emotionRow:3 emotionCol:6 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionOriginal]];
    
    [self.faceView setEmotionManagers:@[manager]];
//        NSMutableArray *emotions = [NSMutableArray array];
//        for (NSString *name in [EaseEmoji allEmoji]) {
//            EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
//            [emotions addObject:emotion];
//        }
//        EaseEmotion *emotion = [emotions objectAtIndex:0];
//        EaseEmotionManager *manager= [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:emotion.emotionId]];
//        [self.faceView setEmotionManagers:@[manager]];
    
}
- (void)setChatToolbar:(GSChatToolBar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self addSubview:_chatToolbar];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.frame.size.height - _chatToolbar.frame.size.height;
    self.tableView.frame = tableFrame;
    if ([chatToolbar isKindOfClass:[GSChatToolBar class]]) {
        [(GSChatToolBar *)self.chatToolbar setDelegate:self];
//        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
        self.faceView = (GSFaceView*)[(GSChatToolBar *)self.chatToolbar faceView];
//        self.recordView = (EaseRecordView*)[(GSChatToolbar *)self.chatToolbar recordView];
    }
}


-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
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
    GSChatViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:modelCellFlag];
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
    
//    NSLog(@"sizeH:%f,H:%f,Y:%f",self.tableView.contentSize.height,self.tableView.frame.size.height,contentOffsetY);
    
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
        
        NSString *normalText = [[GSPPlayerManager sharedManager] textFilter:text];
        
        NSString *html = [[GSEmotionEscape sharedInstance] htmlFromEmotionText:normalText];
        
        GSPUserInfo *user = [GSPPlayerManager sharedManager].selfUserInfo;
        
        GSPChatMessage *chatMessage = [GSPChatMessage new];
        chatMessage.text = normalText;
        chatMessage.richText = html;
        chatMessage.msgID = [[NSUUID UUID] UUIDString];
        chatMessage.senderName = user.userName;
        chatMessage.senderUserID = user.userID;
        chatMessage.senderName = user.userName;
        chatMessage.chatType = GSPChatTypePublic;
        chatMessage.receiveTime = [[NSDate date] timeIntervalSince1970];
        GSChatModel *model = [[GSChatModel alloc]initWithModel:chatMessage type:GSChatModelPublic];

        [self insert:model forceBottom:YES];
        
        [[GSPPlayerManager sharedManager] chatWithAll:chatMessage];
        
        NSLog(@"text:%@,html:%@",normalText,html);
    }
}

//- (BOOL)didInputAtInLocation:(NSUInteger)location
//{
//    if ([self.delegate respondsToSelector:@selector(messageViewController:selectAtTarget:)] && self.conversation.type == EMConversationTypeGroupChat) {
//        location += 1;
//        __weak typeof(self) weakSelf = self;
//        [self.delegate messageViewController:self selectAtTarget:^(EaseAtTarget *target) {
//            __strong EaseMessageViewController *strongSelf = weakSelf;
//            if (strongSelf && target) {
//                if ([target.userId length] || [target.nickname length]) {
//                    [strongSelf.atTargets addObject:target];
//                    NSString *insertStr = [NSString stringWithFormat:@"%@ ", target.nickname ? target.nickname : target.userId];
//                    EaseChatToolbar *toolbar = (EaseChatToolbar*)strongSelf.chatToolbar;
//                    NSMutableString *originStr = [toolbar.inputTextView.text mutableCopy];
//                    NSUInteger insertLocation = location > originStr.length ? originStr.length : location;
//                    [originStr insertString:insertStr atIndex:insertLocation];
//                    toolbar.inputTextView.text = originStr;
//                    toolbar.inputTextView.selectedRange = NSMakeRange(insertLocation + insertStr.length, 0);
//                    [toolbar.inputTextView becomeFirstResponder];
//                }
//            }
//            else if (strongSelf) {
//                EaseChatToolbar *toolbar = (EaseChatToolbar*)strongSelf.chatToolbar;
//                [toolbar.inputTextView becomeFirstResponder];
//            }
//        }];
//        EaseChatToolbar *toolbar = (EaseChatToolbar*)self.chatToolbar;
//        toolbar.inputTextView.text = [NSString stringWithFormat:@"%@@", toolbar.inputTextView.text];
//        [toolbar.inputTextView resignFirstResponder];
//        return YES;
//    }
//    else {
//        return NO;
//    }
//}

//- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location
//{
//    GSChatToolbar *toolbar = (GSChatToolbar*)self.chatToolbar;
//    if ([toolbar.inputTextView.text length] == location + 1) {
//        //delete last character
//        NSString *inputText = toolbar.inputTextView.text;
//        NSRange range = [inputText rangeOfString:@"@" options:NSBackwardsSearch];
//        if (range.location != NSNotFound) {
//            if (location - range.location > 1) {
//                NSString *sub = [inputText substringWithRange:NSMakeRange(range.location + 1, location - range.location - 1)];
//                for (EaseAtTarget *target in self.atTargets) {
//                    if ([sub isEqualToString:target.userId] || [sub isEqualToString:target.nickname]) {
//                        inputText = range.location > 0 ? [inputText substringToIndex:range.location] : @"";
//                        toolbar.inputTextView.text = inputText;
//                        toolbar.inputTextView.selectedRange = NSMakeRange(inputText.length, 0);
//                        [self.atTargets removeObject:target];
//                        return YES;
//                    }
//                }
//            }
//        }
//    }
//    return NO;
//}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{
    //发送图片
//    if ([ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT]) {
//        GSEmotion *emotion = [ext objectForKey:EASEUI_EMOTION_DEFAULT_EXT];
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(emotionExtFormessageViewController:easeEmotion:)]) {
//            NSDictionary *ext = [self.dataSource emotionExtFormessageViewController:self easeEmotion:emotion];
//            [self sendTextMessage:emotion.emotionTitle withExt:ext];
//        } else {
//            [self sendTextMessage:emotion.emotionTitle withExt:@{MESSAGE_ATTR_EXPRESSION_ID:emotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)}];
//        }
//        return;
//    }
//    if (text && text.length > 0) {
//        [self sendTextMessage:text withExt:ext];
//    }
}





@end
