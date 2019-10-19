//
//  BTSEncryptFMDB.m
//  MACAddressInfo
//
//  Created by Hadlinks on 2019/1/7.
//  Copyright © 2019 BTStudio. All rights reserved.
//

#import "BTSEncryptFMDB.h"

@interface BTSEncryptFMDB () {
    NSString *_encryptKey;
}

@end

@implementation BTSEncryptFMDB

/**
 创建加密的FMDB数据库
 
 @param path 数据库路径
 @param encrytKey 加密密码
 @return FMDB数据库
 */
+ (id)databaseWithPath:(NSString *)path encryptKey:(NSString *)encryptKey {
    return [[[self class] alloc] initWithPath:path encryptKey:encryptKey];
}

/**
 创建加密的FMDB数据库
 
 @param path 数据库路径
 @param encrytKey 加密密码
 @return FMDB数据库
 */
- (id)initWithPath:(NSString *)path encryptKey:(NSString *)encryptKey {
    if (self = [super initWithPath:path]) {
        _encryptKey = encryptKey;
    }
    return self;
}


#pragma mark - 重写父类open方法

- (BOOL)open {
    BOOL result = [super open];
    if (result && _encryptKey) {
        [self setKey:_encryptKey];
    }
    return result;
}

- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName {
    BOOL result = [super openWithFlags:flags vfs:vfsName];
    if (result && _encryptKey) {
        [self setKey:_encryptKey];
    }
    return result;
}

@end
