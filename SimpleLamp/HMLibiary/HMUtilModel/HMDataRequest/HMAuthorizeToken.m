//
//  HMAuthorizeToken.m
//  Homesick
//
//  Created by Huamo on 16/5/31.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMAuthorizeToken.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "HMDataRequest.h"


@interface HMAuthorizeToken () {
    
}
@property (nonatomic,strong) AFHTTPSessionManager *manager;

@end


@implementation HMAuthorizeToken

+ (HMAuthorizeToken *)shareAuthorizeToken{
    static HMAuthorizeToken *shareAuthorizeToken = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareAuthorizeToken = [[HMAuthorizeToken alloc]init];
    });
    
    return shareAuthorizeToken;
}

- (id)init{
    if (self = [super init]) {
        
        _manager = [AFHTTPSessionManager manager];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = securityPolicy;
        
        _manager.requestSerializer.timeoutInterval = 20;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",nil];
        
        
    }
    return self;
}

- (void)refrushToken{
    [HMAuthorizeToken refrushTokenWithUrl:nil params:nil imageData:nil cacheTime:0 progressInView:nil mustResrush:NO requestType:HMRequestType_none CallBack:nil];
}


/**
 参数都为空：更新授权token
 参数不为空（以urlStr为准）：token失效，重新获取
 url为空，不考虑isPost参数
 */
+ (void)refrushTokenWithUrl:(NSString *)urlStr params:(NSDictionary *)params imageData:(NSData *)imageData cacheTime:(int)cacheDuration progressInView:(UIView *)progressBaseView mustResrush:(BOOL)mustResrush requestType:(HMRequestType)requestType CallBack:(void(^)(id responseObject, id error))callback{
    
    
    //判断网络连接
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    if([reach currentReachabilityStatus] == 0){
        if (progressBaseView != nil) {
            MBProgressHUD *proHUD=[MBProgressHUD showHUDAddedTo:progressBaseView animated:YES];
            proHUD.mode = MBProgressHUDModeText;
            proHUD.labelText = @"无网络连接，请检查网络！";
            proHUD.margin = 10.f;
            proHUD.yOffset = 80.f;
            proHUD.removeFromSuperViewOnHide=YES;
            [proHUD hide:YES afterDelay:3];
            
            return;
        }
    }
    
    NSString *serverUrl = [anthorizeTokenUrl stringByAppendingString:@"/autho/api/getToken"];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:DEVICE_ID forKey:@"primarykey"];
    [dict setObject:@"IPHONE" forKey:@"access_system"];
    [dict setObject:INT_CURRENT_APP_VERSION forKey:@"version"];
    [dict setObject:[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000] forKey:@"access_time"];
    [dict setObject:[[HMAuthorizeToken shareAuthorizeToken] getMD5SignString] forKey:@"sign"];
    [dict setObject:@"MD5" forKey:@"sign_type"];
    
    
    NSString *condition = @"";
    for(NSString *key in [dict allKeys]){
        if([condition isEqualToString:@""]){
            condition = [NSString stringWithFormat:@"%@=%@", key,[dict objectForKey:key]];
        }else{
            condition = [NSString stringWithFormat:@"%@&%@=%@",condition, key,[dict objectForKey:key]];
        }
    }
    
    
    
    //开始发起网络请求
    AFHTTPSessionManager * manager = [HMAuthorizeToken shareAuthorizeToken].manager;
    
    
    
    NIF_TRACE(@"%@?%@", serverUrl, dict);
    [HMDataRequest showLoadingInView:progressBaseView];
    
    [manager GET:serverUrl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [HMDataRequest hideLoadingInView:progressBaseView];
        
        NIF_TRACE(@"\nURL:%@\n%@",serverUrl, responseObject);
        
        NSDictionary *infomap = [responseObject objectForKey:@"infoMap"];
        if(infomap == nil){
            return;
        } else {
            NSDictionary *infomap = [responseObject objectForKey:@"infoMap"];
            int flag = [[infomap objectForKey:@"flag"] intValue];
            if(flag == 1){
                
                [HMAuthorizeToken shareAuthorizeToken].authoToken = [infomap stringValueForKey:@"access_token"];
                
                if (urlStr && urlStr.length >0) {
                    if (requestType == HMRequestType_get) {
                        
                        [HMDataRequest getRequestWithUrl:urlStr withParams:params withCacheTime:cacheDuration showProgressInView:progressBaseView mustResrush:mustResrush CallBack:callback];
                    }else if (requestType == HMRequestType_post){
                        
                        [HMDataRequest postRequestWithUrl:urlStr withParams:params withCacheTime:cacheDuration showProgressInView:progressBaseView mustResrush:mustResrush CallBack:callback];
                    }else if (requestType == HMRequestType_upload){
                        
                        [HMDataRequest uploadImageWithUrl:urlStr withParams:params imageData:imageData withCacheTime:cacheDuration showProgressInView:progressBaseView CallBack:callback];
                    }
                    
                }
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HMDataRequest hideLoadingInView:progressBaseView];
        
        NIF_TRACE(@"\nURL:%@\n%@",urlStr, error);
    }];
    
}



#pragma mark - 拼接数字签名


/**
 更新授权token：
 primarykey       系统唯一标示
 access_system    接入系统     CRM/PC/ANDROID/IPHONE
 version          系统版本     如100
 access_time      请求时间     13位Unix时间戳
 sign             签名串       对参数进行签名计算后的字符串
 sign_type        签名方式     MD5
 */


/**
 数字签名
 1.	请求的所有参数（注意是所有参数），但除去sign、sign_type本身，以及值是空的参数，
 按参数名字母升序排序，
 2.	按参数1=值1&参数2=值2…&参数n=值n（这里的参数不能是经过处理的，如不能将&quot;转成”后再拼接）的方式进行连接，得到一个字符串，然后在连接后得到的字符串后面加上通知验证密钥，然后计算md5值
 */
- (NSString *)getMD5SignString{
    NSString *signString = @"";
    
    
    NSString *primarykey = DEVICE_ID;
    NSString *access_system = @"IPHONE";
    NSString *version = INT_CURRENT_APP_VERSION;
    NSString *access_time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]*1000];
    
    
    signString = [signString stringByAppendingString:@"access_system"];
    signString = [signString stringByAppendingString:@"="];
    signString = [signString stringByAppendingString:access_system];
    signString = [signString stringByAppendingString:@"&"];
    
    
    signString = [signString stringByAppendingString:@"access_time"];
    signString = [signString stringByAppendingString:@"="];
    signString = [signString stringByAppendingString:access_time];
    signString = [signString stringByAppendingString:@"&"];
    
    if (primarykey.length > 0) {
        signString = [signString stringByAppendingString:@"primarykey"];
        signString = [signString stringByAppendingString:@"="];
        signString = [signString stringByAppendingString:primarykey];
        signString = [signString stringByAppendingString:@"&"];
    }
    
    
    signString = [signString stringByAppendingString:@"version"];
    signString = [signString stringByAppendingString:@"="];
    signString = [signString stringByAppendingString:version];
    
    
    //去除空格
    signString = [signString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //添加秘钥
    signString = [signString stringByAppendingString:iphone_md5_key];
    
    signString = [signString md5];
    
    return signString;
}


@end
