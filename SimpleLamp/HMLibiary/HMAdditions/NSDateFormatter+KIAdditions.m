//
//  NSDateFormatter+KIDateFormatter.m
//  Kitalker
//
//  Created by chen on 12-8-23.
//
//

#import "NSDateFormatter+KIAdditions.h"

@implementation NSDateFormatter (KIAdditions)

+ (NSString *)dateStringWithFormat:(NSString *)format date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString *)weekday:(NSDate *)date {
    [self setDateFormat:@"c"];
    return [self stringFromDate:date];
}

- (NSString *)day:(NSDate *)date {
    [self setDateFormat:@"d"];
    return [self stringFromDate:date];
}

- (NSString *)month:(NSDate *)date {
    [self setDateFormat:@"M"];
    return [self stringFromDate:date];
}

- (NSString *)year:(NSDate *)date {
    [self setDateFormat:@"y"];
    return [self stringFromDate:date];
}

- (NSString *)dateStringWithFormat:(NSString *)format date:(NSDate *)date {
    [self setDateFormat:format];
    return [self stringFromDate:date];
}

@end
