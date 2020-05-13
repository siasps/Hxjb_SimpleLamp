//
//  NSString+KIString.m
//  Kitalker
//
//  Created by 杨 烽 on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+KIAdditions.h"

NSString * emptyString(NSString *anMaybeEmptyString) {
    if ([anMaybeEmptyString isKindOfClass:[NSNumber class]]) {
        anMaybeEmptyString = [NSString stringWithFormat:@"%@",anMaybeEmptyString];
    }
    if (!anMaybeEmptyString || [anMaybeEmptyString isKindOfClass:[NSNull class]] || [anMaybeEmptyString length] == 0) return @"";
    else return anMaybeEmptyString;
    //	return @"";
}

@implementation NSString (KIAdditions)

+ (BOOL)isEmptyString:(NSString *)string {
    if (string != nil && (id)string != [NSNull null]) {
        return [string isEmpty];
    }
    return YES;
}

+ (BOOL)isNotEmptyString:(NSString *)string {
    return ![NSString isEmptyString:string];
}

- (BOOL)isEmpty {
    return ![self isNotEmpty];
}

- (BOOL)isNotEmpty {
    if (self != nil
        && ![self isKindOfClass:[NSNull class]]
        && (id)self != [NSNull null]
        && [[self trimWhitespace] length]>0) {
        return YES;
    }
    return NO;
}

- (NSString *)md5 {
    if (!self) {
        return nil;
    }
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)sha1 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", digest[i]];
    }
    return outString;
}

- (NSString *)base64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64Encoded];
}

- (NSString *)base64Decoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:[data base64Decoded] encoding:NSUTF8StringEncoding];
}

//新浪微博的方式
//- (NSString *)URLEncodedString {
//    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8) autorelease];
//}

//旧的
- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

/*PostValueEncoded*/
- (NSString *)postValueEncodedString{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8));
}


//- (NSString *)URLEncodedString {
//    NSString *encodedString = (NSString *)
//    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                            (CFStringRef)self,
//                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                            CFSTR("+"),
//                                            kCFStringEncodingUTF8);
//    return [encodedString autorelease];
//}


- (NSString *)URLDecodedString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (int)actualLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:encoding];
    return (int)[data length];
}

- (NSString *)trimWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimLeftAndRightWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimHTMLTag {
    NSString *html = self;
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return [html trimWhitespace];
}

- (BOOL)isWhitespace {
    return [self isEmpty];
}

- (BOOL)isMatchesRegularExp:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)URLRegularExp {
    static NSString *urlRegEx = @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*)";;
    return urlRegEx;
}

- (BOOL)isURL {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [self URLRegularExp]];
    return [urlTest evaluateWithObject:self];
}

- (NSArray *)URLList {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:[self URLRegularExp]
                                                                         options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    NSArray *matches = [reg matchesInString:self
                                    options:NSMatchingReportCompletion
                                      range:NSMakeRange(0, self.length)];
    
    NSMutableArray *URLs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in matches) {
        [URLs addObject:[self substringWithRange:result.range]];
    }
    return URLs;
}

//- (BOOL)isIP {
//    NSString *ipRegex = @"((^1([0-9]\\d{0,2}))|(^2([0-5\\d{0,2}])))";
//    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegex];
//    return [ipTest evaluateWithObject:self];
//}

- (BOOL)isCellPhoneNumber {
    NSString *cellPhoneRegEx = @"^1(3[0-9]|4[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSPredicate *cellPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellPhoneRegEx];
    return [cellPhoneTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSString *phoneRegEx= @"((^0(10|2[0-9]|\\d{2,3})){0,1}-{0,1}(\\d{6,8}|\\d{6,8})$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    return [phoneTest evaluateWithObject:self];
}
//非负整数
- (BOOL)validateUnsignedInt
{
    NSString *stringRegex = @"^\\d+$";
    NSPredicate *stringTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [stringTest evaluateWithObject:self];
}
- (BOOL)isZipCode {
    NSString *zipCodeRegEx = @"[1-9]\\d{5}$";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegEx];
    return [zipCodeTest evaluateWithObject:self];
}


- (id)jsonObject:(NSError **)error {
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                           options:NSJSONReadingMutableContainers
                                             error:error];
}

