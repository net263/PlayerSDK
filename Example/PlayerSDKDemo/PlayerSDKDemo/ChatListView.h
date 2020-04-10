//
//  VoteThemesListView.h
//  PlayerSDK
//
//  Created by Gaojin Hsu on 6/26/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListView : UIView

- (id)initWithFrame:(CGRect)frame;

- (void)reloadData;

@property (nonatomic, copy) void (^selectRow)(NSUInteger row);

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
