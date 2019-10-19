//
//  UIColor+Extension.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/4.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "UIColor+Extension.h"

/**
 * @abstract 构造UIColor
 * @param red 红色, 0 - 255
 * @param green 绿, 0 - 255
 * @param blue 蓝, 0 - 255
 * @return UIColor
 */
UIColor *RGB(UInt8 red, UInt8 green, UInt8 blue) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

/**
 * @abstract 构造UIColor
 * @param red 红色, 0 - 255
 * @param green 绿, 0 - 255
 * @param blue 蓝, 0 - 255
 * @param alpha 透明度, 0.0 - 1.0
 * @return UIColor
 */
UIColor *RGBA(UInt8 red, UInt8 green, UInt8 blue, CGFloat alpha) {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}


@implementation UIColor (Extension)

@end
