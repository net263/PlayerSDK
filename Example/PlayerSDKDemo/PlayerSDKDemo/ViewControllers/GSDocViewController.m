//
//  GSDocViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/8/16.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSDocViewController.h"
#import "UIView+GSSetRect.h"
#import "UIAlertController+Blocks.h"

#define NewVersion 0

@interface GSDocViewController () <GSDocViewDelegate>
@property (nonatomic, strong) UIView *docArea;

#if NewVersion
@property (nonatomic, strong) GSDocView *docView;
#else
@property (nonatomic, strong) GSPDocView *docView;
#endif

@end

@implementation GSDocViewController

- (GSPDocView *)docView {
    if (!_docView) {
        _docView = [[GSPDocView alloc] initWithFrame:_docArea.bounds];
//        [self.docArea addSubview:_docView];
        UIView *view = [[UIView alloc] initWithFrame:_docArea.bounds];
        [_docArea addSubview:view];
        [self.docArea insertSubview:_docView belowSubview:view];
        [_docView setBackgroundColor:51 green:51 blue:51]; //文档加载以后侧边栏显示的颜色
    }
    return _docView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat top = 64 + 5;
    
    _docArea = [[UIView alloc] initWithFrame:CGRectMake(5, top + UIView.additionaliPhoneXTopSafeHeight, Width - 10, (Width - 10)*3/4)];
    [self.view addSubview:_docArea];

    
    top = _docArea.bottom + 5;
#if NewVersion
//    _docView = [[GSDocView alloc]initWithFrame:_docArea.bounds];
//    [self.docArea addSubview:_docView];
//    [_docView setBackgroundColor:51 green:51 blue:51]; //文档加载以后侧边栏显示的颜色
#else
    self.docView = [[GSPDocView alloc]initWithFrame:_docArea.bounds];
    //    _docView.backgroundColor = [UIColor redColor];   //文档没有显示出来之前显示的颜色
    [self.docArea addSubview:self.docView];
    [self.docView setGlkBackgroundColor:51 green:51 blue:51]; //文档加载以后侧边栏显示的颜色
#endif
    self.docView.showMode = GSDocViewShowModeScaleAspectFit;
    self.docView.delegate = self;
    self.manager.docView = self.docView;
    self.manager.delegate = self;
}

- (void)popAction {
    [self.docView clearPageAndAnno];
    [[GSPPlayerManager sharedManager] leave];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)docViewOpenFinishSuccess:(GSDocPage*)page docID:(unsigned)docID {
    NSLog(@"docViewOpenFinishSuccess");
}

- (void)playerManagerDidDocumentSwitch:(GSPPlayerManager*)playerManager {
    NSLog(@"playerManagerDidDocumentSwitch");
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
