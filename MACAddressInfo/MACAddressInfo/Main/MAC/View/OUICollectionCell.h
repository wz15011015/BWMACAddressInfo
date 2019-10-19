//
//  OUICollectionCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/22.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const OUICollectionCellID;

#define OUI_COLLECTION_CELL_MARGIN_VER (10) // UICollectionViewCell竖直方向之间的间距
#define OUI_COLLECTION_CELL_MARGIN_HOR (5) // UICollectionViewCell水平方向之间的间距
#define OUI_COLLECTION_CELL_RATIO (2.5 / 1.0) // UICollectionViewCell的宽高比


NS_ASSUME_NONNULL_BEGIN

/**
 公司OUI列表 CollectionCell
 */
@interface OUICollectionCell : UICollectionViewCell

/** OUI编码 */
@property (nonatomic, copy) NSString *ouiCode;

@end

NS_ASSUME_NONNULL_END
