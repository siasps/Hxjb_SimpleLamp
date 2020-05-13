//
//  HMDataRequest.h
//  HuaxiajiaboApp
//
//  Created by huamo on 14/12/9.
//  Copyright (c) 2014年 peng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HMDataRequest : NSObject

+ (void)getRequestWithUrl:(NSString *)urlStr
               withParams:(NSDictionary *)params
                 CallBack:(void(^)(id responseObject, id error))callback;

+ (void)getRequestWithUrl:(NSString *)urlStr
            withParams:(NSDictionary *)params
         withCacheTime:(int)cacheDuration
    showProgressInView:(UIView *)progressBaseView
              CallBack:(void(^)(id responseObject, id error))callback;

//mustResrush：YES，先读缓存，然后请求服务器
+ (void)getRequestWithUrl:(NSString *)urlStr
               withParams:(NSDictionary *)params
            withCacheTime:(int)cacheDuration
       showProgressInView:(UIView *)progressBaseView
              mustResrush:(BOOL)mustResrush
                 CallBack:(void(^)(id responseObject, id error))callback;


+ (void)postRequestWithUrl:(NSString *)urlStr
                withParams:(NSDictionary *)params
             withCacheTime:(int)cacheDuration
        showProgressInView:(UIView *)progressBaseView
                  CallBack:(void(^)(id responseObject, id error))callback;

+ (void)postRequestWithUrl:(NSString *)urlStr
                withParams:(NSDictionary *)params
             withCacheTime:(int)cacheDuration
        showProgressInView:(UIView *)progressBaseView
               mustResrush:(BOOL)mustResrush
                  CallBack:(void(^)(id responseObject, id error))callback;


+ (void)uploadImageWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params imageData:(NSData *)imageData withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView CallBack:(void(^)(id responseObject, id error))callback;;


+ (void)cancelRequestWithURLString:(NSString *)URLString;


+ (NSString *)getCacheKeyWithUrl:(NSString *)urlStr params:(NSDictionary *)params;
+ (NSDictionary *)getCacheDataWithCacheKey:(NSString *)cacheKey cacheTime:(int)cacheTime;
+ (void)saveCacheJsonIfNeeded:(NSDictionary *)jsonDict key:(NSString *)key cacheDuration:(int)cacheDuration;
+ (void)deleteCacheWithUrl:(NSString *)urlStr;



+ (void)showLoadingInView:(UIView *)progressBaseView;
+ (void)hideLoadingInView:(UIView *)progressBaseView;


@end
