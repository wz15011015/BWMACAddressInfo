//
//  NetworkManager.h
//  LifeShanghai
//
//  Created by wenjun on 12-12-1.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define NetworkManagerInstance [NetworkManager sharedInstance]

@class NetworkManager;

/**
 * 网络连接状态发生变化时回调
 */
@protocol NetworkManagerDelegate <NSObject>

@required
- (void)networkManager:(NetworkManager *)util networkStatusChanged:(NetworkStatus)status;

@end


/**
 网络连接状态监听类
 */
@interface NetworkManager : NSObject

/** 网络连接状态 */
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

/** 网络是否可用 */
@property (nonatomic, assign, readonly) BOOL networkAvailable;

/** WiFi是否可用 */
@property (nonatomic, assign, readonly) BOOL wifiAvailable;


+ (instancetype)sharedInstance;

/**
 * 网络代理
 */
- (void)addDelegate:(id<NetworkManagerDelegate>)delegate;
- (void)removeDelegate:(id<NetworkManagerDelegate>)delegate;

@end
