//
//  NSBundle+Extension.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

/**
 App名称
 
 @return 名称
 */
+ (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

/**
 App版本号

 @return 版本号
 */
+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 App Build版本号
 
 @return Build版本号
 */
+ (NSString *)appBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
