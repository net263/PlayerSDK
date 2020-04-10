//
//  GSTextAttachment.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSTextAttachment.h"

#define kEmotionTopMargin -3.0f

@implementation GSTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 0, kEmotionTopMargin, lineFrag.size.height, lineFrag.size.height);
}

@end


#if DEBUG
#define DBLog(fmt, ...) NSLog((@"FASTSDK: %@ %s [Line %d] " fmt), [self class], __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DBLog(fmt, ...)
#endif

@interface GSEmotionEscape ()

@property (nonatomic, strong) NSString *urlPattern;


@end

@implementation GSEmotionEscape

static GSEmotionEscape *_sharedInstance = nil;

+ (GSEmotionEscape *)sharedInstance
{
    if (_sharedInstance == nil)
    {
        @synchronized(self) {
            _sharedInstance = [[GSEmotionEscape alloc] init];
        }
    }
    return _sharedInstance;
}

- (NSString *)urlPattern
{
    if (!_urlPattern) {
        _urlPattern = @"<SPAN[^>]*>([\\s\\S]*?)</SPAN>";
    }
    return _urlPattern;
}

- (NSDictionary *)key2file
{
    if (!_key2file) {
        
        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GSTextAttachment class]] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
        
        NSDictionary* key2fileDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"key2file" ofType:@"plist"]];//emotion\emotion.smile.gif --> 微笑
        _key2file = key2fileDic;
    }
    
    return _key2file;
}

- (NSDictionary *)text2file
{
    if (!_text2file) {
        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GSTextAttachment class]] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
        
        NSDictionary* text2fileDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"text2file" ofType:@"plist"]];//【微笑】--> 微笑
        _text2file = text2fileDic;
    }
    return _text2file;
}

- (NSDictionary *)text2key
{
    if (!_text2key) {
        NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GSTextAttachment class]] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
        
        NSDictionary* text2keyDic = [NSDictionary dictionaryWithContentsOfFile:[resourceBundle pathForResource:@"text2key" ofType:@"plist"]];//【微笑】--> emotion\emotion.smile.gif
        _text2key = text2keyDic;
    }
    return _text2key;
}

