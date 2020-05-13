//
//  UIButton+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-11-23.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import <UIKit/UIKit.h>

//button的image和title的相对对齐方式，这里以title为参照，设置image
typedef NS_ENUM(NSInteger, UIButtonImageAligmentMode) {
    UIButtonImageAligmentModeTop,  //上图片，下文字
    UIButtonImageAligmentModeLeft,
    UIButtonImageAligmentModeBottom,
    UIButtonImageAligmentModeRight
};


@interface UIButton (KIAdditions)

- (void)setImage:(UIImage *)normal
     highlighted:(UIImage *)highlighted
        disabled:(UIImage *)disabled
        selected:(UIImage *)selected;

- (void)setBackgroundImage:(UIImage *)normal
               highlighted:(UIImage *)highlighted
                  disabled:(UIImage *)disabled
                  selected:(UIImage *)selected;

- (void)setTitleColor:(UIColor *)normal
          highlighted:(UIColor *)highlighted
             disabled:(UIColor *)disabled
             selected:(UIColor *)selected;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state contentMode:(UIViewContentMode)contentMode;

/*设置image和title的对齐方式和间距
 padding：间距
 aligmentMode：对齐模式
 */
- (void)setContentPadding:(CGFloat)padding aligmentMode:(UIButtonImageAligmentMode)aligmentMode;

@end
