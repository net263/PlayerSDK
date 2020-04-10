//
//  GSPlayerSelectViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/15.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSPlayerSelectViewController.h"
#import "GSChatViewController.h"
#import "GSQaViewController.h"
#import "GSVideoViewController.h"
#import "GSDocViewController.h"
#import "GSDiagnosisViewController.h"
#import "GSMoreInfoViewController.h"
#import "GSHongbaoViewController.h"

#import "BaseViewController.h"

@interface GSPlayerSelectViewController ()

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) NSArray *controllerIDsArray;

@end

@implementation GSPlayerSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    _titlesArray = @[NSLocalizedString(@"Video", @""), NSLocalizedString(@"Doc", @""), NSLocalizedString(@"Chat",@""), NSLocalizedString(@"Qa",@""), NSLocalizedString(@"Vote",@""),NSLocalizedString(@"Diagnosis",@""),NSLocalizedString(@"MoreInfo",@""), @"老版聊天", NSLocalizedString(@"Hongbao", @"")];
    _controllerIDsArray = @[@"video", @"doc", @"chat", @"qa", @"vote"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return _titlesArray.count;
}

static NSString *cellIdentifier = @"PlayerSelect";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        GSVideoViewController *video = [[GSVideoViewController alloc] init];
        video.param = self.param;
        [self.navigationController pushViewController:video animated:YES];
    }else if (indexPath.row == 1) {
        GSDocViewController *doc = [[GSDocViewController alloc] init];
        doc.param = self.param;
        [self.navigationController pushViewController:doc animated:YES];
    }else if (indexPath.row == 2) {
        GSChatViewController *chatVC = [[GSChatViewController alloc] init];
        chatVC.param = self.param;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else if (indexPath.row == 3) {
        GSQaViewController *qaVC = [[GSQaViewController alloc] init];
        qaVC.param = self.param;
        [self.navigationController pushViewController:qaVC animated:YES];
    }
    else if (indexPath.row == 5) {
        GSDiagnosisViewController *chatVC = [[GSDiagnosisViewController alloc] init];
        chatVC.param = self.param;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else if (indexPath.row == 6) {
        GSMoreInfoViewController *chatVC = [[GSMoreInfoViewController alloc] init];
        chatVC.param = self.param;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else if (indexPath.row == 7) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        BaseViewController *baseController = [board instantiateViewControllerWithIdentifier:@"chat"];
        baseController.param = self.param;
        [self.navigationController pushViewController:baseController animated:YES];
    }else if(indexPath.row == 8){
        GSHongbaoViewController *hongbaoVC = [[GSHongbaoViewController alloc] init];
        hongbaoVC.param = self.param;
        [self.navigationController pushViewController:hongbaoVC animated:YES];
    }else{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        GSCustomViewController *baseController = [board instantiateViewControllerWithIdentifier:_controllerIDsArray[indexPath.row]];
        
        baseController.param = self.param;
        
        [self.navigationController pushViewController:baseController animated:YES];
    }
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