- (NSString *)escapeSPANString:(NSString *)span{
    
    NSString *strCon = span;
    NSString *ampString = [strCon stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    NSString *spcaceString = [ampString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    NSString *spcaceString1 = [spcaceString stringByReplacingOccurrencesOfString:@"&#47;" withString:@"/"];
    NSString *spcaceString2 = [spcaceString1 stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
    NSString *spcaceString3 = [spcaceString2 stringByReplacingOccurrencesOfString:@"&#39;" withString:@"\'"];
    NSString *spcaceString4 = [spcaceString3 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSString *spcaceString5 = [spcaceString4 stringByReplacingOccurrencesOfString:@"<br>" withString:@" \r\n"];
    NSString *spcaceString6 = [spcaceString5 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    NSString *spcaceString7 = [spcaceString6 stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.urlPattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSArray *myArray = [regex matchesInString:spcaceString7 options:0 range:NSMakeRange(0, [spcaceString7 length])] ;
    
    if (myArray.count <= 0) {
        return strCon;
    }
    
    NSMutableArray *matchesSpan = [NSMutableArray arrayWithCapacity:[myArray count]];
    for (NSTextCheckingResult *match in myArray) {
        NSRange matchRange = [match rangeAtIndex:1];
        [matchesSpan addObject:[spcaceString7 substringWithRange:matchRange]];
    }
    spcaceString7 = [matchesSpan lastObject];
    
    //匹配表情，将表情转化为html格式
    NSString *text = [spcaceString7 copy];
    NSArray *extraDeletes =  [[NSArray alloc]initWithObjects: @"【太快了】", @"【太慢了】", @"【赞同】", @"【反对】", @"【鼓掌】", @"【值得思考】",nil]; // 额外需要删除的
    
    
    for (NSString *lv in extraDeletes) {
        text = [text stringByReplacingOccurrencesOfString:lv withString:@""];
    }
    
    return text;
}

- (NSAttributedString *) attributeStringFromHtml:(NSString *)html
                                        textFont:(UIFont*)font
                                       imageType:(NSString *)type{
    NSString *text = [self escapeSPANString:html];
    if (!text) {
//        NSAssert(text, @"html error");
        return nil;
    }
    
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression* preRegex = [[NSRegularExpression alloc]
                                     initWithPattern:@"<IMG.+?src=\"(.*?)\".*?>"
                                     options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                     error:nil]; //2
    NSArray* matches = [preRegex matchesInString:text options:0
                                           range:NSMakeRange(0, [text length])];

    for (NSInteger i = matches.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = matches[i];
        NSRange imgMatchRange = [match rangeAtIndex:0];
  
        NSRange keyRange = [match rangeAtIndex:1];
  
        NSString *keyName = [text substringWithRange:keyRange];// emotion\emotion.hx.gif

        NSString *fileName = [self.key2file objectForKey:keyName]; //emotion\emotion.smile.gif --> 微笑
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        
        if (fileName) { // 能找到对应的图片
         
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GSTextAttachment class]] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
            
            NSString *path = [resourceBundle pathForResource:fileName ofType:type];
            //            NSString *path = [resourceBundle pathForResource:name ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            GSTextAttachment * textAttachment = [[GSTextAttachment alloc ] initWithData:nil ofType:nil];
            textAttachment.imageText = [NSString stringWithFormat:@"【%@】",fileName];
            textAttachment.imageFile = fileName;
            textAttachment.imageKey = keyName;
            
            textAttachment.image = image;
            
            NSAttributedString *attachText = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
            
            substr = attachText;
            
            if (substr != nil) { // 使用先删 后加 能够避免数组越界
                [attributedText deleteCharactersInRange:imgMatchRange];
                [attributedText insertAttributedString:substr atIndex:imgMatchRange.location];
            }
          
            DBLog(@" attri : %@",attributedText);
        }
        
    }
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

- (NSAttributedString *) attributeStringFromEmotionText:(NSString *)emotion
                                               textFont:(UIFont *)font
                                              imageType:(NSString *)type{
    NSString *text = emotion;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 表情的规则
    NSString *emotionPattern = @"\\【[a-zA-Z0-9\\u4e00-\\u9fa5]+\\】";
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emotionPattern options:NSRegularExpressionCaseInsensitive error:&error];
    //取得匹配
    NSArray *matchs = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    //逆序 数组
    //    NSArray *sorts = [matchs sortedArrayUsingComparator:^NSComparisonResult(NSTextCheckingResult*  _Nonnull obj1, NSTextCheckingResult*  _Nonnull obj2) {
    //
    //        if (obj2.range.location > obj1.range.location) {
    //            return NSOrderedDescending;
    //        }
    //
    //        return NSOrderedAscending;
    //    }];
    
    for (NSInteger i = matchs.count - 1; i >= 0; i--) {
        NSTextCheckingResult *result = matchs[i];
        
        NSRange range =  [result range];
        NSString *emotionText = [text substringWithRange:range];
        DBLog(@"emotion %@",emotionText);
        
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
   
        NSString *name;
        
        NSArray *keys = [self.text2file allKeys];
        for (NSString *str in keys) {
            if ([str isEqualToString:emotionText]) {
                name = self.text2file[emotionText];
                break;
            }
        }
        if (name) { // 能找到对应的图片
            NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[GSTextAttachment class]] pathForResource:@"PlayerSDK" ofType:@"bundle"]];
            NSString *path = [resourceBundle pathForResource:name ofType:type];
            //            NSString *path = [resourceBundle pathForResource:name ofType:nil];
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
            GSTextAttachment * textAttachment = [[GSTextAttachment alloc ] initWithData:nil ofType:nil];
            textAttachment.imageText = emotionText;
            textAttachment.imageFile = name;
     
            textAttachment.imageKey = [self.text2key objectForKey:emotionText];
            
            textAttachment.image = image;
            
            NSAttributedString *attachText = [NSMutableAttributedString attributedStringWithAttachment:textAttachment];
            
            substr = attachText;
            
            if (substr != nil) { // 使用先删 后加 能够避免数组越界
                [attributedText deleteCharactersInRange:range];
                [attributedText insertAttributedString:substr atIndex:range.location];
            }
       
            DBLog(@"attri : %@",attributedText);
        }
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    
    
    return attributedText;
}

- (NSString *)emotionTextFromHtml:(NSString *)html{
    
    NSString *text = [self escapeSPANString:html];
    
    
    NSRegularExpression* preRegex = [[NSRegularExpression alloc]
                                     initWithPattern:@"<IMG.+?src=\"(.*?)\".*?>"
                                     options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                     error:nil]; //2
    NSArray* matches = [preRegex matchesInString:text options:0
                                           range:NSMakeRange(0, [text length])];
    
    //    NSArray *sorts = [matches sortedArrayUsingComparator:^NSComparisonResult(NSTextCheckingResult*  _Nonnull obj1, NSTextCheckingResult*  _Nonnull obj2) {
    //        if (obj2.range.location > obj1.range.location) {
    //            return NSOrderedDescending;
    //        }
    //
    //        return NSOrderedAscending;
    //    }];
    //    int offset = 0;
    
    for (NSInteger i = matches.count - 1; i >= 0; i--) {
        NSTextCheckingResult *match = matches[i];
        NSRange imgMatchRange = [match rangeAtIndex:0];
        //        imgMatchRange.location += offset;
        
        NSString *imgMatchString = [text substringWithRange:imgMatchRange]; // <IMG src="emotion\emotion.hx.gif" custom="false">
        
        
        NSRange srcMatchRange = [match rangeAtIndex:1];
        //        srcMatchRange.location += offset;
        
        NSString *srcMatchString = [text substringWithRange:srcMatchRange];// emotion\emotion.hx.gif
   
        NSDictionary* key2fileDic = self.key2file;//emotion\emotion.smile.gif --> 微笑
        
        NSDictionary* dic3 = self.text2file; //[表情] -- 表情
        
        NSString *i_transCharacter = [key2fileDic objectForKey:srcMatchString];
        NSString *objectEightId;
        for (NSString *str in [dic3 allKeys]) { // emotion\emotion.hx.gif --> 表情
            if ([[dic3 objectForKey:str] isEqualToString:i_transCharacter]) {
                objectEightId=str;
                break;
            }
        }
        if (objectEightId) {
            NSString *imageHtml = [NSString stringWithFormat:@"%@", objectEightId];
            text = [text stringByReplacingCharactersInRange:NSMakeRange(imgMatchRange.location, [imgMatchString length]) withString:imageHtml];
            //            offset += (imageHtml.length - imgMatchString.length);
        }
        
    }
    
    return text;
}

// 【表情】--> <IMG src="emotion\emotion.qq.gif" custom="false">
- (NSString *)htmlFromEmotionText:(NSString *)emotion{
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:emotion];
    
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 表情的规则
    NSString *emotionPattern = @"\\【[a-zA-Z0-9\\u4e00-\\u9fa5]+\\】";
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emotionPattern options:NSRegularExpressionCaseInsensitive error:&error];
    //取得匹配
    NSArray *matchs = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    for (NSInteger i = matchs.count - 1; i >= 0; i--) {
        NSTextCheckingResult *result = matchs[i];
        
        NSRange range =  [result range];
        NSString *emotionText = [text substringWithRange:range];
        DBLog(@"emotion %@",emotionText);
    
        NSString *key;
        
        NSArray *mkeys = [self.text2key allKeys];
        for (NSString *str in mkeys) {
            if ([str isEqualToString:emotionText]) {
                key = self.text2key[emotionText];
                break;
            }
        }

        if (key != nil) { // 使用先删 后加 能够避免数组越界
            
            NSString* html_img = [NSString stringWithFormat:@"<IMG src=\"%@\" custom=\"false\">",key];
            
            [text deleteCharactersInRange:range];
            [text insertString:html_img atIndex:range.location];
        }
       
    }
    
    
//    NSString *result = [NSString stringWithFormat:@"<SPAN style=\"FONT-STYLE: normal; COLOR: #000000; FONT-SIZE: 10pt; FONT-WEIGHT: normal\">%@</SPAN>",text];
    
//    return result;
    return text;
}

