//
//  HMHttpCacheDBManager.m
//  Panda
//
//  Created by Huamo on 2018/8/27.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "HMHttpCacheDBManager.h"


@implementation HMHttpCacheDBManager

+ (FMDatabase *)defaultDatabase{
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realDBPath = [docDir stringByAppendingPathComponent:@"fmdb.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:realDBPath];
    
    return db;
}

+ (void)setupDatabase{
    [self copyDB];
    
    [FMDatabase databaseUpdate];
}

+ (void)copyDB
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *realDBPath = [docDir stringByAppendingPathComponent:@"fmdb.db"];
    NSError *err;
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *docFilePath = [docPath stringByAppendingPathComponent:@"fmdb.db"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:realDBPath])
    {
        
        if([[NSFileManager defaultManager] fileExistsAtPath:docFilePath])
        {
            [[NSFileManager defaultManager] copyItemAtPath:docFilePath toPath:realDBPath error:&err];
        }
        else {
            
            NSString *resourctPath = [[NSBundle mainBundle]pathForResource:@"fmdb.db" ofType:@""];
            if (resourctPath && resourctPath.length > 0) {
                [[NSFileManager defaultManager] copyItemAtPath:resourctPath toPath:realDBPath error:&err];
            }
        }
    }
}

@end
