//
//  NSBundle+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-10-25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+KIAdditions.h"


@interface NSBundle (KIAdditions)

+ (NSString *)appHomeDirectory;

+ (NSString *)documentDirectory;

+ (NSString *)libraryDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)tempDirectory;


/*Bundle相关*/
+ (NSString *)bundleIdentifier;

+ (NSString *)bundleName;

+ (NSString *)bundleBuildVersion;

+ (NSString *)bundleShortVersion;

+ (float)bundleMiniumOSVersion;

+ (NSString *)bundlePath;


/*检查新版本  开始*/
+ (void)checkVersionWithAppleID:(NSString *)appleID showNewestMsg:(BOOL)showMsg;


@end
