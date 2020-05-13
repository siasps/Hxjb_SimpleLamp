//
//  HMCityDataModel.h
//  PandaMerchant
//
//  Created by Huamo on 2019/1/5.
//  Copyright © 2019年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HMCityModel;
@class HMAreaModel;

@interface HMProvinceModel: NSObject <NSMutableCopying>

@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * pid;

@property(nonatomic,strong)NSMutableArray<HMCityModel *> *citys;


@end

@interface HMCityModel : NSObject<NSMutableCopying>
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * pid;

@property (nonatomic,strong)NSMutableArray<HMAreaModel *> *areas;


@end


@interface HMAreaModel : NSObject<NSMutableCopying>
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * code;
@property(nonatomic,copy) NSString * pid;


@end



@interface NSArray (yyCityModel_array)

- (NSArray *)yy_modelDataForArray;

@end



