//
//  UIDevice+KIAdditions.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/20.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHFKeychainUtils.h"


#define HM_SERVER_NAME        @"com.51jiabo.hxjbh"
#define HM_UUID_KEY           @"com.51jiabo.hxjbh.uuid"


@interface UIDevice (KIAdditions)

+ (NSString *) deviceType;

+ (NSString *)getNetType;

char*  getMacAddress(char* macAddress, char* ifName);
+(NSString *)getMacAddress;

- (NSString *) uniqueDeviceIdentifier;




+ (long long)getTotalMemorySize;
+ (long long)getAvailableMemorySize;
+ (long long)getUsedMemorySize;


@end
