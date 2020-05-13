//
//  HMRadioFloatView.m
//  XJMerchant
//
//  Created by Huamo on 16/9/9.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMRadioFloatView.h"

#define Button_tag   20000
#define ButtonH_tag  21000


@interface HMRadioFloatView (){
    
}
@property (nonatomic,strong) UIView *coverView;

@end

@implementation HMRadioFloatView

- (id)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 58, 10);
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
    }
    return self;
}


- (void)reloadDataWithIndex:(float)index{
    
    float disposeFloat = 0.f;
    int indexInt = index/1;
    float     decimals = index - indexInt;
    
    if (decimals < 0.5) {
        disposeFloat = indexInt +disposeFloat;
    }else{
        disposeFloat = indexInt +0.5f;

    }
    
    
    CGFloat width = CGRectGetHeight(self.frame);
    CGFloat jianju = (CGRectGetWidth(self.frame) - 5*width) / 4.0;
    
    [_coverView setWidth:(width*disposeFloat + (NSInteger)index*jianju)];
}



- (void)initUI{
    CGFloat width = CGRectGetHeight(self.frame);
    CGFloat jianju = (CGRectGetWidth(self.frame) - 5*width) / 4.0;
    
    for (NSInteger i = 0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((width + jianju)*i, 0, width, width);
        button.tag = Button_tag + i + 1;
        [button setBackgroundImage:[UIImage imageNamed:@"icon_score_star.png"] forState:UIControlStateNormal];
        [self addSubview:button];
        button.userInteractionEnabled = NO;
    }
    
    _coverView = [[UIView alloc]init];
    _coverView.frame = self.bounds;
    _coverView.backgroundColor = [UIColor clearColor];
    _coverView.clipsToBounds = YES;
    [self addSubview:_coverView];
    [_coverView setWidth:0];
    
    for (NSInteger i = 0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((width + jianju)*i, 0, width, width);
        button.tag = ButtonH_tag + i + 1;
        [button setBackgroundImage:[UIImage imageNamed:@"icon_score_starH.png"] forState:UIControlStateNormal];
        [_coverView addSubview:button];
        button.userInteractionEnabled = NO;
    }
    
}


@end
