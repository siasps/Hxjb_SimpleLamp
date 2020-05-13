//
//  UILabel+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-12-14.
//  Copyright (c) 2012年 ibm. All rights reserved.
//

#import "UILabel+KIAdditions.h"

@implementation UILabel (KIAdditions)

- (CGFloat)getWidth{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font}context:nil].size;
    //[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.width;
}

- (CGFloat)getHeight{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font}context:nil].size;
    
    //[self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.height;
}


@end
