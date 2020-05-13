//
//  KIWindowImageView.m
//  Test
//
//  Created by Huamo on 16/6/22.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "KIWindowImageView.h"
#import "KIPageScrollView.h"
#import "KIWindowImageItem.h"
#import "UIImage+blur.h"


@interface KIWindowImageView () <KIPageScrollViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate> {
    
}
@property (nonatomic,strong) KIPageScrollView *pageView;
@property (nonatomic, strong) UIImageView *background;

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,assign) NSInteger originShowIndex;
@property (nonatomic,assign) CGRect originShowRect;        //点击显示大图的view的frame
@property (nonatomic, weak) UIView *originImagesFirstShow; //点击显示大图的view
@property (nonatomic, weak) UIView *originGroupsFirstShow; //点击显示大图的小图集合，如果小图不是一个superView，则不传

@property (nonatomic,strong) UIView *animationView;
@property (nonatomic,strong) UIImageView *animationImage;
@property (nonatomic,assign) NSInteger currShowIndex;
@property (nonatomic,assign) BOOL hasShowedFistView;

@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) BOOL isPresented;
@property (nonatomic,assign) CGPoint panGestureBeginPoint;

@property (nonatomic ,strong) UILabel *currentIndexLabel;


@end


@implementation KIWindowImageView

#pragma mark - 外部调用静态方法 -   显示当前Index／array.count labelde

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect showCurrentIndex:(BOOL)currentBool{
    [KIWindowImageView showWithImageArray:aImageArray selectedIndex:index originRect:originRect groupsView:nil showCurrentIndex:currentBool];
}

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView showCurrentIndex:(BOOL)currentBool{
    if (aImageArray && [aImageArray isKindOfClass:[NSArray class]]
        && [aImageArray count]>0) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        KIWindowImageView *windowImageView = [[KIWindowImageView alloc]initWithFrame:window.bounds imageArray:aImageArray selectedIndex:index originRect:originRect groupsView:groupsView showCurrentIndex:currentBool];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
        
    }
    
}


#pragma mark - 外部调用静态方法 -   不显示当前Index 正常图片显示

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect{
    [KIWindowImageView showWithImageArray:aImageArray selectedIndex:index originRect:originRect groupsView:nil];
}

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView{
    if (aImageArray && [aImageArray isKindOfClass:[NSArray class]]
        && [aImageArray count]>0) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        KIWindowImageView *windowImageView = [[KIWindowImageView alloc]initWithFrame:window.bounds imageArray:aImageArray selectedIndex:index originRect:originRect groupsView:groupsView];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
        
    }
    
}


#pragma mark - init

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView {
    if (self = [super initWithFrame:frame]) {
        
        _imageArray = [[NSMutableArray alloc]init];
        [_imageArray addObjectsFromArray:aImageInformationArray];
        _originShowIndex = index;
        _currShowIndex = index;
        _originShowRect = originRect;
        _originGroupsFirstShow = groupsView;
        _isPresented = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        
        [self addGesture];
        
        [self initSubviews];
        
        [self showWithAnimation:YES];
    }
    return self;
}


//这种初始化方法 - 显示currentIndex
- (id)initWithFrame:(CGRect)frame imageArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView showCurrentIndex:(BOOL)currentBool
{
    if (self = [super initWithFrame:frame]) {
        
        _imageArray = [[NSMutableArray alloc]init];
        [_imageArray addObjectsFromArray:aImageInformationArray];
        _originShowIndex = index;
        _currShowIndex = index;
        _originShowRect = originRect;
        _originGroupsFirstShow = groupsView;
        _isPresented = NO;
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        
        [self addGesture];
        
        [self initSubviews];
        
        [self showWithAnimation:YES];
        
        [self initCurrentIndexLabel];
        
        [self reloadCurrentIndexLabelData];
    }
    return self;
}

-(void)initCurrentIndexLabel
{
    _currentIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 -25, SCREEN_SAFE_HEIGHT - 45, 50, 20)];
    _currentIndexLabel.font = [UIFont systemFontOfSize:13];
    _currentIndexLabel.textColor = [UIColor whiteColor];
    _currentIndexLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_currentIndexLabel];
}

