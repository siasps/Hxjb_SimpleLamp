//
//  HMLocalCityManager.m
//  HuaxiajiaboApp
//
//  Created by Hugh on 1/26/15.
//  Copyright (c) 2015 peng. All rights reserved.
//

#import "HMLocalCityManager.h"
#import "HMProvinceElementNode.h"


static HMLocalCityManager *shareManager = nil;
@implementation HMLocalCityManager


-(id)init
{
    if(self = [super init])
    {
        NSString * dicString=[[NSBundle mainBundle] pathForResource:@"addressDic" ofType:nil];
        wholeDataDict=[[NSDictionary alloc] initWithContentsOfFile:dicString];
        
    }
    return self;
}
+(HMLocalCityManager *)shareManager
{
    @synchronized(self) {
        if (shareManager == nil) {
            shareManager = [[HMLocalCityManager alloc] init];
        }
        return shareManager;
    }
}

-(NSArray *)getAllProvince
{
    NSMutableArray *provinceArr = [NSMutableArray array];
    for(id k in [wholeDataDict allKeys])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSDictionary *d = [wholeDataDict objectForKey:k];
        [dict setObject:[k description] forKey:@"id"];
        [dict setObject:[d objectForKey:@"name"] forKey:@"name"];
        [dict setObject:[d objectForKey:@"code"] forKey:@"code"];
        [provinceArr addObject:dict];
    }
    return provinceArr;
}

- (NSArray *)getAllCity{
    NSMutableArray *cityArr = [NSMutableArray array];
    
    NSArray *proArr = [self getAllProvince];
    for (NSDictionary *proD in proArr) {
        NSArray *cityA = [self getAllCityByProvinceId:[proD stringValueForKey:@"id"]];
        
        [cityArr addObject:cityA];
    }
    return cityArr;
}

//-(NSArray *)getAllDistrictForDiary{
//    
//    //NSString *cityId = emptyString([[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SELECTED_CITY_CODE]);
//    
//    NSString *cityId = @"";
//    NSDictionary *cityDic = [[HMCityDataManager shareCityDataManager] cityListByAlphabetic];
//    NSDictionary *cityDict = [[NSMutableDictionary alloc] initWithDictionary:[cityDic objectForKey:@"cityName"]];
//    
//    NSString *city_id = @"107"; //默认为上海
//    for (NSString *name in [cityDict allKeys]) {
//        NSArray *nameArray = [cityDict valueObjectForKey:name];
//        
//        for (NSDictionary *cityD in nameArray) {
//            if ([[cityD stringValueForKey:@"city_id"] isEqualToString:cityId]) {
//                city_id = [cityD stringValueForKey:@"region_id"];
//            }
//        }
//    }
//    
//    
//    
//    
//    NSMutableArray *dataArray = @[].mutableCopy;
//    
//    NSDictionary *proDict = [wholeDataDict objectForKey:city_id];
//    
//    //说明是直辖市
//    if (proDict) {
//        for (NSString *cityKey in [proDict allKeys]) {
//            if (![cityKey isEqualToString:@"code"] &&
//                ![cityKey isEqualToString:@"index"] &&
//                ![cityKey isEqualToString:@"name"] ){
//                
//                NSDictionary *cityDict = [proDict objectForKey:cityKey];
//                
//                for (NSString *disKey in [cityDict allKeys]){
//                    if (![disKey isEqualToString:@"code"] &&
//                        ![disKey isEqualToString:@"index"] &&
//                        ![disKey isEqualToString:@"name"] ){
//                        
//                        NSDictionary *disDict = [cityDict objectForKey:disKey];
//                        
//                        [dataArray addObject:disDict];
//                    }
//                }
//            }
//        }
//    }else{
//        for (NSString *proKey in [wholeDataDict allKeys]) {
//            NSDictionary *proDict = [wholeDataDict objectForKey:proKey];
//            
//            for (NSString *cityKey in [proDict allKeys]) {
//                if ([cityKey isEqualToString:cityId]) {
//                    NSDictionary *cityDict = [proDict objectForKey:cityKey];
//                    
//                    for (NSString *disKey in [cityDict allKeys]){
//                        if (![disKey isEqualToString:@"code"] &&
//                            ![disKey isEqualToString:@"index"] &&
//                            ![disKey isEqualToString:@"name"] ) {
//                            
//                            NSDictionary *disDict = [cityDict objectForKey:disKey];
//                            
//                            [dataArray addObject:disDict];
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    
//    return dataArray;
//}



