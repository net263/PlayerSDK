//
//  GSQaQuestionCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSQaQuestionCell.h"
#import "UIView+GSSetRect.h"


@implementation GSQaQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [GSQaBaseCell appearance].cellWidth - 90, 20)];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.font = [UIFont systemFontOfSize:13.f];
        _nickLabel.textColor = UICOLOR16(0x339CF5);
        [self.contentView addSubview:_nickLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake([GSQaBaseCell appearance].cellWidth - 80, 10, 70, 20)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = UICOLOR16(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_timeLabel];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_nickLabel.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20, 20)];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.font = [UIFont systemFontOfSize:14.f];
        _content.numberOfLines = 0;
        _content.textColor = UICOLOR16(0x4D4D4D);
        [self.contentView addSubview:_content];
        
        self.backgroundColor = UICOLOR16(0xF4F4F6);
    }
    return self;
}

- (void)setModel:(GSQaModel *)model
{
    
    if (self.model && self.model == model) {
        //do nothing
    }else{
        [super setModel:model];
        
        _nickLabel.text = model.nickName;
        _nickLabel.frame = CGRectMake(10, 10, [GSQaBaseCell appearance].cellWidth - 20, model.nickHeight);
        [_nickLabel sizeToFit];
        
        _timeLabel.text = model.timeStr;
        _timeLabel.height = model.nickHeight;
        
        _content.text = model.content;
        _content.frame = CGRectMake(10, CGRectGetMaxY(_nickLabel.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20, model.contentHeight);
        [_content sizeToFit];
    }

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
