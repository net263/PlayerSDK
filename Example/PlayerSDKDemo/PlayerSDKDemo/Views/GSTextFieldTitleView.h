//
//  GSTextFieldTitleView.h
//  FastDemo
//
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTextFieldTitleView : UIView

@property (nonatomic, strong) NSString    *title;
@property (nonatomic, strong) NSString    *placeHolder;

@property (nonatomic, strong) UITextField *field;
@property (nonatomic, strong) UILabel *titleLabel;

@end
