//
//  BTSDatabaseManager.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/5.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSDatabaseManager.h"
#import "BTSEncryptFMDB.h"
#import "CommonFile.h"
#import "MACAddressInfo-Swift.h"
#import "CountryModel.h"

NSString *const MACOUISqliteName = @"BTSMACOUI"; // 数据库名称
NSString *const MACOUITableName = @"MACOUITable"; // MAC地址的OUI表
NSString *const MACOUICompanyTableName = @"MACOUICompanyTable"; // 公司表

@interface BTSDatabaseManager ()

@property (nonatomic, strong) BTSEncryptFMDB *database;
@property (nonatomic, copy) NSString *databaseFileName; // 数据库文件名称

@end

@implementation BTSDatabaseManager

+ (instancetype)sharedInstance {
    static BTSDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _databaseFileName = [NSString stringWithFormat:@"%@.sqlite", MACOUISqliteName];
    }
    return self;
}


#pragma mark - FMDataBase

// MARK: 增
// 创建MAC地址的OUI表
- (void)createOUITable {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 创建表 (主键oui_id自增, 外键company_id,用MACOUITableName表中的company_id引用MACOUICompanyTableName中的company_id)
    NSString *execute = [NSString stringWithFormat:@"create table if not exists %@(oui_id integer primary key autoincrement, oui text, company_id text, constraint company_id foreign key(company_id) references %@(company_id) on delete cascade on update cascade)", MACOUITableName, MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute];
    NSLog(@"创建OUI表 %@ ！", success ? @"成功" : @"失败");
}

// 创建OUI公司表
- (void)createOUICompanyTable {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 创建表 (主键company_id, blob代表存储二进制类型数据(NSData))
    NSString *execute = [NSString stringWithFormat:@"create table if not exists %@(company_id text primary key, name text, street text, city text, province text, country text, postCode text, countryCode text, name_zh text, street_zh text, city_zh text, province_zh text, country_zh text, ouiList blob, ouiCount integer, ouiRank text, company_url text)", MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute];
    NSLog(@"创建OUI公司表 %@ ！", success ? @"成功" : @"失败");
    
    
    // 添加字段
//    [self addNewField:@"company_url" toTable:MACOUICompanyTableName];
}

// 向表中新增字段
- (void)addNewField:(NSString *)fieldName toTable:(NSString *)tableName {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 修改字段：alter table [表名] alter column [字段名]
    // 新增字段语法: ALTER TABLE <表名> ADD <新列名> <字段类型> <是否为空> DEFAULT <默认值>
    
    // 1. 先判断字段是否已存在
    BOOL exist = [self.database columnExists:fieldName inTableWithName:tableName];
    // 2. 不存在,就执行插入操作
    if (!exist) {
        NSString *execute = [NSString stringWithFormat:@"alter table %@ add %@ text", tableName, fieldName];
        BOOL success = [self.database executeUpdate:execute];
        NSLog(@"%@表 新增字段[%@] %@ ！", tableName, fieldName, success ? @"成功" : @"失败");
    } else {
        NSLog(@"%@表中字段[%@] 已存在！", tableName, fieldName);
    }
}

// 增加一条记录到表中
- (void)insertOUI:(OUIModel *)model {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 归档CompanyModel
//    CompanyModel *company = model.company;
//    NSData *companyData = nil;
//    if (@available(iOS 11.0, *)) {
//        companyData = [NSKeyedArchiver archivedDataWithRootObject:company requiringSecureCoding:YES error:nil];
//    } else {
//        companyData = [NSKeyedArchiver archivedDataWithRootObject:company];
//    }
    // 操作: 插入一条记录
    NSString *execute = [NSString stringWithFormat:@"insert into %@(oui, company_id) values(?, ?)", MACOUITableName];
    BOOL success = [self.database executeUpdate:execute, model.oui, model.company_id];
    NSLog(@"插入一条记录 %@ ！", success ? @"成功" : @"失败");
}

