//
//  AppDelegate.m
//  SimpleLamp
//
//  Created by chen on 2020/5/10.
//  Copyright © 2020 chen. All rights reserved.
//

#import "AppDelegate.h"
#import "LampTabBarViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self initRootViewController];
    
    
    [self.window makeKeyAndVisible];
    
    
    
    
    return YES;
}

- (void)initRootViewController{
    LampTabBarViewController *tabbarController = [[LampTabBarViewController alloc]init];
    self.window.rootViewController = tabbarController;
    
}






@end
