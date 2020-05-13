//
//  HMHttpRequestHeader.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/20.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import "HMHttpRequestHeader.h"


@implementation HMHttpRequestHeader


+(NSDictionary *)getHeader
{
    NSString *mid = @"";//[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SELECTED_CITY_CODE];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:HMUSER_ID];
    NSString *macAddr = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_MACADDRESS];
    NSString *dynimicCode = [[NSUserDefaults standardUserDefaults]objectForKey:HMUSER_DYNAMIC_CODE];
    NSString *gps_mapid = @"";//[HMLocationManager sharedLocationManager].cityCode;
    gps_mapid = @"";//emptyString([[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SELECTED_CITY_CODE]);
    if(macAddr == nil || macAddr.length == 0)
    {
        macAddr = [UIDevice getMacAddress];
        [[NSUserDefaults standardUserDefaults]setObject:macAddr forKey:USERDEFAULT_MACADDRESS];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    NSString *netType = [UIDevice getNetType];
    NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                             CURRENT_APP_DOT_VERSION, @"version",
                             @"zh-CN", @"Accept-Language",
                             [self getAppID], @"APPID",
                             DEVICE_ID, @"primarykey",
                             (gps_mapid==nil?@"":gps_mapid), @"gps_mapid",
                             emptyString(mid), @"mid",
                             emptyString(userid), @"userid",
                             macAddr, @"macaddr",
                             netType,@"nettype",
                             [UIDevice deviceType],@"devicetype",
                             emptyString(dynimicCode),@"dynamic_code", nil];
    
//    [dic setObject:[NSString stringWithFormat:@"%f",[HMLocationManager sharedLocationManager].tmpLatitude] forKey:@"lat"];
//    [dic setObject:[NSString stringWithFormat:@"%f",[HMLocationManager sharedLocationManager].tmpLongitude] forKey:@"lon"];
    
    //NIF_TRACE(@"%@",dic);
    return dic;
    
}



+ (NSString *)getAppID
{
    
//    NSString *appId = [[NSUserDefaults standardUserDefaults] stringForKey:@"APPID"];
//    if(appId != nil || [appId length]>0)
//        return appId;
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *appIDStr = @"";
    
    NSArray *lines = [device.systemVersion componentsSeparatedByString:@"."];
    
    NSString *firstNum;
    NSString *secondNum;
    
    if ([lines count] == 2) {
        if ([[lines objectAtIndex:0] intValue] < 10) {
            firstNum = [NSString stringWithFormat:@"0%@", [lines objectAtIndex:0]];
        } else {
            firstNum = [lines objectAtIndex:0];
        }
        
        secondNum = [NSString stringWithFormat:@"%@0",[lines objectAtIndex:1]];
        
        
    } else if ([lines count] == 3) {
        if ([[lines objectAtIndex:0] intValue] < 10) {
            firstNum = [NSString stringWithFormat:@"0%@", [lines objectAtIndex:0]];
        } else {
            firstNum = [lines objectAtIndex:0];
        }
        
        secondNum = [NSString stringWithFormat:@"%@%@", [lines objectAtIndex:1], [lines objectAtIndex:2]];
    } else {
        firstNum = @"00";
        secondNum = @"00";
    }
    appIDStr = [NSString stringWithFormat:@"I%@%@%@%@%@", firstNum, secondNum,CURRENT_APP_TYPE,CURRENT_APP_VERSION,DISTRIBUTION_CHANNAL];
    [[NSUserDefaults standardUserDefaults] setValue:appIDStr forKey:@"APPID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return appIDStr;
    
}


@end
