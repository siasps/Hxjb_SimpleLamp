//
//  NSMutableDictionary+KIAdditions.m
//  HBNCW
//
//  Created by chen on 13-10-24.
//  Copyright (c) 2013年 杨烽. All rights reserved.
//

#import "NSMutableDictionary+KIAdditions.h"

@implementation NSMutableDictionary (KIAdditions)

- (void)setBoolValue:(BOOL)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setIntValue:(int)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setIntegerValue:(NSInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)setUIntegerValue:(NSUInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:key];
}

- (void)setFloatValue:(CGFloat)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setDoubleValue:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

@end
