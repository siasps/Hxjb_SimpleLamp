//
//  NSNumber+KIAdditions.h
//  ProjectK
//
//  Created by beartech on 14-9-9.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark ==================================================
#pragma mark ==NSNumber
#pragma mark ==================================================
@interface NSNumber (KIAdditions)

//产生>= from 小于to 的随机数
+(NSInteger)randomIntegerBetween:(int)from and:(int)to;


/*是否是整数*/
- (BOOL)isInt;

/*是否是整数*/
- (BOOL)isInteger;

/*是否是浮点数*/
- (BOOL)isFloat;

/*是否是高精度浮点数*/
- (BOOL)isDouble;


@end
