//
//  KKPageControl.m
//  Assistant
//
//  Created by bearmac on 14-4-25.
//  Copyright (c) 2014年 beartech. All rights reserved.
//

#import "KKPageControl.h"


@interface KKPageControl (){
    
}
@property (nonatomic,retain)UIImage *image;
@property (nonatomic,retain)UIImage *currentImage;
@property (nonatomic,assign)BOOL isCreate;

@end

@implementation KKPageControl
@synthesize image = _image;
@synthesize currentImage = _currentImage;
@synthesize isCreate = _isCreate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isCreate = YES;
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        _isCreate = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image currentImage:(UIImage *)currentImage{
    self.image = image;
    self.currentImage = currentImage;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    if (!_image || !_currentImage) {
        return;
    }
    
    //修改图片和图标大小
    [self updateDots];
}

-(void) updateDots {
    
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImage *customDotImage = (i == self.currentPage) ? _image : _currentImage;
        UIView *dotView = [self.subviews objectAtIndex:i];
        dotView.frame = CGRectMake(dotView.frame.origin.x, dotView.frame.origin.y, customDotImage.size.width, customDotImage.size.height);
        if ([dotView isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)dotView).image = customDotImage;
        }
        else {
            dotView.backgroundColor = [UIColor colorWithPatternImage:customDotImage];
        }
    }
    
//    /* ios7以前可以使用这个方法 */
//    if (IS_IOS7) {
//        if (_image || _currentImage) {
//            NSArray *subview = self.subviews;
//            
//            if (_isCreate && [subview count] > 0) {
//                for (NSInteger i = 0; i < [subview count]; i++) {
//                    UIView *bgView = [subview objectAtIndex:i];
//                    for (UIView *view in bgView.subviews) {
//                        [view removeFromSuperview];
//                    }
//                    bgView.backgroundColor = [UIColor clearColor];
//                    UIImageView *image = [[UIImageView alloc]init];
//                    image.tag = 1000 + i;
//                    [bgView addSubview:image];
//                    [image release];
//                    
//                    if (i == self.currentPage){
//                        image.image = _currentImage;
//                        [self updateFrame:bgView image:_currentImage];
//                        image.frame = bgView.bounds;
//                    } else {
//                        image.image = _image;
//                        [self updateFrame:bgView image:_image];
//                        image.frame = bgView.bounds;
//                    }
//                }
//                _isCreate = NO;
//            }else{
//                for (NSInteger i = 0; i < [subview count]; i++) {
//                    UIView *bgView = [subview objectAtIndex:i];
//                    UIImageView *image = (UIImageView *)[bgView viewWithTag:1000 + i];
//                    if (i == self.currentPage){
//                        image.image = _currentImage;
//                        [self updateFrame:bgView image:_currentImage];
//                        image.frame = bgView.bounds;
//                    } else {
//                        image.image = _image;
//                        [self updateFrame:bgView image:_image];
//                        image.frame = bgView.bounds;
//                    };
//                }
//            }
//        }
//    }else{
//        for (int i = 0; i < [self.subviews count]; i++) {
//            UIImageView* imageview = [self.subviews objectAtIndex:i];
//            if (i == self.currentPage){
//                imageview.image = _currentImage;
//                [self updateFrame:imageview image:_currentImage];
//            } else {
//                imageview.image = _image;
//                [self updateFrame:imageview image:_image];
//            }
//        }
//
//    }
}

- (void)updateFrame:(UIView *)view image:(UIImage *)image{
    CGSize size = image.size;
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            15,
                            size.height);

}

@end
