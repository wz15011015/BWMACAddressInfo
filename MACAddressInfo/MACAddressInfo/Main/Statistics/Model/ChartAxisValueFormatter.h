//
//  ChartAxisValueFormatter.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/15.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;

NS_ASSUME_NONNULL_BEGIN

/**
 坐标轴显示数据格式器
 */
@interface ChartAxisValueFormatter : NSObject <IChartAxisValueFormatter>

@property (nonatomic, strong) NSArray *valueArray;


- (id)initWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
