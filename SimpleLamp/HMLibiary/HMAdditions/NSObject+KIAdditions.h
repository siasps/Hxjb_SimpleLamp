//
//  NSObject+KIAddition.h
//  Kitalker
//
//  Created by chen on 12-10-24.
//  Copyright (c) 2012年 chen. All rights reserved.
//


#define kNotificationObject @"kNotificationObject"

@interface NSObject (KIAdditions)


- (NSMutableArray *)attributeList;


/*字符串*/
- (BOOL)isEmptyString;

/*判断是否为空或者nil*/
- (BOOL)isNotEmptyString;



/*设备相关*/
/*当前设备的系统版本号*/
- (float)deviceSystemVersion;

/*当前设备模型*/
- (NSString *)deviceModel;

/*当前设备名称*/
- (NSString *)deviceName;

/*当前设备是否为iPad*/
- (BOOL)deviceIsPad;

/*当前设备是否为iPhone*/
- (BOOL)deviceIsPhone;

/*当前设备是否为iPod touch*/
- (BOOL)deviceIsTouch;

/*当前设备是否为视网膜屏*/
- (BOOL)deviceIsRetina;

/*判断是否为iPhone5*/
- (BOOL)deviceIsPhone5;



/*通知*/
- (void)observeNotificaiton:(NSString *)name selector:(SEL)selector;

- (void)unobserveNotification:(NSString *)name;


/*键盘*/
- (void)observeKeyboardWillChangeNotification;

- (void)unobserveKeyboardWillChangeNotification;

/*重写这个方法，用于处理键盘高度改变事件*/
- (void)changeKeyboardHeight:(CGFloat)height animationDuration:(NSTimeInterval)duration show:(BOOL)show;



/*系统方法*/
- (void)openURL:(NSURL *)url;

- (void)sendMail:(NSString *)mail;

- (void)sendSMS:(NSString *)number;

- (void)callNumber:(NSString *)number;


/*创建一个定时器*/
- (dispatch_source_t)createTimer:(dispatch_queue_t)queue interval:(CGFloat)interval block:(dispatch_block_t)block;

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

/*string、data转换为dictionary对象*/
+ (NSDictionary *)getDictionaryWithJSON:(id)json;



@end
