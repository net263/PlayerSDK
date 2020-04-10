//
//  ViewController.m
//  OfflineSDKDemo
//
//  Created by gzq on 2/2/15.
//  Copyright (c) 2015 Gensee, Inc. All rights reserved.
//

#import "ViewController.h"
//#import <genseeFramework/VodSdk.h>

#import <PlayerSDK/VodSdk.h>

//#import "FileItem.h"
@interface ViewController ()<VodPlayDelegate,VodDownLoadDelegate>
{
    BOOL downLoadFinished;
    downItem *currentDownItem;
    LONGLONG  playTime;
    BOOL isSlideing;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationController.navigationBarHidden = YES;

    [playProcess addTarget:self action:@selector(doSeek:) forControlEvents:UIControlEventTouchUpInside];
    [playProcess addTarget:self action:@selector(dobegin:) forControlEvents:UIControlEventTouchDown];
    
    
    self.voddownloader = [[VodDownLoader alloc]init];
    self.voddownloader.delegate = self;
    downLoadFinished = NO;
   
    [self setVodProgram];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setTitle:@"<-" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    back.frame=CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *itme = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = itme;
    
    
    
    
    self.title=@"点播测试";
    
    
}





- (void)setVodProgram
{
    //  [_donwload addItem:@"172.31.3.136" number:@"18508030" loginName:@"admin@gensee.com" vodPassword:@"222222" loginPassword:@"888888" serType:@"webcast"];
    
   //  [_donwload addItem:@"duia.gensee.com" number:@"" loginName:@"admin@gensee.com" vodPassword:@"" loginPassword:@"duia123456" vodid:@"bfd602af6f954258beec74f18500ab9b" downFlag:1 serType:@"webcast"];
    
    
    //外网  //715
//    address.text = @"duia.gensee.com";
//    number.text = @"00153889";
//    username.text = @"admin@gensee.com";
//    vodpassword.text = @"145789";
//    loginpassword.text = @"duia123456";
//    serviceType.text = @"webcast";
    
    
//    address.text = @"duia.gensee.com";
//    number.text = @"63519178";
//    username.text = @"admin@gensee.com";
//    vodpassword.text = @"";
//    loginpassword.text = @"duia123456";
//    serviceType.text = @"webcast";
    
    //3.
//    address.text = @"192.168.1.142";
//    number.text = @"82176946";
//    username.text = @"aa";
//    vodpassword.text = @"711291";
//    loginpassword.text = @"711291";
//    serviceType.text = @"training";
    
    address.text = @"192.168.1.142";
    number.text = @"89778191";  //编号
    username.text = @"aa";
    vodpassword.text = @"711291";
    loginpassword.text = @"711291";
    serviceType.text = @"training";
    
    
    
    NSString* vodidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodid"];
    if (vodidString) {
        vodId.text  = vodidString;
        downItem *Litem = [[VodManage shareManage]findDownItem:vodId.text];
        playOfflinBtn.enabled = Litem?YES:NO;
    }
    

    
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [address resignFirstResponder];
    [number resignFirstResponder];
    [username resignFirstResponder];
    [vodpassword resignFirstResponder];
    [loginpassword resignFirstResponder];
    [serviceType resignFirstResponder];
    
}





-(void)back
{

    [self.navigationController popViewControllerAnimated:YES];
}



