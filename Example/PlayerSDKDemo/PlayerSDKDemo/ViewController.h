//
//  ViewController.h
//  OfflineSDKDemo
//
//  Created by gzq on 2/2/15.
//  Copyright (c) 2015 Gensee, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <RtSDK/RtSDK.h>
@class VodDownLoader;
@class VodPlayer;
@interface ViewController : UIViewController
{
    IBOutlet UITextField *address;
    IBOutlet UITextField *number;
    IBOutlet UITextField *username;
    IBOutlet UITextField *vodpassword;
    IBOutlet UITextField *loginpassword;
    IBOutlet UITextField *serviceType;
    
    IBOutlet UILabel *vodId;
    IBOutlet UILabel *processLabel;
    
    IBOutlet UIButton *addBtn;
    IBOutlet UIButton *downloadBtn;
    IBOutlet UIButton *playOfflinBtn;
    IBOutlet UIButton *playOnlinBtn;
    
    IBOutlet UISlider *process;
    IBOutlet UISlider *playProcess;
}
@property(nonatomic,strong)VodDownLoader *voddownloader;
@property(nonatomic,strong)VodPlayer *vodplayer;

//添加到下载列表
- (IBAction)doAddDownLoad:(id)sender;
//开始下载
- (IBAction)goDownLoad:(id)sender;
//离线播放
- (IBAction)goPlayOffline:(id)sender;
//在线播放
- (IBAction)goPlayOnline:(id)sender;
//暂停播放
- (IBAction)pausePlay:(id)sender;

//继续播放
- (IBAction)resumePlay:(id)sender;

//结束播放
- (IBAction)stopPlay:(id)sender;
@end

