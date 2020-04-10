//
//  LoginViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 6/10/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import "LoginViewController.h"
#import "NSUserDefaults+UserDefaults.h"
#import "MainTableViewController.h"
#import <PlayerSDK/PlayerSDK.h>

//#import "ViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) GSPChatView *chatView;

@property (nonatomic, strong) GSPVideoView *vieoView;

@property (nonatomic, strong) GSPDocView *docView;

@property (nonatomic, strong) GSPInvestigationView *investigationView;

@property (nonatomic, strong) GSPPlayerManager *playerManager;

@property (nonatomic, strong) NSMutableDictionary *usersDic;


@property (weak, nonatomic) IBOutlet UITextField *domainTextField;

@property (weak, nonatomic) IBOutlet UITextField *serviceTypeTextField;

@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;

@property (weak, nonatomic) IBOutlet UITextField *watchPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (weak, nonatomic) IBOutlet UITextField *thridTokenTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ios6Layout;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配iOS6
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
        _ios6Layout.constant = _ios6Layout.constant - y - 55;
    }
    
    _roomNumberTextField.text = [[NSUserDefaults standardUserDefaults]getRoomNumber];
    _domainTextField.text = [[NSUserDefaults standardUserDefaults]getDomain];
    _serviceTypeTextField.text = [[NSUserDefaults standardUserDefaults]getServiceType];
    _nicknameTextField.text = [[NSUserDefaults standardUserDefaults]getNickname];
    _watchPasswordTextField.text = [[NSUserDefaults standardUserDefaults]getWatchPassword];
//    
//    _roomNumberTextField.text = @"09771807";
//    _domainTextField.text = @"qa100.gensee.com";
//    _serviceTypeTextField.text = @"webcast";
//    _nicknameTextField.text = @"1234";
//    
//    _roomNumberTextField.text = @"47757583";
//    _domainTextField.text = @"btsj.gensee.com";
//    _serviceTypeTextField.text = @"training";
//    _nicknameTextField.text = @"1234";
//    _watchPasswordTextField.text = @"123456";
    [GSPPlayerManager sharedManager].hardwareAccelerateEncode = YES;
    
//    _roomNumberTextField.text = @"11064739";
//    _domainTextField.text = @"192.168.1.106";
//    _serviceTypeTextField.text = @"webcast";
//    _nicknameTextField.text = @"ios";
//    _watchPasswordTextField.text = @"";
////    _thridTokenTextField.text=@"9487BB7C2E228197D846A4B3EC0FDBEA";
    
//    _roomNumberTextField.text = @"14949860";
//    _domainTextField.text = @"qa100.gensee.com";
//    _serviceTypeTextField.text = @"webcast";
//    _nicknameTextField.text = @"ios";
//    _watchPasswordTextField.text = @"333333";
//    _thridTokenTextField.text=@"";
    
    _roomNumberTextField.delegate = self;
    _domainTextField.delegate = self;
    _serviceTypeTextField.delegate = self;
    _nicknameTextField.delegate = self;
    _watchPasswordTextField.delegate = self;
    _thridTokenTextField.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    _vieoView = [[GSPVideoView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2 - 52)];
//    [self.view addSubview:_vieoView];
    
//        _chatView = [[GSPChatView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2 - 52, self.view.bounds.size.width, self.view.bounds.size.height/2) parentView:self.view];
//        _chatView.delegate = self;
//        [self.view addSubview:_chatView];
//    
//        GSPChatInputToolView *inputView = [[GSPChatInputToolView alloc]initWithParentFrame:self.view.bounds combinedChatView:_chatView];
//        [self.view addSubview:inputView];
    
    
//    _docView = [[GSPDocView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height/2 - 52, self.view.bounds.size.width, self.view.bounds.size.height/2 + 52)];
//    [self.view addSubview:_docView];
    
    
//    _investigationView = [[GSPInvestigationView alloc]initWithFrame:self.view.bounds];
//    _investigationView.delegate = self;
//    [self.view addSubview:_investigationView];
    
    

    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[chatView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(chatView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[chatView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(chatView)]];
}





#pragma mark - 处理键盘遮盖

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    
    if(offset > 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    int offset = self.view.frame.origin.y;
    if (offset < 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeforKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向下移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark Actions

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加入直播
- (IBAction)join:(id)sender {
    
    if ([self isInputValid]) {
        
        //把数据保存到MainTableViewController
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        MainTableViewController *mainTBVC = [board instantiateViewControllerWithIdentifier:@"mainTBVC"];
        mainTBVC.playerManager = _playerManager;
        mainTBVC.domain = _domainTextField.text;
        mainTBVC.serviceType = _serviceTypeTextField.text;
        mainTBVC.roomNumber = _roomNumberTextField.text;
        mainTBVC.niceName = _nicknameTextField.text;
        mainTBVC.watchPassword = _watchPasswordTextField.text;
        mainTBVC.thirdToken = _thridTokenTextField.text;
        [self.navigationController pushViewController:mainTBVC animated:YES];
    
    }

    
}

- (BOOL)isInputValid
{
    //匹配域名
    NSString *domainRegex = @"^([0-9a-zA-Z][0-9a-zA-Z-]{0,62}\\.)+([0-9a-zA-Z][0-9a-zA-Z-]{0,62})\\.?$";
    NSPredicate *domainTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",domainRegex];
    if (_domainTextField.text == nil ||
        [[_domainTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""] || ![domainTest evaluateWithObject:_domainTextField.text]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"域名格式不正确",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    //匹配服务类型
    if (![[_serviceTypeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@"webcast"]  &&
             ![[_serviceTypeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]isEqualToString:@"training"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"服务类型格式不正确",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    
        return NO;
    }
    
    //匹配房间号码
//    NSString *roomNumberRegex = @"^\\d{8}$";
//    NSPredicate *roomNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", roomNumberRegex];
//    if ([_roomNumberTextField.text length] != 8 || ![roomNumberTest evaluateWithObject:_roomNumberTextField.text]) {
//        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"房间号格式不正确",@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
//        [alertView show];
//        return NO;
//    }
    
    return YES;
}

@end