- (void)doBack
{
    [self.vodplayer stop];
    self.vodplayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)resignTextField
{
    [address resignFirstResponder];
    [number resignFirstResponder];
    [username resignFirstResponder];
    [vodpassword resignFirstResponder];
    [loginpassword resignFirstResponder];
    [serviceType resignFirstResponder];
}
#pragma mark -
#pragma mark slider action
- (void)dobegin:(UISlider*)slider
{
    isSlideing = YES;
}
- (void)doSeek:(UISlider*)slider
{
    float duratino = slider.value;
    [self.vodplayer seekTo:duratino];
    isSlideing = NO;
}
#pragma mark -
#pragma mark btnActions
- (IBAction)doAddDownLoad:(id)sender
{
    
    //    address.text = @"duia.gensee.com";
    //    number.text = @"00153889";
    //    username.text = @"admin@gensee.com";
    //    vodpassword.text = @"145789";
    //    loginpassword.text = @"duia123456";
    //    serviceType.text = @"webcast";
    //    
  
    
    if (!self.voddownloader) {
        self.voddownloader = [[VodDownLoader alloc]init];
        self.voddownloader.delegate = self;
    }

    NSLog(@"ipaddress:%@  number:%@  loginname:%@ vodpwd:%@  logpwd:%@  sertype:%@",address.text,number.text,username.text,vodpassword.text,loginpassword.text,serviceType.text);
    //af7a0c0da7a14f3da0c6816be160bed5
    [self.voddownloader addItem:address.text number:number.text loginName:username.text vodPassword:vodpassword.text loginPassword:loginpassword.text downFlag:1 serType:serviceType.text];
    
    
    //[self.voddownloader addItem:address.text number:number.text loginName:username.text vodPassword:vodpassword.text loginPassword:loginpassword.text vodid:@"0a8f1c31d043408689b9b3417b0c3295" downFlag:1 serType:serviceType.text];
   // [self.voddownloader addItem:address.text number:number.text loginName:username.text vodPassword:vodpassword.text loginPassword:loginpassword.text vodid:@"daaa353b261f48ec8f6e2fa5fd2e396f" downFlag:1 serType:serviceType.text];
    
//    [self.voddownloader addItem:@"duia.gensee.com" number:@"" loginName:@"admin@gensee.com" vodPassword:@"" loginPassword:@"duia123456" vodid:@"1fe93a796f484992b50264c7fed9544e" downFlag:0 serType:@"webcast"];
    
//    [self.voddownloader addItem:@"192.168.1.142" number:@"" loginName:@"" vodPassword:@"333333" loginPassword:@"" vodid:@"e1a22dbe01364aefa6664c26161a5203" downFlag:0 serType:@"webcast"];
    
    
    
    //715
//      [self.voddownloader addItem:@"cintv.gensee.com" number:@"" loginName:@"" vodPassword:@"" loginPassword:@"" vodid:@"3292a3772e97483ba69981731a9fd801" downFlag:0 serType:@"webcast"];
//
    
    
    
}

- (IBAction)goDownLoad:(id)sender
{
    if (vodId.text.length < 1) {
        NSLog(@" no vodid");
        return;
    }
    downItem *Litem = [[VodManage shareManage]findDownItem:vodId.text];
    if (Litem==nil) {
        return;
    }
    [self.voddownloader Downlod:Litem];
}

- (IBAction)goPlayOffline:(id)sender
{
    [self resignTextField];
//    downItem *downitem = [[VodManage shareManage] findDownItem:@"3292a3772e97483ba69981731a9fd801"];
    downItem *downitem = [[VodManage shareManage] findDownItem:vodId.text];
    if (downitem) {
        if (self.vodplayer) {
            [self.vodplayer stop];
            self.vodplayer = nil;
        }

        CGFloat vodY=playOnlinBtn.frame.origin.y+playOfflinBtn.frame.size.height;
        
        self.vodplayer = [[VodPlayer alloc]initPlay:self videoViewFrame:CGRectMake(0, vodY, 160,120) docViewFrame:CGRectMake(160, vodY, 160, 120) downitem:downitem playDelegate:self];  //160
        self.vodplayer.delegate = self;
        [self.vodplayer OfflinePlay];
    }
   
}
- (IBAction)goPlayOnline:(id)sender
{
//    downItem *Litem = [[VodManage shareManage]findDownItem:@"3292a3772e97483ba69981731a9fd801"];
      downItem *Litem = [[VodManage shareManage]findDownItem:vodId.text];
    if (Litem) {
        if (self.vodplayer) {
            [self.vodplayer stop];
            self.vodplayer = nil;
        }
         CGFloat vodY=playOnlinBtn.frame.origin.y+playOfflinBtn.frame.size.height;
        self.vodplayer = [[VodPlayer alloc] initPlay:self videoViewFrame:CGRectMake(0, vodY, 160, 120) docViewFrame:CGRectMake(160, vodY, 160, 120) downitem:Litem playDelegate:self]; //160
        [self.vodplayer OnlinePlay];
    }
    
}
//暂停播放
- (IBAction)pausePlay:(id)sender
{
    if (self.vodplayer) {
        [self.vodplayer pause];
    }
}

