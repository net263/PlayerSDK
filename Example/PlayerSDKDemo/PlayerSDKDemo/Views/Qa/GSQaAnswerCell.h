//
//  GSQaAnswerCell.h
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSQaBaseCell.h"

@interface GSQaAnswerCell : GSQaBaseCell

@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *content; //内容
@property (nonatomic, strong) UILabel *expandContent; //可以扩张的内容

@property (nonatomic, strong) UIImageView *expandIcon;



- (void)clickEvent;

@end
