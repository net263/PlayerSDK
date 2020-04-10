//
//  GSQaModel.h
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Comm>
@interface GSQaModel : NSObject
@property (nonatomic, strong) GSPQaData *qaData;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *content; //内容
@property (nonatomic, strong) NSString *expandContent; //可以扩张的内容
@property (nonatomic, assign) BOOL expand; //是否扩展开
@property (nonatomic, assign) BOOL isSelf; //是否扩展开
@property (nonatomic, assign) CGFloat   nickHeight;
@property (nonatomic, assign) CGFloat   contentHeight; //暂留
@property (nonatomic, assign) CGFloat   noExpandHeight;
@property (nonatomic, assign) CGFloat   expandHeight;

@property (nonatomic, assign) CGFloat   cellHeight;

- (instancetype)initWithQaData:(GSPQaData*)data;

+ (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width;

@end