//继续播放
- (IBAction)resumePlay:(id)sender
{
    if (self.vodplayer) {
        [self.vodplayer resume];
    }
}

//结束播放
- (IBAction)stopPlay:(id)sender
{
    if (self.vodplayer) {
        [self.vodplayer stop];
    }
}

#pragma mark -
#pragma mark -
#pragma mark VodDownLoadDelegate
//添加item的回调方法
-(void)onAddItemResoult:(RESULT_TYPE)resoultType voditem:(downItem *)item
{
    
    if (resoultType == RESULT_SUCCESS) {                   //如果添加成功，则开始下载
        //[self.voddownloader Downlod:item];
        currentDownItem = item;
        vodId.text = item.strDownloadID;
        [[NSUserDefaults standardUserDefaults] setObject:vodId.text forKey:@"vodid"];
    }
}

- (void) onDLFinish:(NSString*) downLoadId                // 下载完成
{
    downItem *downitem = [[VodManage shareManage] findDownItem:downLoadId];   //根据点播ID查找item
    NSLog(@"%@ is finish download",downitem.name);
    
   downLoadFinished = YES;
    playOfflinBtn.enabled = YES;
}

- (void) onDLPosition:(NSString*) downLoadId  percent:(float) percent // 下载进度
{
     downItem *downitem = [[VodManage shareManage] findDownItem:downLoadId];
    NSLog(@"%@ finished %f%%",downitem.name,percent);
    process.value = percent/100.0;
    processLabel.text = [NSString stringWithFormat:@"进度:%1f",percent];
}
- (void) onDLStart:(NSString*) downLoadId // 下载开始
{
    NSLog(@"download  start");
}
- (void) onDLStop:(NSString*) downLoadId // 下载停止
{
    downItem *downitem = [[VodManage shareManage] findDownItem:downLoadId];
    NSLog(@"%@ stop",downitem.name);
}
- (void) onDLError:(NSString*) downLoadId Status:(VodDownLoadStatus) errorCode // 下载出错
{
    downItem *downitem = [[VodManage shareManage] findDownItem:downLoadId];
    NSLog(@"%@ error",downitem.name);
}

#pragma mark -VodPlayDelegate

//播放按钮的方法
- (void) onInit:(int) result haveVideo:(BOOL)haveVideo duration:(int) duration docInfos:(NSDictionary*)docInfos
      //播放文件的信息.result表示播放的结果,havevideo表示是否包含视频.duration表示文件时长。docinfos表示文档信息
{
    NSLog(@"havevideo:%d,duration:%d,docinfos:%@",haveVideo,duration,docInfos);
    playProcess.maximumValue =  duration;
    playProcess.minimumValue = 0;
    //playTime = duration;
}
- (void) onStop           //播放停止时的回调方法
{
    NSLog(@"play stop");
}
- (void) onPosition:(int) position      //进度回调方法
{
   // float postionvalue = position*1.0/playTime;
    if (!isSlideing) {
        playProcess.value = position;
        NSLog(@"position: %d", position);
    }
    
}

/**
 * 文档信息通知
 * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
 */
- (void) onPage:(int) position  //文档信息通知， position表示播放进度，如果app需要显示相关文档，需要用position去匹配oninit
{
    
}

/**
 * 任意位置定位播放响应
 * @param position 进度变化，快进，快退，拖动等动作后开始播放的进度
 */
- (void) onSeek:(int) position          //进度条定位播放，如快进、快退、拖动进度条等操作回调方法
{
    NSLog(@"begin play at %d",position);
}
/**
 * 音频电频值
 * @param level 电频大小
 */
- (void) onAudioLevel:(int) level   //音频值大小
{
    //NSLog(@"audiolevel :%d",level);
}


-(void)deleteitem:(UIButton *)btn
{
    [self.voddownloader delete:@"00092d7df0ae45219d33f0018986f7eb"];               //根据ID删除downitem
  downItem *item = [[VodManage shareManage] findDownItem:@"00092d7df0ae45219d33f0018986f7eb"];    //根据ID找到downitem
    if (!item) {
        NSLog(@"delete successs");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.voddownloader stop:currentDownItem.strDownloadID];
}

@end
