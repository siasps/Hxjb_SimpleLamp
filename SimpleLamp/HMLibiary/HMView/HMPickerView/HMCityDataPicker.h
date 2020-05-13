//
//  HMCityDataPicker.h
//  XJMerchant
//
//  Created by Huamo on 16/8/26.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCityDataModel.h"


@protocol HMCityDataPickerDelegate ;

@interface HMCityDataPicker : UIView


- (id)initWithDelegate:(id<HMCityDataPickerDelegate>)delegate province:(HMProvinceModel *)province city:(HMCityModel *)city area:(HMAreaModel *)area;

- (void)show;

@end


@protocol HMCityDataPickerDelegate <NSObject>

@optional
- (void)cityDataPicker:(HMCityDataPicker *)cityDataPicker province:(HMProvinceModel *)province city:(HMCityModel *)city area:(HMAreaModel *)area;

@end
