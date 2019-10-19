//
//  CompanyOUIsCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const CompanyOUIsCellID;

#define CompanyOUIsCellH 240

@class CompanyModel;


NS_ASSUME_NONNULL_BEGIN

/**
 公司OUI列表 Cell
 */
@interface CompanyOUIsCell : UITableViewCell

/** 公司对象 */
@property (nonatomic, strong) CompanyModel *company;

/** 跳转到OUI列表 事件的回调 */
@property (nonatomic, copy) void(^jumpToListBlock)(void);

@end

NS_ASSUME_NONNULL_END
