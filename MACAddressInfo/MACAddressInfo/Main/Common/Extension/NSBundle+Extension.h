//
//  NSBundle+Extension.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/23.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Extension)

/**
 App名称
 
 @return 名称
 */
+ (NSString *)appName;

/**
 App版本号
 
 @return 版本号
 */
+ (NSString *)appVersion;

/**
 App Build版本号
 
 @return Build版本号
 */
+ (NSString *)appBuildVersion;

@end

NS_ASSUME_NONNULL_END
