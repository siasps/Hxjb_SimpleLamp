//
//  UIColor+KIAdditions.h
//  Kitalker
//
//  Created by chen on 12-10-24.
//
//

#import <UIKit/UIKit.h>

#define KIColorWithRGBA(r, g, b, a) \
    if (r > 1.0) {r = r/255.0f;}\
    if (g > 1.0) {g = g/255.0f;}\
    if (b > 1.0) {b = b/255.0;}\
    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]\

#define KIColorWithHex(hex) [UIColor colorWithHex:hex]

@interface UIColor (KIAdditions)

+ (UIColor *)colorWithHex:(NSString *)hex;

- (void)colorComponents:(CGFloat[4])components;


+ (UIColor*)colorWithHex:(NSInteger)hexColor alpha:(CGFloat)alpha;

+ (UIColor *) colorWithHexString: (NSString *) hexString;

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;


@end
