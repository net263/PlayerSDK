//
//  GSQaModel.m
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSQaModel.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height))

@implementation GSQaModel


- (instancetype)initWithQaData:(GSPQaData*)data{
    
    if (self = [super init]) {
        _qaData = data;
        long long userID = [GSPPlayerManager sharedManager].selfUserInfo.userID;
       
        if (_qaData.isQuestion) {
            _expandContent = nil;
            _expandHeight = 0;
            _noExpandHeight = 0;
            
            if (_qaData.ownnerID == userID) {
                _isSelf = YES;
                _nickName = [NSString stringWithFormat:@"%@ %@",@"我",@"问"];
            }else{
                _nickName = [NSString stringWithFormat:@"%@ %@",_qaData.questionOwnerName,@"问"];
            }
            
            _content = _qaData.questionContent;
            
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:_qaData.questionTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            _timeStr = dateString;
            
            _nickHeight = [GSQaModel heightWithString:_nickName LabelFont:[UIFont systemFontOfSize:13] withLabelWidth:WIDTH - 20];
            _contentHeight  = [GSQaModel heightWithString:_content LabelFont:[UIFont systemFontOfSize:14] withLabelWidth:WIDTH - 20];
            _cellHeight = 10 + _nickHeight + 5 + _contentHeight + 10;
     
        }else{
            NSString *who_ask;
            if (_qaData.ownnerID == userID) {
                _isSelf = YES;
                _nickName = [NSString stringWithFormat:@"%@ %@ %@",_qaData.answerOwnerName,@"答",@"我"];
                who_ask = [NSString stringWithFormat:@"%@ %@:",@"我",@"问"];
            }else{
                _nickName = [NSString stringWithFormat:@"%@ %@ %@",_qaData.answerOwnerName,@"答",_qaData.ownerName];
                who_ask = [NSString stringWithFormat:@"%@ %@:",_qaData.ownerName,@"问"];
            }
            
            _content = _qaData.answerContent;
            
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:_qaData.answerTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            _timeStr = dateString;
            
            
            NSString *expandStr = [who_ask stringByAppendingString:_qaData.questionContent];
            _expandContent = expandStr;
            _nickHeight = [GSQaModel heightWithString:_nickName LabelFont:[UIFont systemFontOfSize:13] withLabelWidth:WIDTH - 20];
            _contentHeight  = [GSQaModel heightWithString:_qaData.answerContent LabelFont:[UIFont systemFontOfSize:14] withLabelWidth:WIDTH - 20];
            _expandHeight  = [GSQaModel heightWithString:_expandContent LabelFont:[UIFont systemFontOfSize:14] withLabelWidth:WIDTH - 20 - 5 - 30];
            _noExpandHeight = [GSQaModel heightWithString:@"谁问" LabelFont:[UIFont systemFontOfSize:14] withLabelWidth:WIDTH - 20 - 5 - 30];
            
            _cellHeight = 10 + _nickHeight + 5 + _contentHeight + 5 + _noExpandHeight + 10;
        }
        
        
        
    }
    return self;
}

#pragma mark - 计算文本高度
+ (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;
    
    if (string.length == 0) {
        height = 0;
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
        
        height = retSize.height;
    }
    
    return height;
}


@end
