//
//  KIWindowImageItem.m
//  Test
//
//  Created by Huamo on 16/6/22.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "KIWindowImageItem.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import "KIPageScrollView.h"


@interface KIWindowImageItem () <UIScrollViewDelegate> {
    
}

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;


@end



@implementation KIWindowImageItem


- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [UIScreen mainScreen].bounds;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [UIImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, 40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //_progressLayer.center = CGPointMake(self.layer.frame.size.width / 2, self.layer.frame.size.height / 2);
}


- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage{
    
//    [_imageView cancelCurrentImageRequest];
//    [_imageView.layer removePreviousFadeAnimation];
//
//    _progressLayer.hidden = NO;
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    _progressLayer.strokeEnd = 0;
//    _progressLayer.hidden = YES;
//    [CATransaction commit];
    
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:aImageURLString] placeholderImage:aPlaceholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            self.maximumZoomScale = 3;
            
            [self resizeSubviewSize];
        }
    }];
    
    self.maximumZoomScale = 3;
    
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    
    _imageContainerView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}





@end
