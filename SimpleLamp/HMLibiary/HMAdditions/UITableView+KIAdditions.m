//
//  UITableView+KIAdditions.m
//  Kitalker
//
//  Created by chen on 13-3-27.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import "UITableView+KIAdditions.h"

@implementation UITableView (KIAdditions)

- (void)setBackgroundImage:(UIImage *)image {
    static NSUInteger BACKGROUND_IMAGE_VIEW_TAG = 91798;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:BACKGROUND_IMAGE_VIEW_TAG];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setTag:BACKGROUND_IMAGE_VIEW_TAG];
        [self setBackgroundView:imageView];
    }
    [imageView setImage:image];
}

- (void)setBackgroundColor:(UIColor *)color {
    static NSUInteger BACKGROUND_VIEW_TAG = 91799;
    UIView *backgroundView = [self viewWithTag:BACKGROUND_VIEW_TAG];
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setTag:BACKGROUND_VIEW_TAG];
        [self setBackgroundView:backgroundView];
    }
    [backgroundView setBackgroundColor:color];
}

- (void)setSeparatorImage:(UIImage *)image {
    UIColor *separatorColor = [UIColor colorWithPatternImage:image];
    [self setSeparatorColor:separatorColor];
}

- (void)addItemToFirst:(id)item withDataSource:(NSMutableArray *)dataSource {
    [self addItems:[NSArray arrayWithObject:item] beginWithIndex:0 withDataSource:dataSource];
}

- (void)addItemsToFirst:(NSArray *)items withDataSource:(NSMutableArray *)dataSource {
    [self addItems:items beginWithIndex:0 withDataSource:dataSource];
}

- (void)addItemToLast:(id)item withDataSource:(NSMutableArray *)dataSource {
    [self addItems:[NSArray arrayWithObject:item]
    beginWithIndex:[dataSource count]
    withDataSource:dataSource];
}

- (void)addItemsToLast:(NSArray *)items withDataSource:(NSMutableArray *)dataSource {
    [self addItems:items
    beginWithIndex:[dataSource count]
    withDataSource:dataSource];
}

- (void)addItem:(id)item toIndex:(NSUInteger)index withDataSource:(NSMutableArray *)dataSource {
    [self addItems:[NSArray arrayWithObject:item]
    beginWithIndex:index
    withDataSource:dataSource];
}

- (void)addItems:(NSArray *)items beginWithIndex:(NSUInteger)index withDataSource:(NSMutableArray *)dataSource {
    [self addItems:items beginWithIndex:index rowItmeCount:1 withDataSource:dataSource];
}

- (void)addItems:(NSArray *)items
  beginWithIndex:(NSUInteger)index
    rowItmeCount:(NSUInteger)rowItmeCount
  withDataSource:(NSMutableArray *)dataSource {
    if (dataSource==nil || items==nil || [items isKindOfClass:[NSNull class]]) {
        return ;
    }
    
    /*当前列表有多少条数据*/
    NSInteger dataSourceCount = dataSource.count;
    
    /*当前列表最后一行数据量*/
    NSInteger dataSourceRemainder = dataSourceCount % rowItmeCount;
    
    /*需要添加的数据量*/
    NSInteger itmesCount = items.count + dataSourceRemainder;
    
    NSInteger remainder = (itmesCount % rowItmeCount);
    
    /*需要添加的行数*/
    NSInteger count = items.count / rowItmeCount + remainder;
    
    if (dataSourceRemainder) {
        count--;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index*rowItmeCount, items.count)];
    
    [dataSource insertObjects:items atIndexes:indexSet];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath = nil;
    for (int i=0; i<count; i++) {
        indexPath = [NSIndexPath indexPathForRow:index+i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [self beginUpdates];
    [self insertRowsAtIndexPaths:indexPaths
                withRowAnimation:UITableViewRowAnimationFade];
//    if (dataSourceRemainder) {
//        NSIndexPath *last = [NSIndexPath indexPathForRow:index-1 inSection:0];
//        [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:last, nil]
//                    withRowAnimation:UITableViewRowAnimationFade];
//    }
    [self endUpdates];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath withDataSource:(NSMutableArray *)dataSource {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    [indexPaths addObject:indexPath];
    [dataSource removeObjectAtIndex:indexPath.row];
    
    [self beginUpdates];
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}

- (void)clearExtraCellLine{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [self setTableHeaderView:view];
}


@end
