//
//  KIPageScrollView.m
//  navbarTest
//
//  Created by Huamo on 16/6/17.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "KIPageScrollView.h"
#import <objc/runtime.h>


@interface UIView (KIPageScrollView)

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageForCache;

@end

@implementation UIView (KIPageScrollView)


- (NSInteger)page
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setPage:(NSInteger)page
{
    objc_setAssociatedObject(self, _cmd, [NSNumber numberWithInteger:page], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageForCache
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setPageForCache:(NSInteger)pageForCache
{
    objc_setAssociatedObject(self, _cmd, [NSNumber numberWithInteger:pageForCache], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end




@interface KIPageScrollView () <UIScrollViewDelegate> {
    
}

@property(nonatomic,assign) CGFloat nowOffsetX;
@property(nonatomic,assign) NSInteger numberOfPages;
@property(nonatomic,assign) BOOL canRepeat;
@property(nonatomic,assign) CGFloat pageSpace;//页面间距（默认是20:_pageSpace*2）
@property(nonatomic,assign) NSTimeInterval autoScrollTimeInterval;//自动滚动时间间隔

@property (nonatomic,strong) NSMutableArray *cellCaches;

@property (nonatomic,assign) CGFloat pageWidth;
@property (nonatomic,assign) CGFloat pageHeight;

@end





@implementation KIPageScrollView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame pageSpace:0];
}

/*pageSpace：设置页面之间间隙*/
- (id)initWithFrame:(CGRect)frame pageSpace:(CGFloat)pageSpace{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        
        _currentPageIndex = -1;
        _pageSpace = pageSpace;
        _autoScrollTimeInterval = 0;
        //_cellCaches = @[].mutableCopy;
        
        _pageWidth = self.frame.size.width;
        _pageHeight = self.frame.size.height;
        
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-_pageSpace, 0, _pageWidth+_pageSpace*2, _pageHeight)];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.clipsToBounds = YES;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        [_mainScrollView setShowsHorizontalScrollIndicator:NO];
        _mainScrollView.userInteractionEnabled = YES;
        [self addSubview:_mainScrollView];
        
    }
    return self;
}


#pragma mark - reload

- (void)reloadData{
    
    if (!_delegate
        || ![_delegate respondsToSelector:@selector(pageView:viewForPage:)]
        || ![_delegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        
        NSAssert(NO, @"KIPage delegate must not be nil");
        return;
    }
    
    
    _numberOfPages = [_delegate numberOfPagesInPageView:self];
    if (_numberOfPages<= 0) {
        return;
    }
    NSAssert(_numberOfPages>0, @"KIPageScrollView delegate must not be nil");
    
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewCanRepeat:)]) {
        _canRepeat = [_delegate pageViewCanRepeat:self];
    }
    
    
    
    [self setupViews];
}

