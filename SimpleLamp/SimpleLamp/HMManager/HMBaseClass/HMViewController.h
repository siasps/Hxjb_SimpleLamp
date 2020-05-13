//
//  HMViewController.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/20.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMViewControllerDelegate;

@interface HMViewController : UIViewController <UIGestureRecognizerDelegate> {
    __weak id<HMViewControllerDelegate> _viewControllerDelegate;
}
@property (nonatomic,weak) id<HMViewControllerDelegate> viewControllerDelegate;



- (void)closeNavigationBarTranslucent;

//系统返回手势改装
- (void)enableFullScreenPopGesture:(BOOL)enable;

@end




@protocol HMViewControllerDelegate <NSObject>

@optional
- (void)viewController:(HMViewController *)viewController key:(NSString *)key infomation:(id)infomation;

@end




@interface UIViewController (HM)

- (void)showEmptyView;
- (void)showEmptyViewWithMessage:(NSString *)message;
- (void)showEmptyViewWithMessage:(NSString *)message inView:(UIView *)inView;
- (void)hideEmptyViewInView:(UIView *)view;
- (void)hideEmptyView;


/**
 子类重写，无网络的处理
 重写这个方法：无网络时，弹出无网络页面，点击刷新数据
 不重写：不会弹出无网络页面
 */
- (BOOL)canShowNotNetView;
- (void)refrushWithNotNet;



@end
