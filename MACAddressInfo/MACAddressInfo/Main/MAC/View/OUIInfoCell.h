//
//  OUIInfoCell.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 OUI信息类型

 - OUIInfoOUICode: 编码信息
 - OUIInfoCompany: 公司信息
 - OUIInfoStreet: 街道信息
 - OUIInfoCity: 城市信息
 - OUIInfoProvince: 省份/州信息
 - OUIInfoPostCode: 邮编信息
 - OUIInfoCountryCode: 国家代码信息
 */
typedef NS_ENUM(NSUInteger, OUIInfoType) {
    OUIInfoOUICode,
    OUIInfoCompany,
    OUIInfoStreet,
    OUIInfoCity,
    OUIInfoProvince,
    OUIInfoPostCode,
    OUIInfoCountryCode,
};

UIKIT_EXTERN NSString *const OUIInfoCellID;

#define OUIInfoCellH 52

@class OUIModel, CompanyModel, CountryModel;

NS_ASSUME_NONNULL_BEGIN


/**
 OUI信息Cell
 */
@interface OUIInfoCell : UITableViewCell

@property (nonatomic, assign) OUIInfoType infoType;

/** OUI对象 */
@property (nonatomic, strong) OUIModel *ouiModel;

/** 公司对象 */
@property (nonatomic, strong) CompanyModel *company;

/** 国家对象 */
@property (nonatomic, strong) CountryModel *country;


#pragma mark - Public Methods

/** 根据索引值返回Cell的显示类型 (OUI信息页面) */
+ (OUIInfoType)infoTypeForOUIInfoWihtIndex:(NSInteger)index;

/** 根据索引值返回Cell的显示类型 (公司信息页面) */
+ (OUIInfoType)infoTypeForCompanyInfoWihtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
