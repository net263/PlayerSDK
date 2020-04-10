//
//  GSPVideoView.h
//  PlayerSDK
//
//  Created by Gaojin Hsu on 6/9/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GSCommonKit/GSVideoConst.h>

/**
 * 直播中管理视频的视图
 */
@interface GSPVideoView : UIView

@property (nonatomic, retain) AVSampleBufferDisplayLayer *videoLayer;

/**
 @method initWithFrame:
 @abstract 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame renderMode:(GSVideoRenderMode)mode;

#pragma mark - private
/**
 @method flush
 @abstract 清空渲染图层残留
 @discussion 可以用此方法清除最后一帧图像
 */
- (void)flush;

/**
 @method renderVideo:width:height:size:isAs
 @abstract 解码方法
 @discussion 得到解码的数据后，传入这里进行渲染
 */
- (void)renderVideo:(const unsigned char*)data width:(unsigned)width height:(unsigned)height size:(unsigned)size isAs:(BOOL)isAs timestamp:(unsigned long)ts;

/**
 @method renderAsVideoByImage:
 @abstract 桌面共享渲染方法
 @discussion 得到桌面共享的数据后，传入这里进行渲染
 */
- (void)renderAsVideoByImage:(UIImage*)imageFrame;
@end
