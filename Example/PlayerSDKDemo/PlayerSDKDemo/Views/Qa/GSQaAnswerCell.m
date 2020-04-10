//
//  GSQaAnswerCell.m
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import "GSQaAnswerCell.h"
#import "UIView+GSSetRect.h"

#define GAP 5

@implementation GSQaAnswerCell

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
        
        _expandContent = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 55, 20)];
        _expandContent.textAlignment = NSTextAlignmentLeft;
        _expandContent.font = [UIFont systemFontOfSize:14.f];
        _expandContent.numberOfLines = 0;
        _expandContent.textColor = UICOLOR16(0x999999);
        _expandContent.lineBreakMode = NSLineBreakByTruncatingTail;
//        _expandContent.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_expandContent];
        
        _expandIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qa_Pack"]];
        _expandIcon.frame = CGRectMake([GSQaBaseCell appearance].cellWidth - 10 - 30, _content.y + _content.height + 5, 30, 10);
        _expandIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_expandIcon];
        
        self.clipsToBounds = YES;
        self.backgroundColor = UICOLOR16(0xF4F4F6);
    }
    return self;
}

- (void)setModel:(GSQaModel *)model
{
    [super setModel:model];
    
    
        
    _nickLabel.text = self.model.nickName;
    _nickLabel.frame = CGRectMake(10, 10, [GSQaBaseCell appearance].cellWidth - 20, model.nickHeight);
    [_nickLabel sizeToFit];
    
    _timeLabel.text = self.model.timeStr;
    _timeLabel.height = self.model.nickHeight;
    
    _content.text = self.model.content;
    _content.frame = CGRectMake(10, CGRectGetMaxY(_nickLabel.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20, self.model.contentHeight);
    [_content sizeToFit];
    
    if (model.expandHeight <= model.noExpandHeight) {
        _expandIcon.hidden = YES;
    }else{
        _expandIcon.hidden = NO;
    }
    
    _expandContent.text = self.model.expandContent;
    if (!self.model.expand) {
        [self normalStateWithAnimated:NO];
    }else{
        [self expendStateWithAnimated:NO];
    }
    

}

- (void)clickEvent {
    
    if (self.model.expand == YES) {
        
        self.model.expand = NO;
        [self normalStateWithAnimated:YES];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];

    } else {
        
        self.model.expand = YES;
        [self expendStateWithAnimated:YES];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];

    }
}

- (void)normalStateWithAnimated:(BOOL)animated {
    
    if (animated == YES) {
        
        [UIView animateWithDuration:0.35f animations:^{
            
            [self _normalState];
        } completion:^(BOOL finished) {
            _expandContent.frame = CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20 - GAP - 30, self.model.noExpandHeight);
        }];
        
    } else {
        [self _normalState];
        
        _expandContent.frame = CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20 - GAP - 30, self.model.noExpandHeight);
    }
}

- (void)_normalState{
//    _expandContent.frame = CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20 - GAP - 30, self.model.noExpandHeight);
    _expandIcon.frame = CGRectMake([GSQaBaseCell appearance].cellWidth - 10 - 30, _content.y + _content.height + 5, 30, 10);
    _expandIcon.image = [UIImage imageNamed:@"qa_open"];
    self.model.cellHeight =  10 + self.model.nickHeight + 5 + self.model.contentHeight + 5 + self.model.noExpandHeight + 10;
}

- (void)expendStateWithAnimated:(BOOL)animated {
    
    if (animated == YES) {
        
        _expandContent.frame = CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20 - GAP - 30, self.model.expandHeight);
        
        [UIView animateWithDuration:0.35f animations:^{
            [self _expendState];
        }];
        
    } else {
        _expandContent.frame = CGRectMake(10, CGRectGetMaxY(_content.frame) + 5, [GSQaBaseCell appearance].cellWidth - 20 - GAP - 30, self.model.expandHeight);
        
        [self _expendState];
    }
}

- (void)_expendState{
    
    _expandIcon.frame = CGRectMake([GSQaBaseCell appearance].cellWidth - 10 - 30, _content.y + _content.height + 5, 30, 10);
    _expandIcon.image = [UIImage imageNamed:@"qa_Pack"];
    self.model.cellHeight =  10 + self.model.nickHeight + 5 + self.model.contentHeight + 5 + self.model.expandHeight + 10;
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
