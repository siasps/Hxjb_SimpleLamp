//
//  NSDateFormatter+KIDateFormatter.h
//  Kitalker
//
//  Created by chen on 12-8-23.
//
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (KIAdditions)

+ (NSString *)dateStringWithFormat:(NSString *)format date:(NSDate *)date;

- (NSString *)weekday:(NSDate *)date;

- (NSString *)day:(NSDate *)date;

- (NSString *)month:(NSDate *)date;

- (NSString *)year:(NSDate *)date;

- (NSString *)dateStringWithFormat:(NSString *)format date:(NSDate *)date;

@end
