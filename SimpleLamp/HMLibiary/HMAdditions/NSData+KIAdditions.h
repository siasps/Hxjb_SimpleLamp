//
//  NSData+KIData.h
//  Kitalker
//
//  Created by chen on 12-9-21.
//  Copyright (c) 2012年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

typedef void(^KKImageConvertImageOneCompletedBlock)(NSData *imageData,NSInteger index);
typedef void(^KKImageConvertImageAllCompletedBlock)(void);

@interface NSData (KIAdditions)

/*md5 加密*/
- (NSString *)md5;

/*base64 加密*/
- (NSString *)base64Encoded;

/*base64 解密*/
- (NSData *)base64Decoded;

////将图片压缩到指定大小 imageArray UIImage数组，imageDataSize 图片数据大小(单位KB)，比如100KB
+ (void)convertImage:(NSArray*)imageArray toDataSize:(CGFloat)imageDataSize
convertImageOneCompleted:(KKImageConvertImageOneCompletedBlock)completedOneBlock
KKImageConvertImageAllCompletedBlock:(KKImageConvertImageAllCompletedBlock)completedAllBlock;

@end
