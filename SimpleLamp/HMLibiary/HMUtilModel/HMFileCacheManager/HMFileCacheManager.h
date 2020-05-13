//
//  HMFileCacheManager.h
//  Huaxiajiabo
//
//  Created by Huamo on 2018/1/16.
//  Copyright © 2018年 huamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMFileCacheManager : NSObject


+ (NSString *)getRootCacheFile;

+ (NSString *)tempImageFilePath:(NSString *)name;


@end
