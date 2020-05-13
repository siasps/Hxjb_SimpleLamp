//
//  UIColor+KIAdditions.m
//  Kitalker
//
//  Created by chen on 12-10-24.
//
//

#import "UIColor+KIAdditions.h"

@implementation UIColor (KIAdditions)

+ (UIColor *)colorWithHex:(NSString *)hex {
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    hex = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    int length = (int)hex.length;
    
    if (length < 3) {
        return nil;
    }
    
    unsigned int r, g, b, a=1.0f;
    
    int step = length>=6?2:1;
    int start = 0;
    
    [UIColor scann:&r from:hex range:NSMakeRange(start, step)];
    start += step;
    [UIColor scann:&g from:hex range:NSMakeRange(start, step)];
    start += step;
    [UIColor scann:&b from:hex range:NSMakeRange(start, step)];
    
    if (length == 4 || length == 8) {
        start += step;
        [UIColor scann:&a from:hex range:NSMakeRange(start, step)];
    }
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (void)scann:(unsigned int *)value from:(NSString *)from range:(NSRange)range {
    NSString *temp = [from substringWithRange:range];
    if (range.length == 1) {
        temp = [NSString stringWithFormat:@"%@%@", temp, temp];
    }
    [[NSScanner scannerWithString:temp] scanHexInt:value];
}

- (void)colorComponents:(CGFloat[4])components {
    if (self != nil) {
        int numberOfColorComponents = (int)CGColorGetNumberOfComponents(self.CGColor);
        const CGFloat *colorComponents = CGColorGetComponents(self.CGColor);
        
        if (numberOfColorComponents == 2) {
            components[0] = colorComponents[0];
            components[1] = colorComponents[0];
            components[2] = colorComponents[0];
            components[3] = colorComponents[1];
        } else {
            components[0] = colorComponents[0];
            components[1] = colorComponents[1];
            components[2] = colorComponents[2];
            components[3] = colorComponents[3];
        }
    }
}


+ (UIColor*)colorWithHex:(NSInteger)hexColor alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0
                           green:((float)((hexColor & 0xFF00) >> 8))/255.0
                            blue:((float)(hexColor & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            red = [self colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            
            blue = [self colorComponentFrom: colorString start: 2 length: 1];
            
            alpha  = [self colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #AARRGGBB
            
            red = [self colorComponentFrom: colorString start: 0 length: 2];
            
            green  = [self colorComponentFrom: colorString start: 2 length: 2];
            
            blue = [self colorComponentFrom: colorString start: 4 length: 2];
            
            alpha  = [self colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}

@end
