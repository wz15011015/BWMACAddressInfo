//
//  StatisticsManager.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StatisticsManagerInstance [StatisticsManager sharedInstance]

NS_ASSUME_NONNULL_BEGIN

/**
 数据统计管理类
 */
@interface StatisticsManager : NSObject

#pragma mark - Company

/** OUI数量排名前20的公司 */
@property (nonatomic, strong) NSArray *top20Companys;

/** 国家排名 (按公司数量) */
@property (nonatomic, strong) NSArray *countriesOfCompanyRank;


+ (instancetype)sharedInstance;


@end

NS_ASSUME_NONNULL_END
