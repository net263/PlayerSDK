//
//  VodDocView.m
//  VodSDKDemo
//
//  Created by jiangcj on 2018/5/7.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "VodDocView.h"

@implementation VodDocView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setUpView];
    }
    return self;
}



-(void)setUpView
{
    

    
//    [self createVodDocDefaultView];
    
    
    __weak typeof(self) weakSelf = self;
    
    _vodDocSwfView = [[GSVodDocView alloc]initWithFrame:self.bounds];
    [self addSubview:_vodDocSwfView];
    _vodDocSwfView.gSDocModeType = VodScaleAspectFit;
    NSLog(@"NSStringFromCGRect(_vodDocSwfView.frame)=%@",NSStringFromCGRect(_vodDocSwfView.frame));

    _vodDocSwfView.backgroundColor=[UIColor whiteColor];
    [_vodDocSwfView setGlkBackgroundColor:51 green:51 blue:51];
    
   
    
    _vodDocSwfView.vodDocDelegate=self;
    
    
    [self initVodPlayerDocView];

    self.isDocLoaded=NO;
}



- (void)initVodPlayerDocView {
    //手动创建docView
    
    
    
    UITapGestureRecognizer *docTapGesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(vodDocFullScreen)];
    docTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:docTapGesture];
    
    
    //增加文档单击事件
    UITapGestureRecognizer *docSignalTapGesture = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(vodDocSwitchHiddenAndShow)];
    docSignalTapGesture.numberOfTapsRequired = 1;
    [docSignalTapGesture requireGestureRecognizerToFail:docTapGesture];
    [self addGestureRecognizer:docSignalTapGesture];
    
}




//
//
//-(void)createVodDocDefaultView
//{
//    if (_vodDocDefaultView==nil) {
//
//        _vodDocDefaultView=[[UIView alloc] initWithFrame:self.bounds];
//        _vodDocDefaultView.backgroundColor=[UIColor colorWithRed:53/255.f green:53/255.f blue:53/255.f alpha:1];
//
//        UIImageView*  docDefault1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 209, 98)];
//        docDefault1.image=[UIImage imageNamed:@"no_Doc"] ;   //LoadIMG(@"no_Doc")
//
//
//        [_vodDocDefaultView addSubview:docDefault1];
//
//        __weak typeof(self) weakSelf = self;
////        [docDefault1 mas_remakeConstraints:^(MASConstraintMaker *make) {
////
////            make.width.equalTo(@(209));
////            make.height.equalTo(@(98));
////            make.centerX.equalTo(weakSelf.vodDocDefaultView.mas_centerX);
////            make.centerY.equalTo(weakSelf.vodDocDefaultView.mas_centerY);
////
////        }];
//        docDefault1.frame=CGRectMake(0, 0, 209, 98);
//        docDefault1.center=self.center;
//
//    }
//    [self addSubview:_vodDocDefaultView];
//
////    __weak typeof(self) weakSelf = self;
////    [_vodDocDefaultView mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.width.equalTo(weakSelf.mas_width);
////        make.height.equalTo(weakSelf.mas_height);
////        make.centerX.equalTo(weakSelf.mas_centerX);
////        make.centerY.equalTo(weakSelf.mas_centerY);
////
////    }];
//
//    _vodDocDefaultView.frame=self.frame;
//    _vodDocDefaultView.center=self.center;
//
//}




//-(void)createDocSidebar
//{
//    _vodDocSidebarView=[[VodDocSidebarView alloc] init];
//
//    [self addSubview:_vodDocSidebarView];
//
//
//    __weak typeof(self) weakSelf = self;
//
//    [_vodDocSidebarView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(weakSelf.mas_top);
//        make.bottom.equalTo(weakSelf.mas_bottom);
//
//        make.right.equalTo(weakSelf.mas_right);
//        make.width.equalTo(@(40));
//    }];
//
//    _vodDocSidebarView.docFullScreenBtnClickBlock=^{
//
//        //[weakSelf fullScreen:weakSelf.vodPlayer.docSwfView];
//
//        [weakSelf vodDocFullScreen];
//
//
//    };
//
//
//    [self bringSubviewToFront:_vodDocSidebarView];
//}





-(void)layoutSubviews
{
    
    _vodDocSwfView.frame=self.bounds;
    _vodDocDefaultView.frame=self.frame;
    _vodDocDefaultView.center=self.center;
}





#pragma mark ---

-(void)vodDocFullScreen
{
    if (self.vodDocFullScreenBlock) {
        self.vodDocFullScreenBlock();
    }
    
}



-(void)vodDocSwitchHiddenAndShow
{
    if (self.vodDocSwitchHiddenAndShowBlock) {
        
        self.vodDocSwitchHiddenAndShowBlock();
    }
}



//-(void)setIsDocLoaded:(BOOL)isDocLoaded
//{
//
//    if (isDocLoaded) {
//        _vodDocDefaultView.hidden=YES;
//        _vodDocSwfView.hidden=NO;
//        [self bringSubviewToFront:_vodDocSwfView];
////        [self bringSubviewToFront:_vodDocSidebarView];
//    }else{
//
//        _vodDocDefaultView.hidden=NO;
//        _vodDocSwfView.hidden=YES;
//
//        [self bringSubviewToFront:_vodDocDefaultView];
////        [self bringSubviewToFront:_vodDocSidebarView];
//    }
//
//
//}


#pragma mark  GSVodDocViewDelegate


- (void)docVodViewOpenFinishSuccess:(GSVodDocPage*)page
{
    
    self.isDocLoaded=YES;
    
}



@end
