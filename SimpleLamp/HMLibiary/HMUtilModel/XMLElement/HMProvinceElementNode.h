//
//  HMProvinceElementNode.h
//  HuaxiajiaboApp
//
//  Created by huamo on 14/12/29.
//  Copyright (c) 2014年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMProvinceElementNode : NSObject <NSCopying>

@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;


@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong)NSMutableArray * citys;

+ (NSMutableArray *)parseProvinceWithXMLEles:(NSArray *)eles;
+ (HMProvinceElementNode*)copyWityProvince:(HMProvinceElementNode*)province;

@end

@interface City : NSObject <NSCopying>
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;

@property(nonatomic,assign) NSInteger index;
@property (nonatomic,strong)NSMutableArray * areas;
+ (NSMutableArray *)parseCityWithXMLEles:(NSArray *)eles;
+ (City*)copyWityCity:(City*)city;

@end

@interface Area : NSObject <NSCopying>
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;

@property(nonatomic,assign) NSInteger index;
+ (NSMutableArray *)parseAreaWithXMLEles:(NSArray *)eles;

+ (Area*)copyWityArea:(Area*)area;

@end
