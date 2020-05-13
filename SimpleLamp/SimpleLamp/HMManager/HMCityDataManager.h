//
//  HMCityDataManager.h
//  Huaxiajiabo
//
//  Created by Huamo on 16/7/8.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define City_data_cache @"City_data_cache"


@interface HMCityDataManager : NSObject{
    
}



+ (HMCityDataManager *)shareCityDataManager;


-(void)getCityDataFromNet;
- (NSArray *)getCityList;





@end




