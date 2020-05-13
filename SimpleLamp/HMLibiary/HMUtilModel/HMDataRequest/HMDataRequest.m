 //
//  HMDataRequest.m
//  HuaxiajiaboApp
//
//  Created by huamo on 14/12/9.
//  Copyright (c) 2014年 peng. All rights reserved.
//

#import "HMDataRequest.h"
#import "MBProgressHUD.h"
#import "FMDatabase.h"
#import "Reachability.h"
#import "HMHttpRequestHeader.h"
#import "AFNetworking.h"
#import "HMHttpCacheDBManager.h"



@interface HMDataRequest () {
    
}
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) NSMutableDictionary *loadingDict;
@property (nonatomic,strong) NSLock *dbLock;
@property (nonatomic,strong) FMDatabase *cacheDb;

@end



@implementation HMDataRequest


+ (instancetype)shareDataRequest{
    static HMDataRequest *shareDataRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataRequest = [HMDataRequest new];
    });
    return shareDataRequest;
}

- (id)init{
    if (self = [super init]) {
        
        _manager = [AFHTTPSessionManager manager];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = securityPolicy;
        
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",nil];
        
        _loadingDict = @{}.mutableCopy;
        
        _dbLock = NSLock.new;
        _cacheDb = [HMHttpCacheDBManager defaultDatabase];
    }
    return self;
}



+ (void)getRequestWithUrl:(NSString *)urlStr
               withParams:(NSDictionary *)params
                 CallBack:(void(^)(id responseObject, id error))callback{
    
    [HMDataRequest getRequestWithUrl:urlStr withParams:params withCacheTime:0 showProgressInView:nil mustResrush:YES CallBack:callback];
    
}

+ (void)getRequestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView CallBack:(void(^)(id responseObject, id error))callback{
    [self getRequestWithUrl:urlStr withParams:params withCacheTime:cacheDuration showProgressInView:progressBaseView mustResrush:YES CallBack:callback];
    
}

+ (void)getRequestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView mustResrush:(BOOL)mustResrush CallBack:(void(^)(id responseObject, id error))callback{

    //缓存
    NSString *cacheKey = [self getCacheKeyWithUrl:urlStr params:params];
    NSDictionary *cacheJsonData = [self getCacheDataWithCacheKey:cacheKey cacheTime:cacheDuration];
    if(cacheJsonData != nil) {
        callback(cacheJsonData, nil);
        if (!mustResrush) {
            return;
        }
    }
    
    //判断网络请求
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if([reach currentReachabilityStatus] == 0){
        if (!cacheJsonData) {
            [self showNotNetLoadingView:progressBaseView];
        }
        
        callback(nil, @"网络异常");
        return;
    }
    
    
    AFHTTPSessionManager *manager = [HMDataRequest shareDataRequest].manager;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 60;
    [requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *headerDict = [HMHttpRequestHeader getHeader];
    for(NSString *k in [headerDict allKeys]) {
        [requestSerializer setValue:[headerDict objectForKey:k] forHTTPHeaderField:k];
    }
    manager.requestSerializer = requestSerializer;
    
    //头文件添加授权token
    NSString *authoToken = [[HMAuthorizeToken shareAuthorizeToken]authoToken];
    if (authoToken && authoToken.length>0) {
        [manager.requestSerializer setValue:authoToken forHTTPHeaderField:@"access_token"];
    }else{
        [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:nil cacheTime:cacheDuration progressInView:progressBaseView mustResrush:mustResrush requestType:HMRequestType_get CallBack:callback];
        
        return;
    }
    //NIF_TRACE(@"%@?%@\n RequestHeader: %@", urlStr, params, manager.requestSerializer.HTTPRequestHeaders);
    NIF_TRACE(@"%@?%@", urlStr, params);
    
    [self showLoadingInView:progressBaseView];
    
    
    NSURLSessionDataTask *getTask =
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self hideLoadingInView:progressBaseView];
        
        NSDictionary *infomap = [responseObject objectForKey:@"infoMap"];
        if(infomap ){
            int flag = [[infomap objectForKey:@"flag"] intValue];
            NSInteger need_refresh_token = [[infomap stringValueForKey:@"need_refresh_token"] integerValue];
            if(need_refresh_token == 1) {
                
                [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:nil cacheTime:cacheDuration progressInView:progressBaseView mustResrush:mustResrush requestType:HMRequestType_get CallBack:callback];
                
                NIF_TRACE(@"\nURL:%@ \n无效Token",cacheKey);
                return;
            }
            
            if(flag == 1) {
                [self saveCacheJsonIfNeeded:responseObject key:cacheKey cacheDuration:cacheDuration];
            }
            
            NIF_TRACE(@"\nURL:%@\n%@",cacheKey, responseObject);
            
            callback(responseObject,nil);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(progressBaseView != nil){
            [self hideLoadingInView:progressBaseView];
            
            //Error Domain=NSURLErrorDomain Code=-999 "已取消"
            if (error.code != -999) {
                //[HMNotNetView showNotNetView:progressBaseView];
            }
            
        }
        
        NIF_TRACE(@"\nURL:%@\n%@",cacheKey, error);
        callback(nil,error);
    }];

    [[HMDataRequest shareDataRequest] addTask:getTask];
    
}

