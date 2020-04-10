//
//  ReNameViewController.m
//  PlayerSDKDemo
//
//  Created by Gaojin Hsu on 5/23/18.
//  Copyright © 2018 Geensee. All rights reserved.
//

#import "ReNameViewController.h"

@interface ReNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation ReNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishChange)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishChange {
    if (_textfield.text.length > 0) {
        BOOL success = [[GSPPlayerManager sharedManager] changeuserName:_textfield.text];
        NSString *hint = @"修改成功";
        if (!success) {
            hint = @"修改失败";
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:hint delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
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
