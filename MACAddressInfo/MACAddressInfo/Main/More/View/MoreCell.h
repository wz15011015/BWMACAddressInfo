//
//  MoreCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/18.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * _Nonnull const MoreCellID;

#define MoreCellH 44


NS_ASSUME_NONNULL_BEGIN

@interface MoreCell : UITableViewCell

/** 标题 */
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