+ (void)postRequestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView CallBack:(void(^)(id responseObject, id error))callback{
    [self postRequestWithUrl:urlStr withParams:params withCacheTime:cacheDuration showProgressInView:progressBaseView mustResrush:NO CallBack:callback];
    
}

//mustResrush：YES，先读缓存，然后请求服务器
+ (void)postRequestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView mustResrush:(BOOL)mustResrush CallBack:(void(^)(id responseObject, id error))callback{
    
    //缓存
    NSString *cacheKey = [self getCacheKeyWithUrl:urlStr params:params];
    NSDictionary *cacheJsonData = [self getCacheDataWithCacheKey:cacheKey cacheTime:cacheDuration];
    if(cacheJsonData != nil) {
        callback(cacheJsonData, nil);
        if (!mustResrush) {
            return;
        }
    }
    
    //判断网络请求
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if([reach currentReachabilityStatus] == 0){
        if (!cacheJsonData) {
            [self showNotNetLoadingView:progressBaseView];
        }
        return;
    }
    
    
    AFHTTPSessionManager *manager = [HMDataRequest shareDataRequest].manager;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 60;
    manager.requestSerializer = requestSerializer;
    
    NSDictionary *headerDict = [HMHttpRequestHeader getHeader];
    for(NSString *k in [headerDict allKeys]){
        NSString *v = [NSString stringWithFormat:@"%@", [[headerDict objectForKey:k] description]];
        [manager.requestSerializer setValue:v forHTTPHeaderField:k];
    }
    //头文件添加授权token
    NSString *authoToken = [[HMAuthorizeToken shareAuthorizeToken]authoToken];
    if (authoToken && authoToken.length>0) {
        [manager.requestSerializer setValue:authoToken forHTTPHeaderField:@"access_token"];
    }else{
        [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:nil cacheTime:cacheDuration progressInView:progressBaseView mustResrush:mustResrush requestType:HMRequestType_post CallBack:callback];
        
        return;
    }
    //NIF_TRACE(@"%@?%@\n RequestHeader: %@", urlStr, params, manager.requestSerializer.HTTPRequestHeaders);
    NIF_TRACE(@"%@?%@", urlStr, params);
    
    [self showLoadingInView:progressBaseView];
    
    NSURLSessionDataTask *postTask =
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self hideLoadingInView:progressBaseView];
        
        NSDictionary *infomap = [responseObject objectForKey:@"infoMap"];
        if(infomap){
            int flag = [[infomap objectForKey:@"flag"] intValue];
            NSInteger need_refresh_token = [[infomap stringValueForKey:@"need_refresh_token"] integerValue];
            if(need_refresh_token == 1) {
                
                [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:nil cacheTime:cacheDuration progressInView:progressBaseView mustResrush:mustResrush requestType:HMRequestType_post CallBack:callback];
                
                NIF_TRACE(@"\nURL:%@ \n无效Token",urlStr);
                return;
            }
            
            if(flag == 1) {
                
                [self saveCacheJsonIfNeeded:responseObject key:cacheKey cacheDuration:cacheDuration];
                
            }
            
            NIF_TRACE(@"\nURL:%@\n%@",urlStr, responseObject);
            callback(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(progressBaseView != nil){
            [self hideLoadingInView:progressBaseView];
            
            //Error Domain=NSURLErrorDomain Code=-999 "已取消"
            if (error.code != -999) {
                //[HMNotNetView showNotNetView:progressBaseView];
            }
            
        }
        
        NIF_TRACE(@"\nURL:%@\n%@",urlStr, error);
        callback(nil,error);
    }];
    
    [[HMDataRequest shareDataRequest] addTask:postTask];
    
}


