//
//  UIViewController+KIViewController.m
//  Kitalker
//
//  Created by chen on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+KIAdditions.h"

@implementation UIViewController (KIAdditions)


#pragma mark - nav bar 设置

- (void)showCustomBackButton {
    [self showCustomBackButton:@selector(close)];
}

- (void)showCustomBackButton:(SEL)selector {
    [self setNavLeftItem:selector image:[UIImage imageNamed:@"backBtn.png"] imageH:nil];
    
}

- (void)setNavLeftItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH {
    
//    if (@available(iOS 11.0, *)) {
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:selector nomalImage:image higeLightedImage:imageH imageEdgeInsets:UIEdgeInsetsZero];
//    }else{
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setImage:image forState:UIControlStateNormal];
//        [backButton setImage:imageH forState:UIControlStateHighlighted];
//        [backButton setFrame:CGRectMake(0, 0, 50, 44)];
//        [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        
//        //设置leftBarButtonItem相对屏幕左边的位置
//        CGFloat screenScale = [[UIScreen mainScreen] scale];
//        CGFloat imageToButtonPadding = (50-image.size.width/screenScale)/2.0;
//        CGFloat leftBarPadding = 15; //默认的leftBarButtonItem到屏幕右边距离
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = -(imageToButtonPadding+leftBarPadding-15);
//        self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
//    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imageH forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 0, 50, 44)];
    backButton.backgroundColor = [UIColor lightGrayColor];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)setNavRightItem:(SEL)selector image:(UIImage *)image imageH:(UIImage *)imageH {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imageH forState:UIControlStateHighlighted];
    [backButton setFrame:CGRectMake(0, 7, 30, 50)];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
}
-(void)setNavLeftItem:(SEL)selector title:(NSString *)title color:(UIColor *)color
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    [backButton setTitleColor:color forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 7, 70, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)setNavRightItem:(SEL)selector title:(NSString *)title color:(UIColor *)color
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setTitle:title forState:UIControlStateHighlighted];
    [backButton setTitleColor:color forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(0, 7, 70, 30)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [backButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)setTitle:(NSString *)title {
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.navigationItem setTitleView:titleLabel];
        
        //注意：防止rightBarButtonItem为nil，title被挤到右屏幕边缘显示
        if (!self.navigationItem.rightBarButtonItem) {
            UIView *fixedSpaceView = [[UIView alloc]init];
            fixedSpaceView.frame = CGRectMake(0, 7, 20, 50);
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:fixedSpaceView];
            self.navigationItem.rightBarButtonItem = backItem;
        }
    }
    [titleLabel setTextColor:[UIColor colorWithHex:@"#ffffff"]];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    
    
}

- (void)setTitleColor:(UIColor *)color{
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        [self.navigationItem setTitleView:titleLabel];
    }
    [titleLabel setTextColor:color];
}


#pragma mark - controller 控制

- (void)pushController:(UIViewController *)viewController {
    [self pushController:viewController animated:YES];
}

- (void)pushController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self pushViewController:viewController animated:animated];
    } else if (self.navigationController != nil) {
        [self.navigationController pushViewController:viewController animated:animated];
    } else {
        if (viewController == self) {
            return ;
        }
        
        [viewController viewWillAppear:YES];
        [self.view pushView:viewController.view completion:^(BOOL finished) {
            [viewController viewDidAppear:YES];
        }];
    }
}

- (void)popController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        if ([self respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [(UINavigationController *)self popViewControllerAnimated:YES];
        }
    }
    if (self.navigationController != nil) {
        if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } else {
        [self viewWillDisappear:YES];
        [self.view popCompletion:^(BOOL finished) {
            [self viewDidDisappear:YES];
        }];
    }
}


- (void)dismissModalController {
    if (self.navigationController != nil) {
        if ([self.navigationController respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } else {
        if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}


- (void)close {
    [self dismissModalController];
    [self popController];
}


//找到navbar底部的黑色线条
- (BOOL)findNavbarBottomLineUnder:(UIView *)view hide:(BOOL)hide{
    UIView *line = [self findHairlineImageViewUnder:view];
    
    if (line) {
        line.hidden = hide;
        return YES;
    }
    
    return NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



@end
