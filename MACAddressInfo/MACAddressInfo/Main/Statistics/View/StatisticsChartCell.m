//
//  StatisticsChartCell.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "StatisticsChartCell.h"
#import "Common.h"
#import "MACAddressInfo-Bridging-Header.h"
#import "MACAddressInfo-Swift.h"
#import "ChartAxisValueFormatter.h"
#import "CountryModel.h"

NSString *const StatisticsChartCellID = @"StatisticsChartCellIdentifier";

@interface StatisticsChartCell () <ChartViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) BarChartView *barChartView;
@property (nonatomic, strong) XYMarkerView *barChartMarker;

@end

@implementation StatisticsChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.barChartView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Data

- (void)loadDataForTop20Companys {
    // 设置柱形图数据
    self.barChartView.data = [self barChartDataOfTop20Companys];
    // 设置动画效果(可以设置X轴和Y轴的动画效果)
    [self.barChartView animateWithYAxisDuration:1.5];
    
    /**
     * 通过设置X轴最小/最大可视范围,即可达到限制缩放范围的要求.
     * 需要在设置数据源后生效（这是一个坑，懒加载写这个方法并没任何反应，必须在调用数据后使用才有效果.
     */
    // 设置一页显示的数据条数，超出的数量需要滑动查看
    [self.barChartView setVisibleXRangeMinimum:5];
    [self.barChartView setVisibleXRangeMaximum:10];
}

// 柱形图数据 (前20名公司)
- (BarChartData *)barChartDataOfTop20Companys {
    NSArray *companys = StatisticsManagerInstance.top20Companys;
    NSInteger xValuesCount = companys.count;
    
    // X轴需要显示的数据 (排名)
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < xValuesCount; i++) {
        NSString *str = [NSString stringWithFormat:BTSLocalizedString(@"No.%ld", nil), i + 1];
        [xValues addObject:str];
    }
    self.barChartView.xAxis.valueFormatter = [[ChartAxisValueFormatter alloc] initWithArray:xValues];
    self.barChartView.xAxis.labelCount = xValuesCount;
    
    // Y轴需要显示的数据 (ouiCount)
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < xValuesCount; i++) {
        CompanyModel *company = companys[i];
        double x = (i + 1) * 1.0;
        double y = company.ouiCount * 1.0;
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:x y:y];
        [yValues addObject:entry];
    }
    
    
    // 1. 创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *dataSet1 = nil;
    if (self.barChartView.data.dataSetCount > 0) {
        dataSet1 = (BarChartDataSet *)self.barChartView.data.dataSets[0];
        dataSet1.values = yValues;
        [self.barChartView.data notifyDataChanged];
        [self.barChartView notifyDataSetChanged];
    } else {
        dataSet1 = [[BarChartDataSet alloc] initWithValues:yValues label:nil];
        dataSet1.drawValuesEnabled = YES; // 是否在柱形图上面显示数值
        dataSet1.valueFont = [UIFont systemFontOfSize:11]; // y数值字体
        //    dataSet1.highlightEnabled = NO; // 点击选中柱形图是否有高亮效果,（双击空白处取消选中）
        //    dataSet1.highlightColor = [UIColor orangeColor]; // 柱状条高亮颜色
        //    dataSet1.barBorderWidth = 0.0; // 柱状条的边框
        [dataSet1 setColors:ChartColorTemplates.colorful]; // 设置柱状条颜色
        //    dataSet1.valueFormatter = self; // 柱状图顶部显示数据的代理
        //    dataSet1.formSize = 15.0; // 图例方块的大小
        //    dataSet1.formLineWidth = 1.0;
    }
    
    // 2. 将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:dataSet1];
    
    // 3. 创建BarChartData对象,此对象就是BarChartView需要的最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    // 最大值为1,数值越大,柱状条就越宽
    //    data.barWidth = 1.0;
    //    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]]; // 文字字体
    //    [data setValueTextColor:[UIColor orangeColor]]; // 文字颜色
    
    return data;
}

