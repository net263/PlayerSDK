//
//  GSItemBar.h
//  VodSDKDemo
//
//  Created by gensee on 2019/7/30.
//  Copyright © 2019年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSItemBar : UIView

@property (nonatomic, strong) NSArray *styles;

- (instancetype)initWithFrame:(CGRect)frame style:(NSArray*)styles event:(void (^)(int index))block;

@end

NS_ASSUME_NONNULL_END
