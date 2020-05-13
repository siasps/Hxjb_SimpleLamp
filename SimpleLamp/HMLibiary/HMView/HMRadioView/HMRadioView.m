//
//  HMRadioView.m
//  Homesick
//
//  Created by Huamo on 16/4/27.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMRadioView.h"


#define Button_tag  20000


@interface HMRadioView (){
    
}


@end

@implementation HMRadioView

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


- (void)reloadDataWithIndex:(NSInteger)index{
    for(UIButton *button in self.subviews){
        if ([button isKindOfClass:[UIButton class]]) {
            NSInteger tag = button.tag - Button_tag; //从1开始
            if (tag <= index) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
    }
}

-(void)showDataWithIndex:(NSInteger)index{//显示，没点亮的star隐藏
    for(UIButton *button in self.subviews){
        if ([button isKindOfClass:[UIButton class]]) {
            NSInteger tag = button.tag - Button_tag; //从1开始
            if (tag <= index) {
                button.hidden = NO;
                button.selected = YES;
            }else{
                button.hidden = YES;
                button.selected = NO;
            }
        }
    }
}

- (NSInteger)getLevel{
    NSInteger level = 0;
    for(UIButton *button in self.subviews){
        if ([button isKindOfClass:[UIButton class]]) {
            NSInteger tag = button.tag - Button_tag; //从1开始
            if (button.selected) {
                if (tag > level) {
                    level =tag;
                }
            }
        }
    }
    
    return level;
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - Button_tag;
    
    [self reloadDataWithIndex:index];
    
    if (_delegate && [_delegate respondsToSelector:@selector(radioView:selectedIndex:)]) {
        [_delegate radioView:self selectedIndex:index];
    }
}

- (void)initUI{
    CGFloat width = CGRectGetHeight(self.frame);
    CGFloat jianju = (CGRectGetWidth(self.frame) - 5*width) / 4.0;
    
    for (NSInteger i = 0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((width + jianju)*i, 0, width, width);
        button.tag = Button_tag + i + 1;
        [button setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"starH.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}



@end
