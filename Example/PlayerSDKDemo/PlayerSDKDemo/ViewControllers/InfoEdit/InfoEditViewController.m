//
//  InfoEditViewController.m
//  MHJFamilyV1
//
//  Created by tangmi on 16/4/19.
//  Copyright © 2016年 mhjmac. All rights reserved.
//

#import "InfoEditViewController.h"
#import "UIView+GSSetRect.h"
@interface InfoEditViewController ()

@property (copy) UserInfoChangedCompletionBlock infoChangeCompletion;

@property (nonatomic, assign) BOOL isFirstTime;

@property (nonatomic, copy) NSString* transmitString;

@end

@implementation InfoEditViewController
- (instancetype)initWithChangeInfo:(NSString*)string Completion:(UserInfoChangedCompletionBlock)block
{
    if (self = [super init]) {
//        self = [[InfoEditViewController alloc]init];
        self.userInfo = string;
        self.infoChangeCompletion = block;
        self.isFirstTime = YES;
        self.transmitString = string;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64) style:UITableViewStyleGrouped];
    [self _setUpNavigationItems];
    
}

- (void)_setUpNavigationItems
{
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [changeButton setTitle:@"修改" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [changeButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:changeButton]];
}

- (void)changeAction
{
    if (self.transmitString == nil) {
        self.infoChangeCompletion(@"");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }else{
        self.infoChangeCompletion(self.transmitString);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoChangeCell" ];
    if (cell == nil) {
        cell = (InfoEditTableViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"InfoEditTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoTextField.text = self.transmitString;
    if (self.isFirstTime) {
        [cell.infoTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.infoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        cell.infoTextField.clearsOnBeginEditing = YES;
        [cell.infoTextField becomeFirstResponder];
        cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)textFieldEditChanged:(UITextField *)textField

{
//    if (textField.text.length == 0) {
//        self.transmitString = self.userInfo;
//        return;
//    }
    self.transmitString = textField.text;
    NSLog(@"textfield text %@",textField.text);
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;{
    
    self.transmitString = textField.text;
    NSLog(@"textfield text %@",textField.text);
    return YES;
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
