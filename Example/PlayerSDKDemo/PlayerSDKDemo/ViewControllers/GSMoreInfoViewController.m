//
//  GSMoreInfoViewController.m
//  PlayerSDKDemo
//
//  Created by Sheng on 2018/9/6.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import "GSMoreInfoViewController.h"
#import <GSCommonKit/GSCommonKit.h>
@interface GSMoreInfoViewController ()
//UI
@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, strong) UILabel *subject;
@property (nonatomic, strong) UILabel *webcastId;
@property (nonatomic, strong) UILabel *speaker;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *arrangement;
@end

@implementation GSMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播信息";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64 - 50)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    
    CGFloat top = 10.f;
    {
        UILabel *label = [self createTagLabel:@"直播主题" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        _subject = [self createElementLabel:@"未知" top:top];
        [self.scrollView addSubview:_subject];
        top = _subject.bottom + 5;
    }
    
    {
        UILabel *label1 = [self createTagLabel:@"直播ID" top:top];
        [self.scrollView addSubview:label1];
        top = label1.bottom + 5;
        
        _webcastId = [self createElementLabel:@"未知" top:top];
        [self.scrollView addSubview:_webcastId];
        top = _webcastId.bottom + 5;
    }
    
    {
        UILabel *label1 = [self createTagLabel:@"直播简介" top:top];
        [self.scrollView addSubview:label1];
        top = label1.bottom + 5;
        
        _speaker = [self createElementLabel:@"介绍内容" top:top];
        _speaker.layer.cornerRadius = 5.f;
        _speaker.clipsToBounds = YES;
        _speaker.layer.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView addSubview:_speaker];
        top = _speaker.bottom + 5;
        
        _arrangement = [self createElementLabel:@"描述内容" top:top];
        _arrangement.layer.cornerRadius = 5.f;
        _arrangement.clipsToBounds = YES;
        _arrangement.layer.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView addSubview:_arrangement];
        top = _arrangement.bottom + 5;
        
        _content = [self createElementLabel:@"直播内容" top:top];
        _content.layer.cornerRadius = 5.f;
        _content.clipsToBounds = YES;
        _content.layer.backgroundColor = [UIColor grayColor].CGColor;
        [self.scrollView addSubview:_content];
        top = _content.bottom + 5;
    }
    
}

- (void)didPlayerJoinSuccess {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:GSWebaccessInfoKey];
    
    _subject.text = [[NSUserDefaults standardUserDefaults] objectForKey:GSParamSubject];
    [_subject sizeToFit];
    
    _webcastId.text = [[NSUserDefaults standardUserDefaults] objectForKey:GSParamWebcastID];
    [_webcastId sizeToFit];
    
    _speaker.numberOfLines = 0;
    _speaker.width = Width - 10;
    _speaker.text = [dic objectForKey:@"speaker"];
    [_speaker sizeToFit];
    
    _arrangement.top = _speaker.bottom + 5;
    _arrangement.width = Width - 10;
    _arrangement.numberOfLines = 0;
    _arrangement.text = [dic objectForKey:@"arrangement"];
    [_arrangement sizeToFit];
    
    
    _content.top = _arrangement.bottom + 5;
    _content.width = Width - 10;
    _content.numberOfLines = 0;
    _content.text = [dic objectForKey:@"content"];
    [_content sizeToFit];
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
