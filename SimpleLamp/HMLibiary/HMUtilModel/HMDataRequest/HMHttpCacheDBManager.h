//
//  HMHttpCacheDBManager.h
//  Panda
//
//  Created by Huamo on 2018/8/27.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface HMHttpCacheDBManager : NSObject

+ (FMDatabase *)defaultDatabase;

+ (void)setupDatabase;


@end
