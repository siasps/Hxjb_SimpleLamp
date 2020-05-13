//
//  HMAuthorizeToken.h
//  Homesick
//
//  Created by Huamo on 16/5/31.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger , HMRequestType) {
    HMRequestType_none = 1,
    HMRequestType_get,
    HMRequestType_post,
    HMRequestType_upload,
    
};


/**
 放在：PrefixHeader.pch文件
 */
//#ifdef DEBUG //测试
//
//#define iphone_md5_key              @"c1f8593a66657abf315e097768a5d088"
//#define anthorizeTokenUrl           @"http://test.api.51jiabo.com:1080"
//
//#else       //正式
//#define iphone_md5_key              @"be2a7ceeb720bb8e4ad1ddbb7ad8b7dc"
//#define anthorizeTokenUrl           @"http://api.51jiabo.com"
//
//#endif


@interface HMAuthorizeToken : NSObject{
    
}
@property (nonatomic,strong) NSString *authoToken;


+ (HMAuthorizeToken *)shareAuthorizeToken;

/**
 更新授权token
 */
- (void)refrushToken;

/**
 参数都为空：更新授权token
 参数不为空（以urlStr为准）：token失效，重新获取
 */
+ (void)refrushTokenWithUrl:(NSString *)urlStr params:(NSDictionary *)params imageData:(NSData *)imageData cacheTime:(int)cacheDuration progressInView:(UIView *)progressBaseView mustResrush:(BOOL)mustResrush requestType:(HMRequestType)requestType CallBack:(void(^)(id responseObject, id error))callback;

@end



