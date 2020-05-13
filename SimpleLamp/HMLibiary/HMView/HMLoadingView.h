//
//  HMLoadingView.h
//  HM
//
//  Created by Hugh.
//  Copyright 2015 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMLoadingView : UIImageView {
	BOOL          isLoading;
	UIView        *context;
	UILabel       *textLabel;
	NSString      *text;
    UIImageView   *logoImgView;
    UILabel       *progressLabel;
    NSTimer       *changeImageTimer;
    NSArray       *imageArray;
    int           imageIndex;
}
@property(readonly)BOOL isLoading;
@property(readonly)UILabel *progressLabel;

-(void)beginAnimationLoading;
-(void)stopAnimationLoading;

-(void)setText:(NSString *)aText;

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)t;
@end
