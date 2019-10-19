//
//  UIImage+Extension.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/8.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

@end



@implementation UIImage (Scale)

/** 图片等比例缩放 */
- (UIImage *)imageCompressEqualProportionWithSize:(CGSize)size {
    UIImage *newImage = nil;
    CGFloat width = self.size.width; // original width
    CGFloat height = self.size.height; // original height
    
    CGFloat scaleFactorWidth = 0.0;
    CGFloat scaleFactorHeight = 0.0;
    CGFloat scaledWidth = size.width;
    CGFloat scaledHeight = size.height;
    
    scaleFactorWidth = width / size.width;
    scaleFactorHeight = height / size.height;
    if (scaleFactorHeight > scaleFactorWidth) {
        scaledWidth = width / scaleFactorHeight;
    } else {
        scaledHeight = height / scaleFactorWidth;
    }
//    NSLog(@"imageCompressEqualProportion:(%f %f) (%f %f) %f %f", width, height, scaledWidth, scaledHeight, scaleFactorWidth, scaleFactorHeight);
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end



@implementation UIImage (Rendering)

/** 给图片着色 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeColor];
}

/** 使用系统方法添加滤镜给图片着色 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    UIRectFill(bounds);
    
    // Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    // kCGBlendModeOverlay能保留灰度信息,kCGBlendModeDestinationIn能保留透明度信息
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
