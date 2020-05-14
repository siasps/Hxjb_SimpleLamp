//
//  AttendanceDatePickerView.m
//  ProjectK
//
//  Created by beartech on 14-1-3.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "HMDatePickerView.h"
#import "NSDate+KIAdditions.h"
#import "NSDateFormatter+KIAdditions.h"

@interface HMDatePickerView (){
    
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
}
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UILabel *titleL;

@property (nonatomic,retain) UILabel *yearLabel;
@property (nonatomic,retain) UIView *animationView;

@end

@implementation HMDatePickerView
@synthesize delegate = _delegate;
@synthesize datePicker;
@synthesize yearLabel;
@synthesize blackBackgroundButton = _blackBackgroundButton;
@synthesize animationView = _animationView;

#define PickerHeight 190

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _blackBackgroundButton = [[UIButton alloc]init];
        _blackBackgroundButton.frame = self.bounds;
        _blackBackgroundButton.alpha = 0;
        _blackBackgroundButton.backgroundColor = [UIColor blackColor];
        [_blackBackgroundButton addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_blackBackgroundButton];
        
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height+50, [UIApplication sharedApplication].keyWindow.frame.size.width, PickerHeight+50+SCREEN_BOTTOM_HEIGHT)];
        _animationView.backgroundColor = [UIColor whiteColor];
        _animationView.userInteractionEnabled = YES;
        [self addSubview:_animationView];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,50, [UIApplication sharedApplication].keyWindow.frame.size.width, PickerHeight)];
        [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        [datePicker setDate:[NSDate date]];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [_animationView addSubview:datePicker];
        
        [self setNavigationBarView];
    }
    return self;
}


- (void)singleTap{
    [self leftButtonClicked:nil];
}

- (void)setDate:(NSDate*)date{
    if ([NSDate isDate:date earlierThanDate:datePicker.minimumDate]) {
        return;
    }
    
    if ([NSDate isDate:datePicker.maximumDate earlierThanDate:date]) {
        return;
    }
    
    [datePicker setDate:date];
}


- (void)setNavigationBarView{
    
    //盛放按钮的View
    UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(datePicker.frame)-50, [UIApplication sharedApplication].keyWindow.frame.size.width, 50)];
    upVeiw.backgroundColor = [UIColor whiteColor];
    [_animationView addSubview:upVeiw];
    upVeiw.layer.borderWidth = 0.5f;
    upVeiw.layer.borderColor = TableSeparatorLineColor.CGColor;
    
    //左边的取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12, 0, 50, 50);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton setTitleColor:RGB_COLOR_String(@"0d8bf5") forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [upVeiw addSubview:cancelButton];
    
    //右边的确定按钮
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 62, 0, 50, 50);
    [chooseButton setTitle:@"完成" forState:UIControlStateNormal];
    chooseButton.backgroundColor = [UIColor clearColor];
    chooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [chooseButton setTitleColor:RGB_COLOR_String(@"0d8bf5") forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [upVeiw addSubview:chooseButton];
    
    self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(62, 10, SCREEN_WIDTH-124, 30)];
    [upVeiw addSubview:_titleL];
    _titleL.textColor = TextColor_2;
    _titleL.font = [UIFont systemFontOfSize:16];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.text = @"选择送货时间";
    
    //分割线
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 0.5)];
    splitView.backgroundColor = [UIColor lightTextColor];
    [upVeiw addSubview:splitView];
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        datePicker.backgroundColor = [UIColor whiteColor];
    }
    
}

- (void)changeDelegate:(id<HMDatePickerViewDelegate>)delegate{
    self.delegate = delegate;
    delegateClass = object_getClass(delegate);
}

- (void)datePickerValueChanged{
    [self reloadYearLabel:datePicker.date];
}

- (void)reloadYearLabel:(NSDate*)date{
    //    NSString *stringYM = [NSDate getStringFromDate:datePicker.date dateFormatter:KKDateFormatter05];
    NSString *stringYMD = [NSDate getStringFromDate:date dateFormatter:KKDateFormatter04];
    //    NSString *stringYMDH = [NSDate getStringFromDate:date dateFormatter:KKDateFormatter03];
    //    NSString *stringYMDHM = [NSDate getStringFromDate:date dateFormatter:KKDateFormatter02];
    //
    //    CGFloat HH = [[NSDate getStringFromDate:date dateFormatter:@"HH"] floatValue];
    //    CGFloat mm = [[NSDate getStringFromDate:date dateFormatter:@"mm"] floatValue];
    
    
    //    if (HH==0 && mm==0) {
    //        yearLabel.text = stringYMD;
    //        yearLabel.font = [UIFont boldSystemFontOfSize:24];
    //    }
    //    else if (mm==0 && HH!=0){
    //        yearLabel.text = stringYMDH;
    //        yearLabel.font = [UIFont boldSystemFontOfSize:22];
    //    }
    //    else{
    //        yearLabel.text = stringYMDHM;
    //        yearLabel.font = [UIFont boldSystemFontOfSize:20];
    //    }
    yearLabel.text = stringYMD;
    yearLabel.font = [UIFont boldSystemFontOfSize:24];
}

#pragma mark ==================================================
#pragma mark == 接口
#pragma mark ==================================================
+ (void)showInView:(UIView*)view delegate:(id<HMDatePickerViewDelegate>)delegate  minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate showDate:(NSDate *)showDate{
    
    HMDatePickerView *pickerView = [[HMDatePickerView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, view.frame.size.height)];
    pickerView.tag = 2006021272;
    if (minDate) {
        [pickerView.datePicker setMinimumDate:minDate];
    }
    if (maxDate) {
        [pickerView.datePicker setMaximumDate:maxDate];
    }
    if (showDate) {
        [pickerView.datePicker setDate:showDate];
    }
    [pickerView changeDelegate:delegate];
    [view addSubview:pickerView];
    [pickerView show];
}

+ (void)showWithDelegate:(id<HMDatePickerViewDelegate>)delegate minDate:(NSDate*)minDate maxDate:(NSDate*)maxDate showDate:(NSDate*)showDate{
    HMDatePickerView *pickerView = [[HMDatePickerView alloc]initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height)];
    pickerView.tag = 2006021272;
    if (minDate) {
        [pickerView.datePicker setMinimumDate:minDate];
    }
    if (maxDate) {
        [pickerView.datePicker setMaximumDate:maxDate];
    }
    if (showDate) {
        [pickerView.datePicker setDate:showDate];
    }
    [pickerView changeDelegate:delegate];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:pickerView];
    [window bringSubviewToFront:pickerView];
    
    [pickerView show];
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self->_blackBackgroundButton.alpha = 0.3;
        self->_animationView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_BOTTOM_HEIGHT-PickerHeight-50, SCREEN_WIDTH, PickerHeight+50+SCREEN_BOTTOM_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ==================================================
#pragma mark == PickerViewDelegate
#pragma mark ==================================================
- (void)leftButtonClicked:(id)sender{
    Class currentClass = object_getClass(self.delegate);
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(dismissDataPickerView)]) {
        [self.delegate dismissDataPickerView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackBackgroundButton.alpha = 0;
        self.animationView.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)rightButtonClicked:(id)sender{
    Class currentClass = object_getClass(self.delegate);
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(dismissDataPickerView)]) {
        [self.delegate dismissDataPickerView];
    }
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(doneWithDate:)]) {
        [self.delegate doneWithDate:datePicker.date];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackBackgroundButton.alpha = 0;
        self.animationView.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
