//
//  HMUserManager.h
//  SimpleLamp
//
//  Created by chen on 2020/5/11.
//  Copyright © 2020 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMUserManager : NSObject



//判断是否登录
+(BOOL)isLogin;

//获取userID
+ (NSString *)getUserID;

+ (NSString *)getUserItem:(NSString *)itemKey;





@end

NS_ASSUME_NONNULL_END
