//
//  KIPageScrollView.h
//  navbarTest
//
//  Created by Huamo on 16/6/17.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol KIPageScrollViewDelegate;

@interface KIPageScrollView : UIView{
    
}
@property(nonatomic,assign) NSInteger currentPageIndex;
@property(nonatomic,weak) id<KIPageScrollViewDelegate> delegate;
@property(nonatomic,strong) UIScrollView *mainScrollView;


- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame pageSpace:(CGFloat)pageSpace;



- (void)reloadData;

- (void)scrollToIndex:(NSInteger)aIndex animated:(BOOL)animated;


//暴露到外部的方法：获取复用的view
- (UIView *)dequeueReusableCell;

- (UIView *)cellForPage:(NSInteger)page;

@end



#pragma mark - 代理

@protocol KIPageScrollViewDelegate <NSObject>

@required
- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex;

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView;

@optional

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView;

- (CGFloat)timeIntervalOfPageViewAutoCycle:(KIPageScrollView*)pageView;

- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex;

@end
