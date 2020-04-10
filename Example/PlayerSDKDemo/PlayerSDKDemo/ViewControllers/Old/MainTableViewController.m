//
//  MainTableViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/28/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "MainTableViewController.h"
#import "BaseViewController.h"
#import "NSUserDefaults+UserDefaults.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"
#import "VideoViewController.h"
#import "QaViewController.h"
#import "AppDelegate.h"


@interface MainTableViewController ()<GSPPlayerManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) NSArray *controllerIDsArray;

@property (nonatomic, strong) NSMutableArray *userInfoArray;

@property (nonatomic, assign)  NSUInteger clickIndex;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    
    _titlesArray = @[NSLocalizedString(@"video", @""), NSLocalizedString(@"doc", @""), NSLocalizedString(@"chat",@""), NSLocalizedString(@"qa",@""), NSLocalizedString(@"vote",@"")];
    _controllerIDsArray = @[@"video", @"doc", @"chat", @"qa", @"vote"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelConnect)];
    self.navigationItem.rightBarButtonItem = cancel;
}


- (void)cancelConnect
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.playerManager leave];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1004)
    {
        
        if (buttonIndex==1) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                
                GSPDiagnosisInfo *DiagnosisInfo =[[GSPDiagnosisInfo alloc] init];
                [DiagnosisInfo ReportDiagonse];
            });
            
            
        }else if (buttonIndex==0)
        {
            
        }
    }
    
}




- (void)viewWillAppear:(BOOL)animated {
    _userInfoArray = [[NSMutableArray alloc] init];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = _titlesArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _clickIndex = indexPath.row;
    
    //判断加入是否成功
    if (!_playerManager) {
        
        _playerManager = [GSPPlayerManager new];
        
    }
    _playerManager.delegate = self;
    GSPJoinParam *joinParam = [GSPJoinParam new];
    
    joinParam.domain = [_domain stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([[_serviceType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@"training"]) {
        joinParam.serviceType = GSPServiceTypeTraining;
    }
    else {
        joinParam.serviceType = GSPServiceTypeWebcast;
    }
    
    joinParam.roomNumber = [_roomNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    joinParam.nickName = [_niceName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    joinParam.watchPassword = [_watchPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    joinParam.thirdToken = _thirdToken;
    
    joinParam.oldVersion = NO;
    
//    joinParam.userAppData = @"vip=1&city=上海";
//    joinParam.customUserID = 1010507411;
    
    [GSPPlayerManager sharedManager].httpAPIEnabled = YES;
    

    
    
    //test
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.joinParam = joinParam;
    [_playerManager joinWithParam:joinParam];
    
//    [_playerManager redirectLogToFile];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *isException= [defaults objectForKey:IsException];
    if ([isException isEqualToString:@"YES"]) {
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:NSLocalizedString(@"错误报告", nil)
         message:@"检测到程序意外终止，是否发送错误报告"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"忽略", nil)
         otherButtonTitles:NSLocalizedString(@"发送", nil), nil];
        alert.tag=1004;
        [alert show];
    }
    [defaults setObject:@"NO" forKey:IsException];
}

#pragma mark -
#pragma mark GSPPlayerManagerDelegate

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveSelfJoinResult:(GSPJoinResult)joinResult
{
    
    if (joinResult == GSPJoinResultOK) {
        
        
        [[NSUserDefaults standardUserDefaults] setRoomNumber:_roomNumber];
        [[NSUserDefaults standardUserDefaults] setDomain:_domain];
        [[NSUserDefaults standardUserDefaults] setServiceType:_serviceType];
        [[NSUserDefaults standardUserDefaults] setNickname:_niceName];
        [[NSUserDefaults standardUserDefaults] setWatchPassword:_watchPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        BaseViewController *baseController = [board instantiateViewControllerWithIdentifier:_controllerIDsArray[_clickIndex]];
        baseController.playerManager = _playerManager;
        
        if ([_controllerIDsArray[_clickIndex] isEqualToString:@"chat"]) {
            ((ChatViewController *)baseController).userInfoArray = _userInfoArray;
        }
        if ([_controllerIDsArray[_clickIndex] isEqualToString:@"video"]) {
            ((VideoViewController *)baseController).userInfoArray = _userInfoArray;
        }
        if ([_controllerIDsArray[_clickIndex] isEqualToString:@"qa"]) {
            CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
            
            //适配iOS6
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
          
                y = self.navigationController.navigationBar.frame.size.height;
            }

            ((QaViewController *)baseController).qaView = [[GSPQaView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y - 52)];
            baseController.playerManager.qaView = ((QaViewController *)baseController).qaView;
        }
        
        [self.navigationController pushViewController:baseController animated:YES]; 
        
        //test
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        myDelegate.playerManager = _playerManager;
    }
    
    if (joinResult != GSPJoinResultOK) {
//        if (self.playerManager) {
//            [self.playerManager leave];
//        }
        
        if (joinResult == GSPJoinResultNetworkError) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"网络错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }else if (joinResult == GSPJoinResultParamsError) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"参数错误",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }else if (joinResult == GSPJoinResultTOO_EARLY) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"直播尚未开始",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }else if (joinResult == GSPJoinResultLICENSE) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"人数已满",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }else if (joinResult == GSPJoinResultTimeout) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"连接超时",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"错误",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserJoin:(GSPUserInfo *)userInfo
{
    if (userInfo.userID != playerManager.selfUserInfo.userID) {
        [_userInfoArray addObject:userInfo];
    }
}

- (void)playerManager:(GSPPlayerManager *)playerManager didUserLeave:(GSPUserInfo *)userInfo
{
    
}

- (void)playerManager:(GSPPlayerManager *)playerManager didReceiveChatMessage:(GSPChatMessage *)message {
    
}

- (BOOL)sendChatMessage:(GSPChatMessage *)chatMessage
{
    
    return [_playerManager chatWithAll:chatMessage];
}


- (void)viewWillDisappear:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dealloc {
    [self.playerManager leave];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