- (void)setupViews{
    
    
    [self updateCellsForReuse];
    
    
    CGFloat width = _pageWidth;
    CGFloat height = _pageHeight;
    if (_canRepeat) {
        
        for (NSInteger i=0; i<_numberOfPages+2; i++) {
            
            UIView *cell = nil;
            
            //NSInteger cellPage = 0;
            if (i == 0) {
                cell = [_delegate pageView:self viewForPage:_numberOfPages-1];
                //cellPage = _numberOfPages-1;
                
                
            }else if (i == _numberOfPages+2 - 1){
                cell = [_delegate pageView:self viewForPage:0];
                //cellPage = 0;
                
            }else{
                cell = [_delegate pageView:self viewForPage:i-1];
                //cellPage = i-1;
                
            }
            
            cell.page = i;
            if (cell.pageForCache != 1 && _cellCaches) {
                cell.pageForCache = 1;
                [_cellCaches addObject:cell];
            }
            cell.frame = CGRectMake(_pageSpace+width*i+_pageSpace*2*i, 0, width, height);
            [_mainScrollView addSubview:cell];
            
        }
        
        _mainScrollView.contentSize = CGSizeMake(width * (_numberOfPages+2) + _pageSpace*2*(_numberOfPages+2), height);
        [_mainScrollView setContentOffset:CGPointMake(width+ _pageSpace*2, 0) animated:NO];
        
        
        [self setupAutoCycleScroll];
    }else{
        for (NSInteger i=0; i<_numberOfPages; i++) {
            
            UIView *cell = cell = [_delegate pageView:self viewForPage:i];
            cell.page = i;
            if (cell.pageForCache != 1 && _cellCaches) {
                cell.pageForCache = 1;
                [_cellCaches addObject:cell];
            }
            
            cell.frame = CGRectMake(_pageSpace+width*i+_pageSpace*2*i, 0, width, height);
            [_mainScrollView addSubview:cell];
            
        }
        
        _mainScrollView.contentSize = CGSizeMake(width * _numberOfPages+ _pageSpace*2*_numberOfPages, height);
        
    }
    
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!_canRepeat) {
        return;
    }
    
    [self endAutoCycleScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_canRepeat) {
        CGFloat offsetX = scrollView.contentOffset.x ;
        
        if (offsetX >= _pageWidth*(_numberOfPages+1) + _pageSpace*2*_numberOfPages) {
            // 开始显示最后一张图片的时候切换到第二个图
            [scrollView setContentOffset:CGPointMake(_pageWidth + _pageSpace*2, 0) animated:NO];
            
            
        }else if (offsetX <= 0) {
            // 开始显示第一张图片的时候切换到倒数第二个图
            [scrollView setContentOffset:CGPointMake(_pageWidth*_numberOfPages + _pageSpace*2*_numberOfPages, 0) animated:NO];
        }
        
        
        //NSInteger page = (_mainScrollView.contentOffset.x + _pageWidth/2.0) / _pageWidth;
        NSInteger page = (_pageSpace+_mainScrollView.contentOffset.x + _pageWidth/2.0) / (_pageWidth+_pageSpace*2);
        if (page == 0) {
            page = _numberOfPages-1;
        }else if (page == _numberOfPages+2 - 1){
            page = 0;
        }else{
            page = page-1;
        }
        
        if (page != _currentPageIndex) {
            if (_delegate && [_delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [_delegate pageView:self didScrolledToPageIndex:page];
            }
        }
        _currentPageIndex = page;
        
        
    }else{
        NSInteger page = (int)((_pageSpace+_mainScrollView.contentOffset.x)/(_pageWidth+_pageSpace*2));
        
        if (page != _currentPageIndex) {
            if (_delegate && [_delegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [_delegate pageView:self didScrolledToPageIndex:page];
            }
        }
        _currentPageIndex = page;
    }
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!_canRepeat) {
        return;
    }
    
    
    if (!decelerate)
    {
        CGFloat targetX = _mainScrollView.contentOffset.x + _pageWidth+_pageSpace*2;
        targetX = (int)(targetX/(_pageWidth+_pageSpace*2)) * (_pageWidth+_pageSpace*2);
        [self moveToTargetPosition:targetX];
    }else{
        
        [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX{
    [self moveToTargetPosition:targetX animated:YES];
}

- (void)moveToTargetPosition:(CGFloat)targetX animated:(BOOL)animated{
    
    [_mainScrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

- (void)scrollToIndex:(NSInteger)aIndex animated:(BOOL)animated{
    if (!_canRepeat) {
        [self moveToTargetPosition:_pageWidth*aIndex+(aIndex*2)*_pageSpace animated:animated];
        
        return;
    }
    
    
    if (aIndex<0 || aIndex>_numberOfPages-1) {
        return;
    }
    
    [self moveToTargetPosition:_pageWidth*(aIndex+1)+_pageSpace*(aIndex+1+1) animated:animated];
    
    [self scrollViewDidScroll:_mainScrollView];
    
}


#pragma mark - 自动循环滚动

//初次设置自动循环滚动
- (void)setupAutoCycleScroll{
    
    if (_delegate && [_delegate respondsToSelector:@selector(timeIntervalOfPageViewAutoCycle:)]) {
        _autoScrollTimeInterval = [_delegate timeIntervalOfPageViewAutoCycle:self];
    }
    
    if ([self canAutoCycleScroll]) {
        [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
    }
    
}

- (void)endAutoCycleScroll{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAutoCycleScroll) object:nil];
}

//设置自动轮播
- (void)beginAutoCycleScroll{
    [self endAutoCycleScroll];
    
    
    if ([self canAutoCycleScroll]){
        
        CGFloat targetX = _mainScrollView.contentOffset.x + (_pageWidth+_pageSpace*2);
        targetX = (int)(targetX/(_pageWidth+_pageSpace*2)) * (_pageWidth+_pageSpace*2);
        
        [_mainScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
        
        //[self scrollViewDidScroll:_mainScrollView];
        //[self showPageIndex:[self getCurrentPageIndexWithIndex:_currentPageIndex + 1] animated:YES];
        
        [self performSelector:@selector(beginAutoCycleScroll) withObject:nil afterDelay:_autoScrollTimeInterval  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

//获取是否可以循环滚动
- (BOOL)canAutoCycleScroll{
    
    if (!_delegate) {
        //NSLog(@"代理不能为空！！！");
        return NO;
    }
    
    //自动循环滚动的时间间隔：默认为0，不支持滚动
    if (_autoScrollTimeInterval == 0) {
        //NSLog(@"自动循环滚动时间间隔为0，不能自动轮播");
        return NO;
    }else if (!_canRepeat){
        //NSLog(@"不支持循环滚动");
        return NO;
    }else if (_numberOfPages <= 1){
        //NSLog(@"只有一个view，不能滚动");
        return NO;
    }
    
    return YES;
}

//根据索引值，获取对应的当前索引
- (NSInteger)getCurrentPageIndexWithIndex:(NSInteger)index{
    if (index > _numberOfPages-1) {
        return index-_numberOfPages;//index / numberOfPages;
    }else if (index < 0){
        return index+_numberOfPages;
    }
    return index;
}



#pragma mark - 复用

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (UIView *cell in _cellCaches) {
        if (cell.superview) {
            
            [cell removeFromSuperview];
            cell.page = -1;
        }
    }
}

/// dequeue a reusable cell
//暴露到外部的方法：获取复用的view
- (UIView *)dequeueReusableCell {
    if (!_cellCaches) {
        _cellCaches = @[].mutableCopy;
    }
    
    UIView *cell = nil;
    for (cell in _cellCaches) {
        if (!cell.superview && cell.page==-1) {
            return cell;
        }
    }
    
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (UIView *)cellForPage:(NSInteger)page {
    for (UIView *cell in _cellCaches) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}




@end



