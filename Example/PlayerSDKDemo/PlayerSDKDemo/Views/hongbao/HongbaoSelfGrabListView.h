//
//  HongbaoSelfGrabListView.h
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/5.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongbaoSelfGrabListView : UIView
@property(nonatomic, strong)NSArray<GSUserGrabInfo *> *userGrabInfos;
@property(nonatomic, copy)void(^closeBlock)();
@end

@interface UIUserGrabInfoCell : UITableViewCell
@property(nonatomic, strong)GSUserGrabInfo *userGrabInfo;
@end

NS_ASSUME_NONNULL_END
