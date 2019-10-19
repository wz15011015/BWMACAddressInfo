//
//  UIDevice+Extension.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extension)

/**
 获取设备名称 (e.g. "My iPhone")
 
 @return 设备名称
 */
+ (NSString *)deviceName;

/**
 获取设备类型 (e.g. @"iPhone", @"iPod touch")
 
 @return 设备类型
 */
+ (NSString *)deviceModel;

/**
 获取设备本地化的类型
 
 @return 设备本地化的类型
 */
+ (NSString *)deviceLocalizedModel;

/**
 获取设备的类型名称
 
 @return 设备类型名称
 */
+ (NSString *)deviceModelName;

/**
 获取设备的系统名称 (e.g. @"iOS")
 
 @return 设备的系统名称
 */
+ (NSString *)deviceSystemName;

/**
 获取设备的系统版本 (e.g. @"4.0")
 
 @return 设备的系统版本
 */
+ (NSString *)deviceSystemVersion;

@end

NS_ASSUME_NONNULL_END
