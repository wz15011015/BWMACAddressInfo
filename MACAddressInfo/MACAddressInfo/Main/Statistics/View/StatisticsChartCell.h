//
//  StatisticsChartCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, StatisticsChartCellType) {
    ChartCellDefault,
    ChartCellCompanyRank,
    ChartCellCountryRank,
};

UIKIT_EXTERN NSString * _Nonnull const StatisticsChartCellID;

#define StatisticsChartCellH (70 + 200 + 5)


NS_ASSUME_NONNULL_BEGIN

@interface StatisticsChartCell : UITableViewCell

@property (nonatomic, assign) StatisticsChartCellType cellType;


#pragma mark - Data

/** 加载前20名公司数据 */
- (void)loadDataForTop20Companys;

/** 加载全部国家的公司数量数据 */
- (void)loadDataForCountries;

@end

NS_ASSUME_NONNULL_END