- (void)insertOUICompany:(CompanyModel *)company {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 归档ouiList
    NSData *ouiListData = nil;
    if (@available(iOS 11.0, *)) {
        ouiListData = [NSKeyedArchiver archivedDataWithRootObject:company.ouiList requiringSecureCoding:YES error:nil];
    } else {
        ouiListData = [NSKeyedArchiver archivedDataWithRootObject:company.ouiList];
    }
    // 操作: 插入一条记录
    NSString *execute = [NSString stringWithFormat:@"insert into %@(company_id, name, street, city, province, country, postCode, countryCode, name_zh, street_zh, city_zh, province_zh, country_zh, ouiList, ouiCount, ouiRank) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute, company.company_id, company.name, company.street, company.city, company.province, company.country, company.postCode, company.countryCode, company.name_zh, company.street_zh, company.city_zh, company.province_zh, company.country_zh, ouiListData, company.ouiCount, company.ouiRank];
    NSLog(@"插入一条公司记录 %@ ！", success ? @"成功" : @"失败");
}

// MARK: 删
// 删除一条记录
- (void)deleteOUI:(OUIModel *)model {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 删除一条记录
    NSString *execute = [NSString stringWithFormat:@"delete from %@ where oui = ?", MACOUITableName];
    BOOL success = [self.database executeUpdate:execute, model.oui];
    NSLog(@"删除一条记录 %@ ！", success ? @"成功" : @"失败");
}

// 删除一个表中的所有记录
- (void)deleteAllOUI {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 删除表中所有记录
    NSString *execute = [NSString stringWithFormat:@"delete from %@", MACOUITableName];
    BOOL success = [self.database executeUpdate:execute];
    NSLog(@"清除%@表中所有记录 %@ ！", MACOUITableName, success ? @"成功" : @"失败");
}

- (void)deleteAllOUICompany {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 删除表中所有记录
    NSString *execute = [NSString stringWithFormat:@"delete from %@", MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute];
    NSLog(@"清除%@表中所有记录 %@ ！", MACOUICompanyTableName, success ? @"成功" : @"失败");
}

- (void)deleteOUICompanyWithCompanyID:(NSString *)company_id {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 删除表中某条记录
    NSString *execute = [NSString stringWithFormat:@"delete from %@ where company_id = ?", MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute, company_id];
    NSLog(@"删除%@表中一条记录 %@ ！", MACOUICompanyTableName, success ? @"成功" : @"失败");
}

// 删除表
- (void)deleteOUICompanyTable {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 删除表
    NSString *execute = [NSString stringWithFormat:@"drop table %@", MACOUICompanyTableName];
    BOOL success = [self.database executeUpdate:execute];
    NSLog(@"删除%@表 %@ ！", MACOUICompanyTableName, success ? @"成功" : @"失败");
}

// MARK: 改
// 更新一条记录
- (void)updateOUIWithOUI:(NSString *)oui newOUIModel:(OUIModel *)newModel {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    // 操作: 更新一条记录
    NSString *execute = [NSString stringWithFormat:@"update %@ set company_id = ? where oui = ?", MACOUITableName];
    BOOL success = [self.database executeUpdate:execute, newModel.company_id, oui];
    NSLog(@"更新一条记录 %@ ！", success ? @"成功" : @"失败");
}

- (void)updateOUICompanyWithCompanyID:(NSString *)company_id key:(NSString *)key value:(id)value {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 更新一条记录
    NSString *execute = [NSString stringWithFormat:@"update %@ set %@ = ? where company_id = ?", MACOUICompanyTableName, key];
    BOOL success = NO;
    if ([key isEqualToString:@"ouiList"]) {
        NSArray *ouiListArr = value;
        // 归档ouiList
        NSData *ouiListData = nil;
        if (@available(iOS 11.0, *)) {
            ouiListData = [NSKeyedArchiver archivedDataWithRootObject:ouiListArr requiringSecureCoding:YES error:nil];
        } else {
            ouiListData = [NSKeyedArchiver archivedDataWithRootObject:ouiListArr];
        }
        success = [self.database executeUpdate:execute, ouiListData, company_id];
        
    } else {
        success = [self.database executeUpdate:execute, value, company_id];
    }
    NSLog(@"更新一条公司记录的[%@] %@ ！", key, success ? @"成功" : @"失败");
}

// MARK: 查
// MARK: 查 ------------ OUI ------------
// 查询表中记录的个数
- (NSInteger)selectCountFromTable {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中记录的个数
    NSString *execute = [NSString stringWithFormat:@"select count(*) from %@", MACOUITableName];
    NSInteger count = [self.database intForQuery:execute];
    return count;
}

// 查询表中的所有记录
- (NSArray *)selectAllOUI {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表格中的所有记录
//    NSString *execute = [NSString stringWithFormat:@"select * from %@", MACOUITableName];
    
    /**
     * left join是以A表的记录为基础的,A可以看成左表,B可以看成右表,left join是以左表为准的.
     * 换句话说,左表(A)的记录将会全部表示出来,而右表(B)只会显示符合搜索条件的记录.
     */
    NSString *execute = [NSString stringWithFormat:@"select * from %@ left join %@ on %@.company_id = %@.company_id", MACOUITableName, MACOUICompanyTableName, MACOUITableName, MACOUICompanyTableName];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    while ([resultSet next]) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        // Company
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        // Company
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        model.company = company;
        
        // 记录添加到数组
        [results addObject:model];
    }
    return results;
}

