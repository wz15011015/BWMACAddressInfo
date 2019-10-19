//
//  CompanyModel.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/11.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 公司模型 (遵守了NSCoding协议,实现了归档/解档)
 */
@interface CompanyModel : NSObject <NSCoding, NSSecureCoding>

/** 公司ID */
@property (nonatomic, copy) NSString *company_id;

/** 公司名称 */
@property (nonatomic, copy) NSString *name;

/** 公司所在街道 */
@property (nonatomic, copy) NSString *street;

/** 公司所在城市 */
@property (nonatomic, copy) NSString *city;

/** 公司所在省份/州 */
@property (nonatomic, copy) NSString *province;

/** 公司所在国家 */
@property (nonatomic, copy) NSString *country;

/** 公司所在地区的邮编 */
@property (nonatomic, copy) NSString *postCode;

/** 公司所在国家的代码 */
@property (nonatomic, copy) NSString *countryCode;

/** 公司的名称(中文) */
@property (nonatomic, copy) NSString *name_zh;

/** 公司所在街道(中文) */
@property (nonatomic, copy) NSString *street_zh;

/** 公司所在城市(中文) */
@property (nonatomic, copy) NSString *city_zh;

/** 公司所在省份/州(中文) */
@property (nonatomic, copy) NSString *province_zh;

/** 公司所在国家(中文) */
@property (nonatomic, copy) NSString *country_zh;


/** 公司的OUI列表 (["F8E94E", "F40616"]) */
@property (nonatomic, strong) NSArray <NSString *>*ouiList;

/** 公司的OUI个数 */
@property (nonatomic, assign) NSInteger ouiCount;

/** 公司的OUI排名 (根据OUI个数来排序的) */
@property (nonatomic, copy) NSString *ouiRank;

/** 公司网址 */
@property (nonatomic, copy) NSString *company_url;


// MARK: 国际化
/** 公司的名称(国际化) */
@property (nonatomic, copy) NSString *name_local;

/** 公司所在街道(国际化) */
@property (nonatomic, copy) NSString *street_local;

/** 公司所在城市(国际化) */
@property (nonatomic, copy) NSString *city_local;

/** 公司所在省份/州(国际化) */
@property (nonatomic, copy) NSString *province_local;

/** 公司所在国家(国际化) */
@property (nonatomic, copy) NSString *country_local;

@end

NS_ASSUME_NONNULL_END