+ (void)uploadImageWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params imageData:(NSData *)imageData withCacheTime:(int)cacheDuration showProgressInView:(UIView *)progressBaseView CallBack:(void(^)(id responseObject, id error))callback{
    
    //判断网络请求
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if([reach currentReachabilityStatus] == 0){
        [self showNotNetLoadingView:progressBaseView];
        
        return;
    }
    
    //开始发起网络请求
    AFHTTPSessionManager *manager = [HMDataRequest shareDataRequest].manager;
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc]initWithDictionary:[HMHttpRequestHeader getHeader]];
    [headerDict setObject:@"upload_file_name" forKey:@"upload_file_name"];
    for(NSString *k in [headerDict allKeys]){
        NSString *v = [NSString stringWithFormat:@"%@", [[headerDict objectForKey:k] description]];
        [manager.requestSerializer setValue:v forHTTPHeaderField:k];
    }
    for(NSString *key in [params allKeys]){
        [manager.requestSerializer setValue:[params stringValueForKey:key] forHTTPHeaderField:key];
    }
    
    //头文件添加授权token
    NSString *authoToken = [[HMAuthorizeToken shareAuthorizeToken]authoToken];
    if (authoToken && authoToken.length>0) {
        [manager.requestSerializer setValue:authoToken forHTTPHeaderField:@"access_token"];
    }else{
        [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:imageData cacheTime:cacheDuration progressInView:progressBaseView mustResrush:YES requestType:HMRequestType_upload CallBack:callback];
        
        return;
    }
    //NIF_TRACE(@"%@?%@",urlStr,params);
    
    if(progressBaseView != nil){
        [MBProgressHUD showHUDDetailTextTo:progressBaseView animated:YES];
    }
    
    NSURLSessionDataTask *uploadTask =
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"aaaaaaa" fileName:@"aaaaaaa.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(progressBaseView != nil){
            [MBProgressHUD hideAllHUDsForView:progressBaseView animated:NO];
        }
        
        NSDictionary *infomap = [responseObject objectForKey:@"infoMap"];
        NSInteger need_refresh_token = [[infomap stringValueForKey:@"need_refresh_token"] integerValue];
        if(need_refresh_token == 1) {
            
            [HMAuthorizeToken refrushTokenWithUrl:urlStr params:params imageData:imageData cacheTime:cacheDuration progressInView:progressBaseView mustResrush:YES requestType:HMRequestType_upload CallBack:callback];
            
            return;
        }
        
        NIF_TRACE(@"%@",responseObject);
        callback(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(progressBaseView != nil) {
            [MBProgressHUD hideAllHUDsForView:progressBaseView animated:NO];
        }
        callback(nil,error);
    }];
    
    [[HMDataRequest shareDataRequest] addTask:uploadTask];
    
}



#pragma mark - 管理请求队列


- (void)addTask:(NSURLSessionDataTask *)task{
    NSMutableDictionary *taskQueue = [self taskQueue];
    
    [taskQueue setObject:task forKey:@([NSDate date].timeIntervalSince1970)];
}

- (void)removeTask:(NSURLSessionDataTask *)task{
    if ([self ifRequesting]) {
        NSMutableDictionary *taskQueue = [self taskQueue];
        
        [taskQueue removeObjectForKey:@([NSDate date].timeIntervalSince1970)];
    }
}

