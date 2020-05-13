//
//  UITableViewController+KIAdditions.h
//  Ask
//
//  Created by chen on 13-3-14.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+KIAdditions.h"

@interface UITableViewController (KIAdditions)

- (void)setBackgroundImage:(UIImage *)image;

- (void)setBackgroundColor:(UIColor *)color;

- (void)reloadVisibleCells;

- (void)addItemToFirst:(id)item withDataSource:(NSMutableArray *)dataSource;

- (void)addItemsToFirst:(NSArray *)items withDataSource:(NSMutableArray *)dataSource;

- (void)addItemToLast:(id)item withDataSource:(NSMutableArray *)dataSource;

- (void)addItemsToLast:(NSArray *)items withDataSource:(NSMutableArray *)dataSource;

- (void)addItem:(id)item toIndex:(NSUInteger)index withDataSource:(NSMutableArray *)dataSource;

- (void)addItems:(NSArray *)items beginWithIndex:(NSUInteger)index withDataSource:(NSMutableArray *)dataSource;

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath withDataSource:(NSMutableArray *)dataSource;

@end
