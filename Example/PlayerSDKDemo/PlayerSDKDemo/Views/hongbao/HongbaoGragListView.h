//
//  HongbaoGragListView.h
//  PlayerSDKDemo
//
//  Created by net263 on 2019/12/5.
//  Copyright © 2019 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HongbaoGragListView : UIView
@property(nonatomic, strong)NSArray<GSGrabInfo *> *grabInfos;
@property(nonatomic, copy)void(^closeBlock)();
@end

@interface UIGrabInfoCell : UITableViewCell
@property(nonatomic, strong)GSGrabInfo *grabInfo;
@end
NS_ASSUME_NONNULL_END