- (NSMutableDictionary *)taskQueue{
    NSMutableDictionary *taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    
    if (!taskDic) {
        taskDic = @{}.mutableCopy;
        objc_setAssociatedObject(self, @selector(addTask:), taskDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return taskDic;
}

- (BOOL)ifRequesting{
    NSMutableDictionary *taskDic = objc_getAssociatedObject(self, @selector(addTask:));
    
    if (taskDic && taskDic.allKeys.count>0) {
        return YES;
    }
    return NO;
}

- (void)cancelRequest{
    
    if ([self ifRequesting]) {
        NSMutableDictionary *taskDic = [[HMDataRequest shareDataRequest] taskQueue];
        NIF_TRACE(@"----没有结束的队列====%lu", (unsigned long)taskDic.allKeys.count);
        
        [taskDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (((NSURLSessionDataTask *)obj).state != NSURLSessionTaskStateCompleted) {
                [((NSURLSessionDataTask *)obj) cancel];
            }
        }];
    }
}

//取消网络请求
+ (void)cancelRequestWithURLString:(NSString *)URLString{
    
    if ([[HMDataRequest shareDataRequest] ifRequesting]) {
        NSMutableDictionary *taskDic = [[HMDataRequest shareDataRequest] taskQueue];
        //NIF_TRACE(@"----没有结束的队列====%lu", (unsigned long)taskDic.allKeys.count);
        
        [taskDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if (((NSURLSessionDataTask *)obj).state != NSURLSessionTaskStateCompleted
                && [[((NSURLSessionDataTask *)obj).currentRequest.URL absoluteString] rangeOfString:URLString].location != NSNotFound) {
                
                NIF_TRACE(@"----end----%@", [((NSURLSessionDataTask *)obj).currentRequest.URL absoluteString]);
                
                [((NSURLSessionDataTask *)obj) cancel];
                
            }
        }];
    }
    

}


#pragma mark - Cache

+ (NSString *)getCacheKeyWithUrl:(NSString *)urlStr params:(NSDictionary *)params{
    
    if (urlStr.length <= 0) {
        return @"";
    }
    
    NSString *condition = @"";
    for(NSString *key in [params allKeys]){
        if([condition isEqualToString:@""]) {
            condition = [NSString stringWithFormat:@"%@=%@", key,[params objectForKey:key]];
        } else {
            condition = [NSString stringWithFormat:@"%@&%@=%@",condition, key,[params objectForKey:key]];
        }
    }
    
    NSString *cacheKey;
    if([condition isEqualToString:@""]) {
        cacheKey = urlStr;
    } else {
        cacheKey = [NSString stringWithFormat:@"%@?%@",urlStr, condition];
    }
    
    return cacheKey;
}

+ (NSDictionary *)getCacheDataWithCacheKey:(NSString *)cacheKey cacheTime:(int)cacheTime{
    [[HMDataRequest shareDataRequest].dbLock lock];
    NSData *jsonData = [[HMDataRequest shareDataRequest]getCacheDataWithCacheKey:cacheKey cacheTime:cacheTime];
    [[HMDataRequest shareDataRequest].dbLock unlock];
    
    
    if(jsonData != nil) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if(json != nil) {
            return json;
        }
    }
    return nil;
}

- (NSData *)getCacheDataWithCacheKey:(NSString *)cacheKey cacheTime:(int)cacheTime{
    
    if (cacheKey.length <= 0) {
        return nil;
    }
    
    if (cacheTime <= 0) {
        return nil;
    }
    
    
    NSData *jsonData = nil;
    FMDatabase *db = _cacheDb;
    if(![db open]){
        return nil;
    } else {
        
        FMResultSet *set = [db executeQuery:@"SELECT * FROM json_caches WHERE key = ?",cacheKey];
        if ([set next]) {
            NSInteger _id = [set intForColumn:@"row_id"];
            jsonData = [set dataForColumn:@"value"];
            NSInteger readedTimes = [set intForColumn:@"readed_times"];
            NSDate *savedTime = [set dateForColumn:@"saved_time"];
            NSDate *now = [NSDate date];
            double timeInterval = [now timeIntervalSinceDate:savedTime];
            
            if (timeInterval < cacheTime * 3600) {
                BOOL rs = [db executeUpdate:[NSString stringWithFormat:@"UPDATE json_caches SET readed_times = %d WHERE row_id = %d",(int)++readedTimes,(int)_id]];
                NIF_TRACE(@"%d", rs);
            } else {
                jsonData = nil;
            }
        }
        [db close];
    }
    
    
    return jsonData;
    
    
}

