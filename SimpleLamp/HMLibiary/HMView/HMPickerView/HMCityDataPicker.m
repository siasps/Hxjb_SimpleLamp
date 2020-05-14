//
//  HMCityDataPicker.m
//  XJMerchant
//
//  Created by Huamo on 16/8/26.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import "HMCityDataPicker.h"
#import "HMLocalCityManager.h"


@interface HMCityDataPicker() <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    NSInteger _currentFSelectedRow;
    NSInteger _currentSSelectedRow;
    NSInteger _currentTSelectedRow;
}
@property (nonatomic,weak) id<HMCityDataPickerDelegate> delegate;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSMutableArray *provinceArray;
@property (nonatomic,strong) NSMutableArray *cityArray;
@property (nonatomic,strong) NSMutableArray *areaArray;

@property (strong, nonatomic) HMProvinceModel *province;
@property (strong, nonatomic) HMCityModel *city;
@property (strong, nonatomic) HMAreaModel *area;

@end



@implementation HMCityDataPicker

- (id)initWithDelegate:(id<HMCityDataPickerDelegate>)delegate province:(HMProvinceModel *)province city:(HMCityModel *)city area:(HMAreaModel *)area{
    if (self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _delegate = delegate;
        
        
        [self customInit];
        
        if (province && city && area) {
            self.province = province;
            self.cityArray=[self.province citys];
            
            self.city = city;
            self.areaArray =[self.city areas];
            
            self.area = area;
            
        }
        [self initCityXMLParseData];
        
        [self loadCityData];
        
    }
    return self;
}


- (void)show{
    
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    [window addSubview:self];
    
    [_backView setOriginY:SCREEN_HEIGHT];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView setOriginY:SCREEN_HEIGHT-SCREEN_BOTTOM_HEIGHT-40-216];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissPicker{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.backView setOriginY:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
    
    
}


#pragma mark - init subviews

- (void)customInit{
    
    
    UIButton *disButton = [UIButton buttonWithType:UIButtonTypeCustom];
    disButton.frame = self.bounds;
    [disButton addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:disButton];
    
    
    _backView = [[UIView alloc] init];
    _backView.frame = CGRectMake(0, SCREEN_HEIGHT-SCREEN_BOTTOM_HEIGHT-216-40, SCREEN_WIDTH, 216+40);
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    
    
    UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40, SCREEN_WIDTH,216)];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = RGB_COLOR_String(@"f0f0f0");
    pickView.showsSelectionIndicator=YES;
    [_backView addSubview:pickView];
    _pickerView = pickView;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headerView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:headerView];
    headerView.layer.masksToBounds = YES;
    headerView.layer.borderColor = TableSeparatorLineColor.CGColor;
    headerView.layer.borderWidth = 0.5f;
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, 0, headerView.frame.size.width, 40);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    titleLab.text = @"请选择城市";
    [headerView addSubview:titleLab];
    
    
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"取消",@"确定", nil];
    for (int i = 0; i < 2; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:RGB_COLOR_String(@"d80c18") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        if (i == 0) {
            
            button.frame = CGRectMake(15, 0, 60, 40);
        }else{
            
            button.frame = CGRectMake(SCREEN_WIDTH-75, 0, 60, 40);
        }
    }
    
    
    
}


