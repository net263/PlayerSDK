//
//  GSPDocView.h
//  PlayerSDK
//
//  Created by gensee on 2018/11/13.
//  Copyright © 2018年 Geensee. All rights reserved.
//

#import <GSDocKit/GSDocKit.h>

@interface GSPDocPage : GSDocPage

@end

@protocol GSPDocViewDelegate <GSDocViewDelegate>

- (void)docViewPOpenFinishSuccess:(GSPDocPage* _Nonnull)page docID:(unsigned)docID;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GSPDocView : GSDocView


@property (nonatomic, weak) id<GSPDocViewDelegate> pdocDelegate;//文档代理

@property (assign, nonatomic) BOOL doubleEnabled DEPRECATED_MSG_ATTRIBUTE("弃用");

@end

NS_ASSUME_NONNULL_END
