//
//  GSDiagnosisViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/9/5.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSDiagnosisViewController.h"
#import <GSCommonKit/GSCommonKit.h>
@interface GSDiagnosisViewController ()

@end

@implementation GSDiagnosisViewController
// 日志发送步骤
// 1.在AppDelegate.m方法中调用 [[GSDiagnosisInfo shareInstance] redirectNSlogToDocumentFolder]
//   这个时机可以自己选择，调用后就会将控制台输出记录到文件
// 2.给回调block赋值 [GSDiagnosisInfo shareInstance].upLoadResult
// 3.发送日志
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日志发送";
    UIButton *sendLog = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [sendLog setTitle:@"发送日志" forState:UIControlStateNormal];
    sendLog.layer.cornerRadius = 3.f;
    sendLog.layer.masksToBounds = YES;
    [sendLog setBackgroundColor:UICOLOR16(0x009BD8)];
    sendLog.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [sendLog addTarget:self action:@selector(logAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendLog];
    sendLog.center = self.view.center;
}

- (void)logAction:(UIButton *)sender {
    
    __block MBProgressHUD *hud = nil;
    
    [GSDiagnosisInfo shareInstance].upLoadResult = ^(GSDiagnosisType type, NSString *errorDescription) {
        [hud hide:YES];
        if (type == GSDiagnosisUploadSuccess) {
            [MBProgressHUD showHint:@"上传成功"];
        }else if (type == GSDiagnosisUploadNetError) {
            [MBProgressHUD showHint:@"文件上传发生错误"];
        }else if (type == GSDiagnosisPackError) {
            [MBProgressHUD showHint:@"文件打包出错"];
        }else if (type==GSDiagnosisSubmitXMLInfoError){
            [MBProgressHUD showHint:@"提交回执数据出错"];
        }
        hud = nil;
    };
    
    [[GSDiagnosisInfo shareInstance] ReportDiagonseEx];
    hud = [MBProgressHUD showMessage:@"发送日志中"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
