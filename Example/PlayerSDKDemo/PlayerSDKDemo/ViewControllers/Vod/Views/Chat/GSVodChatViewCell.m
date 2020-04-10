//
//  GSChatViewCell.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSVodChatViewCell.h"
#import "UIView+GSSetRect.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 20)

@implementation GSVodChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _nickName                  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH, 20)];
        _nickName.numberOfLines    = 0;
        _nickName.font             = [UIFont fontWithName:@"Heiti SC" size:14.f];
        _nickName.textColor        = [UIColor blackColor];
        [self addSubview:_nickName];
        
        
        _timeLab               = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH, 20)];
        _timeLab.numberOfLines = 0;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font          = [UIFont fontWithName:@"Heiti SC" size:12.f];
        _timeLab.textColor     = [UIColor grayColor];
        [self addSubview:_timeLab];
        
        _typeLabel               = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH, 20)];
        _typeLabel.numberOfLines = 0;
        _typeLabel.font          = [UIFont fontWithName:@"Heiti SC" size:12.f];
        _typeLabel.textColor     = [UIColor grayColor];
        [self addSubview:_typeLabel];
        
        
        _content               = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH, 20)];
        _content.numberOfLines = 0;
        [self addSubview:_content];
        
        
    }
    
    return self;
}
- (void)setModel:(GSVodChatModel *)model
{
    _model = model;
    
    _nickName.text = model.info;
    _nickName.frame = CGRectMake(10, 5, WIDTH, 20);
    [_nickName sizeToFit];
    
    _timeLab.text = model.timeStr;
    [_timeLab sizeToFit];
    _timeLab.frame = CGRectMake(WIDTH - _timeLab.bounds.size.width - 10, 5, _timeLab.bounds.size.width + 10, _timeLab.bounds.size.height);
    
    _content.attributedText = model.message;
//    _content.textLayout = model.layout;
    _content.frame = CGRectMake(10, _nickName.height + 5, WIDTH, model.messageHeight);
    [_content sizeToFit];
}

@end
