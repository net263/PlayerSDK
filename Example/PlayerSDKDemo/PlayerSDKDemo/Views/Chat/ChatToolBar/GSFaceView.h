//
//  GSFaceView.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//  包含表情的collectionView

#import <UIKit/UIKit.h>
#import "GSEmotionManager.h"
#import "GSBaseFaceView.h"

@protocol GSFaceDelegate

@required
/*!
 @method
 @brief 输入表情键盘的默认表情，或者点击删除按钮
 @discussion
 @param str       被选择的表情编码
 @param isDelete  是否为删除操作
 @result
 */
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;

/*!
 @method
 @brief 点击表情键盘的发送回调
 @discussion
 @result
 */
- (void)sendFace;

/*!
 @method
 @brief 点击表情键盘的自定义表情，直接发送
 @discussion
 @param emotion 自定义表情对象
 @result
 */
- (void)sendFaceWithEmotion:(GSEmotion *)emotion;

@end

@interface GSFaceView : UIView <GSBaseFaceViewDelegate>

@property (nonatomic, weak) id<GSFaceDelegate> delegate;

- (BOOL)stringIsFace:(NSString *)string;

/*!
 @method
 @brief 通过数据源获取表情分组数,
 @discussion
 @param number 分组数
 @param emotionManagers 表情分组列表
 @result
 */
- (void)setEmotionManagers:(NSArray*)emotionManagers;

@end
