//  GSVodDocView.h
//  VodSDK
//  Created by jiangcj on 16/7/6.
//  Copyright © 2016年 gensee. All rights reserved.
#import <UIKit/UIKit.h>
#import <GSDocKit/GSDocView.h>
@interface GSVodDocPage : GSDocPage
@end
@protocol GSVodDocViewDelegate <GSDocViewDelegate>
@optional
- (void)docVodViewOpenFinishSuccess:(GSVodDocPage*)page;
@end

typedef NS_ENUM(NSInteger, GSVodDocShowType){
    VodScaleAspectFill = GSDocViewShowModeScaleAspectFit,
    VodScaleToFill = GSDocViewShowModeScaleToFill,
    VodScaleAspectFit = GSDocViewShowModeHeightFit,
    VodScaleAspectFitEx = GSDocViewShowModeWidthFit,
};

@interface GSVodDocView : GSDocView
//文档打开代理
@property (nonatomic, weak) id<GSVodDocViewDelegate> vodDocDelegate;
@property (nonatomic, assign) NSUInteger gSDocModeType;
- (void)clearVodLastPageAndAnno DEPRECATED_MSG_ATTRIBUTE("无效,不再使用");
@end
