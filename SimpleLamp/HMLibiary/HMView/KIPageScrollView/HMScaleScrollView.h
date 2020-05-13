//
//  HMScaleScrollView.h
//  kitest
//
//  Created by Huamo on 2018/5/28.
//  Copyright © 2018年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMScaleScrollViewDelegate ;

@interface HMScaleScrollView : UIView{
    
}

- (instancetype)initWithDelegate:(id<HMScaleScrollViewDelegate>)delegate frame:(CGRect)frame;

- (void)reloadWithDataArray:(NSArray *)array;


@end


@protocol HMScaleScrollViewDelegate <NSObject>

-(void)scaleScrollView:(HMScaleScrollView *)scaleScrollView viewHeight:(CGFloat)height pageIndex:(NSInteger)pageIndex;

@end
