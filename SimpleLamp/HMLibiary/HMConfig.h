//
//  HMConfig.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/16.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#ifndef HuaxiajiaboApp_HMConfig_h
#define HuaxiajiaboApp_HMConfig_h



#import "KIAdditions.h"

#import "HMViewController.h"


#import <SDWebImage/SDWebImage.h>
#import <MJRefresh/MJRefresh.h>
#import "MBProgressHUD.h"

#import "UtilsMacro.h"
#import "VendorMacro.h"
#import "HMDataRequestURL.h"
#import "NIFLog.h"
#import "HMDataRequest.h"
#import "HMAuthorizeToken.h"
#import "HMLocationManager.h"

//#import "KMNavigationBarTransition.h"


#define RGB_COLOR_String(string)  [UIColor colorWithHexString:string]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




//屏幕尺寸获取
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#define SCREEN_SCALE            (SCREEN_WIDTH/375.0f)

#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
#define KeyWindow  [[[UIApplication sharedApplication] delegate] window]

#define SCREEN_STATUS_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCREEN_TOP_HEIGHT       (44.0f + SCREEN_STATUS_HEIGHT)
#define SCREEN_BOTTOM_HEIGHT    (VIEWSAFEAREAINSETS(KeyWindow).bottom)
#define SCREEN_SAFE_HEIGHT      (SCREEN_HEIGHT - SCREEN_TOP_HEIGHT - SCREEN_BOTTOM_HEIGHT)
#define SCREEN_TABBAR_HEIGHT     (49.0f)


#define KIImageMaxSize     ([UIDevice getTotalMemorySize]/1024.0f *1000.0f*1000.0f * 2)   //图片最大size:M

/*判断设备类型*/
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



/* Dump 一个 Rect 结构 */
#define CGRectDump(rect)  NSLog(@"%s = CGRectMake(%f, %f, %f, %f) ", ""#rect"", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)





#endif
