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

/** 从.txt文件中解析OUI数据 */
+ (void)loadOUIDataFromTxt;

/** 从.txt文件中统计OUI数据 */
+ (void)loadOUIDataStatisticsFromTxt;

+ (void)OUIDataDebug;

+ (void)OUIDataDebugForCompany;

/** 统计每个公司的OUI列表 */
+ (void)OUIDataCountEachCompanyOUIList;

@end

NS_ASSUME_NONNULL_END
