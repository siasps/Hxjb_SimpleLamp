//
//  NSDictionary+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-11-28.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KIAdditions)

- (NSString *)jsonString;

- (BOOL)boolValueForKey:(id)key;

- (int)intValueForKey:(id)key;

- (NSInteger)integerValueForKey:(id)key;

- (float)floatValueForKey:(id)key;

- (double)doubleValueForKey:(id)key;

- (NSString *)stringValueForKey:(id)key;

- (id)valueObjectForKey:(id)aKey;

@end
