//
//  HMHomeViewController.m
//  SimpleLamp
//
//  Created by chen on 2020/5/12.
//  Copyright © 2020 chen. All rights reserved.
//

#import "HMHomeViewController.h"

@interface HMHomeViewController () <UIScrollViewDelegate> {
    
}
@property (nonatomic,strong) UIView *tabSelectedView;
@property (nonatomic,assign) NSInteger tabSelectedIndex;

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIView *attentionView;
@property (nonatomic,strong) UIView *discoveryView;
@property (nonatomic,strong) UIView *latestView;
@property (nonatomic,strong) UIView *talentView;

@end

@implementation HMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    [self initTabSelectedView];
    
    [self initMianScrollView];
    
}

#pragma mark - tab select view

- (void)initTabSelectedView{
    _tabSelectedView = [[UIView alloc]init];
    _tabSelectedView.frame = CGRectMake(60, 0, SCREEN_WIDTH-120, 45);
    _tabSelectedView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = _tabSelectedView;
    
    
//    UIView *line = [[UIView alloc]init];
//    line.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5f);
//    line.backgroundColor = TableSeparatorLineColor;
//    [_tabSelectedView addSubview:line];
    
    CGFloat width = (_tabSelectedView.width)/4.0f;
    for (NSInteger i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:TextColor_3 forState:UIControlStateNormal];
        [button setTitleColor:TextColor_1 forState:UIControlStateSelected];
        button.tag = 600+i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.frame = CGRectMake(width*i, 0, width, 45);
        [_tabSelectedView addSubview:button];
        
        if (i==0) {
            [button setTitle:@"关注" forState:UIControlStateNormal];
            
        }else if (i==1){
            button.selected = YES;
            [button setTitle:@"发现" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:17];
            
            UIView *slideView = [[UIView alloc]init];
            slideView.frame = CGRectMake(width*i+(width-60)/2.0, 43, 60, 2.0);
            slideView.backgroundColor = TextColor_yellow;
            slideView.tag = 605;
            [_tabSelectedView addSubview:slideView];
        }else if (i == 2){
            [button setTitle:@"最新" forState:UIControlStateNormal];
            
        }else if (i == 3){
            [button setTitle:@"达人" forState:UIControlStateNormal];
            
        }
        
    }
    
    [self moveSlideViewWithIndex:1];
}

- (void)titleButtonClick:(UIButton *)button{
    UIButton *button1 = (UIButton *)[_tabSelectedView viewWithTag:600];
    UIButton *button2 = (UIButton *)[_tabSelectedView viewWithTag:601];
    UIButton *button3 = (UIButton *)[_tabSelectedView viewWithTag:602];
    UIButton *button4 = (UIButton *)[_tabSelectedView viewWithTag:603];
    button1.selected = NO;
    button2.selected = NO;
    button3.selected = NO;
    button4.selected = NO;
    button.selected = YES;
    

    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    button3.titleLabel.font = [UIFont systemFontOfSize:14];
    button4.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    if (button1.selected) {
        [self moveSlideViewWithIndex:0];
        
        self.tabSelectedIndex = 0;
    }else if (button2.selected){
        [self moveSlideViewWithIndex:1];
        
        self.tabSelectedIndex = 1;
    }else if (button3.selected){
        [self moveSlideViewWithIndex:2];
        
        self.tabSelectedIndex = 2;
        
    }else if (button4.selected){
        [self moveSlideViewWithIndex:3];
        
        self.tabSelectedIndex = 3;
        
    }else{
        
    }
    
}

- (void)moveSlideViewWithIndex:(NSInteger)index{
    _tabSelectedIndex = index;
    
    
    UIView *slideView = (UIView *)[_tabSelectedView viewWithTag:605];
    UIButton *button = (UIButton *)[_tabSelectedView viewWithTag:600+index];
    [UIView animateWithDuration:0.3 animations:^{
        
        [slideView setOriginX:button.width*index+(button.width-60)/2.0];
        self->_mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
        
    } completion:^(BOOL finished) {
        
//        if (index == 0) {
//            //[_attentionView refrushData];
//        }else if (index == 1) {
//            [_discoveryView refrushData];
//        }else if (index == 2) {
//            [_refundView refrushData];
//        }
    }];
}


#pragma mark - scroll view

- (void)initMianScrollView
{
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, CGRectGetMaxY(_tabSelectedView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_TOP_HEIGHT -CGRectGetMaxY(_tabSelectedView.frame));
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, _mainScrollView.height);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.scrollEnabled = NO;
    _mainScrollView.clipsToBounds = NO;
    
//    _allView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _mainScrollView.height) type:0];
//    [_mainScrollView addSubview:_allView];
//
//
//    _nouseView = [[HMPayCouponListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainScrollView.height) type:1];
//    [_mainScrollView addSubview:_nouseView];
//
//    _refundView = [[HMPayCouponListView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, _mainScrollView.height) type:2];
//    [_mainScrollView addSubview:_refundView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}




@end