// 查询表中前count条记录
- (NSArray *)selectOUIInTableWithCount:(NSUInteger)count {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中的所有记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@", MACOUITableName];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    
    count += 1;
    while ([resultSet next] && count) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        // Company
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        // Company
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        model.company = company;
        
        // 添加到数组
        [results addObject:model];
        
        count--;
    }
    return results;
}

// 根据OUI值查询表中某条记录
- (OUIModel *)selectOUIWithOUI:(NSString *)oui {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中的某条记录
    //    NSString *execute = [NSString stringWithFormat:@"select * from %@ where oui = ?", MACOUITableName];
    
    /**
     * inner join并不以谁为基础,它只显示符合条件的记录. 还有就是inner join可以结合where语句来使用.
     */
    NSString *execute = [NSString stringWithFormat:@"select * from %@ inner join %@ on %@.company_id = %@.company_id where %@.oui = ?", MACOUITableName, MACOUICompanyTableName, MACOUITableName, MACOUICompanyTableName, MACOUITableName];
    FMResultSet *resultSet = [self.database executeQuery:execute, oui];
    
    NSMutableArray *results = [NSMutableArray array];
    while ([resultSet next]) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        //        NSData *companyData = [resultSet dataForColumn:@"company"];
        //        CompanyModel *company = nil;
        //        // 解档CompanyModel
        //        if (@available(iOS 11.0, *)) {
        //            company = [NSKeyedUnarchiver unarchivedObjectOfClass:[CompanyModel class] fromData:companyData error:nil];
        //        } else {
        //            company = [NSKeyedUnarchiver unarchiveObjectWithData:companyData];
        //        }
        
        // Company
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        // Company
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        model.company = company;
        
        // 添加到数组
        [results addObject:model];
    }
    
    if (results.count) {
        return results.firstObject;
    }
    return nil;
}

// 分页查询OUI
- (NSArray *)selectOUIWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    // SELECT*FROM t_student ORDER BY id ASC LIMIT 0,10;
    if (pageNum == 0 || pageSize == 0) { // 查询全部
        return [self selectAllOUI];
    }
    
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    /**
     * 第1页：limit 0, 5
     * 第2页：limit 5, 5
     * 第3页：limit 10, 5
     * ...
     * 第n页：limit 5 * (n - 1), 5
     */
    pageNum = pageSize * (pageNum - 1);
    
    // 操作: 分页查询表格中的记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@ inner join %@ on %@.company_id = %@.company_id order by oui_id asc limit %ld, %ld", MACOUITableName, MACOUICompanyTableName, MACOUITableName, MACOUICompanyTableName, pageNum, pageSize];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    while ([resultSet next]) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        // Company
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        // Company
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        model.company = company;
        
        // 记录添加到数组
        [results addObject:model];
    }
    return results;
}

// MARK: 查 ------------ Company ------------
- (NSArray *)selectAllCompany {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表格中的所有记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@", MACOUICompanyTableName];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    while ([resultSet next]) {
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        CompanyModel *model = [[CompanyModel alloc] init];
        model.company_id = company_id;
        model.name = name;
        model.street = street;
        model.city = city;
        model.province = province;
        model.country = country;
        model.postCode = postCode;
        model.countryCode = countryCode;
        
        model.name_zh = name_zh;
        model.street_zh = street_zh;
        model.city_zh = city_zh;
        model.province_zh = province_zh;
        model.country_zh = country_zh;
        
        model.ouiList = ouiList;
        model.ouiCount = ouiCount;
        model.ouiRank = ouiRank;
        model.company_url = company_url;
        
        // 记录添加到数组
        [results addObject:model];
    }
    return results;
}