//  attachment + text --> <SPAN style="FONT-STYLE: normal; COLOR: #000000; FONT-SIZE: 10pt; FONT-WEIGHT: normal"><IMG src="emotion\emotion.qq.gif" custom="false"><IMG src="emotion\rose.up.png" custom="false">text</SPAN>
- (NSString *)htmlFromAttributeString:(NSAttributedString*)attributeStr{
    NSMutableString *plainString = [NSMutableString stringWithString:attributeStr.string];

    [attributeStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeStr.length)
                     options:NSAttributedStringEnumerationReverse
                  usingBlock:^(GSTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          
                          NSString *html_img;
                          if (value.imageKey) {
                              html_img = [NSString stringWithFormat:@"<IMG src=\"%@\" custom=\"false\">",value.imageKey];
                          }
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location, range.length)
                                                     withString:html_img?html_img:@""];
                          //                          base += value.emojiTag.length - 1;
                      }
                  }];
    
//    NSString *result = [NSString stringWithFormat:@"<SPAN style=\"FONT-STYLE: normal; COLOR: #000000; FONT-SIZE: 10pt; FONT-WEIGHT: normal\">%@</SPAN>",plainString];
    
//    return result;
    return plainString;
}

//  attachment + text --> 【表情】+ text
- (NSString *)emotionTextFromAttributeString:(NSAttributedString*)attributeStr{
    NSMutableString *plainString = [NSMutableString stringWithString:attributeStr.string];

    [attributeStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeStr.length)
                     options:NSAttributedStringEnumerationReverse
                  usingBlock:^(GSTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          
                          NSString *html_img;
                          if (value.imageFile) {
                              html_img = [NSString stringWithFormat:@"【%@】",value.imageFile];
                          }
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location, range.length)
                                                     withString:html_img?html_img:@""];
                          //                          base += value.emojiTag.length - 1;
                      }
                  }];
    
//    NSString *result = [NSString stringWithFormat:@"<span>%@</span>",plainString];
    return plainString;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void) setEscapePattern:(NSString *)pattern
{
    _urlPattern = pattern;
}



@end
