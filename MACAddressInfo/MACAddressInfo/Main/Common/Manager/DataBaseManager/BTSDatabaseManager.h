//
//  BTSDatabaseManager.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/5.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DatabaseManagerInstance [BTSDatabaseManager sharedInstance]
#define BW_DATABASE_MODE_DEBUG 0 // 是否为调试模式(1:调试  0:非调试)

@class OUIModel, CompanyModel;


NS_ASSUME_NONNULL_BEGIN

@interface BTSDatabaseManager : NSObject

+ (instancetype)sharedInstance;


#pragma mark - 调试方法

- (void)deleteOUICompanyWithCompanyID:(NSString *)company_id;

// 根据条件(whereKey和whereValue)修改记录中某个key对应的值
- (void)updateOUIWithKey:(NSString *)key value:(NSString *)value whereKey:(NSString *)whereKey whereValue:(NSString *)whereValue;

- (void)updateOUICompanyWithKey:(NSString *)key value:(NSString *)value whereKey:(NSString *)whereKey whereValue:(NSString *)whereValue;

- (void)updateOUICompanyWithCompanyID:(NSString *)company_id key:(NSString *)key value:(id)value;

// 根据条件(key和value)查询表中的记录
- (NSArray *)selectOUIWithKey:(NSString *)key value:(NSString *)value;

- (NSArray *)selectOUICompanyWithKey:(NSString *)key value:(NSString *)value;

// 统计公司的OUI列表
- (NSArray *)countCompanyOUIListWithCompanyID:(NSString *)company_id;

// 根据公司数量统计国家排名
- (NSArray *)countCountryRankWithCompanyCount;


#pragma mark - Public Methods

/**
 创建数据库
 
 @return 是否成功
 */
- (BOOL)createDatabase;

/**
 打开数据库
 
 @return 是否成功
 */
- (BOOL)openDatabase;


// MARK: OUI
/**
 添加一条OUI记录 (添加时会先判断有没有该OUI,若有,去更新该OUI数据; 若无,再增加一条OUI记录)

 @param model OUI对象
 */
- (void)addOUI:(OUIModel *)model;

/**
 查询所有OUI记录
 
 @return OUI数组
 */
- (NSArray *)queryAllOUI;

/**
 根据OUI值查询OUI
 
 @param ouiCode OUI值(格式: F0:76:6F 或 F0-76-6F 或 F0766F)
 @return OUI对象
 */
- (OUIModel *)queryOUIWithOUICode:(NSString *)ouiCode;

// 分页查询OUI
- (NSArray *)queryOUIWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize;


// MARK: Company

- (void)addOUICompany:(CompanyModel *)model;

- (NSArray *)queryAllOUICompany;

// 查询ouiCount排前几名的公司
- (NSArray *)queryCompanyWithTopOUICount:(NSInteger)count;

// 分页查询Company
- (NSArray *)queryCompanyWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