- (void)loadDataForCountries {
    // 设置柱形图数据
    self.barChartView.data = [self barChartDataOfCountries];
    // 设置动画效果(可以设置X轴和Y轴的动画效果)
    [self.barChartView animateWithYAxisDuration:1.5];
    
    /**
     * 通过设置X轴最小/最大可视范围,即可达到限制缩放范围的要求.
     * 需要在设置数据源后生效（这是一个坑，懒加载写这个方法并没任何反应，必须在调用数据后使用才有效果.
     */
    // 设置一页显示的数据条数，超出的数量需要滑动查看
    [self.barChartView setVisibleXRangeMinimum:5];
    [self.barChartView setVisibleXRangeMaximum:10];
}

- (BarChartData *)barChartDataOfCountries {
    NSArray *countries = StatisticsManagerInstance.countriesOfCompanyRank;
    NSInteger xValuesCount = countries.count;
    
    // X轴需要显示的数据
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < xValuesCount; i++) {
//        CountryModel *model = countries[i];
        NSString *str = [NSString stringWithFormat:@"%d", i + 1];
        [xValues addObject:str];
    }
    self.barChartView.xAxis.valueFormatter = [[ChartAxisValueFormatter alloc] initWithArray:xValues];
    self.barChartView.xAxis.labelCount = xValuesCount;
    
    // Y轴需要显示的数据
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < xValuesCount; i++) {
        CountryModel *model = countries[i];
        double x = (i + 1) * 1.0;
        double y = model.companyCount * 1.0;
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:x y:y];
        [yValues addObject:entry];
    }
    
    // 自定义格式
    NSNumberFormatter *leftYAxisFormatter = [[NSNumberFormatter alloc] init];
    leftYAxisFormatter.minimumFractionDigits = 0;
    leftYAxisFormatter.maximumFractionDigits = 1;
    leftYAxisFormatter.negativeSuffix = BTSLocalizedString(@"UnitOfCompany", nil); // 数字后缀单位
    leftYAxisFormatter.positiveSuffix = BTSLocalizedString(@"UnitOfCompany", nil);
    
    self.barChartView.leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftYAxisFormatter];
    
    
    // 1. 创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *dataSet1 = nil;
    if (self.barChartView.data.dataSetCount > 0) {
        dataSet1 = (BarChartDataSet *)self.barChartView.data.dataSets[0];
        dataSet1.values = yValues;
        [self.barChartView.data notifyDataChanged];
        [self.barChartView notifyDataSetChanged];
    } else {
        dataSet1 = [[BarChartDataSet alloc] initWithValues:yValues label:nil];
        dataSet1.drawValuesEnabled = YES; // 是否在柱形图上面显示数值
        dataSet1.valueFont = [UIFont systemFontOfSize:11]; // y数值字体
        [dataSet1 setColors:ChartColorTemplates.material]; // 设置柱状条颜色
    }
    
    // 2. 将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:dataSet1];
    
    // 3. 创建BarChartData对象,此对象就是BarChartView需要的最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    // 最大值为1,数值越大,柱状条就越宽
    //    data.barWidth = 1.0;
    //    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]]; // 文字字体
    //    [data setValueTextColor:[UIColor orangeColor]]; // 文字颜色
    
    return data;
}


#pragma mark - Setters

- (void)setCellType:(StatisticsChartCellType)cellType {
    _cellType = cellType;
    
    if (cellType == ChartCellCompanyRank) {
        self.titleLabel.text = BTSLocalizedString(@"1. Ranking of companies (the top 20, according to the number of OUI requested by the company)", nil);
        
        self.barChartMarker.markerType = XYMarkerTypeCompanyName;
        
        [self loadDataForTop20Companys];
        
    } else if (cellType == ChartCellCountryRank) {
        self.titleLabel.text = BTSLocalizedString(@"2. Ranking of countries or regions (according to the number of companies applying for OUI in the country or the region)", nil);
        
        self.barChartMarker.markerType = XYMarkerTypeCountryName;
        self.barChartView.xAxis.labelRotationAngle = 0;
        
        [self loadDataForCountries];
        
    } else {
        
    }
}

#pragma mark - ChartViewDelegate