-(NSArray *)getAllCityByProvinceId:(NSString *)pid
{
    NSMutableArray *cityArr = [NSMutableArray array];
    NSDictionary *cityDict = [wholeDataDict objectForKey:pid];
    for (id k in [cityDict allKeys]) {
        
        if(![[k description] isEqualToString:@"name"] && [[k description] isEqualToString:@"code"])
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSDictionary *cd = [cityDict objectForKey:k];
            [dict setObject:[k description] forKey:@"id"];
            [dict setObject:[cd objectForKey:@"code"] forKey:@"code"];
            [dict setObject:[cd objectForKey:@"name"] forKey:@"name"];
            [cityArr addObject:dict];
        }
    }
    return cityArr;
}

-(NSArray *)getAllDistrictByProvinceId:(NSString *)pid cityId:(NSString *)cityId
{
    NSMutableArray *districtArr = [NSMutableArray array];
    NSDictionary *cityDict = [wholeDataDict objectForKey:pid];
    for (id k in [cityDict allKeys]) {
        if ([[k description] isEqualToString:cityId]) {
            
            NSDictionary *disDict = [cityDict objectForKey:k];
            for (id d in [disDict allKeys]) {
                if(![[d description] isEqualToString:@"name"]
                   && ![[d description] isEqualToString:@"code"]
                   && ![[d description] isEqualToString:@"index"])
                {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    NSDictionary *cdd = [disDict objectForKey:d];
                    [dict setObject:[cdd objectForKey:@"index"] forKey:@"id"];
                    [dict setObject:[cdd objectForKey:@"code"] forKey:@"code"];
                    [dict setObject:[cdd objectForKey:@"name"] forKey:@"name"];
                    [districtArr addObject:dict];
                }
            }
        }
    }
    return districtArr;
}

-(NSDictionary *)getProvinceByProvinceId:(NSString *)pid
{
    NSDictionary *dict = [wholeDataDict objectForKey:pid];
    //    NSString *proName = [dict objectForKey:@"name"];
    return dict;
}

-(NSDictionary *)getCityByProvinceId:(NSString *)pid CityId:(NSString *)cid
{
    NSDictionary *proDict = [wholeDataDict objectForKey:pid];
    NSDictionary *cityDict = [proDict objectForKey:cid];
    return cityDict;
}

-(NSDictionary *)getDistrictByProvinceId:(NSString *)pid CityId:(NSString *)cid DistrictId:(NSString *)did
{
    NSDictionary *proDict = [wholeDataDict objectForKey:pid];
    NSDictionary *cityDict = [proDict objectForKey:cid];
    NSDictionary *districtDict = [cityDict objectForKey:did];
    return districtDict;
}

-(NSDictionary *)getProvinceByProvinceName:(NSString *)pName{
    NSArray *allProId = [wholeDataDict allKeys];
    for (NSString *proID in allProId) {
        NSDictionary *dict = [wholeDataDict objectForKey:proID];
        NSString *name = [dict stringValueForKey:@"name"];
        
        if ([name containsString:pName]) {
            return dict;
        }
    }
    
    
    return nil;
}

-(NSDictionary *)getCityByCityName:(NSString *)cName
{
    
    return nil;
}

-(NSDictionary *)getDistrictByDistrictName:(NSString *)dName
{
    NSArray *allProId = [wholeDataDict allKeys];
    for (NSString *proID in allProId) {
        NSDictionary *dict = [wholeDataDict objectForKey:proID];
        
        NSArray *allDisID = [dict allKeys];
        for (NSString *disID in allDisID) {
            NSDictionary *disDict = [dict objectForKey:disID];
            if ([disDict isKindOfClass:[NSDictionary class]]) {
                NSString *name = [disDict stringValueForKey:@"name"];
                
                if ([name containsString:dName]) {
                    return disDict;
                }
            }
            
        }
        
        
    }
    
    return nil;
}

-(NSDictionary *)getDistrictByDistrictIndex:(NSString *)index
{
    NSArray *allProId = [wholeDataDict allKeys];
    for (NSString *proID in allProId) {
        NSDictionary *dict = [wholeDataDict objectForKey:proID];
        
        NSArray *allDisID = [dict allKeys];
        for (NSString *disID in allDisID) {
            NSDictionary *disDict = [dict objectForKey:disID];
            if ([disDict isKindOfClass:[NSDictionary class]]) {
                NSString *tempindex = [disDict stringValueForKey:@"index"];
                if ([tempindex isEqualToString:index]) {
                    return disDict;
                }
            }
            
        }
        
        
    }
    
    return nil;
}







@end
