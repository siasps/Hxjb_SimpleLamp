//
//  KIWindowImageView.h
//  Test
//
//  Created by Huamo on 16/6/22.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifndef YY_CLAMP // return the clamped value
#define YY_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#define KIWindowImageView_URL @"URLString"
#define KIWindowImageView_PlaceHolderImage @"PlaceHolderImage"

@interface KIWindowImageView : UIView{
    
}

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect showCurrentIndex:(BOOL)currentBool;

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView showCurrentIndex:(BOOL)currentBool;

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect;

+ (void)showWithImageArray:(NSArray*)aImageArray selectedIndex:(NSInteger)index originRect:(CGRect)originRect groupsView:(UIView *)groupsView;

@end
