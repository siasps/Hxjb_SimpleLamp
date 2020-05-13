//
//  HMDataPicker.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/10/10.
//  Copyright © 2015年 HuaMo. All rights reserved.
//

#import "HMDataPicker.h"


@interface HMDataPicker () <UIPickerViewDataSource, UIPickerViewDelegate>{
    
}
@property (nonatomic,weak) id<HMDataPickerDelegate> delegate;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *pickerBackView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSDictionary *selectedDict;
@property (nonatomic,strong) NSDictionary *tempDict;
@property (nonatomic,strong) NSString *jsonNode;
@property (nonatomic,strong) UILabel *titleLabel;

@end



@implementation HMDataPicker


- (id)initWithDelegate:(id<HMDataPickerDelegate>)delegate dataDict:(NSDictionary *)dataDict selectedDict:(NSDictionary *)selectedDict jsonNode:(NSString *)jsonNode{
    if (self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        _delegate = delegate;
        
        _dataDict = [[NSDictionary alloc]initWithDictionary:dataDict];
        _dataArray = [[NSArray alloc]initWithArray:[dataDict valueObjectForKey:@"item_data"]];
        _selectedDict = selectedDict;
        _jsonNode = jsonNode;
        
        [self customInit];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)customInit{
    
    
    
    _backView = [[UIView alloc] init];
    _backView.frame = [[UIScreen mainScreen] bounds];
    _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    
    UIButton *disButton = [UIButton buttonWithType:UIButtonTypeCustom];
    disButton.frame = _backView.bounds;
    [disButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:disButton];
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60 + 246+SCREEN_BOTTOM_HEIGHT);
    backView.backgroundColor = [UIColor whiteColor];
    //backView.center = _backView.center;
    [_backView addSubview:backView];
    _pickerBackView = backView;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    headerView.backgroundColor = RGB_COLOR_String(@"#EDEEEF");
    [backView addSubview:headerView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    lineView.backgroundColor = RGB_COLOR_String(@"#DCDDDE");
    [backView addSubview:lineView];

    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(30, 10, backView.frame.size.width-60, 40);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16];
    [backView addSubview:titleLab];
    titleLab.text = [NSString stringWithFormat:@"请选择%@", [_dataDict stringValueForKey:@"item_name"]];
    _titleLabel = titleLab;
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 60);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:TextColor_red forState:UIControlStateNormal];
    button.tag = 100;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.tag = 1;
    pickView.frame = CGRectMake(0, 60, backView.frame.size.width, 206);
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = RGB_COLOR_String(@"f0f0f0");
    pickView.showsSelectionIndicator=YES;
    [backView addSubview:pickView];
    pickView.userInteractionEnabled = _dataArray.count>0;
    _pickerView = pickView;
    
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.frame = CGRectMake(backView.frame.size.width/2, 40+pickView.height, 0.5, 40);
//    lineView.backgroundColor = RGB_COLOR_String(@"f0f0f0");
//    [backView addSubview:lineView];
//
//    NSArray *array = [[NSArray alloc] initWithObjects:@"取消",@"确定", nil];
//    for (int i = 0; i < 2; i++) {
//        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0+backView.frame.size.width/2*i, 40+pickView.height, backView.frame.size.width/2, 40);
//        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
//        [button setTitleColor:RGB_COLOR_String(@"#CB0202") forState:UIControlStateNormal];
//        button.tag = i + 100;
//        [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
//        [backView addSubview:button];
//    }
    [_pickerBackView setHeight:40+pickView.height+SCREEN_BOTTOM_HEIGHT];
    
    
    if (_selectedDict) {
        _tempDict = _selectedDict;
        for (NSInteger i=0; i<_dataArray.count; i++) {
            NSDictionary *dict = [_dataArray objectAtIndex:i];
            
            if ([[dict stringValueForKey:_jsonNode] isEqualToString:[_tempDict stringValueForKey:_jsonNode]]) {
                [pickView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
        
    }else{
        if (_dataArray.count > 0)
            _tempDict = [_dataArray objectAtIndex:0];
    }
}

-(void)buttonClick1:(UIButton*)sender{
    if (_tempDict && _delegate && [_delegate respondsToSelector:@selector(dataPicker:selectedDict:)]) {
        [_delegate dataPicker:self selectedDict:_tempDict];
    }
    
    
    [self dismissPicker];
    
}

- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self->_pickerBackView setOriginY:SCREEN_HEIGHT - (40 + _pickerView.height + SCREEN_BOTTOM_HEIGHT)];
    }];
}

- (void)dismissPicker{
    [UIView animateWithDuration:0.3 animations:^{
        [self->_pickerBackView setOriginY:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *dic = [_dataArray objectAtIndex:row];
    NSString *brandAddressStr = [dic objectForKey:_jsonNode];
    
    return brandAddressStr;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent: (NSInteger) component
{
    return 50;
}

-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component{
    
    _tempDict = [_dataArray objectAtIndex:row];
}



@end
