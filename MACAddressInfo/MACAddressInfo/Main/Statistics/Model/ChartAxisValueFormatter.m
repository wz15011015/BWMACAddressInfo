//
//  BarValueFormatter.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/15.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "ChartAxisValueFormatter.h"

@implementation ChartAxisValueFormatter

- (id)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        _valueArray = array;
    }
    return self;
}


#pragma mark - IChartAxisValueFormatter

// 返回X轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    NSInteger xIndex = (NSInteger)value - 1;
    if (xIndex >= 0 && xIndex < _valueArray.count) {
        return _valueArray[xIndex];
    } else {
        return @"";
    }
}

@end
