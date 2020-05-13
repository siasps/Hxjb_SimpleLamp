//
//  UITableViewCell+KIAdditions.h
//  Kitalker
//
//  Created by chen on 13-4-13.
//
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (KIAdditions)

@property(nonatomic, assign) NSIndexPath *indexPath;

- (void)setBackgroundViewColor:(UIColor *)color;

- (void)setBackgroundViewImage:(UIImage *)image;

- (void)setSelectedBackgroundViewColor:(UIColor *)color;

- (void)setSelectedBackgroundViewImage:(UIImage *)image;

@end
