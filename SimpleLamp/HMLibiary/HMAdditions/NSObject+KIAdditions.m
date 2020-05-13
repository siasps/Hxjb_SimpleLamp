//
//  NSObject+KIAddition.m
//  Kitalker
//
//  Created by chen on 12-10-24.
//  Copyright (c) 2012年 chen. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#import "NSObject+KIAdditions.h"
#import "NSData+KIAdditions.h"
#import "NSString+KIAdditions.h"


NSString * const kPropertyList = @"kPropertyList";

@implementation NSObject (KIAdditions)


- (NSMutableArray *)attributeList {
    static NSMutableDictionary *classDictionary = nil;
    if (classDictionary == nil) {
        classDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(self.class);
    
    NSMutableArray *propertyList = [classDictionary objectForKey:className];
    
    if (propertyList != nil) {
        return propertyList;
    }
    
    
    //    NSMutableArray *propertyList = objc_getAssociatedObject(self, kPropertyList);
    //
    //    if (propertyList != nil) {
    //        return propertyList;
    //    }
    
    propertyList = [[NSMutableArray alloc] init];
    
    id theClass = object_getClass(self);
    [self getPropertyList:theClass forList:&propertyList];
    
    [classDictionary setObject:propertyList forKey:className];
    
    return propertyList;
}

- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
    id superClass = class_getSuperclass(theClass);
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        if (propertyName != nil) {
            [*propertyList addObject:propertyName];
            propertyName = nil;
        }
    }
    free(properties);
    
    if (superClass != [NSObject class]) {
        [self getPropertyList:superClass forList:propertyList];
    }
}



/*字符串*/
- (BOOL)isEmptyString {
    return ![self isNotEmptyString];
}

- (BOOL)isNotEmptyString {
    if (self != nil
        && ![self isKindOfClass:[NSNull class]]
        && (id)self != [NSNull null]) {
        return YES;
    }
    return NO;
}


/*设备相关*/
- (float)deviceSystemVersion {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
}

- (NSString *)deviceModel {
    NSString *model = [[UIDevice currentDevice] model];
    return model;
}

- (NSString *)deviceName {
    NSString *name = [[UIDevice currentDevice] name];
    return name;
}

- (BOOL)deviceIsPad {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (BOOL)deviceIsPhone {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}

- (BOOL)deviceIsTouch {
    return [[self deviceModel] rangeOfString:@"iPod touch"].length > 0;
}

- (BOOL)deviceIsRetina {
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)deviceIsPhone5 {
   return ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO);
}


/*通知*/
- (void)observeNotificaiton:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:name
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}


/*键盘*/
- (void)observeKeyboardWillChangeNotification {
    [self observeNotificaiton:UIKeyboardWillShowNotification selector:@selector(keyboardWillShow:)];
    [self observeNotificaiton:UIKeyboardWillHideNotification selector:@selector(keyboardWillHide:)];
    //[self observeNotificaiton:UIKeyboardWillChangeFrameNotification selector:@selector(keyboardWillShow:)];
}

- (void)unobserveKeyboardWillChangeNotification {
    [self unobserveNotification:UIKeyboardWillShowNotification];
    [self unobserveNotification:UIKeyboardWillHideNotification];
    //[self unobserveNotification:UIKeyboardWillChangeFrameNotification];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeKeyboardHeight:CGRectGetHeight(keyboardRect) animationDuration:animationDuration show:YES];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self changeKeyboardHeight:0.0 animationDuration:animationDuration show:NO];
}

- (void)changeKeyboardHeight:(CGFloat)height animationDuration:(NSTimeInterval)duration show:(BOOL)show{
    
}


/*系统方法*/
- (void)openURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

- (void)sendMail:(NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self openURL:[NSURL URLWithString:[url URLEncodedString]]];
}

- (void)sendSMS:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self openURL:[NSURL URLWithString:[url URLEncodedString]]];
}

- (void)callNumber:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:[NSURL URLWithString:[url URLEncodedString]]];
}



- (dispatch_source_t)createTimer:(dispatch_queue_t)queue interval:(CGFloat)interval block:(dispatch_block_t)block {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval*NSEC_PER_SEC, NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self  topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if (rootViewController.presentedViewController) {         UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else {
        return rootViewController;
        
    }
    
}

#pragma mark - json object

/*string、data转换为dictionary对象*/
+ (NSDictionary *)getDictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}


@end
