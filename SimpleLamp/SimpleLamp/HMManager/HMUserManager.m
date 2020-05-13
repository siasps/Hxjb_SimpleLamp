//
//  HMUserManager.m
//  SimpleLamp
//
//  Created by chen on 2020/5/11.
//  Copyright © 2020 chen. All rights reserved.
//

#import "HMUserManager.h"

@implementation HMUserManager



//判断是否登录
+(BOOL)isLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = emptyString([userDefaults objectForKey:HMUSER_ID]);
    return [userID isEqualToString:@""]?NO:YES;
}

//获取userID
+ (NSString *)getUserID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = emptyString([userDefaults objectForKey:HMUSER_ID]);
    
    return userID;
}


+ (NSString *)getUserItem:(NSString *)itemKey{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = emptyString([userDefaults objectForKey:itemKey]);
    
    return userID;
}





@end