-(void)reloadCurrentIndexLabelData
{
    _currentIndexLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currShowIndex +1,_imageArray.count];
}


- (void)initSubviews{
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _background.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:_background];
    //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //_background.image = [[window snapshot] imageByBlurDark];
    
    
    _pageView = [[KIPageScrollView alloc] initWithFrame:self.bounds pageSpace:10];
    _pageView.delegate = self;
    [_pageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_pageView];
    [_pageView reloadData];
    [_pageView scrollToIndex:_originShowIndex animated:NO];
    
    
    
}


#pragma mark - show && dismiss

- (void)showWithAnimation:(BOOL)animation{
    if (!animation) {
        return;
    }
    
    
    CGRect rect = _originShowRect;
    if (_originGroupsFirstShow) {
        UIView *sourceView = _originGroupsFirstShow.subviews[self.currShowIndex];
        rect = [_originGroupsFirstShow convertRect:sourceView.frame toView:self];
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    tempView.clipsToBounds = YES;
    UIImage *defaultImage = [[_imageArray objectAtIndex:_currShowIndex] objectForKey:KIWindowImageView_PlaceHolderImage];
    if (!defaultImage) {
        NSDictionary *information = [_imageArray objectAtIndex:_currShowIndex];
        NSString *big_image_url = [information objectForKey:@"image_url"];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        NSString *imageKey = [[SDWebImageManager sharedManager]cacheKeyForURL:[NSURL URLWithString:big_image_url]];
        defaultImage = [imageCache imageFromCacheForKey:imageKey];
    }
    tempView.image = defaultImage;
    [self addSubview:tempView];
    
    CGRect targetTemp = self.bounds;
    
    tempView.frame = rect;
    _pageView.hidden = YES;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
        
        _background.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _pageView.hidden = NO;
        
        _isPresented = YES;
    }];
    
}

