//
//  StatisticsHeaderView.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "StatisticsHeaderView.h"
#import <WebKit/WebKit.h>
#import "Common.h"

@interface StatisticsHeaderView ()

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation StatisticsHeaderView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        // xib的加载方式
        self = [[[NSBundle mainBundle] loadNibNamed:@"StatisticsHeaderView" owner:nil options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 1. 添加控件
    [self addSubview:self.wkWebView];
    
    // 2. 加载数据
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com/homepod/"]];
//    [self.wkWebView loadRequest:request];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"StatisticsHeaderView" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:htmlStr baseURL:nil];
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
        CGFloat webViewH = 120;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BTSWIDTH, webViewH) configuration:config];
//        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.allowsLinkPreview = YES;
        _wkWebView.scrollView.scrollEnabled = NO;
        
        // 3. 添加KVO监听
//        [_wkWebView addObserver:self forKeyPath:WKWebViewLoadingKey options:NSKeyValueObservingOptionNew context:nil];
//        [_wkWebView addObserver:self forKeyPath:WKWebViewTitleKey options:NSKeyValueObservingOptionNew context:nil];
//        [_wkWebView addObserver:self forKeyPath:WKWebViewProgressKey options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
