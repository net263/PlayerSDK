//
//  HongBaoGrabView.h
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/4.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongBaoGrabView : UIView
@property(nonatomic, strong)GSHongbaoInfo *hongbaoInfo;
@property(nonatomic, copy)void(^grabHongbaoBlock)(GSHongbaoInfo *hongbaoInfo);
@property(nonatomic, copy)void(^closeBlock)();
@end

NS_ASSUME_NONNULL_END
