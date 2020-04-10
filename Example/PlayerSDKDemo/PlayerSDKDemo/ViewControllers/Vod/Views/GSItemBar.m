//
//  GSItemBar.m
//  VodSDKDemo
//
//  Created by gensee on 2019/7/30.
//  Copyright © 2019年 Gensee. All rights reserved.
//

#import "GSItemBar.h"

#define COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSItemBar ()

@property (nonatomic, strong) void(^selectEvent)(int index);

@end

@implementation GSItemBar
{
    NSMutableArray *_saveItems;
    UIView *_slideView;
}

- (void)setStyles:(NSArray *)styles {
    _styles = styles;
    if (_saveItems.count > 0 && _styles.count == _saveItems.count) {
        int leftDistance = 0;
        for (int i = 0; i < _saveItems.count; i++) {
            UIButton* tmp = _saveItems[i];
            NSString *title = _styles[i];
            CGSize size = [self getBoundsByString:title font:16];
            tmp.frame = CGRectMake(leftDistance + i*25, 0, size.width+25, self.frame.size.height - 2);
            leftDistance += size.width;
            [tmp setTitle:_styles[i] forState:UIControlStateNormal];
        }
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(NSArray*)styles event:(void (^)(int index))block {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _styles = styles;
        _saveItems = [NSMutableArray array];
        int leftDistance = 0;        UIButton *firstBtn = nil;
        for (int i = 0; i < _styles.count; i ++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            
            NSString *title = _styles[i];
            CGSize size = [self getBoundsByString:title font:16];
            
            item.frame = CGRectMake(leftDistance + i*25, 0, size.width+25, frame.size.height - 2); // 3pix 用于下侧滑动栏 设计
            
            leftDistance += size.width;
            
            [item setTitle:title forState:UIControlStateNormal];
            [item setTitleColor:COLOR16(0x666666) forState:UIControlStateNormal];
            [item setTitleColor:COLOR16(0x333333) forState:UIControlStateSelected];
            
            if (i == 0) {
                item.selected = YES;
            }
            
            item.tag = i+100; // 100 101 102 103 104 ...
            
            [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [_saveItems addObject:item];
            
            [self addSubview:item];
            
            if (i == 0) {
                firstBtn = item;
            }
            
        }
        
        _slideView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 6, 30, 1.5)];
        _slideView.center = CGPointMake(firstBtn.center.x, _slideView.center.y);
        [_slideView setBackgroundColor:COLOR16(0x000000)];
        
        [self addSubview:_slideView];
        
        _selectEvent = block;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)clickItem:(UIButton *)button{
    
    
    int style = (button.tag - 100);
    
    for (UIButton* tmp in _saveItems) {
        if (tmp.tag != button.tag) {
            tmp.selected = NO;
        }
    }
    
    button.selected = YES;
    
    //滑动条 slider
    
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:7.f initialSpringVelocity:4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _slideView.center = CGPointMake(button.center.x, _slideView.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (_selectEvent) {
        _selectEvent(style);
    }
    
}

- (CGSize)getBoundsByString:(NSString *)str font:(int)num{
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    UIFont *font = [UIFont systemFontOfSize:num];
    
    NSDictionary *attrs = @{NSFontAttributeName:font};
    
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    
    CGSize result = CGSizeMake(ceil(size.width), ceil(size.height));
    //TODO:这里返回计算总是错误 上面init中是加了30固定值才正常  需要修正
    return result;
}
@end
