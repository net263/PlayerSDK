//
//  GSQaBaseCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSQaBaseCell.h"

@implementation GSQaBaseCell

+ (void)initialize{
    // UIAppearance Proxy Defaults
    GSQaBaseCell *cell = [self appearance];
    cell.contentFont = [UIFont systemFontOfSize:14.f];
    cell.nickFont = [UIFont systemFontOfSize:13.f];
    cell.cellWidth = (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