// 查询ouiCount排前几名的公司
- (NSArray *)queryCompanyWithTopOUICount:(NSInteger)count {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 根据 ouiRank 升序查询表格中的记录 (asc:升序  desc:降序)
    NSString *execute = [NSString stringWithFormat:@"select * from %@ order by ouiRank asc", MACOUICompanyTableName];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    
    while ([resultSet next] && count) {
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        CompanyModel *model = [[CompanyModel alloc] init];
        model.company_id = company_id;
        model.name = name;
        model.street = street;
        model.city = city;
        model.province = province;
        model.country = country;
        model.postCode = postCode;
        model.countryCode = countryCode;
        
        model.name_zh = name_zh;
        model.street_zh = street_zh;
        model.city_zh = city_zh;
        model.province_zh = province_zh;
        model.country_zh = country_zh;
        
        model.ouiList = ouiList;
        model.ouiCount = ouiCount;
        model.ouiRank = ouiRank;
        model.company_url = company_url;
        
        // 记录添加到数组
        [results addObject:model];
        
        count--;
    }
    return results;
}

// 根据公司数量统计国家排名 (统计countryCode字段所有值出现的次数)
- (NSArray *)countCountryRankWithCompanyCount {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询countryCode列所有值出现的次数
    /**
     * count(*)统计的是结果集的总条数
     * count(字段名)统计的是该字段值不为null的总条数
     * group by：从字面意义上理解就是根据“by”指定的规则对数据进行分组，所谓的分组就是将一个“数据集”划分成若干个“小区域”，然后针对若干个“小区域”进行数据处理
     */
    NSString *execute = [NSString stringWithFormat:@"select country as name, country_zh as name_zh, countryCode as country_code, count(*) as country_code_count from %@ group by countryCode order by country_code_count desc", MACOUICompanyTableName];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    
    while ([resultSet next]) {
        NSString *countryCode = [resultSet stringForColumn:@"country_code"];
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        int countryCodeCount = [resultSet intForColumn:@"country_code_count"];
        
        CountryModel *model = [[CountryModel alloc] init];
        model.code = countryCode;
        model.name = name;
        model.name_zh = name_zh;
        model.companyCount = countryCodeCount;
        
        [results addObject:model];
    }
    
    return results;
}

// 分页查询Company
- (NSArray *)selectCompanyWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    if (pageNum == 0 || pageSize == 0) { // 查询全部
        return [self selectAllCompany];
    }
    
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    pageNum = pageSize * (pageNum - 1);
    
    // 操作: 分页查询表格中的记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@ limit %ld, %ld", MACOUICompanyTableName, pageNum, pageSize];
    
    NSMutableArray *results = [NSMutableArray array];
    FMResultSet *resultSet = [self.database executeQuery:execute];
    while ([resultSet next]) {
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        CompanyModel *model = [[CompanyModel alloc] init];
        model.company_id = company_id;
        model.name = name;
        model.street = street;
        model.city = city;
        model.province = province;
        model.country = country;
        model.postCode = postCode;
        model.countryCode = countryCode;
        
        model.name_zh = name_zh;
        model.street_zh = street_zh;
        model.city_zh = city_zh;
        model.province_zh = province_zh;
        model.country_zh = country_zh;
        
        model.ouiList = ouiList;
        model.ouiCount = ouiCount;
        model.ouiRank = ouiRank;
        model.company_url = company_url;
        
        // 记录添加到数组
        [results addObject:model];
    }
    return results;
}

    

#pragma mark - 调试方法

