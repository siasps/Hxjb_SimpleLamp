//
//  KIImagePickerController.h
//  Kitalker
//
//  Created by chen on 13-3-19.
//  Copyright (c) 2013年 yangfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+KIAdditions.h"
#import "KIImageCropperViewController.h"


@protocol KIImagePickerControllerDelegate;

@interface KIImagePickerController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    __weak id<KIImagePickerControllerDelegate> _delegate;
    UIViewController                    *_viewController;
    UIActionSheet                       *_actionSheet;
    UIImagePickerController             *_imagePickerController;
    CGSize                              _cropSize;
    NSString                            *_title;
    NSArray                             *_otherItems;
    BOOL                                _showDelete;
}

@property (nonatomic, strong) NSString  *title;

- (id)initWithDelegate:(id<KIImagePickerControllerDelegate>)delegate
        viewController:(UIViewController *)viewController;

- (id)initWithDelegate:(id<KIImagePickerControllerDelegate>)delegate
                 title:(NSString *)title
        viewController:(UIViewController *)viewController;

- (void)showWithDeleteButton:(BOOL)showDelete;

- (void)showWithDeleteButton:(BOOL)showDelete cropSize:(CGSize)cropSize;

- (void)showWithDeleteButton:(BOOL)showDelete cropSize:(CGSize)cropSize otherItems:(NSArray *)items;

@end

@protocol KIImagePickerControllerDelegate <NSObject>

@optional

- (void)KIImagePickerController:(KIImagePickerController *)controller didFinishPickImage:(UIImage *)image;

- (void)KIImagePickerController:(KIImagePickerController *)controller didSelectedOtherIndex:(NSUInteger)index;

- (void)KIImagePickerControllerDidCancel:(KIImagePickerController *)controller;

- (void)KINavigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)KINavigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
