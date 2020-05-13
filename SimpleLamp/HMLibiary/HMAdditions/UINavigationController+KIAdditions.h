//
//  UINavigationController+KIAdditions.h
//  Kitalker
//
//  Created by chen on 13-3-28.
//  
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (KIAdditions)


- (void)popToViewControllerAtIndex:(NSUInteger)index;


@end






//@interface UINavigationController (navbarAlpha)<UINavigationBarDelegate, UINavigationControllerDelegate>{
//    
//}
//@property (copy, nonatomic) NSString *cloudox;
//
//- (void)setNeedsNavigationBackground:(CGFloat)alpha;
//
//@end
//
//
//@interface UIViewController (navbarAlpha)
//@property (copy, nonatomic) NSString *navBarBgAlpha;
//@end

