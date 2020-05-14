//
//  DDLocationManager.m
//  HM
//
//  Created by hugh on 14-12-29.
//  Copyright 2014年 HM. All rights reserved.
//

#import "HMLocationManager.h"
#import "AppDelegate.h"

#define HMURLConnectionTagLocationCityName     5000
#define HMURLConnectionTagLocationNewLonLat    5001
#define HMURLConnectionTagLocationDetailAddr   5002


@implementation HMLocationManager

@synthesize locationDelegate;
@synthesize chinaLongitude;
@synthesize chinaLatitude;
@synthesize cityName = _cityName;
@synthesize cityCode = _cityCode;
@synthesize cityPy  = _cityPy;
@synthesize formattedAddress;
@synthesize tmpLatitude;
@synthesize tmpLongitude;

static HMLocationManager *sharedLocationManager = nil;
static BOOL               isNoPositionShow = NO;
//static BOOL               isNoPositionShowFlag = YES;

+ (HMLocationManager *)sharedLocationManager {
    @synchronized (self) {
        if (sharedLocationManager == nil) {
            sharedLocationManager = [[self alloc] init];
            isNoPositionShow = NO;
        }
        return sharedLocationManager;
    }
}

- (id)init {
    if (self = [super init]) {
        locateFailureTimes = 0;
        chinaLongitude = 0;
        chinaLatitude = 0;
        oldLatitude = 0.0;
        oldLongitude = 0.0;
        firstLocate = YES;
        locationManager = [[CLLocationManager alloc]init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        
        _canLocation = NO;
    }
    return self;
}

+ (BOOL)canUseLocation{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    
    return [HMLocationManager sharedLocationManager].canLocation;
}

- (void)wakeUp{
    _canLocation = NO;
    
    if (IS_IOS8) {
        /*
         kCLAuthorizationStatusNotDetermined  = 0,
         kCLAuthorizationStatusRestricted ,
         kCLAuthorizationStatusDenied ,
         kCLAuthorizationStatusAuthorized ,
         kCLAuthorizationStatusAuthorizedAlways  = kCLAuthorizationStatusAuthorized ,
         kCLAuthorizationStatusAuthorizedWhenInUse
         */
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusNotDetermined) {
            
            //总是授权
            
            //           [locationManager requestAlwaysAuthorization];
            
            //每次授权一次
            
            [locationManager requestWhenInUseAuthorization];
            
        } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
            
            [locationManager startUpdatingLocation];
            
            _canLocation = YES;
        }
        
    } else {
        _canLocation = YES;
        [locationManager startUpdatingLocation];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (IS_IOS8) {
        switch (status) {
                
            case kCLAuthorizationStatusAuthorizedAlways:
                
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                
                NIF_TRACE(@"Got authorization, start tracking location");
                
                [self wakeUp];
                
                break;
                
            case kCLAuthorizationStatusNotDetermined:
                
                [locationManager requestAlwaysAuthorization];
                
                break;
                
            default:
                
                break;
                
        }
    }
    
    
}
- (void)sleep {
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation.horizontalAccuracy < 0) return;
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0 && !firstLocate) return;
    firstLocate = NO;
    
    double theLatitude = newLocation.coordinate.latitude;
    double theLongitude = newLocation.coordinate.longitude;
    
    
    
    if(locationDelegate != nil && [locationDelegate conformsToProtocol:@protocol(HMLocationDelegate)] && [locationManager respondsToSelector:@selector(locationdidUpdateLongitude:Latitude:)]) {
        [locationDelegate locationdidUpdateLongitude:theLongitude Latitude:theLatitude];
    }
    
    //#ifdef  DEBUG
#if 0
    tmpLatitude = 30.283209;
    tmpLongitude = 120.16355;
#else
    tmpLatitude = newLocation.coordinate.latitude;
    tmpLongitude = newLocation.coordinate.longitude;
