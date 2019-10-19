//
//  BTSEncryptFMDB.h
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

/**
 加密FMDB数据库 (继承自FMDatabase)
 */
@interface BTSEncryptFMDB : FMDatabase

/**
 创建加密的FMDB数据库

 @param path 数据库路径
 @param encryptKey 加密密码
 @return FMDB数据库
 */
+ (id)databaseWithPath:(NSString *)path encryptKey:(NSString *)encryptKey;

/**
 创建加密的FMDB数据库

 @param path 数据库路径
 @param encryptKey 加密密码
 @return FMDB数据库
 */
- (id)initWithPath:(NSString *)path encryptKey:(NSString *)encryptKey;

@end

NS_ASSUME_NONNULL_END