- (NSComparisonResult)numericCompare:(NSString *)string {
    NSString *leftString = self;
    NSString *rightString = string;
    
    NSScanner *leftScanner = [NSScanner scannerWithString:leftString];
    NSScanner *rightScanner = [NSScanner scannerWithString:rightString];
    
    NSInteger leftNumber, rightNumber;
    
    if ([leftScanner scanInteger:&leftNumber] && [rightScanner scanInteger:&rightNumber]) {
        if (leftNumber < rightNumber) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
        
        //        leftString = [leftString substringFromIndex:[leftScanner scanLocation]];
        //        rightString = [rightString substringFromIndex:[rightScanner scanLocation]];
    }
    return [leftString caseInsensitiveCompare:rightString];
}

/*是否是整数*/
- (BOOL)isInteger{
    if (self) {
        NSScanner* scan = [NSScanner scannerWithString:self];
        NSInteger val;
        return [scan scanInteger:&val] && [scan isAtEnd];
    }
    else {
        return NO;
    }
}

/*是否是整数*/
- (BOOL)isValuableInteger{
    
    if ([self isInteger]) {
        
        NSString *AA = [NSString stringWithFormat:@"%ld",(long)[self integerValue]];
        //        NSString *BB = [NSString stringWithFormat:@"%ld",NSIntegerMax];
        
        if ([AA isEqualToString:self]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)isFloat{
    
    NSString *clearString = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (![clearString isInteger]) {
        return NO;
    }
    else{
        NSRange stringRange = NSMakeRange(0, [self length]);
        NSRegularExpression* pointRegular = [NSRegularExpression regularExpressionWithPattern:@"[.]"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
        NSArray *matches = [pointRegular matchesInString:self  options:NSMatchingReportCompletion range:stringRange];
        
        if ([matches count]==1) {
            return YES;
        }
        else{
            return NO;
        }
        //        for (NSTextCheckingResult *match in matches) {
        //            NSRange numberRange = [match range];
        //            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
        //                                     value:(id)specialTextColor.CGColor
        //                                     range:numberRange];
        //        }
    }
}


+ (NSString*)stringWithInteger:(NSInteger)intValue{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (NSString*)stringWithFloat:(CGFloat)floatValue{
    return [NSString stringWithFormat:@"%.0f",floatValue];
}


+ (NSString*)stringWithDouble:(double)doubleValue{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}

+ (NSString*)stringWithBool:(BOOL)boolValue{
    if (boolValue) {
        return @"1";
    }else{
        return @"0";
    }
}

//判断是否有表情符
+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;  
                                    } else if (0x2934 <= hs && hs <= 0x2935) {  
                                        returnValue = YES;  
                                    } else if (0x3297 <= hs && hs <= 0x3299) {  
                                        returnValue = YES;  
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {  
                                        returnValue = YES;  
                                    }  
                                }  
                            }];  
    
    return returnValue;  
}

/**
 小数点后两位：
 不为0，返回两位小数点
 为0，返回整数
 */
- (NSString *)getTwoDecimalString{
    
    double floatValue = [self doubleValue];
    NSInteger intValue = [self integerValue];
    
    if (floatValue - intValue >= 0.001) {
        return [NSString stringWithFormat:@"%.2f", floatValue];
    }else{
        return [NSString stringWithInteger:intValue];
    }
}

#pragma mark - 正则表达式
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1[3|4|5|6|7|8|9][0-9]{1}[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//电话号码验证
+ (BOOL) validateTel:(NSString *)tel
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *telRegex = @"^(([0\\+]\\d{2,3}-)?(0\\d{2,3})-)?(\\d{7,8})(-(\\d{3,}))?$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",telRegex];
    return [telTest evaluateWithObject:tel];
}


+ (NSMutableAttributedString *)getAttriString:(NSString *)originStr tags:(NSArray *)tags{
    if (!originStr || originStr.length<=0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableArray *_tempTagsStrArray = @[].mutableCopy;
    
    for (NSString *tagStr in tags) {
        NSString *tagstring = [NSString stringWithFormat:@"%@ ", tagStr];
        [NSString searchAllTextRangeWithInitialArray:_tempTagsStrArray initialText:originStr regexString:tagstring];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:originStr];
    for (NSDictionary *dic in _tempTagsStrArray) {
        NSRange range = [[dic objectForKey:@"subStringRange"] rangeValue];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:TextColor_blue
                        range:range];
    }
    
    return attrStr;
}

