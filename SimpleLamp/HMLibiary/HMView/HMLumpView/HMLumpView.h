//
//  HMLumpView.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/8/18.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMLumpView : UIView

@property (nonatomic,assign) NSInteger limitNum;  //单行显示的状态：最多显示个数

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

- (void)reloadWithDataArray:(NSArray *)dataArray viewWidth:(CGFloat)viewWidth;

+ (CGFloat)getHeight:(NSArray *)dataArray viewWidth:(CGFloat)viewWidth;

//注意：只有一行的情况
+ (CGFloat)getWidth:(NSArray *)dataArray;


@end
