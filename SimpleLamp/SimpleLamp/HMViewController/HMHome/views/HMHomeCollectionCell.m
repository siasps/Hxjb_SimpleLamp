//
//  HMHomeCollectionCell.m
//  SimpleLamp
//
//  Created by chen on 2020/5/14.
//  Copyright © 2020 chen. All rights reserved.
//

#import "HMHomeCollectionCell.h"

@implementation HMHomeCollectionCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        
        [self initSubviews];
    }
    return self;
}



- (void)initSubviews{
    
    
    
}

@end




@implementation HMHomeCollectionAdCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
        
        [self initSubviews];
    }
    return self;
}

- (NSString *)gettImageString:(NSDictionary*)information{
    CGFloat width = [[information stringValueForKey:@"width"] integerValue];
    CGFloat height = [[information stringValueForKey:@"height"] integerValue];
    NSString *image_url = [information stringValueForKey:@"banner_img"];
    
    if (width > HomeCollectionCell_width*[UIScreen mainScreen].scale) {
        CGFloat scale = HomeCollectionCell_width*[UIScreen mainScreen].scale / width;
        
        width = HomeCollectionCell_width*[UIScreen mainScreen].scale;
        height = height * scale;
        
        if (SCREEN_WIDTH<= 320) {
            width = width/2.0f;
            height = height/2.0f;
        }
        
        image_url = [NSString stringWithFormat:@"%@?imageView2/2/w/%.0f/h/%.0f", image_url, width, height];
    }
    
    return image_url;
}

- (void)reloadWithInformation:(NSDictionary*)information{
    CGFloat width = [[information stringValueForKey:@"width"] integerValue];
    CGFloat height = [[information stringValueForKey:@"height"] integerValue];
    NSString *image_url = [self gettImageString:information];
    
    CGFloat actualHeight = 0;
    if (width==0 || height==0) {
        actualHeight = HomeCollectionCell_width;
    }else{
        actualHeight = (HomeCollectionCell_width * height)/width;
    }
    
    [_bigImage setHeight:actualHeight];
    [_bigImage sd_setImageWithURL:[NSURL URLWithString:image_url] placeholderImage:nil];
    
}

- (void)initSubviews{
    
    _bigImage = [[UIImageView alloc]init];
    _bigImage.frame = CGRectMake(0, 0, HomeCollectionCell_width, HomeCollectionCell_width);
    [self addSubview:_bigImage];
    
}


@end