//标签验证
+ (void)searchAllTextRangeWithInitialArray:(NSMutableArray*)initialArray initialText:(NSString*)initialText regexString:(NSString*)regexString{
    
    if (initialArray.count == 0) {//如果此时传入的array是空
        NSRange range = [initialText rangeOfString:regexString options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            //包装字典，存进数组
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"subString"] = [initialText substringWithRange:range];
            dict[@"subStringRange"] = [NSValue valueWithRange:range];
            [initialArray addObject:dict];
            
            //递归调用
            [self searchAllTextRangeWithInitialArray:initialArray initialText:initialText regexString:regexString];
            
        }else{
            return;
        }
    }else{
        //如果数组中已经有值了
        //1、取数组中最后一个字典，记录后串在原串中的起始位置，把该串及其之前的串去掉生成新串
        NSMutableDictionary *lastDict = [initialArray lastObject];
        NSRange lastRange = [lastDict[@"subStringRange"]rangeValue];
        NSString *subStr = lastDict[@"subString"];
        
        //如果当前的字符串和数组最后一个不一样，重新开始
        if (![subStr isEqualToString:regexString]) {
            lastRange = NSMakeRange(0, 0);
        }
        
        NSUInteger newStringBeginLocation = lastRange.location+ lastRange.length;
        NSString*newString = [initialText substringFromIndex:newStringBeginLocation];
        //2、在新串中找符合的子串，如果找到，包装存进数组
        NSRange rangeInNewString = [newString rangeOfString:regexString options:NSRegularExpressionSearch];
        if(rangeInNewString.location!=NSNotFound) {
            //包装字典，存进数组
            NSMutableDictionary*dict = [NSMutableDictionary dictionary];
            dict[@"subString"] = [newString substringWithRange:rangeInNewString];
            NSRange rangeIninitialText = NSMakeRange(rangeInNewString.location+newStringBeginLocation, rangeInNewString.length);
            dict[@"subStringRange"] = [NSValue valueWithRange:rangeIninitialText];
            [initialArray addObject:dict];
            
            //递归调用
            [self searchAllTextRangeWithInitialArray:initialArray initialText:initialText regexString:regexString];
        }else{
            return;
        }
    }
    
}


//30分钟内显示刚刚回复，8小时内，均使用XX小时前回复，8小时后，显示年月日
- (NSString *)formatDateString
{
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue]/1000];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:timeDate toDate:[NSDate date] options:0];
    
    if ([components day] >= 1) {
        return [NSString stringWithFormat:@"%d天前", (int)[components day]];
    } else if ([components hour] >= 1) {
        return [NSString stringWithFormat:@"%d小时前", (int)[components hour]];
    } else if ([components minute] >= 1) {
        return [NSString stringWithFormat:@"%d分钟前", (int)[components minute]];
    }else{
        return @"刚刚";
    }
    
    return [NSDate getStringFromDate:timeDate dateFormatter:@"yyyy-MM-dd"];
}


+ (NSString *)spaceTimeFromDateString:(NSString *)fromString toDateString:(NSString*)toString;
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[fromString longLongValue]/1000];
    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:[toString longLongValue]/1000];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:toDate options:0];

    if ([components day] >= 1) {
        return [NSString stringWithFormat:@"%ld天后",(long)[components day]];
    }else if ([components hour] >= 1) {
        return [NSString stringWithFormat:@"%d小时后", (int)[components hour]];
    } else if ([components minute] >= 1) {
        return [NSString stringWithFormat:@"%d分钟后", (int)[components minute]];
    }else{
        return [NSString stringWithFormat:@"1分钟后"];
    }

    
}

@end




@implementation NSMutableString (Ext_51Job)

//追加字符串 nil不会crash 追加空值
- (void)appendStringEx:(NSString *)aString {
    if (aString == nil) { // 为 nil 时就不用管它了
        return;
    }
    
    [self appendString:aString];
}

@end

