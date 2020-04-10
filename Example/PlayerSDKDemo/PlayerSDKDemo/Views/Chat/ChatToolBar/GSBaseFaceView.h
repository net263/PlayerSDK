//
//  GSBaseFaceView.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSEmotion;
@protocol GSBaseFaceViewDelegate

@optional

/*!
 @method
 @brief 选中默认表情
 @discussion
 @param str 选中的默认表情
 @result
 */
-(void)selectedFacialView:(NSString*)str;

/*!
 @method
 @brief 删除默认表情
 @discussion
 @result
 */
-(void)deleteSelected:(NSString *)str;

/*!
 @method
 @brief 点击表情键盘的发送回调
 @discussion
 @result
 */
-(void)sendFace;

/*!
 @method
 @brief 选择自定义表情，直接发送
 @discussion
 @param emotion    被选中的自定义表情
 @result
 */
-(void)sendFace:(GSEmotion *)emotion;

@end

@class GSManager;
@interface GSBaseFaceView : UIView
{
    NSMutableArray *_faces;
}

@property(nonatomic, weak) id<GSBaseFaceViewDelegate> delegate;

@property(strong, nonatomic, readonly) NSArray *faces;


-(void)loadFacialView:(NSArray*)emotionManagers size:(CGSize)size;

-(void)loadFacialViewWithPage:(NSInteger)page;

//-(void)loadFacialView:(int)page size:(CGSize)size;

@end