-(void)buttonClick1:(UIButton*)sender{
    NSInteger buttonTag = sender.tag - 100;
    
    if (buttonTag == 0) {
        //
        //        if (_province && _city && _area && [_delegate respondsToSelector:@selector(cityDataPicker:province:city:area:)]) {
        //            [_delegate cityDataPicker:self province:_province city:_city area:_area];
        //        }
    }else{
        
        if (_province && _city && _area && [_delegate respondsToSelector:@selector(cityDataPicker:province:city:area:)]) {
            [_delegate cityDataPicker:self province:_province city:_city area:_area];
        }
    }
    
    
    [self dismissPicker];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.textColor = TextColor_1;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    
    switch (component) {
        case 0:
        {
            pickerLabel.text = [[self.provinceArray objectAtIndex:row] name];
        }
            break;
        case 1:
        {
            pickerLabel.text = [[self.cityArray objectAtIndex:row] name];
        }
            break;
        case 2:
        {
            pickerLabel.text = [[self.areaArray objectAtIndex:row] name];
        }
            break;
            
        default:
            break;
    }
    
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            
            return [self.provinceArray count];
        }
            break;
        case 1:
        {
            return [self.cityArray count];
        }
            break;
        case 2:
        {
            
            return [self.areaArray count];
        }
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            return [[self.provinceArray objectAtIndex:row] name];
        }
            break;
        case 1:
        {
            return [[self.cityArray objectAtIndex:row] name];
        }
            break;
        case 2:
        {
            return [[self.areaArray objectAtIndex:row] name];
        }
            break;
            
        default:
            break;
    }
    
    return @"";
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent: (NSInteger) component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            _currentFSelectedRow =row;
            self.province =[_provinceArray objectAtIndex:row];
            self.cityArray=[self.province citys];
            self.city =self.cityArray[0];
            _areaArray =[[_cityArray objectAtIndex:0] areas];
            self.area = _areaArray[0];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            _areaArray =[[_cityArray objectAtIndex:0] areas];
            
            _currentSSelectedRow=_currentTSelectedRow=0;
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
        }
            break;
        case 1:
        {
            _currentSSelectedRow=row;
            self.city=[_cityArray objectAtIndex:_currentSSelectedRow];
            _areaArray=[self.city areas];
            _area=_areaArray[0];
            
            _currentTSelectedRow=0;
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
            break;
        case 2:
        {
            _currentTSelectedRow=row;
            self.area = [_areaArray objectAtIndex:_currentTSelectedRow];
            _area=[_areaArray objectAtIndex:row];
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - city data

-(void)initCityXMLParseData{
    
    NSArray *allProvinceArr = [[[HMCityDataManager shareCityDataManager] getCityList] yy_modelDataForArray];
    
    
    _provinceArray = [allProvinceArr mutableCopy];
    
    if (!_province || !_city || !_area) {
        for (HMProvinceModel *node in _provinceArray) {
            //默认选择上海市
            if ([node.code isEqualToString:@"10"]) {
                self.province = node;
                break;
            }
        }
        
        if (!self.province) {
            self.province = [_provinceArray firstObject];
        }
        
        self.cityArray=[self.province citys];
        self.city =self.cityArray[0];
        
        _areaArray =[[_cityArray objectAtIndex:0] areas];
        self.area = _areaArray[0];
    }else{
        for (HMProvinceModel *node in _provinceArray) {
            if ([node.code isEqualToString:_province.code]) {
                self.province = node;
                break;
            }
        }
        
        
        self.cityArray=[self.province citys];
        for (HMCityModel *node in _cityArray) {
            if ([node.code isEqualToString:_city.code]) {
                self.city = node;
                break;
            }
        }
        
        self.areaArray = _city.areas;
        for (HMAreaModel *node in _areaArray) {
            if ([node.code isEqualToString:_area.code]) {
                self.area = node;
                break;
            }
        }
    }
    
}

- (void)loadCityData{
    
    NSInteger provinceSelectedRow = 0;
    for (NSInteger i=0; i<_provinceArray.count; i++) {
        HMProvinceModel *node = [_provinceArray objectAtIndex:i];
        
        if ([node.name isEqualToString:_province.name]) {
            provinceSelectedRow = i;
            break;
        }
    }
    NSInteger citySelectedRow = 0;
    for (NSInteger i=0; i<_cityArray.count; i++) {
        HMCityModel *node = [_cityArray objectAtIndex:i];
        
        if ([node.name isEqualToString:_city.name]) {
            citySelectedRow = i;
            break;
        }
    }
    NSInteger areaSelectedRow = 0;
    for (NSInteger i=0; i<_areaArray.count; i++) {
        HMAreaModel *node = [_areaArray objectAtIndex:i];
        
        if ([node.name isEqualToString:_area.name]) {
            areaSelectedRow = i;
            break;
        }
    }
    
    
    if (!_province || !_city || !_area){
        provinceSelectedRow = citySelectedRow = areaSelectedRow = 0;
    }
    
    [_pickerView selectRow:provinceSelectedRow inComponent:0 animated:YES];
    [_pickerView selectRow:citySelectedRow inComponent:1 animated:YES];
    [_pickerView selectRow:areaSelectedRow inComponent:2 animated:YES];
    
    
}

@end
