//
//  WiFiManager.m
//  AirCleaner
//
//  Created by Shaojun Han on 10/14/15.
//  Copyright © 2015 HadLinks. All rights reserved.
//

#import <systemconfiguration/captivenetwork.h>
#import <corefoundation/corefoundation.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/socket.h>

#import "WiFiManager.h"

@interface WiFiManager () {
    Reachability *_reachability;
}

@end

@implementation WiFiManager

/**
 * 单例方法
 */
+ (instancetype)sharedInstance {
    static WiFiManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:_reachability];
        
        _reachability = [Reachability reachabilityForLocalWiFi];
        [_reachability startNotifier];
    }
    return self;
}


/**
 判断Wi-Fi开关是否打开
 
 @return 开关状态
 */
- (BOOL)isWiFiEnabled {
    NSCountedSet *cset = [[NSCountedSet alloc] init];
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        for (struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ((interface->ifa_flags & IFF_UP) == IFF_UP) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

/**
 * 获取当前WiFi的名称(ssid)
 */
- (NSString *)wifiName {
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *interfaceName in interfaces) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)interfaceName);
        if (info) {
            break;
        }
    }
    NSDictionary *infoDic = (NSDictionary *)info;
    NSString *ssid = [infoDic objectForKey:@"SSID"]; // WiFi的名称
    NSString *bssid = [infoDic objectForKey:@"BSSID"]; // WiFi的mac地址
    NSLog(@"WiFi SSID=%@ MAC=%@", ssid, bssid);
    return ssid;
}

/**
 * 获取当前WiFi的MAC地址
 */
- (NSString *)wifiMacAddress {
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *interfaceName in interfaces) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)interfaceName);
        if (info) {
            break;
        }
    }
    NSDictionary *infoDic = (NSDictionary *)info;
//    NSString *ssid = [infoDic objectForKey:@"SSID"]; // WiFi的名称
    NSString *bssid = [infoDic objectForKey:@"BSSID"]; // WiFi的mac地址
    
    
    // 针对: d0:ee:7:2d:7d:68 的处理,补零变为: d0:ee:07:2d:7d:68
    NSMutableArray *ssidArr = [NSMutableArray arrayWithArray:[bssid componentsSeparatedByString:@":"]];
    for (int i = 0; i < ssidArr.count; i++) {
        NSString *hexStr = ssidArr[i];
        if (hexStr.length == 1) { // 前面补零
            hexStr = [NSString stringWithFormat:@"0%@", hexStr];
            [ssidArr replaceObjectAtIndex:i withObject:hexStr];
        }
    }
    
    NSString *formatBssid = @"";
    for (int i = 0; i < ssidArr.count; i++) {
        NSString *hexStr = ssidArr[i];
        if (i == ssidArr.count - 1) {
            formatBssid = [NSString stringWithFormat:@"%@%@", formatBssid, hexStr];
        } else {
            formatBssid = [NSString stringWithFormat:@"%@%@:", formatBssid, hexStr];
        }
    }
    
    return formatBssid;
}

/**
 * 获取路由器的广播地址
 */
- (NSString *)broadAddress {
    NSString *routerBroadCastAddress = @"255.255.255.255";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    if (getifaddrs(&interfaces) == 0 && (temp_addr = interfaces) != NULL) {
        // Loop through linked list of interfaces
        do {
            if (temp_addr->ifa_addr->sa_family == AF_INET &&
               [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                // Get NSString from C String // ifa_addr
                // ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                // routerBroadCastAddress
                
                // 找到广播地址，结束
                routerBroadCastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                break;

                /**
                // localIPAddress
                localIPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                // netmask
                netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                // en0Port
                en0Port = [NSString stringWithUTF8String:temp_addr->ifa_name];
                // address
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                **/
            }
            
        } while ((temp_addr = temp_addr->ifa_next) != NULL);
    }
    // Free memory
    freeifaddrs(interfaces);
    return routerBroadCastAddress;
}


#pragma mark - Notification

/**
 * WiFi连接状态变化的通知
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
    NSLog(@"WiFiManager Rreachability Changed: %@", statusStr);
}

@end
