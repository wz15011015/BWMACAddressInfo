//
//  WiFiManager.h
//  AirCleaner
//
//  Created by Shaojun Han on 10/14/15.
//  Copyright © 2015 HadLinks. All rights reserved.

#import <Foundation/Foundation.h>
#import "Reachability.h"

#define WiFiManagerInstance [WiFiManager sharedInstance]


/**
 * WiFi连接状态监听类
 */
@interface WiFiManager : NSObject

@property (nonatomic, copy) NSString *wifiName;     // WiFi名称(ssid)
@property (nonatomic, copy) NSString *broadAddress; // 广播地址

/**
 * 单例方法
 */
+ (instancetype)sharedInstance;


/**
 判断Wi-Fi开关是否打开
 
 @return 开关状态
 */
- (BOOL)isWiFiEnabled;

/**
 * 获取当前WiFi的名称(ssid)
 */
- (NSString *)wifiName;

/**
 * 获取当前WiFi的MAC地址
 */
- (NSString *)wifiMacAddress;

/**
 * 获取路由器的广播地址
 */
- (NSString *)broadAddress;

@end
