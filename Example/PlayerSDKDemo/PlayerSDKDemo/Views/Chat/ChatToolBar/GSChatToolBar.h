//
//  GSChatToolBar.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/17.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - GSChatToolbarItem

@interface GSChatToolbarItem : NSObject

@property (strong, nonatomic, readonly) UIButton *button;

@property (strong, nonatomic) UIView *linkView;

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)linkView;

@end

#pragma mark - GSTextView

@interface GSTextView : UITextView

/*
 *  提示用户输入的标语
 */
@property (nonatomic, copy) NSString *placeHolder;

/*
 *  标语文本的颜色
 */
@property (nonatomic, strong) UIColor *placeHolderTextColor;



@end


#pragma mark - GSChatToolBar
@protocol GSChatToolbarDelegate;
@interface GSChatToolBar : UIView


@property (weak, nonatomic) id<GSChatToolbarDelegate> delegate;

@property (strong, nonatomic) UIView *moreView;

@property (strong, nonatomic) UIView *faceView;

@property (nonatomic) UIImage *backgroundImage;

@property (nonatomic, assign) BOOL editable;//

@property (strong, nonatomic) GSTextView *inputTextView;

//置nil使button消失
//- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems;

- (void)setEmotionHide:(BOOL)isHide;

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems;

- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems;

- (void)addGenseeBack;

- (void)usingBlackStyle;

/**
 *  Initializa chat bar
 * @param horizontalPadding  default 8
 * @param verticalPadding    default 5
 * @param inputViewMinHeight default 36
 * @param inputViewMaxHeight default 150
 */
- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight;

/*!
 @method
 @brief 切换底部的菜单视图
 @discussion
 @param bottomView 待切换的菜单
 @result
 */
- (void)willShowBottomView:(UIView *)bottomView;

@end

@protocol GSChatToolbarDelegate <NSObject>

@optional

/*
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(GSTextView *)inputTextView;

/*
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(GSTextView *)inputTextView;

/*
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/*
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 *  @param ext 扩展消息
 */
- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext;


/**
 显示我的消息

 @param isShow
 */
- (void)didShowMyMessage:(BOOL)isShow;

///*
// *  在光标location位置处是否插入字符@   用于@用户的
// *
// *  @param location 光标位置
// */
//- (BOOL)didInputAtInLocation:(NSUInteger)location;

///*
// *  在光标location位置处是否删除字符@
// *
// *  @param location 光标位置
// */
//- (BOOL)didDeleteCharacterFromLocation:(NSUInteger)location;

/*
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

@required


/*
 *  高度变到toHeight  完成
 */
- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight;

@end



