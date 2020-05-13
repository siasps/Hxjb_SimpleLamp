//
//  HMLumpView.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/8/18.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import "HMLumpView.h"

#define Default_font    [UIFont systemFontOfSize:9]
#define Default_height  16.0f
#define DefaultLabel_tag   5999


@interface HMLumpView () {
    
}
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) CGFloat viewWidth;
@property (nonatomic,strong) NSMutableArray *labelArray;

@end


@implementation HMLumpView

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray{
    if (self = [super initWithFrame:frame]) {
        
        _limitNum = -1;
        _dataArray = [[NSArray alloc]initWithArray:dataArray];
        _viewWidth = frame.size.width;
        _labelArray = [[NSMutableArray alloc]init];
        
        [self initSubview];
    }
    return self;
}

- (void)reloadWithDataArray:(NSArray *)dataArray viewWidth:(CGFloat)viewWidth{
    //处理空字符串
    NSMutableArray *notEmptyArr = [[NSMutableArray alloc]init];
    for (NSString *string in dataArray) {
        if ([string isNotEmpty]) {
            [notEmptyArr addObject:string];
        }
    }
    _dataArray = [[NSArray alloc]initWithArray:notEmptyArr];
    _viewWidth = viewWidth;
    
    
    [self initSubview];
}

+ (CGFloat)getHeight:(NSArray *)dataArray viewWidth:(CGFloat)viewWidth{
    if (!dataArray || dataArray.count<=0) {
        return 0;
    }
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat space = 5.0f;
    for (NSInteger i=0; i<dataArray.count; i++) {
        
        NSString *text = [dataArray objectAtIndex:i];
        CGFloat sizeWidth = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, Default_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Default_font}context:nil].size.width+15;
        
        if (width + sizeWidth > viewWidth) {
            height += Default_height + space;
            
            
            width = 0;
        }
        width += sizeWidth + space;
        
    }
    height += 20+space;
    
    return height;
}

//注意：只有一行的情况
+ (CGFloat)getWidth:(NSArray *)dataArray{
    if (!dataArray || dataArray.count<=0) {
        return 0;
    }
    
    //过滤空字符串
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSString *string in dataArray) {
        if (string.length > 0) {
            [array addObject:string];
        }
    }
    
    CGFloat width = 0;
    CGFloat space = 5.0f;
    for (NSInteger i=0; i<array.count; i++) {
        
        NSString *text = [array objectAtIndex:i];
        CGFloat sizeWidth = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, Default_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Default_font}context:nil].size.width+15;
        
        width += sizeWidth + space;
        
    }
    
    return width;
}

- (void)initSubview{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
        view.tag = DefaultLabel_tag;
    }
    
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat space = 5.0f;
    for (NSInteger i=0; i<_dataArray.count; i++) {
        if (_limitNum >0) {
            if (i>=_limitNum) {
                return;
            }
        }
        
        UILabel *label = [self labelForIndex:i+1];
        if (!label) {
            label = [self dequeueReusableLabel];
            label.tag = DefaultLabel_tag+i+1;
            [self addSubview:label];
        }
        label.frame = CGRectMake(0, height, 30, Default_height);
        
        
        label.text = [_dataArray objectAtIndex:i];
        [label setWidth:[label getWidth]+15];
        if (width + label.width > _viewWidth) {
            height += label.height + space;
            
            [label setOriginY:height];
            
            width = 0;
        }
        [label setOriginX:width];
        width += label.width + space;
        
    }
    height += Default_height+space;
    
    [self setHeight:height];
}


- (UILabel *)dequeueReusableLabel {
    UILabel *label = nil;
    for (label in _labelArray) {
        if (!label.superview) {
            label.text = nil;
            return label;
        }
    }
    
    label = [[UILabel alloc]init];
    label.backgroundColor = RGB_COLOR_String(@"ffffff");
    label.layer.cornerRadius = 3.0f;
    label.layer.borderColor = RGB_COLOR_String(@"#F8999D").CGColor;
    label.layer.borderWidth = 1.0f;
    label.textColor = RGB_COLOR_String(@"#D41323");
    label.font = Default_font;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = DefaultLabel_tag;
    [_labelArray addObject:label];
    
    return label;
}

- (UILabel *)labelForIndex:(NSInteger)index {
    for (UILabel *label in _labelArray) {
        if (label.tag-DefaultLabel_tag-1 == index) {
            label.text = nil;
            return label;
        }
    }
    return nil;
}


@end
