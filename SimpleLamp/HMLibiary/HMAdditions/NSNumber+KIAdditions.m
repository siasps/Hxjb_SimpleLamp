//
//  NSNumber+KIAdditions.m
//  ProjectK
//
//  Created by beartech on 14-9-9.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "NSNumber+KIAdditions.h"

#pragma mark ==================================================
#pragma mark ==NSNumber
#pragma mark ==================================================
@implementation NSNumber (KIAdditions)

//产生>= from 小于to 的随机数
+(NSInteger)randomIntegerBetween:(int)from and:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

/*是否是整数*/
- (BOOL)isInt{
    if (strcmp([self objCType], @encode(int)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}


/*是否是整数*/
- (BOOL)isInteger{
    if (strcmp([self objCType], @encode(long)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)isFloat{
    if (strcmp([self objCType], @encode(float)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是高精度浮点数*/
- (BOOL)isDouble{
    if (strcmp([self objCType], @encode(double)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

@end

