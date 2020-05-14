//
//  HMWebViewController.m
//  Panda
//
//  Created by Huamo on 2018/11/6.
//  Copyright © 2018年 chen. All rights reserved.
//

#import "HMWebViewController.h"
#import <WebKit/WebKit.h>
//#import "HMLoginViewController.h"

@interface HMWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler> {
    
}
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,assign) NSInteger loginType;


@end


@implementation HMWebViewController

- (instancetype)init{
    if (self = [super init]) {
        _loginType = -1;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _webTitle;
    [self showCustomBackButton];
    
    [self initUI];
    
    [self reloadWebView];
    
    
    
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


#pragma mark - UI

- (void)initUI{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsPictureInPictureMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.preferences = preferences;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_TOP_HEIGHT) configuration:config];
    [self.view addSubview:_webView];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
     //*3.添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self jsConfig];
    
}

- (void)reloadWebView{
    
    /* 加载服务器url的方法*/
    //_urlString = @"http://192.168.1.60:8010/help/share";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];
    
//    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]];
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"未命名" ofType:@"html"];
//
//    NSString *html = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:html baseURL:url];
    
}

#pragma mark - WKNavigationDelegate

/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    
}

/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
    
    
}

/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    self.progressView.hidden = YES;
    
    
}

/* 在发送请求之前，决定是否跳转 */
/** JS端
 window.location = 'app://login?account=13011112222&password=123456';
 <a href="javascript:window.javatojs.backtoapp('1','1')">到详细页</a>"
*/
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSURLRequest *request = navigationAction.request;
//    NSString *scheme = request.URL.scheme;
//    NSString *host = request.URL.host;
//
//    // 一般用作交互的链接都会有一个固定的协议头，这里我们一“app”作为协议头为了，实际项目中可以修改
//    if ([scheme isEqualToString:@"app"]) { // scheme为“app”说明是做交互的链接
//        if ([host isEqualToString:@"login"]) { // host为“login”对应的就是登录操作
//
//        }
//
//        //不允许跳转
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }

    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}




/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}



#pragma mark - 监听加载进度

/*
 *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.progressView.alpha = 1.0f;
        [self.progressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
}


#pragma mark - js

- (void)jsConfig{
    
    // js配置
    WKUserContentController *userContentController = _webView.configuration.userContentController;
    [userContentController addScriptMessageHandler:self name:@"jsCallOC"];
    
    _webView.configuration.userContentController = userContentController;
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //NSLog(@"%@--%@", message.name, message.body);
    
    if ([message.name isEqualToString:@"jsCallOC"]) {
        [self dealJsData:message.body];
    }
    
    
}

- (void)dealJsData:(NSDictionary *)jsDict{
    if (!jsDict || jsDict.count<=0) {
        return;
    }
    
    NSInteger type = [[jsDict stringValueForKey:@"type"] integerValue];
    //NSString *content = [jsDict stringValueForKey:@"content"];
    
    
    if (type == 1) {
        //专题活动
        
        [self shareFirstOrder];
    }
    
}

- (void)shareFirstOrder{
    
//    if (![HMUserManager isLogin]) {
//        [HMUserManager loginWithDelegate:self rootController:self];
//        _loginType = 1;
//        return;
//    }
    
    [self getOrderDataWithCache:NO];
}

- (void)loginSucceed{
    
    if (_loginType == 1) {
        [self shareFirstOrder];
        _loginType = -1;
    }
    
    
}

- (void)getOrderDataWithCache:(BOOL)cache{
    
    if (!cache) {
        [HMDataRequest deleteCacheWithUrl:Server_order_list];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"4" forKey:@"orderStatus"];
    [dict setObject:[HMUserManager getUserID] forKey:@"userId"];
    [dict setObject:@"1" forKey:@"pageSize"];
    [dict setObject:@"1" forKey:@"pageNo"];
    
    [HMDataRequest getRequestWithUrl:Server_order_list withParams:dict withCacheTime:0 showProgressInView:self.view CallBack:^(id responseObject, id error) {
        
        if (!error) {
            NSDictionary *respondDict = responseObject;
            NSDictionary *infoMap= [respondDict objectForKey:@"infoMap"];
            NSString *flag = [infoMap objectForKey:@"flag"];
            NSArray *resultList = [respondDict objectForKey:@"resultList"];
            
            
            if ([flag isEqualToString:@"1"]) {
                
                if (resultList && [resultList isKindOfClass:[NSArray class]] && resultList.count > 0) {
                    NSArray *orderGoods = [[resultList firstObject] valueObjectForKey:@"orderGoods"];
                    
                    if (orderGoods.count > 0) {
                        //NSDictionary *goodsDict = [orderGoods firstObject];
                        //[HMShareManager shareWithGoodsDict:goodsDict];
                        return ;
                    }
                }
            }
            
            
            [self jumpToHomeWithNoOrder];
            
        } else{
            NIF_TRACE(@"%@",error);
        }
    }];
    
}

- (void)jumpToHomeWithNoOrder{
    
    NSString *alertStr = @"亲，购物后才可获得邀请资格哦^^";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:alertStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"立即GO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



@end
