//
//  KIGuideViewController.m
//  Kitalker
//
//  Created by 刘 波 on 12-12-25.
//
//

#import "KIGuideView.h"

@interface KIGuideView () {
    UIScrollView        *_scrollView;
    NSMutableDictionary *_guideConfig;
    NSArray             *_pageList;
    BOOL                _statusBarHidden;
    UIPageControl       *_pageControl;
}
@end

@implementation KIGuideView

static KIGuideView *KIGUIDE_VIEW;

#pragma mark - init

+ (KIGuideView *)sharedInstance {
    if (KIGUIDE_VIEW == nil) {
        KIGUIDE_VIEW = [[KIGuideView alloc] init];
    }
    return KIGUIDE_VIEW;
}

- (id)init {
    if (KIGUIDE_VIEW == nil) {
        if (self = [super init]) {
            [self setBackgroundColor:[UIColor clearColor]];
            [self setFrame:[UIApplication sharedApplication].keyWindow.bounds];
            KIGUIDE_VIEW = self;
        };
    }
    return KIGUIDE_VIEW;
}

#pragma mark - 显示

+ (void)showOnceWithAnimated:(BOOL)animated {
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *guideKey = [NSString stringWithFormat:@"guide-%@", bundleVersion];
    NSDictionary *guideDict = [NSDictionary dictionaryWithObjectsAndKeys:@"0", guideKey, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:guideDict];
    BOOL isShow = [[[NSUserDefaults standardUserDefaults] objectForKey:guideKey] boolValue];
    if (!isShow) {
        
        [[KIGuideView sharedInstance] show:animated];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:guideKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /**
         modify by chen
         warning：2.0.0版本，用户信息phone和name字段名字改变，导致手机号用户名不能显示
         解决方案：升级第一次打开，清空所有用户信息
         */
        //[HMUserManager exitLogin];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HMUserInformationModify" object:nil];
    }
}

+ (void)show:(BOOL)animated {
    [[KIGuideView sharedInstance] show:animated];
}

- (void)show:(BOOL)animated {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setPagingEnabled:YES];
        _scrollView.backgroundColor = [UIColor clearColor];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setBounces:NO];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
    }
    
    if ([self initPage]) {
        [self initButton];
        if (animated) {
            [self setAlpha:0.0f];
        }
        
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        
        BOOL statusBarHidden = [[[self guideConfig] objectForKey:@"statusBarHidden"] boolValue];
        [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden withAnimation:UIStatusBarAnimationFade];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                [self setAlpha:1.0f];
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kGuideViewDidShowNotification object:nil];
            }];
        }
    } else {
        [self close];
    }
}

#pragma mark -  界面实现

//加载界面
- (BOOL)initPage {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat count = [self pageList].count;
    
    for (int i=0; i<count; i++) {
        
        NSString *name = [[self pageList] objectAtIndex:i];
        
        if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
            if (SCREEN_BOTTOM_HEIGHT>0) {
                name = [NSString stringWithFormat:@"%@-X", name];
            }else{
                name = [NSString stringWithFormat:@"%@-1104h", name];
            }
        }
        name = [name stringByAppendingString:@".jpg"];
        UIImage *image = [UIImage imageNamed:name];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //[imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setFrame:CGRectMake(width*i, 0, width, height)];
        [_scrollView addSubview:imageView];
        imageView = nil;
    }
    
    if (count>0) {
        UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, [[UIScreen mainScreen] applicationFrame].size.width, 30)];
        [self addSubview:page];
        [page setHidesForSinglePage:YES];
        page.numberOfPages = count;
        page.backgroundColor = [UIColor clearColor];
        if ([page respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
            page.currentPageIndicatorTintColor = [UIColor redColor];
        }
        if ([page respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            page.pageIndicatorTintColor = [UIColor lightGrayColor];
        }
        page.currentPage = 0;
        _pageControl = page;
        _pageControl.hidden = YES;
    }
    
    BOOL slideOpen = [[[self guideConfig] objectForKey:@"slideOpen"] boolValue];
    NSUInteger pageNumber = slideOpen?count+1:count;
    
    [_scrollView setContentSize:CGSizeMake(width*(pageNumber), self.bounds.size.height)];
    return count>0?YES:NO;
}

//加载按钮
- (void)initButton {
    CGFloat count = [self pageList].count-1;
    
    CGRect rect = CGRectMake(100 + SCREEN_WIDTH*count, SCREEN_HEIGHT-50-30, SCREEN_WIDTH-200, 50);
    if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
        if (SCREEN_BOTTOM_HEIGHT>0) {
            rect = CGRectMake(100 + SCREEN_WIDTH*count, SCREEN_HEIGHT-60-40-SCREEN_BOTTOM_HEIGHT, SCREEN_WIDTH-200, 70);
        }else{
            rect = CGRectMake(100 + SCREEN_WIDTH*count, SCREEN_HEIGHT-70-30, SCREEN_WIDTH-200, 70);
        }
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    
    
    [button setShowsTouchWhenHighlighted:YES];
    
    [button addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    //button.backgroundColor = [UIColor greenColor];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    CGFloat width = scrollView.contentSize.width;
    CGFloat viewWidth = self.bounds.size.width;
    
    _pageControl.currentPage = scrollView.contentOffset.x/[[UIScreen mainScreen] applicationFrame].size.width;
    
    BOOL slideOpen = [[[self guideConfig] objectForKey:@"slideOpen"] boolValue];
    if (slideOpen) {
        if (width == x + viewWidth) {
            [self close];
        }
    }
}

- (void)close {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGuideViewWillFinishedNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHidden withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:.5f animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        KIGUIDE_VIEW = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kGuideViewDidFinishedNotification object:nil];
    }];
}


#pragma mark - 读取配置数据

- (NSArray *)pageList {
    if (_pageList == nil || _pageList.count <= 0) {
        NSString *appleLanguages = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        NSString *key = [NSString stringWithFormat:@"pageList-%@", appleLanguages];
        _pageList = [[self guideConfig] objectForKey:key];
        if (_pageList == nil || _pageList.count <= 0) {
            _pageList = [[self guideConfig] objectForKey:@"pageList"];
        }
    }
    return _pageList;
}

- (NSMutableDictionary *)guideConfig {
    if (_guideConfig == nil) {
        _guideConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:[self guideConfigFile]];
    }
    return _guideConfig;
}

- (NSString *)guideConfigFile {
    return [[NSBundle mainBundle] pathForResource:kGuideConfigFileName ofType:@"plist"];
}


@end