#endif
    
    
    double distance = sqrt((tmpLatitude-oldLatitude)*(tmpLatitude-oldLatitude) +
                           (tmpLongitude-oldLongitude)*(tmpLongitude-oldLongitude));
    
    if(distance < 0.00045)
        return;
    oldLatitude = tmpLatitude;
    oldLongitude = tmpLongitude;
    
    if(theLatitude>0.01 && theLongitude>0.01)
        [[NSNotificationCenter defaultCenter] postNotificationName:HMLocationDidUpdateNotification object:nil];
    
    //获取城市基本信息
    //[self getCityFormNetData];
    [self getCityFromGeocoder];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied){
        
        tmpLatitude = 0;
        tmpLongitude = 0;
        
//        _cityCode = @"";
//        _cityName = @"";
        
    }else if (error.code == kCLErrorLocationUnknown){
        tmpLatitude = 0;
        tmpLongitude = 0;
        
//        _cityCode = @"";
//        _cityName = @"";
    }
    
//    if (error.code == kCLErrorDenied) {
//        if ([DDNoNetworkTipView sharedStatusView].isShown) {
//            [[DDNoNetworkTipView sharedStatusView] performSelector:@selector(dismiss) withObject:nil afterDelay:2.f];
//            [self performSelector:@selector(showLocationErrorAlert) withObject:nil afterDelay:3.f];
//        }else {
//            [self performSelector:@selector(showLocationErrorAlert) withObject:nil afterDelay:0.f];
//        }
//    } else if (error.code == kCLErrorLocationUnknown) {
//        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
//
//            if ([emptyString(_cityCode)  isEqualToString:@""] || [emptyString(_cityName) isEqualToString:@""]) {
//                NSString *message = @"当前城市信息无法获取，请链接网络";
//                [[DDMessageTips alloc] showTipsWithMessage:message];
//            }
//
//        }
//    }
//
//    if(locationDelegate && [locationDelegate respondsToSelector:@selector(locationdidUpdateFailWithError:)]){
//        [locationDelegate locationdidUpdateFailWithError:error];
//    }
}

//- (void)showLocationErrorAlert {
//    if (!isNoPositionShow) {
//        isNoPositionShow = YES;
//
//        if (IS_IOS8) {
//            UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"定位失败" message:@"请开启“设置->定位服务”中的相关选项。" preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            [alertV addAction:defaultAction];
//
//
//            [[(AppDelegate *)([UIApplication sharedApplication].delegate) window].rootViewController presentViewController:alertV animated:YES completion:nil];
//
//        } else {
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请开启“设置->定位服务”中的相关选项。" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//            [alert show];
//        }
//
//    }
//    
//}


- (void)changeFlag {
    isNoPositionShow = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}


#pragma mark - 经纬度解码


- (void)getCityFromGeocoder{
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:tmpLatitude longitude:tmpLongitude];
    
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks) {
            
            //NSDictionary *addressDic = placeMark.addressDictionary;
            //NSString *state=[addressDic objectForKey:@"State"];
            //NSString *city=[addressDic objectForKey:@"City"];
            //NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            //NSString *street=[addressDic objectForKey:@"Street"];
            //NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            
//            NSDictionary *cityInfo = [[HMCityDataManager shareCityDataManager]getCityInfoWithCityName:city];
//            
//            if (cityInfo) {
//                formattedAddress = @"";
//                _cityCode = [cityInfo stringValueForKey:@"city_id"];
//                _cityName = [cityInfo stringValueForKey:@"city_name"];
//                _cityPy   = [cityInfo stringValueForKey:@"city_py"];
//                _shopType   = [cityInfo stringValueForKey:@"shop_type_id"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"HMLocationDidFindCityName" object:nil];
//            }
            
        }
        
    }];
}


#pragma mark - 坐标转换

