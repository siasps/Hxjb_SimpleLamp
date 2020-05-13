
//
//  HMCityDataModel.m
//  PandaMerchant
//
//  Created by Huamo on 2019/1/5.
//  Copyright © 2019年 peng. All rights reserved.
//

#import "HMCityDataModel.h"

@implementation HMProvinceModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name":@"label",
             @"code": @"key",
             @"citys": @"children"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"citys" : [HMCityModel class]};
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    HMProvinceModel *custom = [[HMProvinceModel  allocWithZone:zone]  init];
    
    custom.name = self.name;
    custom.code = self.code;
    custom.pid = self.pid;
    custom.citys = self.citys;
    
    return custom;
}


@end



@implementation HMCityModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name" : @"label",
             @"code": @"key",
             @"areas": @"children"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"areas" : [HMAreaModel class]};
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    HMCityModel *custom = [[HMCityModel  allocWithZone:zone]  init];
    
    custom.name = self.name;
    custom.code = self.code;
    custom.pid = self.pid;
    custom.areas = self.areas;
    
    return custom;
}


@end



@implementation HMAreaModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name":@"label",
             @"code": @"key"
             };
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    HMCityModel *custom = [[HMCityModel  allocWithZone:zone]  init];
    
    custom.name = self.name;
    custom.code = self.code;
    custom.pid = self.pid;
    
    return custom;
}


@end



@implementation NSArray (yyCityModel_array)

- (NSArray *)yy_modelDataForArray {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *dict in self) {
        HMProvinceModel *model = [HMProvinceModel yy_modelWithDictionary:dict];
        
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}



@end




