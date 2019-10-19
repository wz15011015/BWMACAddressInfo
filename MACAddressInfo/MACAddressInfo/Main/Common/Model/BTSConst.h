//
//  BTSConst.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 字符串常量

UIKIT_EXTERN NSString *const UserDefaultsAppLanguageCodeKey;

UIKIT_EXTERN NSString *const DatabaseEncryptKey;

/** 公司中特殊公司的名字: Private (无效数据) */
UIKIT_EXTERN NSString *const CompanyPrivateName;


#pragma mark - 类型常量

// 广告时长(秒数)
UIKIT_EXTERN const NSInteger LaunchAdDuration;



NS_ASSUME_NONNULL_BEGIN

@interface BTSConst : NSObject

@end

NS_ASSUME_NONNULL_END
