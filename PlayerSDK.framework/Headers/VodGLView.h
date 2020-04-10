//
//  ESGLView.h
//  kxmovie
//
//  Created by Kolyvan on 22.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.


#import <UIKit/UIKit.h>
#import  <AVFoundation/AVFoundation.h>
#import <GSCommonKit/GSVideoConst.h>

@interface VodGLView : UIView

@property (nonatomic, strong)UIImageView *movieASImageView DEPRECATED_MSG_ATTRIBUTE("新版本不在用这个做渲染视频，而采用videoLayer");
/**
 @property videoLayer
 @discussion 仅为老用户公开使用,新用户无需关心
 */
@property (nonatomic, retain) AVSampleBufferDisplayLayer *videoLayer;
/**
 @property contentMode
 @discussion 修改此值来改变渲染模式，枚举UIViewContentMode,同样会关联修改videolayer的显示模式
 */
@property (nonatomic, assign) UIViewContentMode contentMode;

@property (nonatomic,assign) CGFloat Oratio DEPRECATED_MSG_ATTRIBUTE("not use");
/**
 @method 初始化方法
 @abstract initWithFrame:默认使用GSVideoRenderAVSBDLayer渲染模式,如需要切换，请使用initWithFrame:renderMode:
 */
- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame renderMode:(GSVideoRenderMode)mode;

#pragma mark - private

/**
 @method renderAsVideoByImage:
 @abstract 桌面共享渲染回调
 @discussion 软解渲染回调，传入imageFrame，此方法无需自己调用
 */
- (void)renderAsVideoByImage:(UIImage*)imageFrame;
/**
 @method receivedRawVideoFrame:withSize:
 @abstract 接收未解码的数据源
 @discussion 此方法无需自己调用
 */
- (void)receivedRawVideoFrame:(const uint8_t *)frame withSize:(uint32_t)frameSize;

/**
 @method flush
 @abstract 使得图层清空当前正在显示的图片
 @discussion 当停止接收数据后，视图仍会保留最后一帧图像，使用此方法可以清除最后一帧图像
 */
- (void)flush;

@end
