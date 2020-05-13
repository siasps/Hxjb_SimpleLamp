//
//  UITableViewCell+KIAdditions.m
//  Kitalker
//
//  Created by chen on 13-4-13.
//
//

#import "UITableViewCell+KIAdditions.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString * const kIndexPathKey = @"kIndexPathKey";

@implementation UITableViewCell (KIAdditions)

- (void)setBackgroundImage:(UIImage *)image {
    [self setBackgroundViewImage:image];
}

- (void)setBackgroundViewColor:(UIColor *)color {
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    if (self.backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [backgroundView setOpaque:YES];
        [self setBackgroundView:backgroundView];
    }
    [self.backgroundView setBackgroundColor:color];
}

- (void)setBackgroundViewImage:(UIImage *)image  {
    if (image == nil) {
        [self setBackgroundViewColor:nil];
        return ;
    }
    
    if (![self.backgroundView isKindOfClass:[UIImageView class]]) {
        [self.backgroundView removeFromSuperview];
    }
    
    UIImageView *imageView = (UIImageView *)[self backgroundView];
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self setBackgroundView:imageView];
    }
    
    [imageView setImage:image];
}

- (void)setSelectedBackgroundViewColor:(UIColor *)color {
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [selectedBackgroundView setOpaque:YES];
    [selectedBackgroundView setBackgroundColor:color];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
}

- (void)setSelectedBackgroundViewImage:(UIImage *)image {
    if (image == nil) {
        [self setSelectedBackgroundViewColor:nil];
        return ;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [imageView setImage:image];
    [self setSelectedBackgroundView:imageView];
    
}

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, (__bridge const void *)(kIndexPathKey));
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, (__bridge const void *)(kIndexPathKey), indexPath, OBJC_ASSOCIATION_RETAIN);
}

@end
