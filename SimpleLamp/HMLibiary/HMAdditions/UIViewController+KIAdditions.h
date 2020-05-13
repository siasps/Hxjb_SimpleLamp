//
//  UIViewController+KIViewController.h
//  Kitalker
//
//  Created by chen on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+KIAdditions.h"
#import "UIView+KIAdditions.h"

@interface UIViewController (KIAdditions)

- (void)showCustomBackButton;

- (void)showCustomBackButton:(SEL)selector;

- (void)setNavLeftItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH;
-(void)setNavLeftItem:(SEL)selector title:(NSString *)title color:(UIColor *)color;

- (void)setNavRightItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH;
- (void)setNavRightItem:(SEL)selector title:(NSString *)title color:(UIColor *)color;
- (void)setTitle:(NSString *)title;

- (void)setTitleColor:(UIColor *)color;



- (void)pushController:(UIViewController *)viewController;

- (void)pushController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popController;

- (void)dismissModalController;

- (void)close;


- (BOOL)findNavbarBottomLineUnder:(UIView *)view hide:(BOOL)hide;



@end
