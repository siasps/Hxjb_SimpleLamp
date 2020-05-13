//
//  BaseTableViewCell.m
//  ProjectK
//
//  Created by beartech on 13-9-25.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell
@synthesize cellInfomation = _cellInfomation;
@synthesize indexPath = _indexPath;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
}

- (void)reloadWithInformation:(NSDictionary*)information{
    if ([information isKindOfClass:[NSNull class]] || !information || [information isKindOfClass:[NSString class]]) {
        return;
    }
    _cellInfomation = [[NSDictionary alloc]initWithDictionary:information];
    
    
}

+ (CGFloat)getCellHeight:(NSDictionary*)information{
    
    return 44.0f;
}



@end
