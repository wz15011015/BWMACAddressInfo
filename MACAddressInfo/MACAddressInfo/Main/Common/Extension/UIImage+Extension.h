//
//  UIImage+Extension.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/8.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

@end



@interface UIImage (Scale)

/** 图片等比例缩放 */
- (UIImage *)imageCompressEqualProportionWithSize:(CGSize)size;

@end



@interface UIImage (Rendering)

/** 给图片着色 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

/** 使用系统方法添加滤镜给图片着色 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end

NS_ASSUME_NONNULL_END
