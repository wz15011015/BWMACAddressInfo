//
//  UIDevice+Extension.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "UIDevice+Extension.h"
#import <sys/utsname.h>

@implementation UIDevice (Extension)

/**
 获取设备名称 (e.g. "My iPhone")
 
 @return 设备名称
 */
+ (NSString *)deviceName {
    return [[UIDevice currentDevice] name];
}

/**
 获取设备类型 (e.g. @"iPhone", @"iPod touch")
 
 @return 设备类型
 */
+ (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

/**
 获取设备本地化的类型
 
 @return 设备本地化的类型
 */
+ (NSString *)deviceLocalizedModel {
    return [[UIDevice currentDevice] localizedModel];
}

/**
 获取设备的类型名称
 
 @return 设备类型名称
 */
+ (NSString *)deviceModelName { // 需要导入#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    
//    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSASCIIStringEncoding]; // Name of OS
//    NSString *nodename = [NSString stringWithCString:systemInfo.nodename encoding:NSASCIIStringEncoding]; // Name of this network node
//    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSASCIIStringEncoding]; // Release level
//    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSASCIIStringEncoding]; // Version level
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // https://www.theiphonewiki.com/wiki/Models
    // 1. iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone3,1"] ||
        [deviceModel isEqualToString:@"iPhone3,2"] ||
        [deviceModel isEqualToString:@"iPhone3,3"]) {
        return @"iPhone 4";
    }
    if ([deviceModel isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    }
    if ([deviceModel isEqualToString:@"iPhone5,1"] ||
        [deviceModel isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5";
    }
    if ([deviceModel isEqualToString:@"iPhone5,3"] ||
        [deviceModel isEqualToString:@"iPhone5,4"]) {
        return @"iPhone 5C";
    }
    if ([deviceModel isEqualToString:@"iPhone6,1"] ||
        [deviceModel isEqualToString:@"iPhone6,2"]) {
        return @"iPhone 5S";
    }
    if ([deviceModel isEqualToString:@"iPhone7,1"]) {
        return @"iPhone 6 Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone7,2"]) {
        return @"iPhone 6";
    }
    if ([deviceModel isEqualToString:@"iPhone8,1"]) {
        return @"iPhone 6s";
    }
    if ([deviceModel isEqualToString:@"iPhone8,2"]) {
        return @"iPhone 6s Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone8,4"]) {
        return @"iPhone SE";
    }
    if ([deviceModel isEqualToString:@"iPhone9,1"] ||
        [deviceModel isEqualToString:@"iPhone9,3"]) {
        return @"iPhone 7";
    }
    if ([deviceModel isEqualToString:@"iPhone9,2"] ||
        [deviceModel isEqualToString:@"iPhone9,4"]) {
        return @"iPhone 7 Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone10,1"] ||
        [deviceModel isEqualToString:@"iPhone10,4"]) {
        return @"iPhone 8";
    }
    if ([deviceModel isEqualToString:@"iPhone10,2"] ||
        [deviceModel isEqualToString:@"iPhone10,5"]) {
        return @"iPhone 8 Plus";
    }
    if ([deviceModel isEqualToString:@"iPhone10,3"] ||
        [deviceModel isEqualToString:@"iPhone10,6"]) {
        return @"iPhone X";
    }
    if ([deviceModel isEqualToString:@"iPhone11,2"]) {
        return @"iPhone Xs";
    }
    if ([deviceModel isEqualToString:@"iPhone11,4"] ||
        [deviceModel isEqualToString:@"iPhone11,6"]) {
        return @"iPhone Xs Max";
    }
    if ([deviceModel isEqualToString:@"iPhone11,8"]) {
        return @"iPhone XR";
    }
    
    // 2. iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch 1G";
    }
    if ([deviceModel isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch 2G";
    }
    if ([deviceModel isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch 3G";
    }
    if ([deviceModel isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch 4G";
    }
    if ([deviceModel isEqualToString:@"iPod5,1"]) {
        return @"iPod Touch 5G";
    }
    
    // 3. iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    }
    if ([deviceModel isEqualToString:@"iPad2,1"]) {
        return @"iPad 2 (WiFi)";
    }
    if ([deviceModel isEqualToString:@"iPad2,2"]) {
        return @"iPad 2 (GSM)";
    }
    if ([deviceModel isEqualToString:@"iPad2,3"]) {
        return @"iPad 2 (CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPad2,4"]) {
        return @"iPad 2 (32nm)";
    }
    if ([deviceModel isEqualToString:@"iPad3,1"]) {
        return @"iPad 3(WiFi)";
    }
    if ([deviceModel isEqualToString:@"iPad3,2"]) {
        return @"iPad 3(CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPad3,3"]) {
        return @"iPad 3(4G)";
    }
    if ([deviceModel isEqualToString:@"iPad3,4"]) {
        return @"iPad 4 (WiFi)";
    }
    if ([deviceModel isEqualToString:@"iPad3,5"]) {
        return @"iPad 4 (4G)";
    }
    if ([deviceModel isEqualToString:@"iPad3,6"]) {
        return @"iPad 4 (CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPad4,1"]) {
        return @"iPad Air";
    }
    if ([deviceModel isEqualToString:@"iPad4,2"]) {
        return @"iPad Air";
    }
    if ([deviceModel isEqualToString:@"iPad4,3"]) {
        return @"iPad Air";
    }
    if ([deviceModel isEqualToString:@"iPad5,3"]) {
        return @"iPad Air 2";
    }
    if ([deviceModel isEqualToString:@"iPad5,4"]) {
        return @"iPad Air 2";
    }
    if ([deviceModel isEqualToString:@"iPad6,7"] ||
        [deviceModel isEqualToString:@"iPad6,8"]) {
        return @"iPad Pro(12.9-inch)";
    }
    if ([deviceModel isEqualToString:@"iPad6,3"] ||
        [deviceModel isEqualToString:@"iPad6,4"]) {
        return @"iPad Pro(9.7-inch)";
    }
    if ([deviceModel isEqualToString:@"iPad6,11"] ||
        [deviceModel isEqualToString:@"iPad6,12"]) {
        return @"iPad Pro(5th generation)";
    }
    if ([deviceModel isEqualToString:@"iPad7,1"] ||
        [deviceModel isEqualToString:@"iPad7,2"]) {
        return @"iPad Pro(12.9-inch, 2nd generation)";
    }
    if ([deviceModel isEqualToString:@"iPad7,3"] ||
        [deviceModel isEqualToString:@"iPad7,4"]) {
        return @"iPad Pro(10.5-inch)";
    }
    
    // 4. iPad mini系列
    if ([deviceModel isEqualToString:@"iPad2,5"]) {
        return @"iPad mini (WiFi)";
    }
    if ([deviceModel isEqualToString:@"iPad2,6"]) {
        return @"iPad mini (GSM)";
    }
    if ([deviceModel isEqualToString:@"iPad2,7"]) {
        return @"iPad mini (CDMA)";
    }
    if ([deviceModel isEqualToString:@"iPad4,4"] ||
        [deviceModel isEqualToString:@"iPad4,5"] ||
        [deviceModel isEqualToString:@"iPad4,6"]) {
        return @"iPad mini 2";
    }
    if ([deviceModel isEqualToString:@"iPad4,7"] ||
        [deviceModel isEqualToString:@"iPad4,8"] ||
        [deviceModel isEqualToString:@"iPad4,9"]) {
        return @"iPad mini 3";
    }
    if ([deviceModel isEqualToString:@"iPad5,1"] ||
        [deviceModel isEqualToString:@"iPad5,2"]) {
        return @"iPad mini 4";
    }
    
    // 5. 模拟器
    if ([deviceModel isEqualToString:@"i386"]) {
        return @"Simulator";
    }
    if ([deviceModel isEqualToString:@"x86_64"]) {
        return @"Simulator";
    }
    
    return deviceModel;
}

/**
 获取设备的系统名称 (e.g. @"iOS")
 
 @return 设备的系统名称
 */
+ (NSString *)deviceSystemName {
    return [[UIDevice currentDevice] systemName];
}

/**
 获取设备的系统版本 (e.g. @"4.0")
 
 @return 设备的系统版本
 */
+ (NSString *)deviceSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

@end
