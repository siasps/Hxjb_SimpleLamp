//
//  HMFileCacheManager.m
//  Huaxiajiabo
//
//  Created by Huamo on 2018/1/16.
//  Copyright © 2018年 huamo. All rights reserved.
//

#import "HMFileCacheManager.h"

@implementation HMFileCacheManager


+ (NSString *)getRootCacheFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


+ (NSString *)tempImageFilePath:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempImagePath = [documentsDirectory stringByAppendingPathComponent:@"TempImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager contentsOfDirectoryAtPath:tempImagePath error:nil]){
        [fileManager createDirectoryAtPath:tempImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [tempImagePath stringByAppendingPathComponent:name];
}

@end
