//
//  HMLoadingView.m
//  HM
//
//  Created by Hugh.
//  Copyright 2015 HM. All rights reserved.
//

#import "HMLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@interface HMLoadingView ()

@property (nonatomic, strong)  UILabel *textLabel;

@end

@implementation HMLoadingView
@synthesize isLoading;
@synthesize textLabel;
@synthesize progressLabel;

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)t
{
	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		self.exclusiveTouch = YES;
		self.userInteractionEnabled = YES;
		self.alpha = 0;
        self.layer.cornerRadius = 2;
        
        imageArray = [[NSArray alloc]initWithObjects:
                      [UIImage imageNamed:@""],
                      [UIImage imageNamed:@""],nil];
        imageIndex = 0;
		
        context = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-50, self.bounds.size.height/2-60, 100, 120)];
        if (!IOS7_OR_LATER) {
            context.frame = CGRectMake(self.bounds.size.width/2-50, (self.bounds.size.height)/2-60-44, 100, 120);
        }
        //context.layer.borderColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor;
        context.backgroundColor = [UIColor whiteColor];
        context.layer.cornerRadius = 5;
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, context.frame.size.height-20, 100, 20)];
        progressLabel.textColor = [UIColor blackColor];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.opaque = NO;
        progressLabel.text = t;
        progressLabel.font = [UIFont boldSystemFontOfSize:12];
        self.textLabel = progressLabel;
        
        logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        logoImgView.backgroundColor = [UIColor clearColor];
        logoImgView.image = [UIImage imageNamed:@"loading1.png"];
        
        [context addSubview:logoImgView];
        [context addSubview:progressLabel];
        
        [self addSubview:context];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {

}

- (void)setText:(NSString *)aText {
    text = aText;
	textLabel.text = text;
}


- (void)onTimer:(NSTimer*)timer
{
//    imageIndex++;
//    imageIndex %= [imageArray count];
//    logoImgView.image = [imageArray objectAtIndex: imageIndex];
}

-(void)beginAnimationLoading{
    if(isLoading)
        return;
	isLoading = YES;
	self.alpha = 1;
    imageIndex = 0;
    if (!changeImageTimer) {
        changeImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector: @selector(onTimer:) userInfo:nil repeats:YES];
        //[changeImageTimer retain];
    }
}

-(void)stopAnimationLoading{
	isLoading = NO;
    
    [changeImageTimer invalidate];
    //[changeImageTimer release];
    changeImageTimer = nil;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3f];
	self.alpha = 0;
	[UIView commitAnimations];
}

@end
