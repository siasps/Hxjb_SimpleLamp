//
//  LampTabBarViewController.m
//  SimpleLamp
//
//  Created by chen on 2020/5/12.
//  Copyright © 2020 chen. All rights reserved.
//

#import "LampTabBarViewController.h"
#import "HMHomeViewController.h"
#import "HMHouseViewController.h"
#import "HMMessageViewController.h"
#import "HMMineViewController.h"
#import "LampPlusSubButton.h"


static CGFloat const CYLTabBarControllerHeight = 40.f;
#define RANDOM_COLOR [UIColor colorWithHue: (arc4random() % 256 / 256.0) saturation:((arc4random()% 128 / 256.0 ) + 0.5) brightness:(( arc4random() % 128 / 256.0 ) + 0.5) alpha:1]


@interface LampTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation LampTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[UITabBar appearance] setTranslucent:NO];
//    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"#738299FF"];
//    if (@available(iOS 10.0, *)) {
//        self.tabBarController.tabBar.unselectedItemTintColor = [UIColor greenColor];
//    } else {
//
//    }
//    self.tabBar.tintColor = [UIColor whiteColor];
//    self.delegate = self;
//    self.tabBar.clipsToBounds = NO;

    [LampPlusSubButton registerPlusButton];
}
//
//- (void)addControllers{
//    HMHomeViewController *homeController = [[HMHomeViewController alloc] init];
//    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
//    homeNavigationController.title = @"首页";
//
//    HMHouseViewController *houseController = [[HMHouseViewController alloc] init];
//    UINavigationController *houseNavigationController = [[UINavigationController alloc] initWithRootViewController:houseController];
//    homeNavigationController.title = @"全屋记";
//
//    HMMessageViewController *messageController = [[HMMessageViewController alloc] init];
//    UINavigationController *messageNavigationController = [[UINavigationController alloc] initWithRootViewController:messageController];
//    homeNavigationController.title = @"消息";
//
//    HMMineViewController *mineController = [[HMMineViewController alloc] init];
//    UINavigationController *mineNavigationController = [[UINavigationController alloc] initWithRootViewController:mineController];
//    homeNavigationController.title = @"我的";
//
//
//    NSArray *viewControllers = @[homeNavigationController,
//                                houseNavigationController,
//                                messageNavigationController,
//                                mineNavigationController
//                                ];
//
//    self.viewControllers = viewControllers;
//}


- (instancetype)init {
    
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等 效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    if (self = [super initWithViewControllers:[self viewControllersForTabBar]
                        tabBarItemsAttributes:[self tabBarItemsAttributesForTabBar]
                                  imageInsets:imageInsets
                      titlePositionAdjustment:titlePositionAdjustment
                                      context:NULL
                ]) {
        [self customizeTabBarAppearance];
        self.delegate = self;
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (NSArray *)viewControllersForTabBar {
   HMHomeViewController *homeController = [[HMHomeViewController alloc] init];
   UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeController];

    HMHouseViewController *houseController = [[HMHouseViewController alloc] init];
    UINavigationController *houseNavigationController = [[UINavigationController alloc] initWithRootViewController:houseController];

    HMMessageViewController *messageController = [[HMMessageViewController alloc] init];
    UINavigationController *messageNavigationController = [[UINavigationController alloc] initWithRootViewController:messageController];

    HMMineViewController *mineController = [[HMMineViewController alloc] init];
    UINavigationController *mineNavigationController = [[UINavigationController alloc] initWithRootViewController:mineController];

    
   NSArray *viewControllers = @[homeNavigationController,
                                houseNavigationController,
                                messageNavigationController,
                                mineNavigationController
                                ];
   return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForTabBar {
    // lottie动画的json文件来自于NorthSea, respect!
    CGFloat firstXOffset = -12/2;
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : [UIImage imageNamed:@"home_normal"],  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"home_highlight",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(firstXOffset, -3.5)]
                                                 };
    CGFloat secondXOffset = (-25+2)/2;
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"全屋记",
                                                  CYLTabBarItemImage : [UIImage imageNamed:@"fishpond_normal"],
                                                  CYLTabBarItemSelectedImage : @"fishpond_highlight",
                                                  CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(secondXOffset, -3.5)]
                                                  };
    
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"消息",
                                                 CYLTabBarItemImage : [UIImage imageNamed:@"message_normal"],
                                                 CYLTabBarItemSelectedImage : @"message_highlight",
                                                 CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(-secondXOffset, -3.5)]
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage :[UIImage imageNamed:@"account_normal"],
                                                  CYLTabBarItemSelectedImage : @"account_highlight",
                                                  CYLTabBarItemTitlePositionAdjustment: [NSValue valueWithUIOffset:UIOffsetMake(-firstXOffset, -3.5)]
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor cyl_systemGrayColor];
    //normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor cyl_labelColor];
    //selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];

    
    
    // NO.1，using Image note:recommended.推荐方式
    // set the bar shadow image
    // without shadow : use -[[CYLTabBarController hideTabBarShadowImageView] in CYLMainRootViewController.m
    if (@available(iOS 13.0, *)) {
        UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance  alloc] init];
        // set the text Attributes
        // 设置文字属性
        [inlineLayoutAppearance.normal setTitleTextAttributes:normalAttrs];
        [inlineLayoutAppearance.selected setTitleTextAttributes:selectedAttrs];
    
        UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
        standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
        standardAppearance.backgroundColor = [UIColor cyl_systemBackgroundColor];
        //shadowColor和shadowImage均可以自定义颜色, shadowColor默认高度为1, shadowImage可以自定义高度.
        standardAppearance.shadowColor = [UIColor cyl_systemGreenColor];
        // standardAppearance.shadowImage = [[self class] imageWithColor:[UIColor cyl_systemGreenColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)];
        self.tabBar.standardAppearance = standardAppearance;
    } else {
        // Override point for customization after application launch.
        // set the text Attributes
        // 设置文字属性
        UITabBarItem *tabBar = [UITabBarItem appearance];
        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
        
        // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
        [[UITabBar appearance] setShadowImage:[[self class] imageWithColor:[UIColor cyl_systemGreenColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    }
}



+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"");
}

