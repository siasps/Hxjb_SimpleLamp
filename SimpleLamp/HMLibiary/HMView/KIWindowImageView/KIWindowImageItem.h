//
//  KIWindowImageItem.h
//  Test
//
//  Created by Huamo on 16/6/22.
//  Copyright © 2016年 Huamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIWindowImageItem : UIScrollView{
    
}
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger page;



- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage;


@end
