//
//  GSBaseViewController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSBaseViewController.h"
#import <PlayerSDK/PlayerSDK.h>
#define UICOLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSBaseViewController ()

@end

@implementation GSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extern
- (UILabel *)createElementLabel:(NSString *)tagContent top:(CGFloat)top {
    return [self createElementLabel:tagContent top:top left:15];
}

- (UILabel *)createElementLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, 20)];
    label.text = tagContent;
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    return label;
}
- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top {
    return [self createTagLabel:tagContent top:top left:15];
}

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, 20)];
    label.text = tagContent;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12.f];
    [label sizeToFit];
    return label;
}

- (UIView *)createWhiteBGViewWithTop:(CGFloat)top itemCount:(NSInteger)count {
    
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, top, Width, count * 40.f)];
    view.backgroundColor = [UIColor whiteColor];
    
    // Top line.
    {
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5f)];
        line.backgroundColor = UICOLOR16(0xE8E8E8);
        [view addSubview:line];
    }
    
    // Bottom line.
    {
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5f)];
        line.backgroundColor = UICOLOR16(0xE8E8E8);
        line.bottom          = view.height;
        [view addSubview:line];
    }
    
    // Middle lines.
    for (int i = 1; i < count; i++) {
        
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(15, i * 40.f - 0.5f, Width - 15.f, 0.5f)];
        line.backgroundColor = UICOLOR16(0xE8E8E8);
        [view addSubview:line];
    }
    
    return view;
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
