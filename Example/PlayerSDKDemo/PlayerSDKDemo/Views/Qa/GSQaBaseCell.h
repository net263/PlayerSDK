//
//  GSQaBaseCell.h
//  FASTSDK
//
//  Created by Sheng on 2017/12/8.
//  Copyright © 2017年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSQaModel.h"
@interface GSQaBaseCell : UITableViewCell

@property (nonatomic, strong) GSQaModel *model;

@property (nonatomic, weak) UITableView  *tableView;

#pragma mark - APPEARANCE


@property (nonatomic,strong) UIFont *contentFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:14];

@property (nonatomic,strong) UIFont *nickFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:13];
//宽度
@property (nonatomic,assign) CGFloat cellWidth UI_APPEARANCE_SELECTOR;

@end
