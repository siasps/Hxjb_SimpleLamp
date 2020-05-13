//
//  UIImage+KIImage.m
//  Kitalker
//
//  Created by 杨 烽 on 12-8-3.
//
//

#import "UIImage+KIAdditions.h"

@implementation UIImage (KIAdditions)

- (UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    }
    //    else {
    //        UIGraphicsBeginImageContext(rect.size);
    //    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)flipVertical {
    return [self flip:NO];
}

- (UIImage *)flipHorizontal {
    return [self flip:YES];
}

- (UIImage *)resizeTo:(CGSize)size {
    return [self resizeToWidth:size.width height:size.height];
}

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    }
    
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaleWithWidth:(CGFloat)width {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.width / width;
    CGFloat height = imageSize.height / scale;
    return [self resizeToWidth:width height:height];
}

- (UIImage *)scaleWithHeight:(CGFloat)heigh {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.height / heigh;
    CGFloat width = imageSize.width / scale;
    return [self resizeToWidth:width height:heigh];
}

- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)decodedImage {
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 // Just always return width * 4 will be enough
                                                 CGImageGetWidth(imageRef) * 4,
                                                 // System only supports RGB, set explicitly
                                                 colorSpace,
                                                 // Makes system don't need to do extra conversion when displayed.
                                                 // NOTE: here we remove the alpha channel for performance. Most of the time, images loaded
                                                 //       from the network are jpeg with no alpha channel. As a TODO, finding a way to detect
                                                 //       if alpha channel is necessary would be nice.
                                                 kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGRect rect = (CGRect){CGPointZero,{CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}};
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)decoded;
{
    CGImageRef imageRef = self.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    } else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return self;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef
                                                     scale:self.scale
                                               orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

- (UIImage *)addMark:(NSString *)mark textColor:(UIColor *)textColor font:(UIFont *)font point:(CGPoint)point {
    CGSize size = self.size;
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    }
    //    else {
    //        UIGraphicsBeginImageContext(size);
    //    }
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    if (textColor == nil) {
        textColor = [UIColor whiteColor];
    }
    
    [textColor setFill];
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    
    
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    [mark drawInRect:rect withAttributes:attributes];
    
    //    [mark drawAtPoint:point
    //             forWidth:self.size.width
    //             withFont:font
    //        lineBreakMode:NSLineBreakByCharWrapping];
    
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)addCreateTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:date];
    
    CGSize size = [dateString boundingRectWithSize:CGSizeMake(self.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]}context:nil].size;
    //    [dateString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]
    //                         constrainedToSize:CGSizeMake(self.size.width, CGFLOAT_MAX)
    //                             lineBreakMode:NSLineBreakByCharWrapping];
    
    return [self addMark:dateString
               textColor:[UIColor blackColor]
                    font:[UIFont boldSystemFontOfSize:16.0f]
                   point:CGPointMake(self.size.width-size.width-10, self.size.height-size.height-10)];
    
}

+ (NSString *) contentTypeExtensionForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return UIImageExtensionType_JPG;
        case 0x89:
            return UIImageExtensionType_PNG;
        case 0x47:
            return UIImageExtensionType_GIF;
        case 0x49:
        case 0x4D:
            return UIImageExtensionType_TIFF;
    }
    return @"";
}

CGFloat KKDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat KKRadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(KKDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, KKDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)convertImageToScale:(double)scale{
    
    
    CGSize newImageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(newImageSize);
    [self drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//referWidth：压缩后的宽带，高等比压缩
+ (UIImage *)scaleToSize:(UIImage *)img referWidth:(CGFloat)referWidth{
    //NSLog(@"\n originImage-------width:%f,height:%f,big:%f", img.size.width,img.size.height,  UIImageJPEGRepresentation(img, 1).length / 1024.0/1024);
    
    CGFloat width = referWidth;
    CGFloat height = (referWidth / img.size.width) * img.size.height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    
    //NSLog(@"\n scaledImage-------width:%f,height:%f,big:%f", scaledImage.size.width,scaledImage.size.height,  UIImageJPEGRepresentation(scaledImage, 1).length / 1024.0/1024);
    return scaledImage;
}

//referSize：压缩后图片大小
+ (UIImage *)scaleToSize:(UIImage *)img referSize:(CGFloat)referSize{
    CGFloat size = UIImageJPEGRepresentation(img, 1.0).length / 1024.0;
    if (size <= referSize) {
        return img;
    }
    
    CGFloat scale = referSize / size;
    scale = sqrt(scale);
    CGFloat width = img.size.width * scale;
    CGFloat height = img.size.height * scale;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)scaleToNormalSize:(UIImage *)originImage{
    NSData *originData = UIImageJPEGRepresentation(originImage, 1);
    //CGFloat size = originData.length / 1024.0/1024;
    
    CGFloat rota = 1 / (originData.length/1024/1024.0f / 0.2);
    
    NSData *newData = UIImageJPEGRepresentation(originImage, sqrtf(rota));
    
    //NSLog(@"\n ---------originData:%f, newData:%f", size, newData.length / 1024.0/1024);
    UIImage *newImage = [UIImage imageWithData:newData];
    
    return newImage;
}


+ (UIImage *)checkImage:(UIImage *)originImage{
    
    UIImage *scaleImage = originImage;
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat scaleWidth = SCREEN_WIDTH * screenScale * 1.0;
    CGFloat scaleheight = SCREEN_HEIGHT * screenScale * 1.0;
    
    if (originImage.size.width*originImage.scale > scaleWidth || originImage.size.height*originImage.scale > scaleheight) {
        scaleImage = [originImage imageByScalingAndCroppingForSize:CGSizeMake(scaleWidth, scaleheight)];
    }
    
    CGFloat totalFileMB = [UIImagePNGRepresentation(originImage) length];
    if (totalFileMB > KIImageMaxSize) {
        scaleImage = [UIImage compressionImage:originImage];
    }
    
    
    //NSLog(@"-------%f--%f", scaleImage.size.width, scaleImage.size.height);
    return scaleImage;
}

+ (UIImage *)compressionImage:(UIImage *)originImage{
    if (!originImage) {
        return nil;
    }
    
    CGFloat totalFileSize = [UIImageJPEGRepresentation(originImage,1) length];
    //NSLog(@"-1------%.3f",  totalFileSize/1000.0f/1000.0f);
    
    if (totalFileSize > KIImageMaxSize) {
        
        CGFloat scale = sqrtf(KIImageMaxSize / totalFileSize);
        CGFloat width = originImage.size.width * scale;
        CGFloat height = originImage.size.height  * scale;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        // 绘制改变大小的图片
        [originImage drawInRect:CGRectMake(0,0, width, height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        
        //CGFloat totalFileMB = [UIImageJPEGRepresentation(scaledImage,1) length]/1000.0f/1000.0f;
        //NSLog(@"-2------%.3f",  totalFileMB);
        
        //返回新的改变大小后的图片
        return scaledImage;
        
    }
    
    return originImage;
    
}




//图片压缩到指定大小
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    
    if (self.size.width*self.scale <= targetSize.width && self.size.height*self.scale <= targetSize.height) {
        
        return self;
    }
    
    
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight)); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


//图片压缩到指定大小
- (UIImage*)imageCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage *)compressImageWithMaxLength:(NSUInteger)maxLength{
    
    NSData *compressData = [self compressWithMaxLength:maxLength*1024];
    
    UIImage *newImage = [[UIImage alloc]initWithData:compressData];
    
    return newImage;
}

-(NSData *)compressWithMaxLength:(double)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}




@end
