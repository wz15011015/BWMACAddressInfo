//
//  XYMarkerView.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation
import Charts

open class XYMarkerView: BalloonMarker {
    @objc public enum XYMarkerType: Int {
        case defaultType
        case companyName
        case countryName
    }
    
    @objc open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    @objc open var markerType = XYMarkerType.defaultType
    /**
     * open,public对应的级别是该模块或者是引用了该模块的模块可以访问
     * private作用于某个类
     * fileprivate的适用场景可以是某个文件的extension，如果你的类中定义了private变量,那么这个变量在你这个类的扩展文件中就无法访问了，这时就需要定义为fileprivate
     
     * 在项目中如果想把 Swift 写的 API 暴露给 Objective-C 调用，需要增加 @objc。在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc。
     */
    @objc var companyName: String?
    @objc var countryName: String?
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    @objc open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        if markerType == .companyName {
            setLabel(self.companyName ?? "")
            
        } else if markerType == .countryName {
            setLabel(self.countryName ?? "")
            
        } else {
            setLabel("x: " + xAxisValueFormatter!.stringForValue(entry.x, axis: nil) + ", y: " + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!)
        }
    }
}
