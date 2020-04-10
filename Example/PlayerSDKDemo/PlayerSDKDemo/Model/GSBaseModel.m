//
//  GSBaseModel.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSBaseModel.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 20)

@implementation GSBaseModel

-(void)setSubinfo:(NSString *)subinfo
{
    _subinfo = subinfo;
    
    _subInfoHeight = [GSBaseModel heightWithString:_subinfo LabelFont:[UIFont systemFontOfSize:14.f] withLabelWidth:WIDTH];
    
    _totalHeight = _subInfoHeight + _infoHeight + _messageHeight;
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
