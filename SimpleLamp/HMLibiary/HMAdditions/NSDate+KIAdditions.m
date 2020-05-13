//
//  NSDate+KIDate.m
//  Kitalker
//
//  Created by 杨 烽 on 12-8-30.
//
//

#import "NSDate+KIAdditions.h"


@implementation NSDate (KIAdditions)


+ (NSString *)day:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return [dateFormatter day:date];
}

+ (NSString *)weekday:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return [dateFormatter weekday:date];
}

+ (NSString *)month:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return [dateFormatter month:date];
}

+ (NSString *)year:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return [dateFormatter year:date];
}

+ (NSCalendar *)calendar:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    return calendar;
}

+ (int)numberOfDaysInMonth:(NSDate*)date {
    return (int)[[NSDate calendar:date] rangeOfUnit:NSCalendarUnitDay
                                             inUnit:NSCalendarUnitMonth
                                            forDate:date].length;
}

+ (int)weeksOfMonth:(NSDate*)date {
    return (int)[[NSDate calendar:date] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                             inUnit:NSCalendarUnitMonth
                                            forDate:date].length;
}

- (BOOL)isBefore:(NSDate *)date {
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    NSTimeInterval dateTimeInterval = [date timeIntervalSince1970];
    if (selfTimeInterval < dateTimeInterval) {
        return YES;
    }
    return NO;
}

- (BOOL)isAfter:(NSDate *)date {
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    NSTimeInterval dateTimeInterval = [date timeIntervalSince1970];
    if (selfTimeInterval > dateTimeInterval) {
        return YES;
    }
    return NO;
}
/*是否在某个时间闭区间之间*/
- (BOOL)isBetween:(NSDate *)startDate and:(NSDate *)endDate
{
    NSTimeInterval selfTimeInterval = [self timeIntervalSince1970];
    NSTimeInterval startTimeInterval = [startDate timeIntervalSince1970];
    NSTimeInterval endtTimeInterval = [endDate timeIntervalSince1970];
    
    if (selfTimeInterval >= startTimeInterval&&selfTimeInterval<=endtTimeInterval) {
        return YES;
    }
    return NO;
}

/**
 判断时间是否超过N天了
 date01：需要判断的日期
 */
+ (BOOL)isDate:(NSDate*)date01 beforeNDays:(NSUInteger)days{
    NSDate *dateNow = [NSDate date];
    NSTimeInterval cha = [dateNow timeIntervalSinceDate:date01];
    if (cha>=60*60*24*days) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSDate *)exchangeToBeijingDate{
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: self];
    
    NSDate *localeDate = [self  dateByAddingTimeInterval:interval];
    
    return localeDate;
}

#pragma mark ==================================================
#pragma mark == 字符串方法
#pragma mark ==================================================
+ (NSString*)getStringWithFormatter:(NSString*)formatterString{
    if ((formatterString==nil) || ![formatterString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
    
    
    return nowDateString;
}

+ (NSDate*)getDateFromString:(NSString*)dateString formatterString:(NSString*)formatterString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSDate *returnDate = [formatter dateFromString:dateString];
    
    
    return returnDate;
}

+ (NSString*)getStringFromOldDateString:(NSString*)oldDateString
                       withOldFormatter:(NSString*)oldFormatterString
                           newFormatter:(NSString*)newFormatterString {
    
    if (oldDateString==nil || (![oldDateString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (oldFormatterString==nil || (![oldFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (newFormatterString==nil || (![newFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSDate *oldDate = [NSDate getDateFromString:oldDateString dateFormatter:oldFormatterString];
    
    NSString *returnString = [NSDate getStringFromDate:oldDate dateFormatter:newFormatterString];
    
    return returnString;
}

+ (NSString*)getStringFromDate:(NSDate*)date dateFormatter:(NSString*)formatterString{
    
    if (formatterString==nil || (![formatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (date==nil || (![date isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatterString];
    NSString *returnString = [formatter2 stringFromDate:date];
    
    return returnString;
}

+ (NSDate*)getDateFromString:(NSString*)string dateFormatter:(NSString*)formatterString{
    
    if (formatterString==nil || (![formatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (string==nil || (![string isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSDate *oldDate = [formatter dateFromString:string];
    
    
    return oldDate;
}

+ (BOOL)isString:(NSString*)date1String01 earlierThanString:(NSString*)date1String02 formatter01:(NSString*)formatter01 formatter02:(NSString*)formatter02{
    
    if (date1String01==nil || (![date1String01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (date1String02==nil || (![date1String02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter01==nil || (![formatter01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter02==nil || (![formatter02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatter01];
    NSDate *date1 = [formatter1 dateFromString:date1String01];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatter02];
    NSDate *date2 = [formatter2 dateFromString:date1String02];
    
    NSTimeInterval before = [date1 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [date2 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isDate:(NSDate*)date01 earlierThanDate:(NSDate*)date02{
    
    if (date01==nil || (![date01 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    NSTimeInterval before = [date01 timeIntervalSince1970]*1;
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isString:(NSString*)date1String01 earlierThanDate:(NSDate*)date02 formatter01:(NSString*)formatter01 {
    
    if (date1String01==nil || (![date1String01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter01==nil || (![formatter01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatter01];
    NSDate *date1 = [formatter1 dateFromString:date1String01];
    
    NSTimeInterval before = [date1 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (NSDate *)dateForTodayInClock:(NSInteger)clock
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour) fromDate:[NSDate date]];
    [todayComponents setHour:clock];
    NSDate *theDate = [gregorian dateFromComponents:todayComponents];
    return theDate;
}


- (NSString *)normalizeDateString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    if ([components day] >= 3) {
        return [NSDate getStringFromDate:self dateFormatter:@"yyyy-MM-dd"];
    } else if ([components day] >= 2) {
        return @"前天";
    } else if ([components day] >= 1) {
        return @"昨天";
    } else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%d小时前", (int)[components hour]];
    } else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%d分钟前", (int)[components minute]];
    } else if ([components second] > 0) {
        return [NSString stringWithFormat:@"%d秒前", (int)[components second]];
    } else {
        return @"刚刚";
    }
}

- (NSString *)normalizeDateString_houseFilter
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    if ([components day] >= 1) {
        return [NSDate getStringFromDate:self dateFormatter:@"yyyy.MM.dd更新"];
    } else if ([components hour] > 0) {
        return [NSString stringWithFormat:@"%d小时前更新", (int)[components hour]];
    } else if ([components minute] > 0) {
        return [NSString stringWithFormat:@"%d分钟前更新", (int)[components minute]];
    }else {
        return @"刚刚";
    }
}





@end
