//
//  HMCityDataManager.m
//  Huaxiajiabo
//
//  Created by Huamo on 16/7/8.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMCityDataManager.h"

@implementation HMCityDataManager

static HMCityDataManager *shareCityDataManager = nil;


+ (HMCityDataManager *)shareCityDataManager {
    @synchronized(self) {
        if (shareCityDataManager == nil) {
            shareCityDataManager = [[HMCityDataManager alloc] init];
        }
        return shareCityDataManager;
    }
}


- (void)getCityDataFromNet {
    
    
    [HMDataRequest getRequestWithUrl:Server_config_getRegionList withParams:nil withCacheTime:24*8 showProgressInView:nil mustResrush:NO CallBack:^(id responseObject, id error) {
        if(error != nil){
            
        }else{
            if ([emptyString([responseObject valueForKeyPath:@"infoMap.flag"]) isEqualToString:@"1"]) {
                
                [responseObject writeToFile:[HMCityDataManager cityPath] atomically:YES];
            }
        }
        
    }];
}


+ (NSString *)cityPath {
    
    NSError *e;
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *groupFilePath = [docDir stringByAppendingPathComponent:City_data_cache];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath: groupFilePath isDirectory: &isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath: groupFilePath withIntermediateDirectories:YES attributes:nil error: &e];
    }
    
    
    return [[docDir stringByAppendingPathComponent:City_data_cache] stringByAppendingPathComponent: @"citylist"];
    
}




- (NSArray *)getCityList{
    NSString *cpath = [HMCityDataManager cityPath];
    NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:cpath];
    
    if (!cityDict || cityDict.count <= 0) {
        [self getCityDataFromNet];
        
        return @[];
    }
    
    NSDictionary *infoMap = [cityDict valueObjectForKey:@"infoMap"];
    
    NSArray *allCityArray = [NSArray arrayWithArray:[infoMap objectForKey:@"regionList"]];
    
    if (!allCityArray || allCityArray.count <= 0) {
        [self getCityDataFromNet];
        
        return @[];
    }
    
    return allCityArray;
}



@end
