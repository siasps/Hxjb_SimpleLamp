//
//  KIImagePickerController.m
//  Kitalker
//
//  Created by chen on 13-3-19.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import "KIImagePickerController.h"

@interface KIImagePickerController ()
@property (nonatomic, weak) id<KIImagePickerControllerDelegate>   delegate;
@property (nonatomic, strong) UIViewController                      *viewController;
@property (nonatomic, assign) CGSize                                cropSize;
@property (nonatomic, strong) NSArray                               *otherItems;
@property (nonatomic, assign) BOOL                                  showDelete;
@end

@implementation KIImagePickerController
@synthesize delegate        = _delegate;
@synthesize viewController  = _viewController;
@synthesize title           = _title;
@synthesize cropSize        = _cropSize;
@synthesize otherItems      = _otherItems;
@synthesize showDelete      = _showDelete;

- (id)initWithDelegate:(id<KIImagePickerControllerDelegate>)delegate viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.delegate = delegate;
        self.viewController = viewController;
        self.title = @"请选择";
    }
    return self;
}

- (id)initWithDelegate:(id<KIImagePickerControllerDelegate>)delegate
                 title:(NSString *)title
        viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.delegate = delegate;
        self.viewController = viewController;
        self.title = title;
    }
    return self;
}

- (void)showWithDeleteButton:(BOOL)showDelete {
    UIApplication *applicaiton = [UIApplication sharedApplication];
    
    [[self actionSheet:showDelete] showInView:[applicaiton keyWindow]];
}

- (void)showWithDeleteButton:(BOOL)showDelete cropSize:(CGSize)cropSize {
    [self setCropSize:cropSize];
    [self showWithDeleteButton:showDelete];
}

- (void)showWithDeleteButton:(BOOL)showDelete cropSize:(CGSize)cropSize otherItems:(NSArray *)items {
    [self setOtherItems:items];
    [self showWithDeleteButton:showDelete cropSize:cropSize];
}

- (UIActionSheet *)actionSheet:(BOOL)needDelete {
    self.showDelete = needDelete;
    
    if (_actionSheet == nil) {
        
        _actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"从相册选择", @"从相机拍摄", nil];
        
        NSUInteger cancelIndex = 1;
        if (self.showDelete) {
            [_actionSheet addButtonWithTitle:@"删除图片"];
            cancelIndex++;
        }
        
        for (NSString *title in self.otherItems) {
            [_actionSheet addButtonWithTitle:title];
            cancelIndex++;
        }
        
        [_actionSheet addButtonWithTitle:@"取消"];
        cancelIndex++;
        
        _actionSheet.cancelButtonIndex = cancelIndex;
        //[self retain];
    }
    return _actionSheet;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        [_imagePickerController setDelegate:self];
    }
    return _imagePickerController;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [_viewController presentViewController:[self imagePickerController] animated:YES completion:^{
            
        }];
    } else if (buttonIndex == 1) {
        [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [_viewController presentViewController:[self imagePickerController] animated:YES completion:^{
            
        }];
    } else if (buttonIndex == actionSheet.cancelButtonIndex) {
        if ([self.delegate respondsToSelector:@selector(KIImagePickerControllerDidCancel:)]) {
            [self.delegate KIImagePickerControllerDidCancel:self];
        }
        [self dismiss];
    } else if (self.showDelete && buttonIndex == 2) {
        [self pickImage:nil];
    } else {
        [self didSelectedOtherIndex:buttonIndex-(self.showDelete?3:2)];
    }
}



- (void)pickImage:(UIImage *)image {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(KIImagePickerController:didFinishPickImage:)]) {
        [self.delegate KIImagePickerController:self didFinishPickImage:image];
    }
    [self dismiss];
}

- (void)didSelectedOtherIndex:(NSUInteger)index {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(KIImagePickerController:didSelectedOtherIndex:)]) {
        [self.delegate KIImagePickerController:self didSelectedOtherIndex:index];
    }
}

- (void)dismiss {
    [[self imagePickerController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}



#pragma mark ==================================================
#pragma mark == UINavigationControllerDelegate
#pragma mark ==================================================
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.delegate respondsToSelector:@selector(KINavigationController:willShowViewController:animated:)]) {
        [self.delegate KINavigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self.delegate respondsToSelector:@selector(KINavigationController:didShowViewController:animated:)]) {
        [self.delegate KINavigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

#pragma mark ==================================================
#pragma mark == UIImagePickerControllerDelegate
#pragma mark ==================================================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    NSURL   *imageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    //    NSString *imagePath = [imageURL absoluteString];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (CGSizeEqualToSize(self.cropSize, CGSizeZero)) {
        [self pickImage:image];
    } else {
        KIImageCropperViewController *cropImageViewController = [[KIImageCropperViewController alloc] initWithImage:[image fixOrientation]
                                                                                                           cropSize:self.cropSize];
        [[self imagePickerController] pushViewController:cropImageViewController animated:YES];
        [cropImageViewController setCroppedImage:^(UIImage *image) {
            [self pickImage:image];
        }];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.delegate respondsToSelector:@selector(KIImagePickerControllerDidCancel:)]) {
        [self.delegate KIImagePickerControllerDidCancel:self];
    }
    [self dismiss];
}


@end

