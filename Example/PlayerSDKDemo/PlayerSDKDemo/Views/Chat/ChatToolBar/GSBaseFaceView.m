//
//  GSBaseFaceView.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSBaseFaceView.h"
#import "GSFaceView.h"
#import "GSEmotionManager.h"
//#import "PagingCollectionViewLayout.h"

@interface UIButton (UIButtonImageWithLable)
- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType;
@end

@implementation UIButton (UIButtonImageWithLable)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    CGSize titleSize;
    if ([NSString instancesRespondToSelector:@selector(sizeWithAttributes:)]) {
        titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    } else {
        titleSize = [title sizeWithFont:[UIFont systemFontOfSize:10]];
    }
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,
                                              0.0,
                                              20,
                                              0)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self setTitleColor:[UIColor blackColor] forState:stateType];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(CGRectGetHeight(self.bounds)-20,
                                              -image.size.width,
                                              0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end

@protocol GSEmotionCollectionViewCellDelegate

@optional

- (void)didSendEmotion:(GSEmotion*)emotion;

@end

@interface GSEmotionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<GSEmotionCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) GSEmotion *emotion;
@property (nonatomic, assign) BOOL isDelete;
@end

@implementation GSEmotionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = self.bounds;
        _imageButton.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageButton.frame = self.bounds;
}

