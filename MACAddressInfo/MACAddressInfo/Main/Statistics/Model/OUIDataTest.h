//
//  OUIDataTest.h
//  MACAddressInfo
//
//  Created by hadlinks on 2019/10/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据 调试/测试 类
@interface OUIDataTest : NSObject

/// 从oui.txt文件中加载OUI数据
+ (void)loadOUIDataFromOUITXTFile;

/// 从oui.txt文件中加载OUI统计数据
+ (void)loadOUIStatisticsDataFromOUITXTFile;


+ (void)OUIDataDebug;

+ (void)OUIDataDebugForCompany;

/** 统计每个公司的OUI列表 */
+ (void)OUIDataCountEachCompanyOUIList;

@end

NS_ASSUME_NONNULL_END
