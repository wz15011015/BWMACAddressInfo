//
//  CountryModel.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/16.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 国家模型
 */
@interface CountryModel : NSObject

/** 国家编码 */
@property (nonatomic, copy) NSString *code;

/** 国家名称(英文) */
@property (nonatomic, copy) NSString *name;

/** 国家名称(中文) */
@property (nonatomic, copy) NSString *name_zh;

/** 公司数量 */
@property (nonatomic, assign) NSInteger companyCount;

// MARK: 国际化
/** 公司的名称(国际化) */
@property (nonatomic, copy) NSString *name_local;

@end

NS_ASSUME_NONNULL_END
