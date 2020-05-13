//
//  HMLocalCityManager.h
//  HuaxiajiaboApp
//
//  Created by Hugh on 1/26/15.
//  Copyright (c) 2015 peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMLocalCityManager : NSObject{
    NSDictionary *wholeDataDict;
    NSArray *wholeDataArr;
}



+(HMLocalCityManager *)shareManager;
-(NSArray *)getAllProvince;
-(NSArray *)getAllCityByProvinceId:(NSString *)pid;
-(NSArray *)getAllDistrictByProvinceId:(NSString *)pid cityId:(NSString *)cityId;
//-(NSArray *)getAllDistrictForDiary;

-(NSDictionary *)getProvinceByProvinceId:(NSString *)pid;
-(NSDictionary *)getCityByProvinceId:(NSString *)pid CityId:(NSString *)cid;
-(NSDictionary *)getDistrictByProvinceId:(NSString *)pid CityId:(NSString *)cid DistrictId:(NSString *)did;

-(NSDictionary *)getProvinceByProvinceName:(NSString *)pName;
-(NSDictionary *)getCityByCityName:(NSString *)cName;
-(NSDictionary *)getDistrictByDistrictName:(NSString *)dName;
-(NSDictionary *)getDistrictByDistrictIndex:(NSString *)index;


@end
