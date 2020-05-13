//
//  HMTextField.m
//  HuaxiaMerchant
//
//  Created by Huamo on 15/11/26.
//  Copyright © 2015年 Huamo. All rights reserved.
//

#import "HMTextField.h"

@implementation HMTextField


////控制文本所在的的位置，左右缩 10
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 5, 0);
//}
//
////控制编辑文本时所在的位置，左右缩 10
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 5, 0);
//}

//可输入的字符的区域

-(CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super textRectForBounds:bounds];
    
    if (self.leftView ==nil) {
        
        return CGRectInset(textRect, 5,1);
        
    }
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =40;
    
    textRect.size.width = textRect.size.width - offset - 5;
    
    return textRect;
    
}



//编辑显示的区域

-(CGRect)editingRectForBounds:(CGRect)bounds{
    
    CGRect textRect = [super editingRectForBounds:bounds];
    
    if (self.leftView ==nil) {
        
        return CGRectInset(textRect, 5,1);
        
    }
    
    CGFloat offset =40 - textRect.origin.x;
    
    textRect.origin.x =40;
    
    textRect.size.width = textRect.size.width - offset - 5;
    
    return textRect;
    
}



@end