- (void)dismiss{
    _pageView.hidden = YES;
    _isPresented = NO;
    
    
    CGRect targetTemp = _originShowRect;
    
    
    //NSDictionary *information = [_imageArray objectAtIndex:_currShowIndex];
    UIImage *defaultImage = [self getCurrShowImage:_currShowIndex];
    if (!defaultImage) {
        defaultImage = [UIImage imageNamed:@"default640x640.png"];
    }
    
    
    CGFloat h = (self.bounds.size.width / defaultImage.size.width) * defaultImage.size.height;
    if (!defaultImage || h==0) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = defaultImage;
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.clipsToBounds = YES;
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    [self addSubview:tempView];
    tempView.center = self.center;
    
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        tempView.frame = targetTemp;
        
        _background.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (UIImage *)getCurrShowImage:(NSInteger)index{
    KIWindowImageItem *item = (KIWindowImageItem *)[_pageView cellForPage:index];
    
    if (item) {
        return item.imageView.image;
    }
    
    return nil;
}

#pragma mark - KIPageScrollViewDelegate

- (UIView*)pageView:(KIPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    KIWindowImageItem *itemView = (KIWindowImageItem*)[pageView dequeueReusableCell];
    
    if (!itemView) {
        itemView = [[KIWindowImageItem alloc] init];
        //itemView.delegate = self;
    }
    
    NSString *urlString = [[_imageArray objectAtIndex:pageIndex] objectForKey:KIWindowImageView_URL];
    if ([urlString length] <= 0) {
        urlString = [[_imageArray objectAtIndex:pageIndex] objectForKey:@"image_url"];
    }
    
    if (urlString.length <= 0) {
        urlString = [[_imageArray objectAtIndex:pageIndex] objectForKey:@"image_path"];
    }
    UIImage *defaultImage = [UIImage imageNamed:@"default640x640.png"];//[[_imageArray objectAtIndex:pageIndex] objectForKey:KIWindowImageView_PlaceHolderImage];
    
    [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
    
    return itemView;
}

- (NSInteger)numberOfPagesInPageView:(KIPageScrollView*)pageView{
    return [_imageArray count];
}

- (BOOL)pageViewCanRepeat:(KIPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KIPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    
    _currShowIndex = pageIndex;
    
    [self reloadCurrentIndexLabelData];

    
}


#pragma mark - 添加手势

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [self addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [self addGestureRecognizer:press];
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 7) {
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        [self addGestureRecognizer:pan];
//        _panGesture = pan;
    }
}


- (void)doubleTap:(UITapGestureRecognizer *)g {
    if (!_isPresented) return;
    KIWindowImageItem *tile = (KIWindowImageItem*)[_pageView cellForPage:_currShowIndex];
    if (tile) {
        if (tile.zoomScale > 1) {
            [tile setZoomScale:1 animated:YES];
        } else {
//            CGPoint touchPoint = [g locationInView:tile.imageView];
//            CGFloat newZoomScale = tile.maximumZoomScale;
//            CGFloat xsize = self.frame.size.width / newZoomScale;
//            CGFloat ysize = self.frame.size.height / newZoomScale;
//            [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
            
            CGFloat widthScale = tile.imageView.width / SCREEN_WIDTH;
            CGFloat heightScale = tile.imageView.height / SCREEN_HEIGHT;
            
            //注意：正常最大只能为1
            if (widthScale >= 1 && heightScale >= 1) {
                CGPoint touchPoint = [g locationInView:tile.imageView];
                CGFloat newZoomScale = tile.maximumZoomScale;
                CGFloat xsize = self.frame.size.width / newZoomScale;
                CGFloat ysize = self.frame.size.height / newZoomScale;
                [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
            }else{
                CGFloat zoomScale = (widthScale > heightScale) ? heightScale : widthScale;
                
                CGPoint touchPoint = [g locationInView:tile.imageView];
                CGFloat newZoomScale = 1/zoomScale; //当相对小的方向，刚好充满屏幕的scale
                CGFloat xsize = self.frame.size.width / newZoomScale;
                CGFloat ysize = self.frame.size.height / newZoomScale;
                [tile zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
            }
            
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    if (!_isPresented) return;
    
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    KIWindowImageItem *tile = (KIWindowImageItem*)[_pageView cellForPage:_currShowIndex];
    if (!tile.imageView.image) return;
    
    //if (isGIF) return;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到相册", nil];
    [sheet showInView:self];
}



- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _pageView.originY = deltaY;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _background.alpha = alpha;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                //[self cancelAllImageLoad];
                
                _isPresented = NO;
                //[[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? CGRectGetMaxY(_pageView.frame) : self.height - _pageView.y) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    //                    _blurBackground.alpha = 0;
                    //                    _pager.alpha = 0;
                    _background.alpha = 0;
                    
                    if (moveToTop) {
                        CGRect rect = _pageView.frame;
                        rect.origin.y = 0 - rect.size.height;
                        _pageView.frame = rect;
                    } else {
                        
                        _pageView.originY = self.height;
                    }
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
                //                _background.image = _snapshotImage;
                //                [_background.layer addFadeAnimationWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    CGRect rect = _pageView.frame;
                    rect.origin.y = 0 - rect.size.height;
                    _pageView.frame = rect;
                    //                    _blurBackground.alpha = 1;
                    //                    _pager.alpha = 1;
                    
                    _background.alpha = 1;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            
            CGRect rect = _pageView.frame;
            rect.origin.y = 0 - rect.size.height;
            _pageView.frame = rect;
            
            //_blurBackground.alpha = 1;
            
            _background.alpha = 1;
        }
        default:break;
    }
}


#pragma mark - 保存图片

//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {//保存到相册
        //NSLog(@"保存到相册");
        KIWindowImageItem *itemView = (KIWindowImageItem*)[_pageView cellForPage:_pageView.currentPageIndex];
        UIImageWriteToSavedPhotosAlbum(itemView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
    else{//取消
        //NSLog(@"取消");
    }
}

#if 1
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:KILocalization(@"保存成功")];
    }
    else{
        //[[TKAlertCenter defaultCenter] postAlertWithMessage:KILocalization(@"保存失败")];
    }
}
#endif


@end
