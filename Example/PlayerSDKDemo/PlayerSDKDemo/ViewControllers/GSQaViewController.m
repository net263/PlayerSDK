//
//  GSQaViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSQaViewController.h"
#import "GSQaView.h"

@interface GSQaViewController ()
@property (nonatomic, strong) GSQaView *qaView;
@end

@implementation GSQaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.qaView = [[GSQaView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height -64)];
    [self.view addSubview:self.qaView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPlayerJoinSuccess {
    //这里由于demo需要单独功能演示，故去掉音视频数据
    [[GSPPlayerManager sharedManager] enableVideo:NO];
    [[GSPPlayerManager sharedManager] enableAudio:NO];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveNewQaData:(NSArray *)qaDatas{

    GSPQaData *data = qaDatas[0];

    if ([data.questionID isEqualToString:@""] || data.questionID.length == 0) {
        NSLog(@"非正常的 QA 数据");
        return;
    }
    //这里还要处理
//    if (!data.isCanceled && (data.ownnerID == [GSPPlayerManager sharedManager].selfUserInfo.userID) && data.isQuestion) {
//        NSLog(@"过滤自己的 QA 数据");
//        return;
//    }
    
    GSQaModel *model = [[GSQaModel alloc]initWithQaData:data];
    
    [self.qaView insert:model];
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
