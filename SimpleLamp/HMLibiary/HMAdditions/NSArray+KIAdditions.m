//
//  NSArray+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-11-29.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import "NSArray+KIAdditions.h"

@implementation NSArray (KIAdditions)

- (NSString *)jsonString{
    if (!self || self.count<=0) {
        //NSLog(@"数组为空！");
        return @"";
    }
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        //NSLog(@"NSArray JSONString error: %@", [error localizedDescription]);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