/*
 ①火星坐标：(GCJ-02)
 描述：中国标准，行货 GPS 设备取出的最终数据是这个
 国家龟腚： 国内出版的各种地图系统（包括电子形式），必须至少采用GCJ-02对地理位置进行首次加密。
 
 使用者：iOS 地图
 Gogole地图
 搜搜、阿里云、高德地图、苹果地图
 
 ②地球坐标:(WGS84)
 描述：国际标准，GPS标准从 GPS 设备中取出的原始数据是就是这个
 国际地图提供商一般使用的也是这个
 使用者：Google 卫星地图（国外地图应该都是……）
 
 ③百度坐标：(BD-09)
 描述：百度标准，百度 SDK，地图，Geocoding 用的都是这个。
 使用者：百度地图
 
 可参考百度API：http://lbsyun.baidu.com/index.php?title=webapi/guide/changeposition
 */

/*高德地图坐标=》百度坐标转*/
+ (CLLocationCoordinate2D)locationTranslate_FromGCJ02_To_BD09:(CLLocationCoordinate2D)locationGCJ_02{
    double GCJ_x = locationGCJ_02.longitude, GCJ_y = locationGCJ_02.latitude;
    
    double z = sqrt(GCJ_x * GCJ_x + GCJ_y * GCJ_y) + 0.00002 * sin(GCJ_y * M_PI);
    
    double theta = atan2(GCJ_y, GCJ_x) + 0.000003 * cos(GCJ_x * M_PI);
    
    double BD_lon = z * cos(theta) + 0.0065;
    
    double BD_lat = z * sin(theta) + 0.006;
    
    
    CLLocationCoordinate2D locationCoordinate2D;
    locationCoordinate2D.longitude = BD_lon;
    locationCoordinate2D.latitude = BD_lat;
    return locationCoordinate2D;
}

/*地球坐标=》火星坐标*/
+ (CLLocationCoordinate2D)locationTranslate_FromWGS84_To_GCJ02:(CLLocationCoordinate2D)locationWGS84{
    
    BOOL outOfChina = NO;
    if (locationWGS84.longitude < 72.004 || locationWGS84.longitude > 137.8347
        || locationWGS84.latitude < 0.8293 || locationWGS84.latitude > 55.8271){
        outOfChina = YES;
    }
    
    
    if (outOfChina){
        return locationWGS84;
    }
    else{
        //
        // Krasovsky 1940
        //
        // a = 6378245.0, 1/f = 298.3
        // b = a * (1 - f)
        // ee = (a^2 - b^2) / a^2;
        double a = 6378245.0;
        double ee = 0.00669342162296594323;
        
        //
        // World Geodetic System ==> Mars Geodetic System
        double x = locationWGS84.longitude - 105.0;
        double y = locationWGS84.latitude - 35.0;
        
        double dLat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(ABS(x));
        dLat += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
        dLat += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
        dLat += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
        
        
        double dLon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(ABS(x));
        dLon += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
        dLon += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
        dLon += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
        
        
        double radLat = locationWGS84.latitude / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
        
        CLLocationCoordinate2D locationCoordinate2D;
        locationCoordinate2D.longitude = locationWGS84.longitude + dLon;
        locationCoordinate2D.latitude = locationWGS84.latitude + dLat;
        return locationCoordinate2D;
    }
}

//地球坐标 =》 百度坐标
+ (CLLocationCoordinate2D)locationTranslate_FromWGS84_To_BD09:(CLLocationCoordinate2D)locationWGS84{
    CLLocationCoordinate2D chinaCoor = [HMLocationManager locationTranslate_FromWGS84_To_GCJ02:locationWGS84];
    
    CLLocationCoordinate2D newCoor = [HMLocationManager locationTranslate_FromGCJ02_To_BD09:chinaCoor];
    
    return newCoor;
}

/*百度地图坐标=》高德坐标转*/
+ (CLLocationCoordinate2D)locationTranslate_FromBD09_To_GCJ02:(CLLocationCoordinate2D)locationBD09
{
    double bd_lon = locationBD09.longitude, bd_lat = locationBD09.latitude;
    
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    
    
    CLLocationCoordinate2D locationCoordinate2D;
    locationCoordinate2D.longitude = gg_lon;
    locationCoordinate2D.latitude = gg_lat;
    return locationCoordinate2D;
}





@end
