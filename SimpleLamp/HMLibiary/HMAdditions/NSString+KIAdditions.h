//
//  NSString+KIString.h
//  Kitalker
//
//  Created by 杨 烽 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSData+KIAdditions.h"


NSString * emptyString(NSString *anMaybeEmptyString);

@interface NSString (KIAdditions)

+ (BOOL)isEmptyString:(NSString *)string;

+ (BOOL)isNotEmptyString:(NSString *)string;

- (BOOL)isEmpty;

/*判断是否为空或者nil*/
- (BOOL)isNotEmpty;


/*md5 加密*/
- (NSString *)md5;

/*sha1 加密*/
- (NSString *)sha1;

/*base64 加密*/
- (NSString *)base64Encoded;

/*base64 加密*/
- (NSString *)base64Decoded;

/*URLEncoded*/
- (NSString *)URLEncodedString;

/*URLDecoded*/
- (NSString *)URLDecodedString;

/*PostValueEncoded*/
- (NSString *)postValueEncodedString;

/*返回实际的长度，一个中文字符算作两个长度*/
- (int)actualLength;

/*去除空格*/
- (NSString *)trimWhitespace;

/*去除左右空格*/
- (NSString *)trimLeftAndRightWhitespace;

/*去除html标签*/
- (NSString *)trimHTMLTag;

/*判断是否为空白字符串*/
- (BOOL)isWhitespace;

/*判断是否为非负整数*/
- (BOOL)validateUnsignedInt;

/*判断是否匹配某个正则*/
- (BOOL)isMatchesRegularExp:(NSString *)regex;

/*判断是否为email*/
- (BOOL)isEmail;

/*返回URL的正则表达式*/
- (NSString *)URLRegularExp;

/*判断是否为URL*/
- (BOOL)isURL;

/*返回其中包含的URL列表*/
- (NSArray *)URLList;

//- (BOOL)isIP;

/*判断是否为手机号码*/
- (BOOL)isCellPhoneNumber;

/*判断是否为电话号码*/
- (BOOL)isPhoneNumber;

/*判断是否为中国地区邮编*/
- (BOOL)isZipCode;


/*转换为数值进行比较*/
- (NSComparisonResult)numericCompare:(NSString *)string;

/*是否是整数*/
- (BOOL)isInteger;

/*是否是整数*/
- (BOOL)isValuableInteger;

/*是否是浮点数*/
- (BOOL)isFloat;


+ (NSString*)stringWithInteger:(NSInteger)intValue;
+ (NSString*)stringWithFloat:(CGFloat)floatValue;
+ (NSString*)stringWithDouble:(double)doubleValue;
+ (NSString*)stringWithBool:(BOOL)boolValue;


+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateTel:(NSString *)tel;

- (NSString *)formatDateString;

+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 小数点后两位：
 不为0，返回两位小数点
 为0，返回整数
 */
- (NSString *)getTwoDecimalString;

+ (NSString *)spaceTimeFromDateString:(NSString *)fromString toDateString:(NSString*)toString;

+ (NSMutableAttributedString *)getAttriString:(NSString *)originStr tags:(NSArray *)tags;
//标签验证
+ (void)searchAllTextRangeWithInitialArray:(NSMutableArray*)initialArray initialText:(NSString*)initialText regexString:(NSString*)regexString;


@end



/**
 *
 * NSMutableString (Ext_51Job) 集合
 *
 *   1.为SDK自带的 NSMutableString 类添加一些实用方法
 *
 * @InterfaceName:   NSMutableString (Ext_51Job)
 * @Copyright:       51job Wireless Dev (c) 2011
 * @date:            2012-10-24
 */
@interface NSMutableString (Ext_51Job)

/* 追加字符串 nil不会crash 追加空值 */
- (void)appendStringEx:(NSString *)aString;

@end


