//
//  GSEmotionManager.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSEmotionManager.h"

@implementation GSEmotionManager

- (id)initWithType:(GSEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
{
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        NSMutableArray *tempEmotions = [NSMutableArray array];
        for (id name in emotions) {
            if ([name isKindOfClass:[NSString class]]) {
                GSEmotion *emotion = [[GSEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:GSEmotionDefault];
                [tempEmotions addObject:emotion];
            }
        }
        _emotions = tempEmotions;
        _tagImage = nil;
    }
    return self;
}

- (id)initWithType:(GSEmotionType)Type
        emotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage

{
    self = [super init];
    if (self) {
        _emotionType = Type;
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        _emotions = emotions;
        _tagImage = tagImage;
    }
    return self;
}

@end

@implementation GSEmotion

- (id)initWithName:(NSString*)emotionTitle
         emotionId:(NSString*)emotionId
  emotionThumbnail:(NSString*)emotionThumbnail
   emotionOriginal:(NSString*)emotionOriginal
emotionOriginalURL:(NSString*)emotionOriginalURL
       emotionType:(GSEmotionType)emotionType
{
    self = [super init];
    if (self) {
        _emotionTitle = emotionTitle;
        _emotionId = emotionId;
        _emotionThumbnail = emotionThumbnail;
        _emotionOriginal = emotionOriginal;
        _emotionOriginalURL = emotionOriginalURL;
        _emotionType = emotionType;
    }
    return self;
}

@end
