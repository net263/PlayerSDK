//
//  GSTextFieldTitleView.m
//  FastDemo
//
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.
//

#import "GSTextFieldTitleView.h"
#import "UIView+GSSetRect.h"
@implementation GSTextFieldTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel           = [[UILabel alloc] init];
        self.titleLabel.font      = [UIFont systemFontOfSize:14.f];
        [self addSubview:self.titleLabel];
        
        self.field               = [[UITextField alloc] init];
        self.field.textAlignment = NSTextAlignmentRight;
        self.field.font          = [UIFont systemFontOfSize:14.f];
//        [self.field addInputAccessoryViewButtonWithTitle:@"收起键盘"];
        [self addSubview:self.field];
    }
    
    return self;
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    self.titleLabel.left    = 15.f;
    self.titleLabel.centerY = self.middleY;
    
    self.field.width  = Width - self.titleLabel.right - 30.f;
    self.field.height = self.height;
    self.field.right  = Width - 15.f;
}

- (NSString *)title {
    
    return self.titleLabel.text;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    self.field.placeholder = placeHolder;
}

- (NSString *)placeHolder {
    
    return self.field.placeholder;
}


@end
