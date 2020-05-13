//
//  HMRadioView.h
//  Homesick
//
//  Created by Huamo on 16/4/27.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HMRadioViewDelegate ;

@interface HMRadioView : UIView{
    
}
@property (nonatomic,weak) id<HMRadioViewDelegate> delegate;

- (id)init;
- (id)initWithFrame:(CGRect)frame;

- (void)reloadDataWithIndex:(NSInteger)index;

-(void)showDataWithIndex:(NSInteger)index;//显示，没点亮的star隐藏

- (NSInteger)getLevel;

@end


@protocol HMRadioViewDelegate <NSObject>

- (void)radioView:(HMRadioView *)radioView selectedIndex:(NSInteger)selectedIndex;

@end
