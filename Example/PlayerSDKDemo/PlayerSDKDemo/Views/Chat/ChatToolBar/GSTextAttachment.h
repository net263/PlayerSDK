//
//  GSTextAttachment.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSEmotionEscape : NSObject

@property (nonatomic, strong) NSDictionary *key2file; //emotion\emotion.smile.gif --> 微笑

@property (nonatomic, strong) NSDictionary *text2file; // 【微笑】--> emotion\emotion.smile.gif

@property (nonatomic, strong) NSDictionary *text2key; //【微笑】--> 微笑

+ (GSEmotionEscape *)sharedInstance;

// <IMG src="emotion\emotion.qq.gif" custom="false"> --> attachment + text
- (NSAttributedString *) attributeStringFromHtml:(NSString *)html
                                        textFont:(UIFont*)font
                                       imageType:(NSString *)type;
// 【表情】 --> attachment + text
- (NSAttributedString *) attributeStringFromEmotionText:(NSString *)emotion
                                               textFont:(UIFont*)font
                                              imageType:(NSString *)type;

// <IMG src="emotion\emotion.qq.gif" custom="false"> --> 【表情】
- (NSString *)emotionTextFromHtml:(NSString *)html;

// 【表情】--> <IMG src="emotion\emotion.qq.gif" custom="false">
- (NSString *)htmlFromEmotionText:(NSString *)emotion;

//  attachment + text --> <SPAN style="FONT-STYLE: normal; COLOR: #000000; FONT-SIZE: 10pt; FONT-WEIGHT: normal"><IMG src="emotion\emotion.qq.gif" custom="false"><IMG src="emotion\rose.up.png" custom="false">text</SPAN>
- (NSString *)htmlFromAttributeString:(NSAttributedString*)attributeStr;

//  attachment + text --> 【表情】+ text
- (NSString *)emotionTextFromAttributeString:(NSAttributedString*)attributeStr;


+ (BOOL)stringContainsEmoji:(NSString *)string;

- (void)setEscapePattern:(NSString*)pattern;


@end

@interface GSTextAttachment : NSTextAttachment

@property (nonatomic, strong) NSString *imageText; // [表情]

@property (nonatomic, strong) NSString *imageFile; // 表情

@property (nonatomic, strong) NSString *imageKey; // emotion\feedback.quickly.png


@end