- (void)setEmotion:(GSEmotion *)emotion
{
    _emotion = emotion;
    if ([emotion isKindOfClass:[GSEmotion class]]) {
        if (emotion.emotionType == GSEmotionGif) {
            [_imageButton setImage:[UIImage imageNamed:emotion.emotionOriginal] withTitle:emotion.emotionTitle forState:UIControlStateNormal];
        } else if (emotion.emotionType == GSEmotionPng || emotion.emotionType == GSEmotionGensee) {
            [_imageButton setImage:[UIImage imageNamed:emotion.emotionOriginal] forState:UIControlStateNormal];
            _imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_imageButton setTitle:nil forState:UIControlStateNormal];
            [_imageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_imageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        } else {
            [_imageButton.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
            [_imageButton setTitle:emotion.emotionThumbnail forState:UIControlStateNormal];
            [_imageButton setImage:nil forState:UIControlStateNormal];
            [_imageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_imageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [_imageButton addTarget:self action:@selector(sendEmotion:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
        if (_isDelete) {
            [_imageButton setTitle:nil forState:UIControlStateNormal];
            [_imageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_imageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_imageButton setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateNormal];
//            [_imageButton setImage:[UIImage imageNamed:@"Delete_ios7"] forState:UIControlStateHighlighted];
            [_imageButton addTarget:self action:@selector(sendEmotion:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_imageButton setImage:nil forState:UIControlStateNormal];
            [_imageButton setTitle:nil forState:UIControlStateNormal];
        }
        
        
    }
}

- (void)sendEmotion:(id)sender
{
    if (_delegate) {
        if ([_emotion isKindOfClass:[GSEmotion class]]) {
            [_delegate didSendEmotion:_emotion];
        } else {
            
            if (self.isDelete) {
                [_delegate didSendEmotion:nil];
            }
            
        }
    }
}

@end

@interface GSBaseFaceView () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GSEmotionCollectionViewCellDelegate>
{
    CGFloat _itemWidth;
    CGFloat _itemHeight;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *emotionManagers;


@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageIndexs; //获取各表情组起始页下标数组
@property (nonatomic, strong) NSArray<NSNumber *> *emoticonGroupPageCounts; //每个manager多少页
@property (nonatomic, assign) NSInteger emoticonGroupTotalPageCount; //表情组总页数
@property (nonatomic, assign) NSInteger currentPageIndex;
@end

@implementation GSBaseFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageControl = [[UIPageControl alloc] init];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[GSEmotionCollectionViewCell class] forCellWithReuseIdentifier:@"GSCollectionCell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.userInteractionEnabled = YES;
        //        [self addSubview:_scrollview];
        [self addSubview:_pageControl];
        [self addSubview:_collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (section < [_emotionManagers count]) {
//        GSEmotionManager *emotionManager = [_emotionManagers objectAtIndex:section];
//        return [emotionManager.emotions count];
//    }
//    return 0;
    return kOnePageCount + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    if (_emotionManagers == nil || [_emotionManagers count] == 0) {
//        return 1;
//    }
//    return [_emotionManagers count];
    return _emoticonGroupTotalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"GSCollectionCell";
    GSEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        
    }
    [cell sizeToFit];
    
//    GSEmotionManager *emotionManager;
//
//    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
//        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
//        if (indexPath.section >= pageIndex.unsignedIntegerValue) {
//            emotionManager = _emotionManagers[i];
//
//        }
//    }
//    GSEmotionManager *emotionManager = [_emotionManagers objectAtIndex:indexPath.section];
//    GSEmotion *emotion = [emotionManager.emotions objectAtIndex:indexPath.row];
//    cell.emotion = emotion;
    if (indexPath.row == kOnePageCount) {
        cell.isDelete = YES;
        cell.emotion = nil;
    } else {
        cell.isDelete = NO;
        cell.emotion = [self _emoticonForIndexPath:indexPath];
    }

    cell.userInteractionEnabled = YES;
    cell.delegate = self;
    return cell;
}

static int kOnePageCount = 17;

- (GSEmotion *)_emoticonForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;

    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (section >= pageIndex.unsignedIntegerValue) {
            GSEmotionManager *group = _emotionManagers[i];
            NSUInteger page = section - pageIndex.unsignedIntegerValue;
            NSUInteger index = page * kOnePageCount + indexPath.row;
            
            // transpose line/row
            NSUInteger ip = index / kOnePageCount;
            NSUInteger ii = index % kOnePageCount;
            NSUInteger reIndex = (ii % 3) * 6 + (ii / 3);
            index = reIndex + ip * kOnePageCount;
            
            if (index < group.emotions.count) {
                return group.emotions[index];
            } else {
                return nil;
            }
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    GSEmotionManager *emotionManager;
//
//    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
//        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
//        if (section >= pageIndex.unsignedIntegerValue) {
//            emotionManager = _emotionManagers[i];
//            NSInteger maxRow = emotionManager.emotionRow;
//            NSInteger maxCol = emotionManager.emotionCol;
//            CGFloat itemWidth = self.frame.size.width / maxCol;
//            CGFloat itemHeight = (self.frame.size.height) / maxRow;
//            return CGSizeMake(itemWidth, itemHeight);
//        }
//    }
////    GSEmotionManager *emotionManager = [_emotionManagers objectAtIndex:section];
//    CGFloat itemWidth = self.frame.size.width / emotionManager.emotionCol;
//    NSInteger pageSize = emotionManager.emotionRow*emotionManager.emotionCol;
//    NSInteger lastPage = (pageSize - [emotionManager.emotions count]%pageSize);
//    if (lastPage < emotionManager.emotionRow ||[emotionManager.emotions count]%pageSize == 0) {
        return CGSizeMake(0, 0);
//    } else{
//        NSInteger size = lastPage/emotionManager.emotionRow;
//        return CGSizeMake(size*itemWidth, self.frame.size.height);
//    }
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//
//    if (kind == UICollectionElementKindSectionHeader){
//
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        reusableview = headerView;
//
//    }
//    if (kind == UICollectionElementKindSectionFooter){
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        reusableview = footerview;
//    }
//    return reusableview;
//}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GSEmotionManager *emotionManager;
    
    for (NSInteger i = _emoticonGroupPageIndexs.count - 1; i >= 0; i--) {
        NSNumber *pageIndex = _emoticonGroupPageIndexs[i];
        if (indexPath.section >= pageIndex.unsignedIntegerValue) {
            emotionManager = _emotionManagers[i];
            NSInteger maxRow = emotionManager.emotionRow;
            NSInteger maxCol = emotionManager.emotionCol;
            CGFloat itemWidth = self.frame.size.width / maxCol;
            CGFloat itemHeight = (self.frame.size.height) / maxRow;
            return CGSizeMake(itemWidth, itemHeight);
        }
    }
    
    emotionManager = _emotionManagers[0];
    NSInteger maxRow = emotionManager.emotionRow;
    NSInteger maxCol = emotionManager.emotionCol;
    CGFloat itemWidth = self.frame.size.width / maxCol;
    CGFloat itemHeight = (self.frame.size.height) / maxRow;
    return CGSizeMake(itemWidth, itemHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma makr - GSEmotionCollectionViewCellDelegate
- (void)didSendEmotion:(GSEmotion *)emotion
{
    if (emotion) {
        if (emotion.emotionType == GSEmotionDefault || emotion.emotionType == GSEmotionGensee) {
            if (_delegate) {
                [_delegate selectedFacialView:emotion.emotionTitle];
            }
        } else {
            if (_delegate) {
                [_delegate sendFace:emotion];
            }
        }
    } else {
        [_delegate deleteSelected:nil];
    }
}

-(void)loadFacialView:(NSArray*)emotionManagers size:(CGSize)size
{
    for (UIView *view in [self.scrollview subviews]) {
        [view removeFromSuperview];
    }
    _emotionManagers = emotionManagers;
    
    //获取各表情组起始页下标数组
    NSMutableArray *indexs = [NSMutableArray new];
    NSUInteger index = 0;
    
    for (NSInteger i = 0; i < _emotionManagers.count ; i++) {
        GSEmotionManager *group = _emotionManagers[i];
        group.emotionPageIndex = index;
        [indexs addObject:@(index)];
        NSUInteger count = ceil(group.emotions.count / (float)kOnePageCount);
        if (count == 0) count = 1;
        index += count;
    }
    _emoticonGroupPageIndexs = indexs;
    
    //表情组总页数
    NSMutableArray *pageCounts = [NSMutableArray new];
    _emoticonGroupTotalPageCount = 0;
    for (GSEmotionManager *group in _emotionManagers) {
        NSUInteger pageCount = ceil(group.emotions.count / (float)kOnePageCount);
        if (pageCount == 0) pageCount = 1;
        [pageCounts addObject:@(pageCount)];
        _emoticonGroupTotalPageCount += pageCount;
    }
    _emoticonGroupPageCounts = pageCounts;
    
    
    [_collectionView reloadData];
}

-(void)loadFacialViewWithPage:(NSInteger)page
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:page]
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:NO];
    CGPoint offSet = _collectionView.contentOffset;
    if (page == 0) {
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*((int)(offSet.x/CGRectGetWidth(self.frame))+1), 0) animated:NO];
    }
    //    [_collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*2, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

@end
