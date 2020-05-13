//
//  HMActionSheet.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/7/2.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import "HMActionSheet.h"


@interface HMActionSheet () {
    
}
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,weak) id<HMActionSheetDelegate> delegate;


@end

@implementation HMActionSheet

- (instancetype)initWithDelegate:(id<HMActionSheetDelegate>)delegate otherButtonTitles:(NSArray *)otherButtonTitles {
    if (self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.2f];
        self.clipsToBounds = YES;
        _delegate = delegate;
        
        [self initSubviewWithTitles:otherButtonTitles];
        
    }
    return self;
}

- (void)initSubviewWithTitles:(NSArray *)titles{
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = self.bounds;
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    
    
    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backView];
    
    for (NSInteger i=0; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 44*i, SCREEN_WIDTH, 44);
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.tag = 20000+i;
        [_backView addSubview:button];
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(0, 43.5+44*i, SCREEN_WIDTH, 0.5);
        line.backgroundColor = RGB_COLOR_String(@"E7E7E7");
        [_backView addSubview:line];
    }
    
    _backView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, 44*titles.count);
    [self addSubview:_backView];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setOriginY:self.height];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_backView setOriginY:self.height-_backView.height];
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

- (void)show{
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    
    [self showInView:window];
}

- (void)buttonClick:(UIButton *)button{
    NSInteger index = button.tag - 20000;
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:index];
    }
    
    [self dismiss];
}


@end
