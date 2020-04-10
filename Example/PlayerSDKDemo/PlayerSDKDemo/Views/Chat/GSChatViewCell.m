//
//  GSChatViewCell.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSChatViewCell.h"
#import "UIView+GSSetRect.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 20)

@implementation GSChatViewCell

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
//        _content.font          = [UIFont italicSystemFontOfSize:16.f];
//        _content.textColor     = [UIColor redColor];
        [self addSubview:_content];
        
        
    }
    
    return self;
}
- (void)setModel:(GSChatModel *)model
{
    _model = model;
    
    _nickName.text = model.info;
    _nickName.frame = CGRectMake(10, 5, WIDTH, 20);
    [_nickName sizeToFit];
    
    _timeLab.text = model.timeStr;
    [_timeLab sizeToFit];
    _timeLab.frame = CGRectMake(WIDTH - _timeLab.bounds.size.width - 10, 5, _timeLab.bounds.size.width + 10, _timeLab.bounds.size.height);
    
    _typeLabel.text = model.subinfo;
    _typeLabel.frame = CGRectMake(10, _nickName.height + 5, WIDTH, model.subInfoHeight);
    
    if (model.type == GSChatModelPrivate) {
        _typeLabel.textColor     = [UIColor redColor];
    }else{
        _typeLabel.textColor     = [UIColor grayColor];
    }
    
    [_typeLabel sizeToFit];
    
    _content.attributedText = model.message;
//    _content.textLayout = model.layout;
    _content.frame = CGRectMake(10, _nickName.height + _timeLab.height + 5, WIDTH, model.messageHeight);
    [_content sizeToFit];
    
    
    
    
}

@end
