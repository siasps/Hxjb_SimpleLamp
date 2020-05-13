//
//  HMProvinceElementNode.m
//  HuaxiajiaboApp
//
//  Created by huamo on 14/12/29.
//  Copyright (c) 2014年 peng. All rights reserved.
//

#import "HMProvinceElementNode.h"

@implementation HMProvinceElementNode
+(NSMutableArray *)parseProvinceWithXMLEles:(NSArray *)eles
{
    if (![eles count]) {
        return nil;
    }
    
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:[eles count]];
    for (NSDictionary *provinc in eles) {
        HMProvinceElementNode *provinceAttr = [[HMProvinceElementNode alloc] init];
        provinceAttr.name = [provinc stringValueForKey:@"name"];
        provinceAttr.code = [provinc stringValueForKey:@"id"];
        //provinceAttr.index =[[[provinc attributeForName:@"index"] stringValue] integerValue];

        NSArray * cityEles=[provinc objectForKey:@"cityList"];
        provinceAttr.citys=[City parseCityWithXMLEles:cityEles];
        [array1 addObject:provinceAttr];
        
    }
    return array1;
}

+ (HMProvinceElementNode*)copyWityProvince:(HMProvinceElementNode*)province{
    HMProvinceElementNode *tempProvince = [HMProvinceElementNode new];
    
    tempProvince.name = province.name;
    tempProvince.code = province.code;
    tempProvince.citys = province.citys;
    
    //tempProvince.index = province.index;

    
    return tempProvince;
}

- (id)copyWithZone:(NSZone *)zone{
    HMProvinceElementNode *custom = [[HMProvinceElementNode  allocWithZone:zone]  init];
    
    return custom;
}


@end

@implementation City

+(NSMutableArray *)parseCityWithXMLEles:(NSArray *)eles
{
    if (![eles count]) {
        return nil;
    }
    
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:[eles count]];
    for (NSDictionary *city in eles) {
        City *cityAttr = [[City alloc] init];
        cityAttr.name =[city stringValueForKey:@"name"];
        cityAttr.code =[city stringValueForKey:@"id"];
        //cityAttr.index =[[[city attributeForName:@"index"] stringValue] integerValue];

        NSArray * cityEles=[city objectForKey:@"districtList"];
        cityAttr.areas=[Area parseAreaWithXMLEles:cityEles];
        [array2 addObject:cityAttr];
    }
    return array2;
}

+ (City*)copyWityCity:(City*)city{
    City *tempCity = [City new];
    
    tempCity.name = city.name;
    tempCity.code = city.code;
    tempCity.areas = city.areas;
    //    tempCity.index = city.index;

    return tempCity;
}
- (id)copyWithZone:(NSZone *)zone{
    
    City *custom = [[[self class]  allocWithZone:zone]  init];
    
    return custom;
}
@end

@implementation Area

+(NSMutableArray *)parseAreaWithXMLEles:(NSArray *)eles
{
    if (![eles count]) {
        return nil;
    }
    NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:[eles count]];
    for (NSDictionary *area in eles) {
        Area *areaAttr = [[Area alloc] init];
        areaAttr.name =[area stringValueForKey:@"name"];
        areaAttr.code =[area stringValueForKey:@"id"];
        //        areaAttr.index =[[[area attributeForName:@"id"] stringValue] integerValue];

        [array3 addObject:areaAttr];
    }
    return array3;
    
}

+ (Area*)copyWityArea:(Area*)area{
    Area *tempArea = [Area new];
    
    tempArea.name = area.name;
    //tempArea.index = area.index;
    tempArea.code = area.code;
    
    return tempArea;
}
- (id)copyWithZone:(NSZone *)zone{
    
    Area *custom = [[[self class]  allocWithZone:zone]  init];
    
    return custom;
}

@end







