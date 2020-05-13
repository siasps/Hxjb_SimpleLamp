//
//  KIGuideViewController.h
//  Kitalker
//
//  Created by 刘 波 on 12-12-25.
//
//

#import <UIKit/UIKit.h>

#define kGuideConfigFileName @"guideConfig"

#define kGuideViewDidShowNotification @"kGuideViewDidShowNotification"
#define kGuideViewWillFinishedNotification @"kGuideViewWillFinishedNotification"
#define kGuideViewDidFinishedNotification @"kGuideViewDidFinishedNotification"

@interface KIGuideView : UIView <UIScrollViewDelegate> {
}

+ (void)showOnceWithAnimated:(BOOL)animated;

//+ (void)show:(BOOL)animated;

@end
