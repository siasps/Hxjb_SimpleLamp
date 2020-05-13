//
//  HMActionSheet.h
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/7/2.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HMActionSheetDelegate;

@interface HMActionSheet : UIView


- (instancetype)initWithDelegate:(id<HMActionSheetDelegate>)delegate otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showInView:(UIView *)view;
- (void)show;

@end

@protocol HMActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(HMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)actionSheetCancel:(UIActionSheet *)actionSheet;

@end