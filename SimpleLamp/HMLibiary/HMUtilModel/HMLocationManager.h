//
//  DDLocationManager.h
//  HM
//
//  Created by hugh on 14-12-29.
//  Copyright 2014年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


static NSString *const HMLocationDidUpdateNotification			= @"HMLocationDidUpdateNotification";
static NSString *const HMLocationDidFailNotification			= @"HMLocationDidFailNotification";

static NSString *const HMLocationDidUpdateChinaNotification		= @"HMLocationDidUpdateChinaNotification";
static NSString *const HMLocationDidUpdatChinaFailNotification	= @"HMLocationDidUpdatChinaFailNotification";

static NSString *const HMLocationDidFindCityName				= @"HMLocationDidFindCityName";
static NSString *const HMLocationCantParseCityName				= @"HMLocationCantParseCityName";

static NSString *const HMLocationFindAddressDetailSuccess       = @"HMLocationFindAddressDetailSuccess";
static NSString *const HMLocationFindAddressDetailFail          = @"HMLocationFindAddressDetailFail";


@protocol HMLocationDelegate<NSObject>

@optional

- (void)locationdidUpdateChinaLongitude:(double)aLongitude	chinaLatitude:(double) aLatitude;
- (void)locationdidUpdateChinaFailWithError:(NSError *)error;
- (void)locationdidUpdateLongitude:(double)aLongitude Latitude:(double) aLatitude;
- (void)locationdidUpdateFailWithError:(NSError *)error;

@end

@interface HMLocationManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>{
    
    double chinaLongitude;
    double chinaLatitude;
    
    NSString *formattedAddress;
    
    NSInteger locateFailureTimes;
    
    NSString *_cityName;
    NSString *_cityCode;
    NSString *cityPy;
    
    double oldLatitude;
    double oldLongitude;
    BOOL  firstLocate;
    double tmpLatitude;
    double tmpLongitude;
    
    CLLocationManager *locationManager;
    
    
    
}

@property (weak)	id<HMLocationDelegate> locationDelegate;
@property (readonly) double chinaLongitude;
@property (readonly) double chinaLatitude;
@property (readonly)double tmpLatitude;
@property (readonly)double tmpLongitude;
@property (readonly,retain)  NSString *formattedAddress;
@property (nonatomic,assign) BOOL canLocation;
@property (readonly) NSString *cityName;
@property (readonly) NSString *cityCode;
@property (readonly) NSString *cityPy;//城市简称
@property (readonly) NSString *shopType;

+ (HMLocationManager *)sharedLocationManager;

+ (BOOL)canUseLocation;

- (void)wakeUp;
- (void)sleep;


/*百度地图坐标=》高德坐标转*/
+ (CLLocationCoordinate2D)locationTranslate_FromBD09_To_GCJ02:(CLLocationCoordinate2D)locationBD09;



@end

