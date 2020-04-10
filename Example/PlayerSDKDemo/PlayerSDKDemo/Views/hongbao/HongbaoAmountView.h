//
//  HongbaoAmountView.h
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/4.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongbaoAmountView : UIView
@property(nonatomic, assign) int hongbaoType;
@property(nonatomic, copy)NSString *hongbaoId;
@property(nonatomic, assign)NSInteger grabMoney;
@property(nonatomic, assign)GSHongbaoGrabResult grabResult;
@property(nonatomic, copy)void(^queryHongbaoGrabListBlock)(NSString *hongbaoId);
@property(nonatomic, copy)void(^closeBlock)();
@end

NS_ASSUME_NONNULL_END
