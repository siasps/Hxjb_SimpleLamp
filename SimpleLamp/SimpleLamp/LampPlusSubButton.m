//
//  LampPlusSubButton.m
//  SimpleLamp
//
//  Created by 陈正文 on 2020/5/13.
//  Copyright © 2020 chen. All rights reserved.
//

#import "LampPlusSubButton.h"

@interface LampPlusSubButton () {
    CGFloat _buttonImageHeight;
}


@end


@implementation LampPlusSubButton

//+ (void)load {
//    //请在 `-[AppDelegate application:didFinishLaunchingWithOptions:]` 中进行注册，否则iOS10系统下存在Crash风险。
//    //[super registerPlusButton];
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

#pragma mark - CYLPlusButtonSubclassing Methods

/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
+ (id)plusButton {
    LampPlusSubButton *button = [[LampPlusSubButton alloc] init];
    UIImage *normalButtonImage = [UIImage imageNamed:@"home_normal"];
    UIImage *hlightButtonImage = [UIImage imageNamed:@"home_normal"];
    [button setImage:normalButtonImage forState:UIControlStateNormal];
    [button setImage:[hlightButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    [button setImage:[hlightButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [button setTintColor:  [UIColor colorWithRed:0/255.0f green:255/255.0f blue:189/255.0f alpha:1]];
    
    //    UIImage *normalButtonBackImage = [UIImage imageNamed:@"videoback"];
    //    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateNormal];
    //    [button setBackgroundImage:normalButtonBackImage forState:UIControlStateSelected];
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
    button.frame = CGRectMake(0.0, 0.0, 55, 55);
    
    // if you use `+plusChildViewController` , do not addTarget to plusButton.
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Event Response

- (void)clickPublish {
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    UIViewController *viewController = tabBarController.selectedViewController;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册选取", nil];
    [actionSheet showInView:viewController.view];
#pragma clang diagnostic pop

}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %@", @(buttonIndex));
}
#pragma clang diagnostic pop

//#pragma mark - CYLPlusButtonSubclassing
//
//+ (UIViewController *)plusChildViewController {
//    UIViewController *plusChildViewController = [[UIViewController alloc] init];
//    plusChildViewController.view.backgroundColor = [UIColor whiteColor];
//    plusChildViewController.navigationItem.title = @"PlusChildViewController";
//    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:plusChildViewController];
//    return plusChildNavigationController;
//}
//
//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 2;
//}
//
//+ (BOOL)shouldSelectPlusChildViewController {
//    BOOL isSelected = CYLExternPlusButton.selected;
//    if (isSelected) {
////        HDLLogDebug("🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is selected");
//    } else {
////        HDLLogDebug("🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is not selected");
//    }
//    return YES;
//}

+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    return  0.3;
}

+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    return (CYL_IS_IPHONE_X ? - 6 : 4);
}


@end
