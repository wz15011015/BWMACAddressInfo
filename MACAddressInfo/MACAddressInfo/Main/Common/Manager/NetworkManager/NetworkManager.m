//
//  NetworkManager.m
//  LifeShanghai
//
//  Created by wenjun on 12-12-1.
//

#import "NetworkManager.h"
#import "Reachability.h"

#define HostOfApple @"www.apple.com"


@interface NetworkManagerDelegateObject : NSObject

@property (weak, nonatomic) id<NetworkManagerDelegate>delegate;

- (instancetype)initWithDelegate:(id<NetworkManagerDelegate>)delegate;

@end

@implementation NetworkManagerDelegateObject

- (instancetype)initWithDelegate:(id<NetworkManagerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

@end


@interface NetworkManager () {
    NSMutableArray *_delegateQueue;
    Reachability   *_reachability;
}

@end

@implementation NetworkManager

/**
 * 单例
 */
+ (instancetype)sharedInstance {
    static NetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_delegateQueue removeAllObjects];
}

/**
 * 初始化
 */
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:_reachability];
        
        _delegateQueue = [NSMutableArray array];
        _reachability = [Reachability reachabilityWithHostName:HostOfApple];
        [_reachability startNotifier];
    }
    return self;
}

/**
 * 网络代理
 */
/**
 * 添加代理
 * 移除代理
 */
- (void)addDelegate:(id<NetworkManagerDelegate>)delegate {
    if (!delegate) { // 非法值
        return;
    }
    for (NetworkManagerDelegateObject *delegateObject in _delegateQueue) {
        if (delegate == delegateObject.delegate) { // 已经添加过了
            return;
        }
    }
    NetworkManagerDelegateObject *delegateObject = [[NetworkManagerDelegateObject alloc] initWithDelegate:delegate];
    [_delegateQueue addObject:delegateObject];
}

- (void)removeDelegate:(id<NetworkManagerDelegate>)delegate {
    if (!delegate) { // 非法值
        return;
    }
    
    for (int i = (int)_delegateQueue.count - 1; i >= 0; --i) {
        NetworkManagerDelegateObject *delegateObject = [_delegateQueue objectAtIndex:i];
        if (delegateObject.delegate == nil) {
            [_delegateQueue removeObject:delegateObject];
        }
        if (!(delegate == delegateObject.delegate)) {
            continue;
        }
        // 找到删除
        [_delegateQueue removeObject:delegateObject];
        break;
    }
}


#pragma mark - Notification

/**
 * 网络连接状态变化的通知
 */
- (void)reachabilityChanged:(NSNotification *)notification {
    NetworkStatus status = _reachability.currentReachabilityStatus;
    NSString *statusStr = @"";
    if (status == NotReachable) {
        statusStr = @"NotReachable";
    } else if (status == ReachableViaWiFi) {
        statusStr = @"ReachableViaWiFi";
    } else if (status == ReachableViaWWAN) {
        statusStr = @"ReachableViaWWAN";
    }
    NSLog(@"NetworkManager Rreachability Changed: %@", statusStr);
    
    for (int i = (int)_delegateQueue.count - 1; i >= 0; --i) {
        NetworkManagerDelegateObject *delegateObject = [_delegateQueue objectAtIndex:i];
        if (delegateObject.delegate == nil) {
            [_delegateQueue removeObject:delegateObject];
        } else if ([delegateObject.delegate respondsToSelector:@selector(networkManager:networkStatusChanged:)]) {
            [delegateObject.delegate networkManager:self networkStatusChanged:[self networkStatus]];
        }
    }
}


#pragma mark - Getters

/** 网络连接状态 */
- (NetworkStatus)networkStatus {
    return _reachability.currentReachabilityStatus;
}

/** 网络是否可用 */
- (BOOL)networkAvailable {
    return _reachability.currentReachabilityStatus != NotReachable;
}

/** WiFi是否可用 */
- (BOOL)wifiAvailable {
    return _reachability.currentReachabilityStatus == ReachableViaWiFi;
}

@end