//- (UIButton *)selectedCover {
//    if (_selectedCover) {
//        return _selectedCover;
//    }
//    UIButton *selectedCover = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *image = [UIImage imageNamed:@"home_select_cover"];
//    [selectedCover setImage:image forState:UIControlStateNormal];
//    selectedCover.frame = ({
//        CGRect frame = selectedCover.frame;
//        frame.size = CGSizeMake(image.size.width, image.size.height);
//        frame;
//    });
//    selectedCover.translatesAutoresizingMaskIntoConstraints = NO;
//    // selectedCover.userInteractionEnabled = false;
//    _selectedCover = selectedCover;
//    return _selectedCover;
//}
//
//- (void)setSelectedCoverShow:(BOOL)show {
//    UIControl *selectedTabButton = [self.viewControllers[0].tabBarItem cyl_tabButton];
//    [selectedTabButton cyl_replaceTabButtonWithNewView:self.selectedCover
//                                                  show:show];
//    if (show) {
//        [self addOnceScaleAnimationOnView:self.selectedCover];
//    }
//}

//缩放动画
- (void)addOnceScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@0.5, @1.0];
    animation.duration = 0.1;
    //    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection  {
    [super traitCollectionDidChange:previousTraitCollection];
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
#if __has_include(<UIKit/UIScene.h>)
        UIUserInterfaceStyle currentUserInterfaceStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
        if (currentUserInterfaceStyle == previousTraitCollection.userInterfaceStyle) {
            return;
        }
#else
#endif
        //TODO:
        [[UIViewController cyl_topmostViewController].navigationController.navigationBar setBarTintColor:[UIColor cyl_systemBackgroundColor]];
    }
    #endif
    
}


#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    BOOL should = YES;
    [self updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController shouldSelect:should];
    UIControl *selectedTabButton = [viewController.tabBarItem cyl_tabButton];
    if (selectedTabButton.selected) {
        @try {
            [[[self class] cyl_topmostViewController] performSelector:@selector(refresh)];
        } @catch (NSException *exception) {
            NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
        }
    }
    return should;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    //    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：control : %@ ,tabBarChildViewControllerIndex: %@, tabBarItemVisibleIndex : %@", @(__PRETTY_FUNCTION__), @(__LINE__), control, @(control.cyl_tabBarChildViewControllerIndex), @(control.cyl_tabBarItemVisibleIndex));
    if ([control cyl_isTabButton]) {
        //更改红标状态
        if ([self.selectedViewController cyl_isShowBadge]) {
            [self.selectedViewController cyl_clearBadge];
        } else {
            [self.selectedViewController cyl_showBadge];
        }
        animationView = [control cyl_tabImageView];
    }
    
    UIButton *button = CYLExternPlusButton;
    BOOL isPlusButton = [control cyl_isPlusButton];
    // 即使 PlusButton 也添加了点击事件，点击 PlusButton 后也会触发该代理方法。
    if (isPlusButton) {
        animationView = button.imageView;
    }
    
    //[self addScaleAnimationOnView:animationView repeatCount:1];
    
    
    //添加仿淘宝tabbar，第一个tab选中后有图标覆盖
    if ([control cyl_isTabButton]|| [control cyl_isPlusButton]) {
        //        BOOL shouldSelectedCoverShow = (self.selectedIndex == 0);
        //        [self setSelectedCoverShow:shouldSelectedCoverShow];
    }
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}






@end
