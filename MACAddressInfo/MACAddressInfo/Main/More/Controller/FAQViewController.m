//
//  FAQViewController.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "FAQViewController.h"
#import <WebKit/WebKit.h>

static NSString *WKWebViewLoadingKey = @"loading";
static NSString *WKWebViewTitleKey = @"title";
static NSString *WKWebViewProgressKey = @"estimatedProgress";

@interface FAQViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) CALayer *progresslayer;
@property (nonatomic, strong) UIView *progress; // 顶部进度条

@end

@implementation FAQViewController

- (void)dealloc {
    // 移除监听
    [_wkWebView removeObserver:self forKeyPath:WKWebViewLoadingKey context:nil];
    [_wkWebView removeObserver:self forKeyPath:WKWebViewTitleKey context:nil];
    [_wkWebView removeObserver:self forKeyPath:WKWebViewProgressKey context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 添加控件
    [self.view addSubview:self.wkWebView];
    // 添加进度条
    [self.view addSubview:self.progress];
    
    // 2. 加载数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.htmlFileName ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:htmlStr baseURL:nil];
}


#pragma mark - WKNavigationDelegate

/**
 *  每当加载一个请求之前会调用该方法，通过该方法决定是否允许或取消请求的发送
 *
 *  @param navigationAction  导航动作对象
 *  @param decisionHandler   请求处理的决定
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 1. 主机名
    NSString *hostName = navigationAction.request.URL.host.lowercaseString;
    // 2. 获得协议头（http/https, 可以自定义协议头，根据协议头判断是否要执行跳转）
    NSString *scheme = navigationAction.request.URL.scheme;
    NSLog(@"hostName:%@  scheme:%@", hostName, scheme);
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

/**
 *  当开始发送请求时调用
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始发送请求");
}

/**
 *  当内容开始返回时调用
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"开始返回内容");
}

/**
 *  当请求过程中出现错误时调用
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"请求过程中出现错误, %@", error);
}

/**
 *  当开始发送请求时出现错误时调用
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"开始发送请求时出现错误, %@", error);
}

/**
 *  当网页加载完毕时调用：该方法使用最频繁
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"加载完毕");
}

/**
 *  每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  当收到服务器返回的受保护空间（证书）时调用
 *
 *  @param challenge  安全质询-->包含受保护空间和证书
 *  @param completionHandler   完成回调-->告诉服务器如何处置证书
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    // 创建凭据对象
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    // 告诉服务器信任证书
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:WKWebViewTitleKey]) {
//        self.title = self.wkWebView.title;
    } else if ([keyPath isEqualToString:WKWebViewLoadingKey]) {
        
    } else if ([keyPath isEqualToString:WKWebViewProgressKey]) {
        // 获得进度值
        CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
        // 显示进度
        NSLog(@"加载进度：%f", progress);
        
        if ([keyPath isEqualToString:WKWebViewProgressKey]) {
            self.progresslayer.opacity = 1;
            if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
                return;
            }
            self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
            if ([change[@"new"] floatValue] == 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.progresslayer.opacity = 0;
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


#pragma mark - Getters

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // 1. 创建网页配置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 1.1 创建设置
        WKPreferences *preference = [[WKPreferences alloc] init];
        preference.minimumFontSize = 10; // 设置字体大小（最小的字体大小）
        preference.javaScriptEnabled = YES; // 是否支持JavaScript
        preference.javaScriptCanOpenWindowsAutomatically = NO; // 不通过用户交互，是否可以打开窗口
        // 1.2 添加设置
        config.preferences = preference;
        
        // 2. 创建WKWebView
        CGFloat webViewH = BTSHEIGHT - BTSNavBarHeightAdded - BTSTabBarHeightAdded - NAVIGATION_BAR_HEIGHT;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, BTSWIDTH, webViewH) configuration:config];
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.allowsLinkPreview = YES;
        
        // 3. 添加KVO监听
        [_wkWebView addObserver:self forKeyPath:WKWebViewLoadingKey options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebView addObserver:self forKeyPath:WKWebViewTitleKey options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebView addObserver:self forKeyPath:WKWebViewProgressKey options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}

- (CALayer *)progresslayer {
    if (!_progresslayer) {
        _progresslayer = [CALayer layer];
        _progresslayer.frame = CGRectMake(0, 0, 0, 3);
        _progresslayer.backgroundColor = THEME_COLOR.CGColor;
    }
    return _progresslayer;
}

- (UIView *)progress {
    if (!_progress) {
        _progress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3)];
        _progress.backgroundColor = [UIColor clearColor];
        
        [_progress.layer addSublayer:self.progresslayer];
    }
    return _progress;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
