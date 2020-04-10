//
//  GSEmotionManager.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GENSEE_EMOTION_DEFAULT_EXT @"gs_emotion"

#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"gs_is_big_expression"
#define MESSAGE_ATTR_EXPRESSION_ID @"gs_expression_id"

typedef NS_ENUM(NSUInteger, GSEmotionType) {
    GSEmotionDefault = 0,
    GSEmotionGensee,
    GSEmotionPng,
    GSEmotionGif
};

@interface GSEmotionManager : NSObject

@property (nonatomic, strong) NSArray *emotions;

/*!
 @property
 @brief number of lines of emotion
 */
@property (nonatomic, assign) NSInteger emotionRow;

/*!
 @property
 @brief number of columns of emotion
 */
@property (nonatomic, assign) NSInteger emotionCol;

/*!
 @property
 @brief emotion type
 */
@property (nonatomic, assign) GSEmotionType emotionType;

@property (nonatomic, strong) UIImage *tagImage;

@property (nonatomic, assign) NSInteger emotionPageIndex;//表情所指向section


- (id)initWithType:(GSEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions;

- (id)initWithType:(GSEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage;

@end

@interface GSEmotion : NSObject

@property (nonatomic, assign) GSEmotionType emotionType;

@property (nonatomic, copy) NSString *emotionTitle; //ex: 【微笑】

@property (nonatomic, copy) NSString *emotionId; //与服务器交互的id ex: emotion\emotion.angerly.gif

@property (nonatomic, copy) NSString *emotionThumbnail;  //缩略图 ex: 微笑 ,本地表情可用于取本地图片

@property (nonatomic, copy) NSString *emotionOriginal; //图片路径

@property (nonatomic, copy) NSString *emotionOriginalURL; //图片路径 url

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(GSEmotionType)emotionType;

@end