// 选中了某个柱形图
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    NSInteger xIndex = (NSInteger)entry.x - 1;
    NSLog(@"选中了柱形图:%ld", xIndex);
    
    if (self.cellType == ChartCellCompanyRank) {
        NSArray *companys = StatisticsManagerInstance.top20Companys;
        CompanyModel *company = companys[xIndex];
        self.barChartMarker.companyName = company.name_local;
        
    } else if (self.cellType == ChartCellCountryRank) {
        NSArray *countries = StatisticsManagerInstance.countriesOfCompanyRank;
        CountryModel *country = countries[xIndex];
        NSString *str = [NSString stringWithFormat:@"%@: %@", country.code, country.name_local];
        self.barChartMarker.countryName = str;
        
    } else {
        
    }
}

// 取消选中柱形图
- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    NSLog(@"取消选中柱形图");
}

// 缩放了柱形图
- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    //    NSLog(@"缩放了柱形图");
}

// 拖拽了柱形图
- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    //    NSLog(@"拖拽了柱形图");
}


#pragma mark - Getters

- (BarChartView *)barChartView {
    if (!_barChartView) {
        _barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 70, BTSWIDTH, 200)];
        _barChartView.delegate = self;
        
        // 1. 基本样式设置
        // 背景颜色
//        _barChartView.backgroundColor = [UIColor orangeColor];
        // 没有数据时的文字提示
        _barChartView.noDataText = BTSLocalizedString(@"No Data", nil);
        // 数值显示在柱形图上面
        _barChartView.drawValueAboveBarEnabled = YES;
        // 是否绘制柱形图的背景阴影
        _barChartView.drawBarShadowEnabled = NO;
        
        
        // 2. 交互设置
        // Y轴缩放(打开/关闭)
        _barChartView.scaleYEnabled = NO;
        // X轴缩放(打开/关闭)
        _barChartView.scaleXEnabled = YES;
        // 双击缩放(打开/关闭)
        _barChartView.doubleTapToZoomEnabled = NO;
        // 拖拽(打开/关闭)
        _barChartView.dragEnabled = YES;
        // 拖拽后的惯性效果(打开/关闭)
        _barChartView.dragDecelerationEnabled = YES;
        // 拖拽后惯性效果的摩擦系数[0~1],值越大,惯性效果越明显
        _barChartView.dragDecelerationFrictionCoef = 0.8;
        
        // 只滑动不缩放:初始化时x轴就缩放1.5倍,就可以滑动了（系统内部默认是先缩放后滑动）
        ChartViewPortHandler *viewPortHandler = _barChartView.viewPortHandler;
        [viewPortHandler setMinimumScaleX:1.5];
        
        
        // 3. X轴样式设置 (先获取到BarChartView的X轴,然后再进行设置)
        ChartXAxis *xAxis = _barChartView.xAxis;
        xAxis.axisLineWidth = 1.0; // X轴线宽
        xAxis.labelPosition = XAxisLabelPositionBottom; // X轴Label显示在下面
        xAxis.labelFont = [UIFont systemFontOfSize:8.f]; // X轴Label文字字体
        //        xAxis.labelTextColor = THEME_COLOR; // X轴Label文字颜色
        xAxis.labelRotationAngle = 26; // X轴Label文字旋转角度
        xAxis.drawGridLinesEnabled = NO; // 是否绘制网格
        xAxis.granularity = 1.0; // only intervals of 1 day
        //        xAxis.labelCount = 20;
        //        xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:self.barChartView];
        
        
        // 4. Y轴样式设置 (BarChartView默认样式中会绘制左右两侧的Y轴)
        // 隐藏右侧的Y轴
        _barChartView.rightAxis.enabled = NO;
        
        // 4.1 Y坐标轴(左边)
        ChartYAxis *leftYAxis = _barChartView.leftAxis;
        
        // 4.1.1 设置Y轴上标签的样式
        leftYAxis.labelFont = [UIFont systemFontOfSize:8.f];
        //        leftYAxis.labelTextColor = [UIColor brownColor]; // 文字颜色
        leftYAxis.labelPosition = YAxisLabelPositionOutsideChart;
        //        leftYAxis.axisLineWidth = 1.0; // Y轴线宽
        //        leftYAxis.axisLineColor = [UIColor blackColor]; // Y轴颜色
        
        // 4.1.2 设置Y轴上标签显示数字的格式
        // 自定义格式
        NSNumberFormatter *leftYAxisFormatter = [[NSNumberFormatter alloc] init];
        leftYAxisFormatter.minimumFractionDigits = 0;
        leftYAxisFormatter.maximumFractionDigits = 1;
        leftYAxisFormatter.negativeSuffix = BTSLocalizedString(@"UnitOfOUI", nil); // 数字后缀单位
        leftYAxisFormatter.positiveSuffix = BTSLocalizedString(@"UnitOfOUI", nil);
        
        // 4.1.3 设置Y轴上网格线的样式
        // 设置虚线样式的网格线
        //        leftYAxis.gridLineDashLengths = @[@3.0f, @3.0f];
        // 网格线颜色
        //        leftYAxis.gridColor = RGB(200, 200, 200);
        // 开启抗锯齿
        //        leftYAxis.gridAntialiasEnabled = YES;
        
        
        // 在Y轴上添加限制线
        //        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];
        //        limitLine.lineWidth = 2;
        //        limitLine.lineColor = [UIColor greenColor];
        //        limitLine.lineDashLengths = @[@5.0f, @5.0f]; // 虚线样式
        //        limitLine.labelPosition = ChartLimitLabelPositionRightTop; // 位置
        //        [leftYAxis addLimitLine:limitLine]; // 添加到Y轴上
        //        leftYAxis.drawLimitLinesBehindDataEnabled = YES; // 设置限制线绘制在柱形图的后面
        
        
        // 通过labelCount属性设置Y轴要均分的数量.
        // 设置的labelCount的值不一定就是Y轴要均分的数量，这还要取决于forceLabelsEnabled属性，如果forceLabelsEnabled等于YES, 则强制绘制指定数量的label, 但是可能不是均分的.
        leftYAxis.labelCount = 5;
        // 是否强制绘制指定数量的label
        leftYAxis.forceLabelsEnabled = NO;
        leftYAxis.spaceTop = 0.15;
        // 设置Y轴的最小值
        leftYAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        // 设置Y轴的最大值
        //        leftYAxis.axisMaximum = 100;
        // 是否将Y轴进行上下翻转
        //        leftYAxis.inverted = NO;
        
        leftYAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftYAxisFormatter];
        
        // 4.2 Y坐标轴(右边)
        //    ChartYAxis *rightYAxis = self.barChartView.rightAxis;
        //    rightYAxis.enabled = YES;
        //    rightYAxis.drawGridLinesEnabled = NO;
        //    rightYAxis.labelFont = [UIFont systemFontOfSize:10.f];
        //    rightYAxis.labelCount = 8;
        //    rightYAxis.valueFormatter = leftAxis.valueFormatter;
        //    rightYAxis.spaceTop = 0.15;
        //    rightYAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
        
        
        // 5. 其他样式设置
        // 是否显示图例说明
        _barChartView.legend.enabled = NO;
        // 图例样式设置
        //        ChartLegend *legend = _barChartView.legend;
        //        legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
        //        legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        //        legend.orientation = ChartLegendOrientationHorizontal;
        //        legend.drawInside = NO;
        //        legend.form = ChartLegendFormSquare;
        //        legend.formSize = 9.0;
        //        legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
        //        legend.xEntrySpace = 4.0;
        
        // 点击柱状条时显示的View
        XYMarkerView *marker = [[XYMarkerView alloc]
                                initWithColor: [UIColor colorWithWhite:0.0 alpha:0.75]
                                font: [UIFont systemFontOfSize:14.0]
                                textColor: UIColor.whiteColor
                                insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
                                xAxisValueFormatter: _barChartView.xAxis.valueFormatter];
        marker.minimumSize = CGSizeMake(80.f, 40.f);
        marker.markerType = XYMarkerTypeDefaultType;
        marker.chartView = _barChartView;
        _barChartMarker = marker;
        _barChartView.marker = marker;
    }
    return _barChartView;
}

@end
