//
//  UIImage+blur.h
//  Huaxiajiabo
//
//  Created by Huamo on 16/7/21.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef YY_SWAP // swap two value
#define YY_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


@interface UIImage (blur)

- (UIImage *)imageByBlurDark;

@end
