//
//  InfoEditViewController.h
//  MHJFamilyV1
//
//  Created by tangmi on 16/4/19.
//  Copyright © 2016年 mhjmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoEditTableViewCell.h"



typedef void (^UserInfoChangedCompletionBlock)(NSString *result);

@interface InfoEditViewController : UITableViewController

@property (nonatomic, copy) NSString* userInfo;

- (instancetype)initWithChangeInfo:(NSString*)string Completion:(UserInfoChangedCompletionBlock)block;



@end
