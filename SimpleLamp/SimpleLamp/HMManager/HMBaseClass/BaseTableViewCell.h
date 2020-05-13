//
//  BaseTableViewCell.h
//  ProjectK
//
//  Created by beartech on 13-9-25.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableViewCell : UITableViewCell{
    NSDictionary *_cellInfomation;
    NSIndexPath *_indexPath;
}

@property(nonatomic,strong) NSDictionary *cellInfomation;
@property(nonatomic,strong) NSIndexPath *indexPath;


- (void)initSubviews;

- (void)reloadWithInformation:(NSDictionary*)information;

+ (CGFloat)getCellHeight:(NSDictionary*)information;

@end
