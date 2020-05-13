//
//  HMEditTagsView.h
//  Huaxiajiabo
//
//  Created by Huamo on 2018/1/22.
//  Copyright © 2018年 huamo. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HMEditTagsView;
@protocol HMEditTagsViewDelegate <NSObject>

@optional
-(void)heightDidChangedTagView:(HMEditTagsView*)tagView;

@end



@interface HMEditTagsView : UIView{
    
}

@property (nonatomic, strong) id<HMEditTagsViewDelegate> delegate;
@property (nonatomic, strong) UITextField* tfInput;

@property (nonatomic) float tagWidht;//default
@property (nonatomic) float tagHeight;//default

@property (nonatomic) float viewMaxHeight;

@property (nonatomic) CGSize tagPaddingSize;//top & left
@property (nonatomic) CGSize textPaddingSize;


@property (nonatomic, strong) UIFont* fontTag;
@property (nonatomic, strong) UIFont* fontInput;


@property (nonatomic, strong) UIColor* colorTag;
@property (nonatomic, strong) UIColor* colorInput;
@property (nonatomic, strong) UIColor* colorInputPlaceholder;

@property (nonatomic, strong) UIColor* colorTagBg;
@property (nonatomic, strong) UIColor* colorInputBg;
@property (nonatomic, strong) UIColor* colorInputBord;


- (void)addTags:(NSArray *)tags;
- (void)addTags:(NSArray *)tags selectedTags:(NSArray*)selectedTags;
-(void)layoutTagviews;
-(void)setTagStringsSelected:(NSMutableArray *)tagStringsSelected;
-(NSMutableArray *)tagStrings;



@end
