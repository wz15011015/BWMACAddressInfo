//
//  ImageCollectionCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const ImageCollectionCellID;

#define IMAGE_CELL_MARGIN_VER (0) // Cell竖直方向之间的间距
#define IMAGE_CELL_MARGIN_HOR (15) // Cell水平方向之间的间距
#define IMAGE_CELL_RATIO (1.0 / 1.0) // Cell的宽高比


NS_ASSUME_NONNULL_BEGIN

/**
 反馈页面图片Cell
 */
@interface ImageCollectionCell : UICollectionViewCell

/** 图片 */
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

/** 是否为添加Cell */
@property (nonatomic, assign) BOOL isAddCell;

/** 删除事件回调 */
@property (nonatomic, copy) void(^deleteImageBlock)(void);

@end

NS_ASSUME_NONNULL_END
