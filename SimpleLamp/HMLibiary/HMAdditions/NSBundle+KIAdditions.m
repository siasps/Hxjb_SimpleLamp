//
//  NSBundle+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-10-25.
//
//

#import "NSBundle+KIAdditions.h"

@implementation NSBundle (KIAdditions)


+ (NSString *)appHomeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)tempDirectory {
    return NSTemporaryDirectory();
}


/*Bundle相关*/
+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleShortVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (float)bundleMiniumOSVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] floatValue];
}

+ (NSString *)bundlePath {
    return [[NSBundle mainBundle] bundlePath];
}


/*检查新版本  开始
+ (void)checkVersionWithAppleID:(NSString *)appleID showNewestMsg:(BOOL)showMsg {
    NSString *urlPath = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appleID];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 && !error ) {
            NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *result = nil;
            if ([appInfo valueForKey:@"results"]) {
                NSArray *arrary = [appInfo valueForKey:@"results"];
                if (arrary && [arrary count]>0) {
                    result = [arrary objectAtIndex:0];
                }
            }
            
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *versionsInAppStore = [result valueForKey:@"version"];
                    if (versionsInAppStore) {
                        if ([[NSBundle bundleShortVersion] compare:versionsInAppStore options:NSNumericSearch] == NSOrderedAscending) {
                            [NSBundle showAlertWithAppStoreVersion:versionsInAppStore
                                                           appleID:appleID
                                                       description:[result valueForKey:@"description"]
                                                        updateInfo:[result valueForKey:@"releaseNotes"]];
                        }
                        else {
                            if (showMsg) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                    message:@"当前应用已为最新版本。"
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"好的"
                                                                          otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                    } else {
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (showMsg) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"当前应用已为最新版本。"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"好的"
                                                                  otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                });
                
            }
        }
    }];
}

+ (void)showAlertWithAppStoreVersion:(NSString *)appStoreVersion appleID:(NSString *)appleID description:(NSString *)description updateInfo:(NSString *)updateInfo {
    NSString *message = [NSString stringWithFormat:@"内容介绍:\n%@\n\n更新内容:\n%@", description, updateInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"当前应用有新版本(%@)可以下载，是否前往更新？", appStoreVersion]
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新", nil];
    [alertView setUserInfo:appleID];
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
        case 0:{
        } break;
        case 1:{
            NSString *urlPath = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", alertView.userInfo];
            NSURL *url = [NSURL URLWithString:urlPath];
            [[UIApplication sharedApplication] openURL:url];
        } break;
        default:
            break;
    }
}
检查新版本  结束*/


@end
