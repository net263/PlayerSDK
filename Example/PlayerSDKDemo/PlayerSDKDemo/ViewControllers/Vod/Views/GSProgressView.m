//
//  GSProgressView.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/6.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSProgressView.h"
#import "UIView+GSSetRect.h"

#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]


@implementation GSProgressView
{
    CAShapeLayer *_back;
    CAShapeLayer *_progress;
    UIBezierPath *_path;
    //百分比label
    UILabel *_label;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (!_path) {
            _path = [UIBezierPath bezierPath];
            [_path moveToPoint:CGPointMake(8, 15)];
            [_path addLineToPoint:CGPointMake(frame.size.width - 16 - 40, 15)];
        }
        _back = [self _createProgressLayer];
        _progress = [self _createProgressLayer];
        _back.strokeEnd   = 1.f;
        _progress.strokeEnd = 0.f;
        [self.layer addSublayer:_back];
        [self.layer addSublayer:_progress];
        
        _label = [[UILabel alloc] init];
        _label.text = @"0%";
        _label.textColor = [UIColor grayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_label];
    }
    return self;
}

- (void)resetProgress {
    self.height = 30;
    // Set shapeLayer fill color & stroke color.
    if (_progressColor) {
        _progress.strokeColor = _progressColor.CGColor;
    }else{
        _progress.strokeColor = FASTSDK_COLOR16(0x009BD8).CGColor;
    }
    _label.frame = CGRectMake(self.width - 40, 0, 40, 30);
    [_label sizeToFit];
    _label.top = (self.height - _label.height)/2;
    
}

- (CAShapeLayer *)_createProgressLayer{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.bounds.size.width - 40, 30);
    layer.path = _path.CGPath;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.fillColor   = [[UIColor clearColor] CGColor];
    layer.lineWidth   = 16;
    layer.lineCap = kCALineCapRound;
    
    return layer;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    [self resetProgress];
}

- (void)setPercent:(float)percent {
    if (percent < 0) return;
    if (percent > 1) return;
    _percent = percent;
    

    CABasicAnimation * animaiton = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animaiton.removedOnCompletion = NO;
    animaiton.fillMode = kCAFillModeForwards;
    animaiton.duration = 0.8;
    
    // Start animation.
    _progress.strokeEnd = percent;
    [_progress addAnimation:animaiton forKey:nil];
    
    
    _label.text = [NSString stringWithFormat:@"%.01f%%",percent*100];
    [_label sizeToFit];
    _label.top = (self.height - _label.height)/2;
}

@end