// 根据条件(whereKey和whereValue)更新记录中某个key对应的值
- (void)updateOUIWithKey:(NSString *)key value:(NSString *)value whereKey:(NSString *)whereKey whereValue:(NSString *)whereValue {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 更新一条记录
    NSString *execute = [NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?", MACOUITableName, key, whereKey];
    BOOL success = [self.database executeUpdate:execute, value, whereValue];
    NSLog(@"更新记录的%@ %@ ！", key, success ? @"成功" : @"失败");
}

// 根据条件(whereKey和whereValue)更新记录中某个key对应的值
- (void)updateOUICompanyWithKey:(NSString *)key value:(NSString *)value whereKey:(NSString *)whereKey whereValue:(NSString *)whereValue {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 更新一条记录
    NSString *execute = [NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?", MACOUICompanyTableName, key, whereKey];
    BOOL success = [self.database executeUpdate:execute, value, whereValue];
    NSLog(@"更新公司记录的[%@] %@ ！", key, success ? @"成功" : @"失败");
}

// 根据条件(key和value)查询表中的记录
- (NSArray *)selectOUIWithKey:(NSString *)key value:(NSString *)value {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中的记录
//    NSString *execute = [NSString stringWithFormat:@"select * from %@ where %@ = ?", MACOUITableName, key];
    NSString *execute = [NSString stringWithFormat:@"select * from %@ inner join %@ on %@.company_id = %@.company_id where %@.%@ = ?", MACOUITableName, MACOUICompanyTableName, MACOUITableName, MACOUICompanyTableName, MACOUITableName, key];
    FMResultSet *resultSet = [self.database executeQuery:execute, value];
    
    NSMutableArray *results = [NSMutableArray array];
    while ([resultSet next]) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        // Company
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        // Company
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        model.company = company;
        
        // 添加到数组
        [results addObject:model];
    }
    return results;
}

// 根据条件(key和value)查询表中的记录
- (NSArray *)selectOUICompanyWithKey:(NSString *)key value:(NSString *)value {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中的记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@ where %@ = ?", MACOUICompanyTableName, key];
    FMResultSet *resultSet = [self.database executeQuery:execute, value];
    
    NSMutableArray *results = [NSMutableArray array];
    while ([resultSet next]) {
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        NSString *name = [resultSet stringForColumn:@"name"];
        NSString *street = [resultSet stringForColumn:@"street"];
        NSString *city = [resultSet stringForColumn:@"city"];
        NSString *province = [resultSet stringForColumn:@"province"];
        NSString *country = [resultSet stringForColumn:@"country"];
        NSString *postCode = [resultSet stringForColumn:@"postCode"];
        NSString *countryCode = [resultSet stringForColumn:@"countryCode"];
        
        NSString *name_zh = [resultSet stringForColumn:@"name_zh"];
        NSString *street_zh = [resultSet stringForColumn:@"street_zh"];
        NSString *city_zh = [resultSet stringForColumn:@"city_zh"];
        NSString *province_zh = [resultSet stringForColumn:@"province_zh"];
        NSString *country_zh = [resultSet stringForColumn:@"country_zh"];
        
        NSInteger ouiCount = [resultSet intForColumn:@"ouiCount"];
        NSString *ouiRank = [resultSet stringForColumn:@"ouiRank"];
        NSString *company_url = [resultSet stringForColumn:@"company_url"];
        NSData *ouiListData = [resultSet dataForColumn:@"ouiList"];
        
        // 解档ouiList
        NSArray *ouiList = [NSArray array];
        if (@available(iOS 11.0, *)) {
            ouiList = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:ouiListData error:nil];
        } else {
            ouiList = [NSKeyedUnarchiver unarchiveObjectWithData:ouiListData];
        }
        
        CompanyModel *company = [[CompanyModel alloc] init];
        company.company_id = company_id;
        company.name = name;
        company.street = street;
        company.city = city;
        company.province = province;
        company.country = country;
        company.postCode = postCode;
        company.countryCode = countryCode;
        
        company.name_zh = name_zh;
        company.street_zh = street_zh;
        company.city_zh = city_zh;
        company.province_zh = province_zh;
        company.country_zh = country_zh;
        
        company.ouiList = ouiList;
        company.ouiCount = ouiCount;
        company.ouiRank = ouiRank;
        company.company_url = company_url;
        
        // 添加到数组
        [results addObject:company];
    }
    return results;
}