+ (void)saveCacheJsonIfNeeded:(NSDictionary *)jsonDict key:(NSString *)key cacheDuration:(int)cacheDuration{
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    
    [[HMDataRequest shareDataRequest].dbLock lock];
    [[HMDataRequest shareDataRequest]saveCacheJsonIfNeeded:jsonData key:key cacheDuration:cacheDuration];
    [[HMDataRequest shareDataRequest].dbLock unlock];
}
- (void)saveCacheJsonIfNeeded:(NSData *)jsonData key:(NSString *)key cacheDuration:(int)cacheDuration{
    
    
    if (key && key.length>0 && cacheDuration > 0 && jsonData.length>0) {
        FMDatabase *db = _cacheDb;
        if(![db open]){
            
        } else {
            FMResultSet *set = [db executeQuery:@"SELECT * FROM json_caches WHERE key = ?",key,nil];
            if ([set next]) {       // UPDATE
                int _id = [set intForColumn:@"row_id"];
                BOOL rs = [db executeUpdate:@"UPDATE json_caches SET value = ?,saved_time = ?,validity_duration=? WHERE row_id = ?", jsonData, [NSDate date],[NSNumber numberWithDouble:cacheDuration*3600], [NSNumber numberWithInt:_id]];
                NIF_TRACE(@"update cache success? : %d", rs);
            } else {
                
                BOOL rs = [db executeUpdate:@"INSERT INTO json_caches (key,value,saved_time,validity_duration,type) VALUES(?,?,?,?,?)",key,jsonData, [NSDate date], [NSNumber numberWithDouble:cacheDuration*3600],key, nil];
                NIF_TRACE(@"save cache success? : %d", rs);
                
            }
            [db close];
        }
    }
}

+ (void)deleteCacheWithUrl:(NSString *)urlStr
{
    [[HMDataRequest shareDataRequest].dbLock lock];
    FMDatabase *db = [HMDataRequest shareDataRequest].cacheDb;
    if(![db open]){
        
    } else {
        
        BOOL rs = [db executeUpdate:@"DELETE from json_caches where key like '%?%'",urlStr, nil];
        NIF_TRACE(@"delete cache success? : %d", rs);
        
        [db close];
    }
    [[HMDataRequest shareDataRequest].dbLock unlock];
}


#pragma mark - load view manager

+ (void)showNotNetLoadingView:(UIView *)progressBaseView{
    
    if (progressBaseView == nil) {
        
    }else{
        MBProgressHUD *proHUD=[MBProgressHUD showHUDAddedTo:progressBaseView animated:YES];
        proHUD.mode=MBProgressHUDModeText;
        proHUD.labelText=@"无网络连接，请检查网络！";
        proHUD.margin=10.f;
        proHUD.yOffset=80.f;
        proHUD.removeFromSuperViewOnHide=YES;
        [proHUD hide:YES afterDelay:3];
        
        
        //[HMNotNetView showNotNetView:progressBaseView];
        
    }
    
    
}

//+ (void)showLoadingWithUrl:(NSString *)urlStr progressInView:(UIView *)progressBaseView{
//
//    if(progressBaseView != nil){
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedCustomViewTo:progressBaseView animated:YES];
//        hud.keyURL = urlStr;
//    }
//
//}
//
//+ (void)hideLoadingWithUrl:(NSString *)urlStr progressInView:(UIView *)progressBaseView{
//
//    if(progressBaseView != nil){
//        NSArray *huds = [MBProgressHUD allHUDsForView:progressBaseView];
//        for (MBProgressHUD *hud in huds) {
//            if ([hud.keyURL isEqualToString:urlStr]) {
//                [hud hide:YES];
//            }
//        }
//    }
//
//}


+ (void)showLoadingInView:(UIView *)progressBaseView{
    [[HMDataRequest shareDataRequest] showLoading:YES progressInView:progressBaseView];
}

+ (void)hideLoadingInView:(UIView *)progressBaseView{
    [[HMDataRequest shareDataRequest] showLoading:NO progressInView:progressBaseView];
}

- (void)showLoading:(BOOL)show progressInView:(UIView *)progressBaseView{
    @synchronized (self){
        
        if (!progressBaseView) {
            return;
        }
        
        NSString *claseName = NSStringFromClass(progressBaseView.class);
        int loadNum = [[_loadingDict stringValueForKey:claseName] intValue];
        
        if (show) {
            if (loadNum <= 0) {
                loadNum=0;
                [MBProgressHUD showHUDAddedCustomViewTo:progressBaseView animated:YES];;
            }
            
            loadNum++;
            
            
        }else{
            loadNum--;
            
            if (loadNum <= 0) {
                loadNum = 0; //防止小于0
                
                NSArray *huds = [MBProgressHUD allHUDsForView:progressBaseView];
                for (MBProgressHUD *hud in huds) {
                    [hud hide:YES];
                }
            }
        }
        
        [_loadingDict setObject:[NSNumber numberWithInt:loadNum] forKey:claseName];
    }
    
}



@end
