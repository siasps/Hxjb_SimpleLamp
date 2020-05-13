//
//  UIButton+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-11-23.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import "UIButton+KIAdditions.h"

@implementation UIButton (KIAdditions)


- (void)setImage:(UIImage *)normal
     highlighted:(UIImage *)highlighted
        disabled:(UIImage *)disabled
        selected:(UIImage *)selected {
    
    [self setImage:normal forState:UIControlStateNormal];
    if (highlighted != nil) {
        [self setImage:highlighted forState:UIControlStateHighlighted];
    }
    if (disabled != nil) {
        [self setImage:disabled forState:UIControlStateDisabled];
    }
    if (selected != nil) {
        [self setImage:selected forState:UIControlStateSelected];
    }
}

- (void)setBackgroundImage:(UIImage *)normal
               highlighted:(UIImage *)highlighted
                  disabled:(UIImage *)disabled
                  selected:(UIImage *)selected {
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    if (highlighted != nil) {
        [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    }
    if (disabled != nil) {
        [self setBackgroundImage:disabled forState:UIControlStateDisabled];
    }
    if (selected != nil) {
        [self setBackgroundImage:selected forState:UIControlStateSelected];
    }
}

- (void)setTitleColor:(UIColor *)normal
          highlighted:(UIColor *)highlighted
             disabled:(UIColor *)disabled
             selected:(UIColor *)selected {
    [self setTitleColor:normal forState:UIControlStateNormal];
    if (highlighted != nil) {
        [self setTitleColor:highlighted forState:UIControlStateHighlighted];
    }
    if (disabled != nil) {
        [self setTitleColor:disabled forState:UIControlStateDisabled];
    }
    if (selected != nil) {
        [self setTitleColor:selected forState:UIControlStateSelected];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:newImage forState:controlState];
    UIGraphicsEndImageContext();
    
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state contentMode:(UIViewContentMode)contentMode{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.contentMode = contentMode;
    imageView.image = image;
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, imageView.layer.contentsScale);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:newImage forState:state];
    UIGraphicsEndImageContext();
    
}

/*设置image和title的对齐方式和间距
 padding：间距
 aligmentMode：对齐模式
 */
- (void)setContentPadding:(CGFloat)padding aligmentMode:(UIButtonImageAligmentMode)aligmentMode{
    
    //垂直方向空白高度
    CGFloat spaceHeight = 0;
    CGPoint endImageViewCenter;
    CGPoint endTitleLabelCenter;
    
    if (aligmentMode == UIButtonImageAligmentModeTop) {
        //垂直方向空白高度
        spaceHeight = CGRectGetHeight(self.frame) - CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.titleLabel.frame);
        
        //偏移量
        CGFloat offestY = padding/2.0 - spaceHeight/2.0;
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        // 找出imageView最终的center
        endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds)-offestY);
        // 找出titleLabel最终的center
        endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.titleLabel.bounds) + offestY);
        
    }else if(aligmentMode == UIButtonImageAligmentModeLeft){
        //垂直方向空白高度
        spaceHeight = CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.titleLabel.frame);
        
        //偏移量
        CGFloat offestX = padding/2.0 - spaceHeight/2.0;
        
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        // 找出imageView最终的center
        endImageViewCenter = CGPointMake(CGRectGetMidX(self.imageView.bounds)-offestX, buttonBoundsCenter.y);
        // 找出titleLabel最终的center
        endTitleLabelCenter = CGPointMake(CGRectGetWidth(self.bounds)-CGRectGetMidX(self.titleLabel.bounds)+offestX, buttonBoundsCenter.y);
        
    }else if (aligmentMode == UIButtonImageAligmentModeBottom){
        
        //垂直方向空白高度
        spaceHeight = CGRectGetHeight(self.frame) - CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.titleLabel.frame);
        
        //偏移量
        CGFloat offestY = padding/2.0 - spaceHeight/2.0;
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        // 找出titleLabel最终的center
        endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.titleLabel.bounds)-offestY);
        // 找出imageView最终的center
        endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.imageView.bounds) + offestY);
        
    }else if (aligmentMode == UIButtonImageAligmentModeRight){
        
        
        //垂直方向空白高度
        spaceHeight = CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.titleLabel.frame);
        
        //偏移量
        CGFloat offestX = padding/2.0 - spaceHeight/2.0;
        
        
        CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        // 找出titleLabel最终的center
        endTitleLabelCenter = CGPointMake(CGRectGetMidX(self.titleLabel.bounds)-offestX, buttonBoundsCenter.y);
        // 找出imageView最终的center
        endImageViewCenter = CGPointMake(CGRectGetWidth(self.bounds)-CGRectGetMidX(self.imageView.bounds)+offestX, buttonBoundsCenter.y);
        
        
    }
    
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}



@end