// 统计公司的OUI列表
- (NSArray *)countCompanyOUIListWithCompanyID:(NSString *)company_id {
    if (!self.database) {
        BW_DATABASE_MODE_DEBUG ? [self createDatabase] : [self openDatabase];
    }
    
    // 操作: 查询表中的某条记录
    NSString *execute = [NSString stringWithFormat:@"select * from %@ where company_id = ?", MACOUITableName];
    FMResultSet *resultSet = [self.database executeQuery:execute, company_id];
    
    NSMutableArray *results = [NSMutableArray array];
    while ([resultSet next]) {
        // OUI
        NSInteger oui_id = [resultSet intForColumn:@"oui_id"];
        NSString *oui = [resultSet stringForColumn:@"oui"];
        NSString *company_id = [resultSet stringForColumn:@"company_id"];
        
        // OUI
        OUIModel *model = [[OUIModel alloc] init];
        model.oui_id = oui_id;
        model.oui = oui;
        model.company_id = company_id;
        
        // 添加到数组
        [results addObject:model];
    }
    
    return results;
}


#pragma mark - Public Methods

/**
 创建数据库

 @return 是否成功
 */
- (BOOL)createDatabase {
    // 1. 创建数据库
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *databaseFilePath = [documents stringByAppendingPathComponent:self.databaseFileName];
    self.database = [BTSEncryptFMDB databaseWithPath:databaseFilePath encryptKey:DatabaseEncryptKey];
    NSLog(@"数据库路径: %@", self.database.databasePath);
    
    // 2. 打开数据库
    BOOL success = [self.database open];
    if (success) {
        NSLog(@"数据库创建或打开成功！");
        [self createOUITable];
        [self createOUICompanyTable];
    } else {
        NSLog(@"数据库创建或打开失败！");
    }
    return success;
}

/**
 打开数据库
 
 @return 是否成功
 */
- (BOOL)openDatabase {
    /**
     加密后的数据库暂时没有找到可以打开的GUI工具查看（MesaSQLite），即使输入secretKey也无法查看，不知道为何
     */
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:MACOUISqliteName ofType:@"sqlite"];
    NSLog(@"数据库路径: %@", databasePath);
    if (!databasePath) {
        NSLog(@"数据库打开失败,数据库文件不存在！");
        return NO;
    }
    
    self.database = [BTSEncryptFMDB databaseWithPath:databasePath encryptKey:DatabaseEncryptKey];
    BOOL success = [self.database open];
    if (success) {
        NSLog(@"数据库打开成功！");
    } else {
        NSLog(@"数据库打开失败！");
    }
    return success;
}


// MARK: OUI
/**
 添加一条OUI记录 (添加时会先判断有没有该OUI,若有,去更新该OUI数据; 若无,再增加一条OUI记录)
 
 @param model OUI对象
 */
- (void)addOUI:(OUIModel *)model {
    OUIModel *oldModel = [self selectOUIWithOUI:model.oui];
    if (oldModel) { // 已存储该记录，则去更新数据
        [self updateOUIWithOUI:oldModel.oui newOUIModel:model];
    } else { // 还没存储该记录，则去增加该记录
        [self insertOUI:model];
    }
}

/**
 查询所有OUI记录

 @return OUI数组
 */
- (NSArray *)queryAllOUI {
    NSArray *ouiArr = [self selectAllOUI];
    return ouiArr;
}

/**
 根据OUI值查询OUI

 @param ouiCode OUI值(格式: F0:76:6F 或 F0-76-6F 或 F0766F)
 @return OUI对象
 */
- (OUIModel *)queryOUIWithOUICode:(NSString *)ouiCode {
    ouiCode = [ouiCode convertToStandardOUICode];
    NSLog(@"转换后的OUI Code: %@", ouiCode);
    OUIModel *model = [self selectOUIWithOUI:ouiCode];
    return model;
}

// 分页查询OUI
- (NSArray *)queryOUIWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    NSArray *results = [self selectOUIWithPageNum:pageNum pageSize:pageSize];
    return results;
}


// MARK: Company

- (void)addOUICompany:(CompanyModel *)model {
    // 如果model已存在(即company_id相同),则插入失败
    /**
     * 报错信息为: Unknown error calling sqlite3_step (19: UNIQUE constraint failed: MACOUICompanyTable.company_id) eu
     * 说明company_id重复或者为空,这里为重复的情况
     */
    [self insertOUICompany:model];
}

- (NSArray *)queryAllOUICompany {
    NSArray *results = [self selectAllCompany];
    return results;
}

// 分页查询Company
- (NSArray *)queryCompanyWithPageNum:(NSUInteger)pageNum pageSize:(NSUInteger)pageSize {
    NSArray *results = [self selectCompanyWithPageNum:pageNum pageSize:pageSize];
    return results;
}

@end
