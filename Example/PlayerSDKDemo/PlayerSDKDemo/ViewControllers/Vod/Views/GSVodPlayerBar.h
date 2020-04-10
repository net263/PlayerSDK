//
//  GSVodPlayerBar.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GSVodPlayerBar;
@protocol GSVodPlayerBarDelegate <NSObject>
- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSetPlay:(BOOL)isPlay;
- (void)vodPlayerBar:(GSVodPlayerBar *)bar beginSlide:(int)value;
- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSlideToValue:(int)value;

@end

@interface GSVodPlayerBar : UIView
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, weak) id <GSVodPlayerBarDelegate> delegate;
@property (nonatomic, assign) int totalTime;
@property (nonatomic, assign) int currentTime;

- (instancetype)initWithFrame:(CGRect)frame;
@end
