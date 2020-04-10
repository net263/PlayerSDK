//
//  GSProgressView.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/6.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSProgressView : UIView

@property (nonatomic, assign) float percent;

@property (nonatomic, strong) UIColor *progressColor;

- (instancetype)initWithFrame:(CGRect)frame;

@end
